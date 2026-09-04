open Neu_core
open Ast

let test_scalar_math () =
  let lexbuf = Lexing.from_string "2 + 3 * 4" in
  let expr = Parser.single_expr Lexer.read lexbuf in
  let res = Eval.eval [] expr in
  assert (res = VInt 14);
  print_endline "[PASS] test_scalar_math"

let test_vectorized_math () =
  let lexbuf = Lexing.from_string "[10, 20, 30] * 2" in
  let expr = Parser.single_expr Lexer.read lexbuf in
  let res = Eval.eval [] expr in
  assert (res = VVec [VInt 20; VInt 40; VInt 60]);
  print_endline "[PASS] test_vectorized_math"

let test_vector_vector_add () =
  let lexbuf = Lexing.from_string "[1, 2, 3] + [10, 20, 30]" in
  let expr = Parser.single_expr Lexer.read lexbuf in
  let res = Eval.eval [] expr in
  assert (res = VVec [VInt 11; VInt 22; VInt 33]);
  print_endline "[PASS] test_vector_vector_add"

let test_flow_arrow () =
  let prog_str = "fn double(x) = x * 2;\n10 -> double" in
  let lexbuf = Lexing.from_string prog_str in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.mem "20" results);
  print_endline "[PASS] test_flow_arrow (->)"

let test_structural_shift () =
  let prog_str = "[1, 2, 3, 4] -> shift(1)" in
  let lexbuf = Lexing.from_string prog_str in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.mem "[4, 1, 2, 3]" results);
  print_endline "[PASS] test_structural_shift"

let test_structural_cover () =
  let prog_str = "[10, 20, 30, 40] -> cover(2, 1)" in
  let lexbuf = Lexing.from_string prog_str in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.mem "[[10, 20], [20, 30], [30, 40]]" results);
  print_endline "[PASS] test_structural_cover"

let test_structural_split () =
  let prog_str = "
fn add_ten(x) = x + 10;
fn times_two(x) = x * 2;
5 -> split { add_ten, times_two }
" in
  let lexbuf = Lexing.from_string prog_str in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.mem "[15, 10]" results);
  print_endline "[PASS] test_structural_split"

let test_structural_cast () =
  let prog_str = "[100, 200] -> cast(BioTelemetry)" in
  let lexbuf = Lexing.from_string prog_str in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.mem "BioTelemetry([100, 200])" results);
  print_endline "[PASS] test_structural_cast"

let test_contract_generation () =
  let contract_code = "
contract ArtificialPancreas {
  rule 1: 0..70, -50..50 -> suppress_dosage \"INV_HYPO_BARRIER\";
  rule 2: 71..95, -50..-2 -> set_dosage(5) \"INV_RAMP_SUPPRESS\";
  rule 3: 96..130, -2..5 -> set_dosage(10) \"INV_BASAL_NORM\";
}
" in
  let lexbuf = Lexing.from_string contract_code in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.length results = 1);
  (match List.hd prog with
   | DeclContract c ->
       assert (c.contract_name = "ArtificialPancreas");
       assert (List.length c.rules = 3);
       let smt = P4_codegen.emit_smtlib2 c in
       let p4 = P4_codegen.emit_p4_json c in
       assert (String.length smt > 50);
       assert (String.length p4 > 50)
   | _ -> failwith "Expected contract decl");
  print_endline "[PASS] test_contract_generation"

let () =
  print_endline "=== Running Neu Test Suite ===";
  test_scalar_math ();
  test_vectorized_math ();
  test_vector_vector_add ();
  test_flow_arrow ();
  test_structural_shift ();
  test_structural_cover ();
  test_structural_split ();
  test_structural_cast ();
  test_contract_generation ();
  print_endline "All tests passed successfully!"
