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
