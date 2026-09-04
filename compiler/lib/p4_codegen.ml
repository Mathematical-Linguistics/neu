(** =========================================================================
    p4_codegen.ml
    Bio-P4 Bridge for Neu:
    Translates clinical contracts and match-action rules to SMT-LIB2 (Z3)
    and P4-16 JSON table entries for sub-100 nW physiological data planes.
    ========================================================================= *)

open Ast

type patient_state = {
  glucose : int;
  rate_of_change : int;
}

let check_safety (contract : clinical_contract) (state : patient_state) (act : bio_act) : bool =
  match act with
  | SetDosage u ->
      let safe_hypo = if state.glucose <= contract.min_glucose then u = 0 else true in
      let safe_ceiling = u <= contract.max_dosage in
      let safe_slope =
        if state.rate_of_change < contract.steep_fall_threshold then
          u <= contract.basal_dosage
        else true
      in
      safe_hypo && safe_ceiling && safe_slope
  | SuppressDosage -> true
  | ModulateBasal f -> f >= 0.0 && f <= 1.0
  | AlertClinician _ -> true

let evaluate_table (rules : bio_rule list) (state : patient_state) : bio_act =
  let sorted_rules = List.sort (fun r1 r2 -> compare r1.priority r2.priority) rules in
  let matches (rule : bio_rule) =
    let (g_low, g_high) = rule.glucose_range in
    let (d_low, d_high) = rule.delta_range in
    state.glucose >= g_low && state.glucose <= g_high &&
    state.rate_of_change >= d_low && state.rate_of_change <= d_high
  in
  match List.find_opt matches sorted_rules with
  | Some r -> r.action
  | None -> SuppressDosage

let emit_smtlib2 (contract : clinical_contract) : string =
  let buf = Buffer.create 2048 in
  Buffer.add_string buf ";; =========================================================\n";
  Buffer.add_string buf (Printf.sprintf ";; SMT-LIB2 Safety Verification for Neu Contract: %s\n" contract.contract_name);
  Buffer.add_string buf ";; Logic: QF_BV (Quantifier-Free Bit-Vectors)\n";
  Buffer.add_string buf ";; =========================================================\n";
  Buffer.add_string buf "(set-logic QF_BV)\n\n";
  Buffer.add_string buf "(declare-const G (_ BitVec 16))   ;; Blood Glucose (mg/dL)\n";
  Buffer.add_string buf "(declare-const dG (_ BitVec 16))  ;; Rate of change (mg/dL/min)\n";
  Buffer.add_string buf "(declare-const u (_ BitVec 16))   ;; Delivered dosage (uL/h)\n\n";
  Buffer.add_string buf ";; Physiological Bounded Domain [40, 400] mg/dL\n";
  Buffer.add_string buf "(assert (bvuge G (_ bv40 16)))\n";
  Buffer.add_string buf "(assert (bvule G (_ bv400 16)))\n\n";
  Buffer.add_string buf (Printf.sprintf ";; Clinical Invariant: Hypo-barrier at <= %d mg/dL\n" contract.min_glucose);
  Buffer.add_string buf (Printf.sprintf "(assert (=> (bvule G (_ bv%d 16)) (bvult u (_ bv1 16))))\n\n" contract.min_glucose);
  Buffer.add_string buf (Printf.sprintf ";; Clinical Invariant: Bolus ceiling <= %d uL/h\n" contract.max_dosage);
  Buffer.add_string buf (Printf.sprintf "(assert (bvule u (_ bv%d 16)))\n\n" contract.max_dosage);
  Buffer.add_string buf "(check-sat)\n";
  Buffer.add_string buf "(get-model)\n";
  Buffer.contents buf

let emit_p4_json (contract : clinical_contract) : string =
  let rules_json = List.map (fun r ->
    let act_str = match r.action with
      | SetDosage u -> Printf.sprintf "{\"action\": \"set_dosage\", \"param\": %d}" u
      | SuppressDosage -> "{\"action\": \"suppress_dosage\", \"param\": 0}"
      | ModulateBasal f -> Printf.sprintf "{\"action\": \"modulate_basal\", \"param\": %.2f}" f
      | AlertClinician c -> Printf.sprintf "{\"action\": \"alert_clinician\", \"code\": %d}" c
    in
    Printf.sprintf "    {\n      \"priority\": %d,\n      \"glucose_min\": %d, \"glucose_max\": %d,\n      \"delta_min\": %d, \"delta_max\": %d,\n      \"target\": %s,\n      \"invariant\": \"%s\"\n    }"
      r.priority (fst r.glucose_range) (snd r.glucose_range) (fst r.delta_range) (snd r.delta_range) act_str r.invariant_id
  ) contract.rules in
  Printf.sprintf "{\n  \"contract\": \"%s\",\n  \"target\": \"P4-16 V1Model\",\n  \"table_name\": \"IngressPipe.triage_table\",\n  \"rules\": [\n%s\n  ]\n}\n"
    contract.contract_name (String.concat ",\n" rules_json)
