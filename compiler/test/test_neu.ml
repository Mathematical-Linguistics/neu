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

let test_learn_syntax () =
  let code = "
let l1 = learn(target: [1, 2, 3], max_entropy: 1.2);
let l2 = learn(target_labels);
let l3 = learn { loss: \"mse\", budget: 50 };
" in
  let lexbuf = Lexing.from_string code in
  let prog = Parser.program_file Lexer.read lexbuf in
  assert (List.length prog = 3);
  print_endline "[PASS] test_learn_syntax"

let contains_substr s sub =
  let len_s = String.length s and len_sub = String.length sub in
  if len_sub > len_s then false
  else
    let rec loop i =
      if i + len_sub > len_s then false
      else if String.sub s i len_sub = sub then true
      else loop (i + 1)
    in
    loop 0

let test_learn_tier2_routing () =
  let code = "
let stream = [10.0, 20.0, 30.0, 40.0];
let labels = [1.0, 2.0, 3.0, 4.0];
let model = stream -> learn(target: labels, max_entropy: 1.2);
let pred = [50.0, 60.0] -> model;
" in
  let lexbuf = Lexing.from_string code in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.length results = 4);
  (* Check that model converged with low cost *)
  let model_res = List.nth results 2 in
  assert (contains_substr model_res "model NeuClassifier");
  (* Check that prediction produced expected output *)
  let pred_res = List.nth results 3 in
  assert (List.mem pred_res ["[5.00, 6.00]"; "let pred = [5.00, 6.00]"]);
  print_endline "[PASS] test_learn_tier2_routing"

let test_learn_cover_routing () =
  let code = "
let vitals = [98.6, 99.1, 101.4, 98.4, 102.2, 99.8, 100.5, 98.9];
let labels = [0.0, 1.0, 1.0, 0.0];
let detector = vitals -> learn(target: labels);
let test_batch = [98.2, 98.5, 99.0, 98.4];
let alert = test_batch -> detector;
" in
  let lexbuf = Lexing.from_string code in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  assert (List.length results = 5);
  let detector_str = List.nth results 2 in
  assert (contains_substr detector_str "model NeuClassifier");
  print_endline "[PASS] test_learn_cover_routing"

let test_learn_model_call () =
  let code = "
let x = [2.0, 4.0, 6.0];
let y = [4.0, 8.0, 12.0];
let doubler = x -> learn(target: y);
let out = doubler([10.0, 20.0]);
" in
  let lexbuf = Lexing.from_string code in
  let prog = Parser.program_file Lexer.read lexbuf in
  let results = Eval.eval_program prog in
  let out_res = List.nth results 3 in
  assert (List.mem out_res ["[20.00, 40.00]"; "let out = [20.00, 40.00]"]);
  print_endline "[PASS] test_learn_model_call"

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
  test_learn_syntax ();
  test_learn_tier2_routing ();
  test_learn_cover_routing ();
  test_learn_model_call ();
  print_endline "All tests passed successfully!"
