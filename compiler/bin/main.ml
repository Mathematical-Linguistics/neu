(** =========================================================================
    main.ml
    Neu CLI Compiler & Runtime Driver (mlG)
    Commands:
      neu run <file.neu>
      neu check <file.neu>
      neu compile --target=p4 <file.neu>
      neu --demo
    ========================================================================= *)

open Neu_core
open Ast

let print_banner () =
  print_endline "=================================================================";
  print_endline "  Neu: Engine Expression Language (mlG)                         ";
  print_endline "  Morphisms (->) · Split · Scatter · Decompose · Cover · Shift   ";
  print_endline "================================================================="

let run_demo () =
  print_banner ();
  print_endline "\n[1] Structural Engine Flow (->) & Vectorized Arithmetic:";
  let code_vec = "let temps = [72.0, 68.0, 75.0, 69.0, 71.0] in (temps - 32.0) * 0.555" in
  Printf.printf "  Source: %s\n" code_vec;
  let lexbuf = Lexing.from_string code_vec in
  let expr = Parser.single_expr Lexer.read lexbuf in
  let result = Eval.eval [] expr in
  Printf.printf "  Result: %s\n" (Eval.string_of_val result);

  print_endline "\n[2] Structural Topological Verbs (shift, cover, split, cast):";
  let demo_lines = [
    ("Shift (temporal/spatial delay):", "[1, 2, 3, 4] -> shift(1)");
    ("Cover (topological sliding window):", "[10, 20, 30, 40] -> cover(2, 1)");
    ("Cast (functorial projection):", "[100, 200] -> cast(BioTelemetry)");
  ] in
  List.iter (fun (desc, src) ->
    let lbuf = Lexing.from_string src in
    let ex = Parser.single_expr Lexer.read lbuf in
    let res = Eval.eval [] ex in
    Printf.printf "  %-38s %s -> %s\n" desc src (Eval.string_of_val res);
  ) demo_lines;

  print_endline "\n[3] Engine Trajectory Validation (synthesis, analysis, isometry):";
  let cert_synth = Typecheck.check_entropy_trajectory "generative_expander" Synthesis 12.0 48.0 in
  let cert_analysis = Typecheck.check_entropy_trajectory "on_body_triage" Analysis 128.0 4.0 in
  let cert_iso = Typecheck.check_entropy_trajectory "fourier_transform" Transformation 64.0 64.0 in
  print_endline ("  " ^ Typecheck.string_of_cert cert_synth);
  print_endline ("  " ^ Typecheck.string_of_cert cert_analysis);
  print_endline ("  " ^ Typecheck.string_of_cert cert_iso);

  print_endline "\n[4] Bio-P4 Clinical Safety Contract Synthesis:";
  let default_rules = [
    { priority = 1; glucose_range = (0, 70); delta_range = (-50, 50); action = SuppressDosage; invariant_id = "INV_HYPO_BARRIER" };
    { priority = 2; glucose_range = (71, 95); delta_range = (-50, -2); action = SetDosage 5; invariant_id = "INV_RAMP_SUPPRESS" };
    { priority = 3; glucose_range = (96, 130); delta_range = (-2, 5); action = SetDosage 10; invariant_id = "INV_BASAL_NORM" };
    { priority = 4; glucose_range = (131, 180); delta_range = (-2, 10); action = SetDosage 25; invariant_id = "INV_CORRECTION" };
    { priority = 5; glucose_range = (181, 400); delta_range = (-2, 50); action = SetDosage 40; invariant_id = "INV_BOLUS_CEILING" };
  ] in
  let contract = {
    contract_name = "ArtificialPancreasSafety";
    min_glucose = 70;
    max_dosage = 50;
    basal_dosage = 10;
    steep_fall_threshold = -2;
    rules = default_rules;
  } in
  Printf.printf "  Contract: %s (Rules: %d)\n" contract.contract_name (List.length contract.rules);
  print_endline "  --- SMT-LIB2 Formula Preview ---";
  let smt = P4_codegen.emit_smtlib2 contract in
  List.iter (fun l -> print_endline ("    " ^ l)) (List.filter (fun s -> String.length s > 0 && String.sub s 0 1 <> ";") (String.split_on_char '\n' smt));
  print_endline "  --- Hardware P4-16 Match-Action Table JSON ---";
  print_endline (P4_codegen.emit_p4_json contract)

let parse_and_eval_file path =
  let ic = open_in path in
  let len = in_channel_length ic in
  let content = really_input_string ic len in
  close_in ic;
  let lexbuf = Lexing.from_string content in
  let prog = Parser.program_file Lexer.read lexbuf in
  let outputs = Eval.eval_program prog in
  List.iter print_endline outputs

let parse_and_compile_p4 path =
  let ic = open_in path in
  let len = in_channel_length ic in
  let content = really_input_string ic len in
  close_in ic;
  let lexbuf = Lexing.from_string content in
  let prog = Parser.program_file Lexer.read lexbuf in
  List.iter (function
    | DeclContract c ->
        print_endline (P4_codegen.emit_p4_json c);
        let smt_path = (Filename.remove_extension path) ^ "_safety.smt2" in
        let p4_path = (Filename.remove_extension path) ^ "_table.json" in
        let oc_smt = open_out smt_path in
        output_string oc_smt (P4_codegen.emit_smtlib2 c);
        close_out oc_smt;
        let oc_p4 = open_out p4_path in
        output_string oc_p4 (P4_codegen.emit_p4_json c);
        close_out oc_p4;
        Printf.printf "\n[+] Emitted SMT-LIB2 verification query: %s\n" smt_path;
        Printf.printf "[+] Emitted P4-16 Match-Action Table:    %s\n" p4_path
    | _ -> ()
  ) prog

let () =
  let args = Array.to_list Sys.argv in
  match args with
  | _ :: "--demo" :: _ -> run_demo ()
  | _ :: "run" :: file :: _ -> parse_and_eval_file file
  | _ :: "compile" :: "--target=p4" :: file :: _ -> parse_and_compile_p4 file
  | _ ->
      print_banner ();
      print_endline "Usage:";
      print_endline "  neu --demo";
      print_endline "  neu run <file.neu>";
      print_endline "  neu compile --target=p4 <file.neu>"
