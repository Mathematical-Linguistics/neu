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

  (* 7. General function / closure flow: data -> fn *)
  | _ ->
      let fn_val = eval env e2 in
      (match fn_val with
       | VClosure ([param], body, closure_env) ->
           eval ((param, v1) :: closure_env) body
       | VClosure (param :: rest, body, closure_env) ->
           VClosure (rest, body, (param, v1) :: closure_env)
       | _ -> raise (EvalError "RHS of flow (->) must be an engine or function closure"))

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
