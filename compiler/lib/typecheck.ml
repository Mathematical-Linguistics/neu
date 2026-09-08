(** =========================================================================
    typecheck.ml
    Information-Theoretic & Contract Typechecker for Neu:
    Verifies Shannon Entropy trajectories:
      Synthesis:      H(S_n) > H(S_1)
      Analysis:       H(S_n) < H(S_1)
      Transformation: H(S_n) = H(S_1)
    ========================================================================= *)

open Ast

type entropy_cert = {
  fn_name : string;
  engine_class : engine_type;
  status : string;
  h_initial : float;
  h_final : float;
}

let check_entropy_trajectory (name : string) (eng : engine_type) (h_in : float) (h_out : float) : entropy_cert =
  match eng with
  | Synthesis ->
      let ok = h_out > h_in in
      { fn_name = name; engine_class = Synthesis; status = (if ok then "VERIFIED_EXPANSIVE" else "VIOLATION_EXPANSION_EXPECTED"); h_initial = h_in; h_final = h_out }
  | Analysis ->
      let ok = h_out < h_in in
      { fn_name = name; engine_class = Analysis; status = (if ok then "VERIFIED_COMPRESSIVE" else "VIOLATION_COMPRESSION_EXPECTED"); h_initial = h_in; h_final = h_out }
  | Transformation ->
      let ok = abs_float (h_out -. h_in) < 1e-6 in
      { fn_name = name; engine_class = Transformation; status = (if ok then "VERIFIED_ISOMETRIC" else "VIOLATION_ISOMETRY_EXPECTED"); h_initial = h_in; h_final = h_out }

let string_of_cert (cert : entropy_cert) : string =
  let eng_str = match cert.engine_class with
    | Synthesis -> "Synthesis [H(S_n) > H(S_1)]"
    | Analysis -> "Analysis  [H(S_n) < H(S_1)]"
    | Transformation -> "Isometry  [H(S_n) = H(S_1)]"
  in
  Printf.sprintf "[aie Entropy Check] %s: %s -> %s (H_in: %.2f bits, H_out: %.2f bits)"
    cert.fn_name eng_str cert.status cert.h_initial cert.h_final

type epiplexity_cert = {
  stream_name : string;
  budget_t : float;
  s_t : float;             (** Epiplexity: structural learnable bits *)
  h_t : float;             (** Time-bounded residual entropy bits *)
  structure_ratio : float; (** S_T / (S_T + H_T) *)
  status : string;         (** "VERIFIED_STRUCTURAL" | "TIME_BOUNDED_NOISE" *)
}

let check_epiplexity_cert (name : string) (budget : float) (s_t : float) (h_t : float) : epiplexity_cert =
  let total = s_t +. h_t in
  let ratio = if total < 1e-9 then 0.0 else s_t /. total in
  let status = if ratio >= 0.50 then "VERIFIED_STRUCTURAL" else "TIME_BOUNDED_NOISE" in
  {
    stream_name = name;
    budget_t = budget;
    s_t;
    h_t;
    structure_ratio = ratio;
    status;
  }

let string_of_epiplexity_cert (cert : epiplexity_cert) : string =
  Printf.sprintf "[epiplexity Check] %s (Budget T: %.0f): S_T = %.2f bits, H_T = %.2f bits (Ratio: %.1f%%) -> %s"
    cert.stream_name cert.budget_t cert.s_t cert.h_t (cert.structure_ratio *. 100.0) cert.status
