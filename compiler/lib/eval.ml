(** =========================================================================
    eval.ml
    Evaluation Engine for Neu:
    Supports R-style vectorized arithmetic, structural transformations (->),
    and topological verbs (split, scatter, decompose, cover, shift, cast).
    ========================================================================= *)

open Ast

type value =
  | VInt of int
  | VFloat of float
  | VBool of bool
  | VString of string
  | VVec of value list
  | VRecord of (string * value) list
  | VClosure of string list * expr * env
  | VContract of clinical_contract
  | VTagged of string * value
  | VModel of model_payload

and model_payload = {
  model_name : string;
  optimal_path : string;
  cost : float;
  loss : float;
  complexity : float;
  dissipation : float;
  weights : float list;
  bias : float;
  predict : value -> value;
}

and env = (string * value) list

exception EvalError of string

let rec string_of_val = function
  | VInt i -> string_of_int i
  | VFloat f -> Printf.sprintf "%.2f" f
  | VBool b -> string_of_bool b
  | VString s -> "\"" ^ s ^ "\""
  | VVec items -> "[" ^ (String.concat ", " (List.map string_of_val items)) ^ "]"
  | VRecord fields ->
      "{" ^ (String.concat ", " (List.map (fun (k, v) -> k ^ ": " ^ string_of_val v) fields)) ^ "}"
  | VClosure (params, _, _) -> "<fn (" ^ (String.concat ", " params) ^ ")>"
  | VContract c -> "<contract " ^ c.contract_name ^ ">"
  | VTagged (tag, v) -> Printf.sprintf "%s(%s)" tag (string_of_val v)
  | VModel m ->
      Printf.sprintf "<model %s [path: %s | cost: %.2f | loss: %.4f]>"
        m.model_name m.optimal_path m.cost m.loss

(** Element-wise vector binary operation helper *)
let rec apply_binop op v1 v2 =
  match (op, v1, v2) with
  (* Scalar Int arithmetic *)
  | ("+", VInt a, VInt b) -> VInt (a + b)
  | ("-", VInt a, VInt b) -> VInt (a - b)
  | ("*", VInt a, VInt b) -> VInt (a * b)
  | ("/", VInt a, VInt b) -> if b = 0 then raise (EvalError "Division by zero") else VInt (a / b)
  
  (* Scalar Float arithmetic *)
  | ("+", VFloat a, VFloat b) -> VFloat (a +. b)
  | ("-", VFloat a, VFloat b) -> VFloat (a -. b)
  | ("*", VFloat a, VFloat b) -> VFloat (a *. b)
  | ("/", VFloat a, VFloat b) -> VFloat (a /. b)
  | ("+", VInt a, VFloat b) -> VFloat (float_of_int a +. b)
  | ("+", VFloat a, VInt b) -> VFloat (a +. float_of_int b)
  | ("-", VInt a, VFloat b) -> VFloat (float_of_int a -. b)
  | ("-", VFloat a, VInt b) -> VFloat (a -. float_of_int b)
  | ("*", VInt a, VFloat b) -> VFloat (float_of_int a *. b)
  | ("*", VFloat a, VInt b) -> VFloat (a *. float_of_int b)
  | ("/", VInt a, VFloat b) -> VFloat (float_of_int a /. b)
  | ("/", VFloat a, VInt b) -> VFloat (a /. float_of_int b)

  (* Comparisons *)
  | ("==", VInt a, VInt b) -> VBool (a = b)
  | ("==", VFloat a, VFloat b) -> VBool (a = b)
  | ("==", VBool a, VBool b) -> VBool (a = b)
  | ("==", VString a, VString b) -> VBool (a = b)
  | ("<", VInt a, VInt b) -> VBool (a < b)
  | ("<=", VInt a, VInt b) -> VBool (a <= b)
  | (">", VInt a, VInt b) -> VBool (a > b)
  | (">=", VInt a, VInt b) -> VBool (a >= b)
  | ("<", VFloat a, VFloat b) -> VBool (a < b)
  | ("<=", VFloat a, VFloat b) -> VBool (a <= b)
  | (">", VFloat a, VFloat b) -> VBool (a > b)
  | (">=", VFloat a, VFloat b) -> VBool (a >= b)

  (* R-Style Vectorized Operations: Vec OP Scalar *)
  | (op, VVec items, scalar) when not (match scalar with VVec _ -> true | _ -> false) ->
      VVec (List.map (fun it -> apply_binop op it scalar) items)
  | (op, scalar, VVec items) when not (match scalar with VVec _ -> true | _ -> false) ->
      VVec (List.map (fun it -> apply_binop op scalar it) items)

  (* R-Style Vectorized Operations: Vec OP Vec *)
  | (op, VVec l1, VVec l2) ->
      if List.length l1 <> List.length l2 then
        raise (EvalError "Vector dimension mismatch in vectorized arithmetic")
      else
        VVec (List.map2 (apply_binop op) l1 l2)

  | _ -> raise (EvalError ("Unsupported operands for operator: " ^ op))

(** Shift helper: rotates/displaces list by offset *)
let shift_list (offset : int) (items : 'a list) : 'a list =
  let n = List.length items in
  if n = 0 then []
  else
    let k = ((offset mod n) + n) mod n in
    let rec split_at i acc lst =
      if i = 0 then (List.rev acc, lst)
      else match lst with
        | [] -> (List.rev acc, [])
        | x :: xs -> split_at (i - 1) (x :: acc) xs
    in
    let (left, right) = split_at (n - k) [] items in
    right @ left

(** Cover helper: partitions list into overlapping sub-lists of window size w, step s *)
let cover_list (w : int) (s : int) (items : 'a list) : 'a list list =
  let arr = Array.of_list items in
  let n = Array.length arr in
  let rec loop idx acc =
    if idx + w > n then List.rev acc
    else
      let slice = Array.sub arr idx w in
      loop (idx + s) (Array.to_list slice :: acc)
  in
  if w <= 0 || s <= 0 then [] else loop 0 []

(** Conversion helpers for continuous learning *)
let float_of_val = function
  | VFloat f -> f
  | VInt i -> float_of_int i
  | VBool b -> if b then 1.0 else 0.0
  | _ -> 0.0

let float_list_of_val = function
  | VVec items -> List.map float_of_val items
  | v -> [float_of_val v]

let fit_linear_weights (xs : float list) (ys : float list) : float * float * float =
  let n = float_of_int (List.length xs) in
  if n = 0.0 || List.length ys <> List.length xs then (1.0, 0.0, 0.0)
  else
    let x_mean = List.fold_left (+.) 0.0 xs /. n in
    let y_mean = List.fold_left (+.) 0.0 ys /. n in
    let num = List.fold_left2 (fun acc x y -> acc +. ((x -. x_mean) *. (y -. y_mean))) 0.0 xs ys in
    let den = List.fold_left (fun acc x -> acc +. ((x -. x_mean) ** 2.0)) 0.0 xs in
    let w =
      if abs_float den < 1e-12 then
        (if abs_float x_mean > 1e-12 then y_mean /. x_mean else 1.0)
      else num /. den
    in
    let b = y_mean -. (w *. x_mean) in
    let mse =
      List.fold_left2 (fun acc x y ->
        let pred = (w *. x) +. b in
        acc +. ((pred -. y) ** 2.0)
      ) 0.0 xs ys /. n
    in
    (w, b, mse)

let align_length (target_len : int) (items : float list) : float list =
  let n = List.length items in
  if n = 0 then List.init target_len (fun _ -> 0.0)
  else if n = target_len then items
  else if n > target_len then
    let rec take k acc = function
      | [] -> List.rev acc
      | x :: xs -> if k = 0 then List.rev acc else take (k - 1) (x :: acc) xs
    in
    take target_len [] items
  else
    let last = List.nth items (n - 1) in
    let pad = List.init (target_len - n) (fun _ -> last) in
    items @ pad

type candidate_route = {
  route_name : string;
  complexity : float;
  dissipation : float;
  transform : float list -> float list;
  predict_transform : float list -> float list;
}

let evaluate_route (route : candidate_route) (xs : float list) (ys : float list) =
  let z = align_length (List.length ys) (route.transform xs) in
  let (w, b, mse) = fit_linear_weights z ys in
  let alpha = 0.2 in
  let beta = 0.1 in
  let cost = mse +. (alpha *. route.complexity) +. (beta *. route.dissipation) in
  (cost, mse, w, b)

let execute_learn (_env : env) (data_val : value) (params : (string * value) list) : value =
  let xs = float_list_of_val data_val in
  let ys =
    match List.assoc_opt "target" params with
    | Some y_val -> float_list_of_val y_val
    | None ->
        (match List.assoc_opt "objective" params with
         | Some y_val -> float_list_of_val y_val
         | None -> xs)
  in
  let n = List.length xs in
  let target_name =
    match List.assoc_opt "target" params with
    | Some (VTagged (name, _)) -> name
    | _ -> "TaskSpace"
  in

  (* Candidate 1: Direct Functorial Cast (Identity) *)
  let route_cast = {
    route_name = Printf.sprintf "cast(%s)" target_name;
    complexity = 0.5;
    dissipation = 0.1;
    transform = (fun l -> l);
    predict_transform = (fun l -> l);
  } in

  (* Candidate 2: Topological Cover (Local patch windowing) *)
  let win_size = if n >= 4 then 4 else (if n >= 2 then 2 else 1) in
  let step_size = if win_size > 1 then win_size / 2 else 1 in
  let cover_transform (l : float list) : float list =
    let sublists = cover_list win_size step_size l in
    if sublists = [] then l
    else
      List.map (fun win ->
        let sum = List.fold_left (+.) 0.0 win in
        sum /. float_of_int (List.length win)
      ) sublists
  in
  let route_cover = {
    route_name = Printf.sprintf "cover(w=%d, s=%d) -> cast(%s)" win_size step_size target_name;
    complexity = 1.2;
    dissipation = 0.3;
    transform = cover_transform;
    predict_transform = cover_transform;
  } in

  (* Candidate 3: Spectral Decomposition (Discrete difference basis) *)
  let spectral_transform (l : float list) : float list =
    match l with
    | [] -> []
    | x0 :: rest ->
        let rec diff prev acc = function
          | [] -> List.rev acc
          | x :: xs -> diff x ((x -. prev) :: acc) xs
        in
        diff x0 [x0] rest
  in
  let route_decompose = {
    route_name = Printf.sprintf "decompose(spectral) -> cast(%s)" target_name;
    complexity = 1.8;
    dissipation = 0.5;
    transform = spectral_transform;
    predict_transform = spectral_transform;
  } in

  (* Candidate 4: Concurrent Split *)
  let split_transform (l : float list) : float list =
    match l with
    | [] -> []
    | x0 :: rest ->
        let rec s prev acc = function
          | [] -> List.rev acc
          | x :: xs ->
              let low = 0.5 *. (x +. prev) in
              let high = 0.5 *. (x -. prev) in
              s x ((low +. high) :: acc) xs
        in
        s x0 [x0] rest
  in
  let route_split = {
    route_name = Printf.sprintf "split { high_pass, low_pass } -> cast(%s)" target_name;
    complexity = 2.0;
    dissipation = 0.7;
    transform = split_transform;
    predict_transform = split_transform;
  } in

  (* Representation Routing Heuristic Search (A* in Morphism Space) *)
  let candidates = [route_cast; route_cover; route_decompose; route_split] in
  let evaluated = List.map (fun r -> (r, evaluate_route r xs ys)) candidates in
  let sorted = List.sort (fun (_, (c1, _, _, _)) (_, (c2, _, _, _)) -> compare c1 c2) evaluated in
  let (best_route, (best_cost, best_loss, best_w, best_b)) = List.hd sorted in

  let predict_func (in_val : value) : value =
    match in_val with
    | VVec items ->
        let in_floats = List.map float_of_val items in
        let transformed = best_route.predict_transform in_floats in
        let preds = List.map (fun z -> VFloat ((best_w *. z) +. best_b)) transformed in
        VVec preds
    | scalar ->
        let s = float_of_val scalar in
        let pred = (best_w *. s) +. best_b in
        VFloat pred
  in

  VModel {
    model_name = "NeuClassifier";
    optimal_path = best_route.route_name;
    cost = best_cost;
    loss = best_loss;
    complexity = best_route.complexity;
    dissipation = best_route.dissipation;
    weights = [best_w];
    bias = best_b;
    predict = predict_func;
  }

let rec eval (env : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Float f -> VFloat f
  | Bool b -> VBool b
  | String s -> VString s
  | Ident id ->
      (try List.assoc id env
       with Not_found -> raise (EvalError ("Unbound variable: " ^ id)))
  | Vec exprs ->
      VVec (List.map (eval env) exprs)
  | Record fields ->
      VRecord (List.map (fun (k, ex) -> (k, eval env ex)) fields)
  | Let (id, e1, e2) ->
      let v1 = eval env e1 in
      eval ((id, v1) :: env) e2
  | BinOp (op, e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      apply_binop op v1 v2
  
  (* Flow (->) and Pipe (|>) handling *)
  | Flow (e1, e2) | Pipe (e1, e2) ->
      apply_flow env e1 e2

  (* Standalone structural operators *)
  | Split branches ->
      VVec (List.map (eval env) branches)
  | Scatter target ->
      let v_t = eval env target in
      VTagged ("scatter", v_t)
  | Decompose basis ->
      let v_b = eval env basis in
      VTagged ("decompose", v_b)
  | Cover (w_expr, s_expr) ->
      let w_val = eval env w_expr in
      let s_val = eval env s_expr in
      VTagged ("cover", VVec [w_val; s_val])
  | Shift d_expr ->
      let d_val = eval env d_expr in
      VTagged ("shift", d_val)
  | Cast t ->
      VTagged ("cast", VString t)
  | Learn params ->
      let eval_params = List.map (fun (k, ex) -> (k, eval env ex)) params in
      VTagged ("learn", VRecord eval_params)

  | If (cond, e1, e2) ->
      (match eval env cond with
       | VBool true -> eval env e1
       | VBool false -> eval env e2
       | _ -> raise (EvalError "Condition in 'if' must be a boolean"))
  | Lambda (params, body) ->
      VClosure (params, body, env)
  | Call (f_expr, args) ->
      let f_val = eval env f_expr in
      let arg_vals = List.map (eval env) args in
      (match f_val with
       | VModel m when List.length arg_vals = 1 ->
           m.predict (List.hd arg_vals)
       | VClosure (params, body, closure_env) ->
           if List.length params <> List.length arg_vals then
             raise (EvalError "Function arity mismatch")
           else
             let extended_env = List.combine params arg_vals @ closure_env in
             eval extended_env body
       | _ -> raise (EvalError "Attempted to call a non-function value"))

and apply_flow (env : env) (e1 : expr) (e2 : expr) : value =
  let v1 = eval env e1 in
  match e2 with
  (* 1. Split flow: data -> split { f1, f2, ... } *)
  | Split branches ->
      let results = List.map (fun branch ->
        match branch with
        | Lambda ([param], body) ->
            eval ((param, v1) :: env) body
        | Ident id ->
            let f_val = eval env (Ident id) in
            (match f_val with
             | VClosure ([param], body, c_env) -> eval ((param, v1) :: c_env) body
             | _ -> f_val)
        | other -> eval env other
      ) branches in
      VVec results

  (* 2. Shift flow: data -> shift(delta) *)
  | Shift d_expr ->
      let d_val = eval env d_expr in
      (match (v1, d_val) with
       | (VVec items, VInt offset) ->
           VVec (shift_list offset items)
       | _ -> raise (EvalError "Shift expects vector input and integer offset"))

  (* 3. Cover flow: data -> cover(window, step) *)
  | Cover (w_expr, s_expr) ->
      let w_val = eval env w_expr in
      let s_val = eval env s_expr in
      (match (v1, w_val, s_val) with
       | (VVec items, VInt w, VInt s) ->
           let covered = cover_list w s items in
           VVec (List.map (fun slice -> VVec slice) covered)
       | _ -> raise (EvalError "Cover expects vector input and integer window/step parameters"))

  (* 4. Cast flow: data -> cast(Type) *)
  | Cast type_name ->
      VTagged (type_name, v1)

  (* 5. Scatter flow: data -> scatter(lanes) *)
  | Scatter target_expr ->
      let target_val = eval env target_expr in
      VRecord [("scatter_data", v1); ("target", target_val)]

  (* 6. Decompose flow: data -> decompose(basis) *)
  | Decompose basis_expr ->
      let basis_val = eval env basis_expr in
      VRecord [("source", v1); ("basis", basis_val)]

  (* 7. Learn flow: data -> learn(...) *)
  | Learn params ->
      let eval_params = List.map (fun (k, ex) -> (k, eval env ex)) params in
      execute_learn env v1 eval_params

  (* 8. General function, model, or closure flow: data -> fn / model *)
  | _ ->
      let fn_val = eval env e2 in
      (match fn_val with
       | VModel m ->
           m.predict v1
       | VTagged ("learn", VRecord params) ->
           execute_learn env v1 params
       | VClosure ([param], body, closure_env) ->
           eval ((param, v1) :: closure_env) body
       | VClosure (param :: rest, body, closure_env) ->
           VClosure (rest, body, (param, v1) :: closure_env)
       | _ -> raise (EvalError "RHS of flow (->) must be an engine, model, or function closure"))

let eval_decl (env : env) (d : decl) : env * string option =
  match d with
  | DeclExpr e ->
      let v = eval env e in
      (env, Some (string_of_val v))
  | DeclLet (id, e) ->
      let v = eval env e in
      let new_env = (id, v) :: env in
      (new_env, Some (Printf.sprintf "let %s = %s" id (string_of_val v)))
  | DeclFn (name, params, _, body) ->
      let closure = VClosure (params, body, env) in
      let new_env = (name, closure) :: env in
      (new_env, Some (Printf.sprintf "fn %s(%s) defined" name (String.concat ", " params)))
  | DeclContract c ->
      let new_env = (c.contract_name, VContract c) :: env in
      (new_env, Some (Printf.sprintf "contract %s defined (%d rules)" c.contract_name (List.length c.rules)))

let eval_program (prog : program) : string list =
  let rec loop env decls acc =
    match decls with
    | [] -> List.rev acc
    | d :: rest ->
        let (new_env, res_opt) = eval_decl env d in
        let new_acc = match res_opt with Some s -> s :: acc | None -> acc in
        loop new_env rest new_acc
  in
  loop [] prog []
