(** =========================================================================
    ast.ml
    Abstract Syntax Tree for Neu:
    Engine Expression Language with Structural Flow (->, split, scatter,
    decompose, cover, shift, cast)
    ========================================================================= *)

type engine_type =
  | Synthesis       (** H(S_n) > H(S_1): Generative / expanding *)
  | Analysis        (** H(S_n) < H(S_1): Compressive / feature extraction *)
  | Transformation  (** H(S_n) = H(S_1): Isomorphic / lossless *)

type bio_act =
  | SetDosage of int
  | SuppressDosage
  | ModulateBasal of float
  | AlertClinician of int

type bio_rule = {
  priority : int;
  glucose_range : int * int;
  delta_range : int * int;
  action : bio_act;
  invariant_id : string;
}

type clinical_contract = {
  contract_name : string;
  min_glucose : int;
  max_dosage : int;
  basal_dosage : int;
  steep_fall_threshold : int;
  rules : bio_rule list;
}

type expr =
  | Int of int
  | Float of float
  | Bool of bool
  | String of string
  | Ident of string
  | Vec of expr list
  | Record of (string * expr) list
  | Let of string * expr * expr
  | BinOp of string * expr * expr
  | Pipe of expr * expr
  | Flow of expr * expr                    (** Morphism flow: e1 -> e2 *)
  | Split of expr list                     (** Concurrent split: split { e1, e2, ... } *)
  | Scatter of expr                        (** Scatter distribution: scatter(lanes) *)
  | Decompose of expr                      (** Constituent decomposition: decompose(basis) *)
  | Cover of expr * expr                   (** Topological cover: cover(window, step) *)
  | Shift of expr                          (** Displace / offset: shift(delta) *)
  | Cast of string                         (** Functorial cast: cast(Type) *)
  | If of expr * expr * expr
  | Lambda of string list * expr
  | Call of expr * expr list

type decl =
  | DeclExpr of expr
  | DeclLet of string * expr
  | DeclFn of string * string list * engine_type option * expr
  | DeclContract of clinical_contract

type program = decl list
