
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | TRANSFORMATION
    | THEN
    | SYNTHESIS
    | SUPPRESS_DOSAGE
    | STRING of 
# 7 "lib/parser.mly"
       (string)
# 19 "lib/parser.ml"
  
    | STAR
    | SLASH
    | SET_DOSAGE
    | SEMICOLON
    | RULE
    | RPAREN
    | RBRACKET
    | RBRACE
    | PLUS
    | PIPE
    | MINUS
    | LPAREN
    | LET
    | LESS_EQUAL
    | LESS
    | LBRACKET
    | LBRACE
    | INT of 
# 5 "lib/parser.mly"
       (int)
# 41 "lib/parser.ml"
  
    | IN
    | IF
    | IDENT of 
# 7 "lib/parser.mly"
       (string)
# 48 "lib/parser.ml"
  
    | GREATER_EQUAL
    | GREATER
    | FN
    | FLOAT of 
# 6 "lib/parser.mly"
       (float)
# 56 "lib/parser.ml"
  
    | EQUAL_EQUAL
    | EQUAL
    | EOF
    | ELSE
    | DOT_DOT
    | CONTRACT
    | COMMA
    | COLON
    | BOOL of 
# 8 "lib/parser.mly"
       (bool)
# 69 "lib/parser.ml"
  
    | ARROW
    | ANALYSIS
  
end

include MenhirBasics

# 1 "lib/parser.mly"
  
  open Ast

# 82 "lib/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_program_file) _menhir_state
    (** State 000.
        Stack shape : <empty>.
        Start symbol: program_file. *)

  | MenhirState002 : (('s, 'r) _menhir_cell1_LPAREN, 'r) _menhir_state
    (** State 002.
        Stack shape : LPAREN.
        Start symbol: <undetermined>. *)

  | MenhirState005 : (('s, 'r) _menhir_cell1_LET _menhir_cell0_IDENT, 'r) _menhir_state
    (** State 005.
        Stack shape : LET IDENT.
        Start symbol: <undetermined>. *)

  | MenhirState006 : (('s, 'r) _menhir_cell1_LBRACKET, 'r) _menhir_state
    (** State 006.
        Stack shape : LBRACKET.
        Start symbol: <undetermined>. *)

  | MenhirState007 : (('s, 'r) _menhir_cell1_LBRACE, 'r) _menhir_state
    (** State 007.
        Stack shape : LBRACE.
        Start symbol: <undetermined>. *)

  | MenhirState009 : (('s, 'r) _menhir_cell1_IDENT, 'r) _menhir_state
    (** State 009.
        Stack shape : IDENT.
        Start symbol: <undetermined>. *)

  | MenhirState011 : (('s, 'r) _menhir_cell1_IF, 'r) _menhir_state
    (** State 011.
        Stack shape : IF.
        Start symbol: <undetermined>. *)

  | MenhirState016 : (('s, 'r) _menhir_cell1_term_expr, 'r) _menhir_state
    (** State 016.
        Stack shape : term_expr.
        Start symbol: <undetermined>. *)

  | MenhirState018 : (('s, 'r) _menhir_cell1_term_expr, 'r) _menhir_state
    (** State 018.
        Stack shape : term_expr.
        Start symbol: <undetermined>. *)

  | MenhirState021 : (('s, 'r) _menhir_cell1_pipe_expr, 'r) _menhir_state
    (** State 021.
        Stack shape : pipe_expr.
        Start symbol: <undetermined>. *)

  | MenhirState025 : (('s, 'r) _menhir_cell1_arith_expr, 'r) _menhir_state
    (** State 025.
        Stack shape : arith_expr.
        Start symbol: <undetermined>. *)

  | MenhirState027 : (('s, 'r) _menhir_cell1_arith_expr, 'r) _menhir_state
    (** State 027.
        Stack shape : arith_expr.
        Start symbol: <undetermined>. *)

  | MenhirState034 : (('s, 'r) _menhir_cell1_arith_expr _menhir_cell0_comp_op, 'r) _menhir_state
    (** State 034.
        Stack shape : arith_expr comp_op.
        Start symbol: <undetermined>. *)

  | MenhirState038 : ((('s, 'r) _menhir_cell1_IF, 'r) _menhir_cell1_expr, 'r) _menhir_state
    (** State 038.
        Stack shape : IF expr.
        Start symbol: <undetermined>. *)

  | MenhirState040 : (((('s, 'r) _menhir_cell1_IF, 'r) _menhir_cell1_expr, 'r) _menhir_cell1_expr, 'r) _menhir_state
    (** State 040.
        Stack shape : IF expr expr.
        Start symbol: <undetermined>. *)

  | MenhirState045 : (('s, 'r) _menhir_cell1_record_field, 'r) _menhir_state
    (** State 045.
        Stack shape : record_field.
        Start symbol: <undetermined>. *)

  | MenhirState053 : (('s, 'r) _menhir_cell1_expr, 'r) _menhir_state
    (** State 053.
        Stack shape : expr.
        Start symbol: <undetermined>. *)

  | MenhirState055 : ((('s, 'r) _menhir_cell1_LET _menhir_cell0_IDENT, 'r) _menhir_cell1_expr, 'r) _menhir_state
    (** State 055.
        Stack shape : LET IDENT expr.
        Start symbol: <undetermined>. *)

  | MenhirState056 : (((('s, 'r) _menhir_cell1_LET _menhir_cell0_IDENT, 'r) _menhir_cell1_expr, 'r) _menhir_cell1_IN, 'r) _menhir_state
    (** State 056.
        Stack shape : LET IDENT expr IN.
        Start symbol: <undetermined>. *)

  | MenhirState062 : (('s, _menhir_box_program_file) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_state
    (** State 062.
        Stack shape : LET IDENT.
        Start symbol: program_file. *)

  | MenhirState063 : ((('s, _menhir_box_program_file) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_expr, _menhir_box_program_file) _menhir_state
    (** State 063.
        Stack shape : LET IDENT expr.
        Start symbol: program_file. *)

  | MenhirState068 : (('s, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_state
    (** State 068.
        Stack shape : FN IDENT.
        Start symbol: program_file. *)

  | MenhirState070 : (('s, _menhir_box_program_file) _menhir_cell1_IDENT, _menhir_box_program_file) _menhir_state
    (** State 070.
        Stack shape : IDENT.
        Start symbol: program_file. *)

  | MenhirState075 : ((('s, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__, _menhir_box_program_file) _menhir_state
    (** State 075.
        Stack shape : FN IDENT loption(separated_nonempty_list(COMMA,IDENT)).
        Start symbol: program_file. *)

  | MenhirState076 : (((('s, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__, _menhir_box_program_file) _menhir_cell1_expr, _menhir_box_program_file) _menhir_state
    (** State 076.
        Stack shape : FN IDENT loption(separated_nonempty_list(COMMA,IDENT)) expr.
        Start symbol: program_file. *)

  | MenhirState083 : ((('s, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_cell0_engine_annot, _menhir_box_program_file) _menhir_state
    (** State 083.
        Stack shape : FN IDENT loption(separated_nonempty_list(COMMA,IDENT)) engine_annot.
        Start symbol: program_file. *)

  | MenhirState084 : (((('s, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_cell0_engine_annot, _menhir_box_program_file) _menhir_cell1_expr, _menhir_box_program_file) _menhir_state
    (** State 084.
        Stack shape : FN IDENT loption(separated_nonempty_list(COMMA,IDENT)) engine_annot expr.
        Start symbol: program_file. *)

  | MenhirState088 : (('s, _menhir_box_program_file) _menhir_cell1_CONTRACT _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_state
    (** State 088.
        Stack shape : CONTRACT IDENT.
        Start symbol: program_file. *)

  | MenhirState091 : (('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_state
    (** State 091.
        Stack shape : RULE INT.
        Start symbol: program_file. *)

  | MenhirState096 : ((('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_state
    (** State 096.
        Stack shape : RULE INT signed_int.
        Start symbol: program_file. *)

  | MenhirState098 : (((('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_state
    (** State 098.
        Stack shape : RULE INT signed_int signed_int.
        Start symbol: program_file. *)

  | MenhirState100 : ((((('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_state
    (** State 100.
        Stack shape : RULE INT signed_int signed_int signed_int.
        Start symbol: program_file. *)

  | MenhirState105 : (((((('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_state
    (** State 105.
        Stack shape : RULE INT signed_int signed_int signed_int signed_int.
        Start symbol: program_file. *)

  | MenhirState109 : (((((('s, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int _menhir_cell0_action_spec _menhir_cell0_STRING, _menhir_box_program_file) _menhir_state
    (** State 109.
        Stack shape : RULE INT signed_int signed_int signed_int signed_int action_spec STRING.
        Start symbol: program_file. *)

  | MenhirState111 : (('s, _menhir_box_program_file) _menhir_cell1_rule_spec, _menhir_box_program_file) _menhir_state
    (** State 111.
        Stack shape : rule_spec.
        Start symbol: program_file. *)

  | MenhirState119 : (('s, _menhir_box_program_file) _menhir_cell1_expr, _menhir_box_program_file) _menhir_state
    (** State 119.
        Stack shape : expr.
        Start symbol: program_file. *)

  | MenhirState121 : (('s, _menhir_box_program_file) _menhir_cell1_decl, _menhir_box_program_file) _menhir_state
    (** State 121.
        Stack shape : decl.
        Start symbol: program_file. *)

  | MenhirState124 : ('s, _menhir_box_single_expr) _menhir_state
    (** State 124.
        Stack shape : <empty>.
        Start symbol: single_expr. *)


and 's _menhir_cell0_action_spec = 
  | MenhirCell0_action_spec of 's * (Ast.bio_act)

and ('s, 'r) _menhir_cell1_arith_expr = 
  | MenhirCell1_arith_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and 's _menhir_cell0_comp_op = 
  | MenhirCell0_comp_op of 's * (string)

and ('s, 'r) _menhir_cell1_decl = 
  | MenhirCell1_decl of 's * ('s, 'r) _menhir_state * (Ast.decl)

and 's _menhir_cell0_engine_annot = 
  | MenhirCell0_engine_annot of 's * (Ast.engine_type)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ = 
  | MenhirCell1_loption_separated_nonempty_list_COMMA_IDENT__ of 's * ('s, 'r) _menhir_state * (string list)

and ('s, 'r) _menhir_cell1_pipe_expr = 
  | MenhirCell1_pipe_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_record_field = 
  | MenhirCell1_record_field of 's * ('s, 'r) _menhir_state * (string * Ast.expr)

and ('s, 'r) _menhir_cell1_rule_spec = 
  | MenhirCell1_rule_spec of 's * ('s, 'r) _menhir_state * (Ast.bio_rule)

and ('s, 'r) _menhir_cell1_signed_int = 
  | MenhirCell1_signed_int of 's * ('s, 'r) _menhir_state * (int)

and ('s, 'r) _menhir_cell1_term_expr = 
  | MenhirCell1_term_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_CONTRACT = 
  | MenhirCell1_CONTRACT of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_FN = 
  | MenhirCell1_FN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_IDENT = 
  | MenhirCell1_IDENT of 's * ('s, 'r) _menhir_state * 
# 7 "lib/parser.mly"
       (string)
# 322 "lib/parser.ml"


and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * 
# 7 "lib/parser.mly"
       (string)
# 329 "lib/parser.ml"


and ('s, 'r) _menhir_cell1_IF = 
  | MenhirCell1_IF of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_IN = 
  | MenhirCell1_IN of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_INT = 
  | MenhirCell0_INT of 's * 
# 5 "lib/parser.mly"
       (int)
# 342 "lib/parser.ml"


and ('s, 'r) _menhir_cell1_LBRACE = 
  | MenhirCell1_LBRACE of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LBRACKET = 
  | MenhirCell1_LBRACKET of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LET = 
  | MenhirCell1_LET of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LPAREN = 
  | MenhirCell1_LPAREN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_RULE = 
  | MenhirCell1_RULE of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_STRING = 
  | MenhirCell0_STRING of 's * 
# 7 "lib/parser.mly"
       (string)
# 364 "lib/parser.ml"


and _menhir_box_single_expr = 
  | MenhirBox_single_expr of (Ast.expr) [@@unboxed]

and _menhir_box_program_file = 
  | MenhirBox_program_file of (Ast.program) [@@unboxed]

let _menhir_action_02 =
  fun u ->
    (
# 69 "lib/parser.mly"
                                               ( SetDosage u )
# 378 "lib/parser.ml"
     : (Ast.bio_act))

let _menhir_action_03 =
  fun () ->
    (
# 70 "lib/parser.mly"
                                               ( SuppressDosage )
# 386 "lib/parser.ml"
     : (Ast.bio_act))

let _menhir_action_04 =
  fun e1 e2 ->
    (
# 104 "lib/parser.mly"
                                           ( BinOp ("+", e1, e2) )
# 394 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_05 =
  fun e1 e2 ->
    (
# 105 "lib/parser.mly"
                                           ( BinOp ("-", e1, e2) )
# 402 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_06 =
  fun e ->
    (
# 106 "lib/parser.mly"
                  ( e )
# 410 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_07 =
  fun i ->
    (
# 114 "lib/parser.mly"
               ( Int i )
# 418 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_08 =
  fun f ->
    (
# 115 "lib/parser.mly"
               ( Float f )
# 426 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_09 =
  fun b ->
    (
# 116 "lib/parser.mly"
               ( Bool b )
# 434 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_10 =
  fun s ->
    (
# 117 "lib/parser.mly"
               ( String s )
# 442 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_11 =
  fun id ->
    (
# 118 "lib/parser.mly"
               ( Ident id )
# 450 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_12 =
  fun xs ->
    let items = 
# 241 "<standard.mly>"
    ( xs )
# 458 "lib/parser.ml"
     in
    (
# 119 "lib/parser.mly"
                                                            ( Vec items )
# 463 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_13 =
  fun xs ->
    let fields = 
# 241 "<standard.mly>"
    ( xs )
# 471 "lib/parser.ml"
     in
    (
# 120 "lib/parser.mly"
                                                                 ( Record fields )
# 476 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_14 =
  fun e1 e2 id ->
    (
# 121 "lib/parser.mly"
                                                     ( Let (id, e1, e2) )
# 484 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_15 =
  fun c e1 e2 ->
    (
# 122 "lib/parser.mly"
                                                   ( If (c, e1, e2) )
# 492 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_16 =
  fun e ->
    (
# 123 "lib/parser.mly"
                             ( e )
# 500 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_17 =
  fun () ->
    (
# 97 "lib/parser.mly"
                  ( "==" )
# 508 "lib/parser.ml"
     : (string))

let _menhir_action_18 =
  fun () ->
    (
# 98 "lib/parser.mly"
                  ( "<=" )
# 516 "lib/parser.ml"
     : (string))

let _menhir_action_19 =
  fun () ->
    (
# 99 "lib/parser.mly"
                  ( ">=" )
# 524 "lib/parser.ml"
     : (string))

let _menhir_action_20 =
  fun () ->
    (
# 100 "lib/parser.mly"
                  ( "<" )
# 532 "lib/parser.ml"
     : (string))

let _menhir_action_21 =
  fun () ->
    (
# 101 "lib/parser.mly"
                  ( ">" )
# 540 "lib/parser.ml"
     : (string))

let _menhir_action_22 =
  fun name rules ->
    (
# 38 "lib/parser.mly"
    (
      DeclContract {
        contract_name = name;
        min_glucose = 70;
        max_dosage = 50;
        basal_dosage = 10;
        steep_fall_threshold = -2;
        rules = rules;
      }
    )
# 557 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_23 =
  fun d ->
    (
# 29 "lib/parser.mly"
                      ( d )
# 565 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_24 =
  fun d ->
    (
# 30 "lib/parser.mly"
                      ( d )
# 573 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_25 =
  fun e id ->
    (
# 31 "lib/parser.mly"
                                                 ( DeclLet (id, e) )
# 581 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_26 =
  fun e ->
    (
# 32 "lib/parser.mly"
                         ( DeclExpr e )
# 589 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_27 =
  fun () ->
    (
# 78 "lib/parser.mly"
                          ( Synthesis )
# 597 "lib/parser.ml"
     : (Ast.engine_type))

let _menhir_action_28 =
  fun () ->
    (
# 79 "lib/parser.mly"
                          ( Analysis )
# 605 "lib/parser.ml"
     : (Ast.engine_type))

let _menhir_action_29 =
  fun () ->
    (
# 80 "lib/parser.mly"
                          ( Transformation )
# 613 "lib/parser.ml"
     : (Ast.engine_type))

let _menhir_action_30 =
  fun e ->
    (
# 86 "lib/parser.mly"
                  ( e )
# 621 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_31 =
  fun body name xs ->
    let eng = 
# 123 "<standard.mly>"
    ( None )
# 629 "lib/parser.ml"
     in
    let params = 
# 241 "<standard.mly>"
    ( xs )
# 634 "lib/parser.ml"
     in
    (
# 75 "lib/parser.mly"
    ( DeclFn (name, params, eng, body) )
# 639 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_32 =
  fun body name x xs ->
    let eng = 
# 126 "<standard.mly>"
    ( Some x )
# 647 "lib/parser.ml"
     in
    let params = 
# 241 "<standard.mly>"
    ( xs )
# 652 "lib/parser.ml"
     in
    (
# 75 "lib/parser.mly"
    ( DeclFn (name, params, eng, body) )
# 657 "lib/parser.ml"
     : (Ast.decl))

let _menhir_action_33 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 665 "lib/parser.ml"
     : (Ast.program))

let _menhir_action_34 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 673 "lib/parser.ml"
     : (Ast.program))

let _menhir_action_35 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 681 "lib/parser.ml"
     : (Ast.bio_rule list))

let _menhir_action_36 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 689 "lib/parser.ml"
     : (Ast.bio_rule list))

let _menhir_action_37 =
  fun e1 e2 op ->
    (
# 93 "lib/parser.mly"
                                                   ( BinOp (op, e1, e2) )
# 697 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_38 =
  fun e ->
    (
# 94 "lib/parser.mly"
                   ( e )
# 705 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_39 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 713 "lib/parser.ml"
     : (string list))

let _menhir_action_40 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 721 "lib/parser.ml"
     : (string list))

let _menhir_action_41 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 729 "lib/parser.ml"
     : (Ast.expr list))

let _menhir_action_42 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 737 "lib/parser.ml"
     : (Ast.expr list))

let _menhir_action_43 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 745 "lib/parser.ml"
     : ((string * Ast.expr) list))

let _menhir_action_44 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 753 "lib/parser.ml"
     : ((string * Ast.expr) list))

let _menhir_action_45 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 761 "lib/parser.ml"
     : (unit option))

let _menhir_action_46 =
  fun x ->
    (
# 114 "<standard.mly>"
    ( Some x )
# 769 "lib/parser.ml"
     : (unit option))

let _menhir_action_47 =
  fun e1 e2 ->
    (
# 89 "lib/parser.mly"
                                          ( Pipe (e1, e2) )
# 777 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_48 =
  fun e ->
    (
# 90 "lib/parser.mly"
                   ( e )
# 785 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_49 =
  fun decls ->
    (
# 26 "lib/parser.mly"
                            ( decls )
# 793 "lib/parser.ml"
     : (Ast.program))

let _menhir_action_50 =
  fun key value ->
    (
# 126 "lib/parser.mly"
                                     ( (key, value) )
# 801 "lib/parser.ml"
     : (string * Ast.expr))

let _menhir_action_51 =
  fun act d_high d_low g_high g_low inv p ->
    (
# 58 "lib/parser.mly"
    (
      {
        priority = p;
        glucose_range = (g_low, g_high);
        delta_range = (d_low, d_high);
        action = act;
        invariant_id = inv;
      }
    )
# 817 "lib/parser.ml"
     : (Ast.bio_rule))

let _menhir_action_52 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 825 "lib/parser.ml"
     : (string list))

let _menhir_action_53 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 833 "lib/parser.ml"
     : (string list))

let _menhir_action_54 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 841 "lib/parser.ml"
     : (Ast.expr list))

let _menhir_action_55 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 849 "lib/parser.ml"
     : (Ast.expr list))

let _menhir_action_56 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 857 "lib/parser.ml"
     : ((string * Ast.expr) list))

let _menhir_action_57 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 865 "lib/parser.ml"
     : ((string * Ast.expr) list))

let _menhir_action_58 =
  fun i ->
    (
# 50 "lib/parser.mly"
                   ( i )
# 873 "lib/parser.ml"
     : (int))

let _menhir_action_59 =
  fun i ->
    (
# 51 "lib/parser.mly"
                   ( -i )
# 881 "lib/parser.ml"
     : (int))

let _menhir_action_60 =
  fun e ->
    (
# 83 "lib/parser.mly"
                  ( e )
# 889 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_61 =
  fun e1 e2 ->
    (
# 109 "lib/parser.mly"
                                          ( BinOp ("*", e1, e2) )
# 897 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_62 =
  fun e1 e2 ->
    (
# 110 "lib/parser.mly"
                                          ( BinOp ("/", e1, e2) )
# 905 "lib/parser.ml"
     : (Ast.expr))

let _menhir_action_63 =
  fun e ->
    (
# 111 "lib/parser.mly"
                  ( e )
# 913 "lib/parser.ml"
     : (Ast.expr))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | TRANSFORMATION ->
        "TRANSFORMATION"
    | THEN ->
        "THEN"
    | SYNTHESIS ->
        "SYNTHESIS"
    | SUPPRESS_DOSAGE ->
        "SUPPRESS_DOSAGE"
    | STRING _ ->
        "STRING"
    | STAR ->
        "STAR"
    | SLASH ->
        "SLASH"
    | SET_DOSAGE ->
        "SET_DOSAGE"
    | SEMICOLON ->
        "SEMICOLON"
    | RULE ->
        "RULE"
    | RPAREN ->
        "RPAREN"
    | RBRACKET ->
        "RBRACKET"
    | RBRACE ->
        "RBRACE"
    | PLUS ->
        "PLUS"
    | PIPE ->
        "PIPE"
    | MINUS ->
        "MINUS"
    | LPAREN ->
        "LPAREN"
    | LET ->
        "LET"
    | LESS_EQUAL ->
        "LESS_EQUAL"
    | LESS ->
        "LESS"
    | LBRACKET ->
        "LBRACKET"
    | LBRACE ->
        "LBRACE"
    | INT _ ->
        "INT"
    | IN ->
        "IN"
    | IF ->
        "IF"
    | IDENT _ ->
        "IDENT"
    | GREATER_EQUAL ->
        "GREATER_EQUAL"
    | GREATER ->
        "GREATER"
    | FN ->
        "FN"
    | FLOAT _ ->
        "FLOAT"
    | EQUAL_EQUAL ->
        "EQUAL_EQUAL"
    | EQUAL ->
        "EQUAL"
    | EOF ->
        "EOF"
    | ELSE ->
        "ELSE"
    | DOT_DOT ->
        "DOT_DOT"
    | CONTRACT ->
        "CONTRACT"
    | COMMA ->
        "COMMA"
    | COLON ->
        "COLON"
    | BOOL _ ->
        "BOOL"
    | ARROW ->
        "ARROW"
    | ANALYSIS ->
        "ANALYSIS"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_116 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_program_file =
    fun _menhir_stack _v ->
      let decls = _v in
      let _v = _menhir_action_49 decls in
      MenhirBox_program_file _v
  
  let rec _menhir_run_122 : type  ttv_stack. (ttv_stack, _menhir_box_program_file) _menhir_cell1_decl -> _ -> _menhir_box_program_file =
    fun _menhir_stack _v ->
      let MenhirCell1_decl (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_34 x xs in
      _menhir_goto_list_decl_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list_decl_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_116 _menhir_stack _v
      | MenhirState121 ->
          _menhir_run_122 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  let _menhir_run_126 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_single_expr =
    fun _menhir_stack _v _tok ->
      match (_tok : MenhirBasics.token) with
      | EOF ->
          let e = _v in
          let _v = _menhir_action_60 e in
          MenhirBox_single_expr _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_001 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let s = _v in
      let _v = _menhir_action_10 s in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_atom_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState016 ->
          _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState018 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState000 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState002 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState006 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState009 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState011 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState021 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState025 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState027 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState034 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState040 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState121 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState124 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_017 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_term_expr -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_term_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_61 e1 e2 in
      _menhir_goto_term_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_term_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState002 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState006 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState009 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState011 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState021 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState034 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState040 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState121 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState124 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState025 ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState027 ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_015 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer
      | SLASH ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | EQUAL_EQUAL | FLOAT _ | FN | GREATER | GREATER_EQUAL | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LESS | LESS_EQUAL | LET | LPAREN | MINUS | PIPE | PLUS | RBRACE | RBRACKET | RPAREN | SEMICOLON | STRING _ | THEN ->
          let e = _v in
          let _v = _menhir_action_06 e in
          _menhir_goto_arith_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_term_expr -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState016 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_002 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState002 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_003 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LET (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQUAL ->
              let _menhir_s = MenhirState005 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | STRING _v ->
                  _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | LPAREN ->
                  _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LET ->
                  _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LBRACKET ->
                  _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LBRACE ->
                  _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | INT _v ->
                  _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | IF ->
                  _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FLOAT _v ->
                  _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | BOOL _v ->
                  _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_006 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LBRACKET (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState006 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | RBRACKET ->
          let _v = _menhir_action_41 () in
          _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_007 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LBRACE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState007 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | RBRACE ->
          let _v = _menhir_action_43 () in
          _menhir_goto_loption_separated_nonempty_list_COMMA_record_field__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState009 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let i = _v in
      let _v = _menhir_action_07 i in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_011 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IF (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState011 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_012 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let id = _v in
      let _v = _menhir_action_11 id in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_013 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let f = _v in
      let _v = _menhir_action_08 f in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_014 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let b = _v in
      let _v = _menhir_action_09 b in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_record_field__ : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_LBRACE -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_LBRACE (_menhir_stack, _menhir_s) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_13 xs in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_LBRACKET -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_LBRACKET (_menhir_stack, _menhir_s) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_12 xs in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_018 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_term_expr -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState018 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_arith_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState002 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState006 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState009 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState011 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState021 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState040 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState121 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState124 ->
          _menhir_run_024 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState034 ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_024 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESS_EQUAL ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_18 () in
          _menhir_goto_comp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | LESS ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_20 () in
          _menhir_goto_comp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | GREATER_EQUAL ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_19 () in
          _menhir_goto_comp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | GREATER ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_21 () in
          _menhir_goto_comp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | EQUAL_EQUAL ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_17 () in
          _menhir_goto_comp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | FLOAT _ | FN | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LET | LPAREN | PIPE | RBRACE | RBRACKET | RPAREN | SEMICOLON | SLASH | STAR | STRING _ | THEN ->
          let e = _v in
          let _v = _menhir_action_38 e in
          _menhir_goto_logic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_025 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_arith_expr -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState025 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_027 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_arith_expr -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState027 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_comp_op : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_arith_expr -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_comp_op (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING _v_0 ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState034
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | INT _v_1 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState034
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | IDENT _v_2 ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState034
      | FLOAT _v_3 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState034
      | BOOL _v_4 ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState034
      | _ ->
          _eRR ()
  
  and _menhir_goto_logic_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState021 ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState000 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState002 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState006 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState009 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState011 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState040 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState121 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState124 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_022 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_pipe_expr -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_pipe_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_47 e1 e2 in
      _menhir_goto_pipe_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_pipe_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PIPE ->
          let _menhir_stack = MenhirCell1_pipe_expr (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState021 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | EQUAL_EQUAL | FLOAT _ | FN | GREATER | GREATER_EQUAL | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LESS | LESS_EQUAL | LET | LPAREN | MINUS | PLUS | RBRACE | RBRACKET | RPAREN | SEMICOLON | SLASH | STAR | STRING _ | THEN ->
          let e = _v in
          let _v = _menhir_action_30 e in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_goto_expr : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState011 ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState040 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState009 ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState006 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState002 ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState062 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState000 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState121 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState124 ->
          _menhir_run_126 _menhir_stack _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_037 : type  ttv_stack ttv_result. ((ttv_stack, ttv_result) _menhir_cell1_IF as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | THEN ->
          let _menhir_s = MenhirState038 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_039 : type  ttv_stack ttv_result. (((ttv_stack, ttv_result) _menhir_cell1_IF, ttv_result) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | ELSE ->
          let _menhir_s = MenhirState040 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_041 : type  ttv_stack ttv_result. (((ttv_stack, ttv_result) _menhir_cell1_IF, ttv_result) _menhir_cell1_expr, ttv_result) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _, e1) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _, c) = _menhir_stack in
      let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_15 c e1 e2 in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_042 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_IDENT -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, key) = _menhir_stack in
      let value = _v in
      let _v = _menhir_action_50 key value in
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_record_field (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState045 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | RBRACE ->
          let x = _v in
          let _v = _menhir_action_56 x in
          _menhir_goto_separated_nonempty_list_COMMA_record_field_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_record_field_ : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState007 ->
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState045 ->
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_043 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_LBRACE -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_44 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_record_field__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_run_046 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_record_field -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_record_field (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_57 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_record_field_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_052 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState053 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | RBRACKET ->
          let x = _v in
          let _v = _menhir_action_54 x in
          _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_expr_ : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState006 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState053 ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_049 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_LBRACKET -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_42 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_run_054 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_expr -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_55 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_055 : type  ttv_stack ttv_result. ((ttv_stack, ttv_result) _menhir_cell1_LET _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | IN ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState055
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack ttv_result. (((ttv_stack, ttv_result) _menhir_cell1_LET _menhir_cell0_IDENT, ttv_result) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, ttv_result) _menhir_state -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState056 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_057 : type  ttv_stack ttv_result. (((ttv_stack, ttv_result) _menhir_cell1_LET _menhir_cell0_IDENT, ttv_result) _menhir_cell1_expr, ttv_result) _menhir_cell1_IN -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_IN (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _, e1) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, id) = _menhir_stack in
      let MenhirCell1_LET (_menhir_stack, _menhir_s) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_14 e1 e2 id in
      _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_058 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_LPAREN -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_16 e in
          _menhir_goto_atom_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_LET _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | IN ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState063
      | BOOL _ | CONTRACT | EOF | FLOAT _ | FN | IDENT _ | IF | INT _ | LBRACE | LBRACKET | LET | LPAREN | STRING _ ->
          let _ = _menhir_action_45 () in
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = () in
      let _ = _menhir_action_46 x in
      _menhir_goto_option_SEMICOLON_ _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
  
  and _menhir_goto_option_SEMICOLON_ : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      match _menhir_s with
      | MenhirState063 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState076 ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState084 ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState109 ->
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | MenhirState119 ->
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_065 : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_expr (_menhir_stack, _, e) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, id) = _menhir_stack in
      let MenhirCell1_LET (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_25 e id in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_decl : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_decl (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING _v_0 ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState121
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | LET ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | INT _v_1 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState121
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | IDENT _v_2 ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState121
      | FN ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | FLOAT _v_3 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState121
      | CONTRACT ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState121
      | BOOL _v_4 ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState121
      | EOF ->
          let _v_5 = _menhir_action_33 () in
          _menhir_run_122 _menhir_stack _v_5
      | _ ->
          _eRR ()
  
  and _menhir_run_060 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LET (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQUAL ->
              let _menhir_s = MenhirState062 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | STRING _v ->
                  _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | LPAREN ->
                  _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LET ->
                  _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LBRACKET ->
                  _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LBRACE ->
                  _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | INT _v ->
                  _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | IF ->
                  _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FLOAT _v ->
                  _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | BOOL _v ->
                  _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_066 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LPAREN ->
              let _menhir_s = MenhirState068 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | IDENT _v ->
                  _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | RPAREN ->
                  let _v = _menhir_action_39 () in
                  _menhir_goto_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_069 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState070 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | RPAREN ->
          let x = _v in
          let _v = _menhir_action_52 x in
          _menhir_goto_separated_nonempty_list_COMMA_IDENT_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_IDENT_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState070 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState068 ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_071 : type  ttv_stack. (ttv_stack, _menhir_box_program_file) _menhir_cell1_IDENT -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_53 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_IDENT_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_072 : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let x = _v in
      let _v = _menhir_action_40 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_IDENT__ : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_loption_separated_nonempty_list_COMMA_IDENT__ (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _menhir_s = MenhirState075 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | COLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | TRANSFORMATION ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_29 () in
              _menhir_goto_engine_annot _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | SYNTHESIS ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_27 () in
              _menhir_goto_engine_annot _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | ANALYSIS ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_28 () in
              _menhir_goto_engine_annot _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_engine_annot : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ -> _ -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_engine_annot (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _menhir_s = MenhirState083 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LPAREN ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACKET ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LBRACE ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IF ->
              _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOAT _v ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BOOL _v ->
              _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_CONTRACT (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LBRACE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | RULE ->
                  _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState088
              | RBRACE ->
                  let _v_0 = _menhir_action_35 () in
                  _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_089 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_RULE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | INT _v ->
          let _menhir_stack = MenhirCell0_INT (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState091 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | MINUS ->
                  _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | INT _v ->
                  _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let i = _v in
          let _v = _menhir_action_59 i in
          _menhir_goto_signed_int _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_signed_int : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState091 ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState098 ->
          _menhir_run_099 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState105 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_095 : type  ttv_stack. ((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_signed_int (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | DOT_DOT ->
          let _menhir_s = MenhirState096 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | MINUS ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_094 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let i = _v in
      let _v = _menhir_action_58 i in
      _menhir_goto_signed_int _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_097 : type  ttv_stack. (((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_signed_int (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_s = MenhirState098 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | MINUS ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_099 : type  ttv_stack. ((((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_signed_int (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | DOT_DOT ->
          let _menhir_s = MenhirState100 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | MINUS ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INT _v ->
              _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_101 : type  ttv_stack. (((((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_signed_int (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | ARROW ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SUPPRESS_DOSAGE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_03 () in
              _menhir_goto_action_spec _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | SET_DOSAGE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LPAREN ->
                  let _menhir_s = MenhirState105 in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | MINUS ->
                      _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | INT _v ->
                      _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_action_spec : type  ttv_stack. (((((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int -> _ -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_action_spec (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING _v_0 ->
          let _menhir_stack = MenhirCell0_STRING (_menhir_stack, _v_0) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SEMICOLON ->
              _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState109
          | RBRACE | RULE ->
              let _ = _menhir_action_45 () in
              _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_110 : type  ttv_stack. (((((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int _menhir_cell0_action_spec _menhir_cell0_STRING -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell0_STRING (_menhir_stack, inv) = _menhir_stack in
      let MenhirCell0_action_spec (_menhir_stack, act) = _menhir_stack in
      let MenhirCell1_signed_int (_menhir_stack, _, d_high) = _menhir_stack in
      let MenhirCell1_signed_int (_menhir_stack, _, d_low) = _menhir_stack in
      let MenhirCell1_signed_int (_menhir_stack, _, g_high) = _menhir_stack in
      let MenhirCell1_signed_int (_menhir_stack, _, g_low) = _menhir_stack in
      let MenhirCell0_INT (_menhir_stack, p) = _menhir_stack in
      let MenhirCell1_RULE (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_51 act d_high d_low g_high g_low inv p in
      let _menhir_stack = MenhirCell1_rule_spec (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | RULE ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState111
      | RBRACE ->
          let _v_0 = _menhir_action_35 () in
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_112 : type  ttv_stack. (ttv_stack, _menhir_box_program_file) _menhir_cell1_rule_spec -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_rule_spec (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_36 x xs in
      _menhir_goto_list_rule_spec_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_rule_spec_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState111 ->
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState088 ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_113 : type  ttv_stack. (ttv_stack, _menhir_box_program_file) _menhir_cell1_CONTRACT _menhir_cell0_IDENT -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_IDENT (_menhir_stack, name) = _menhir_stack in
      let MenhirCell1_CONTRACT (_menhir_stack, _menhir_s) = _menhir_stack in
      let rules = _v in
      let _v = _menhir_action_22 name rules in
      let d = _v in
      let _v = _menhir_action_23 d in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_106 : type  ttv_stack. (((((ttv_stack, _menhir_box_program_file) _menhir_cell1_RULE _menhir_cell0_INT, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int, _menhir_box_program_file) _menhir_cell1_signed_int -> _ -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let u = _v in
          let _v = _menhir_action_02 u in
          _menhir_goto_action_spec _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_077 : type  ttv_stack. (((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__, _menhir_box_program_file) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_expr (_menhir_stack, _, body) = _menhir_stack in
      let MenhirCell1_loption_separated_nonempty_list_COMMA_IDENT__ (_menhir_stack, _, xs) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, name) = _menhir_stack in
      let MenhirCell1_FN (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_31 body name xs in
      _menhir_goto_fn_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_fn_decl : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let d = _v in
      let _v = _menhir_action_24 d in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_085 : type  ttv_stack. (((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_cell0_engine_annot, _menhir_box_program_file) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_expr (_menhir_stack, _, body) = _menhir_stack in
      let MenhirCell0_engine_annot (_menhir_stack, x) = _menhir_stack in
      let MenhirCell1_loption_separated_nonempty_list_COMMA_IDENT__ (_menhir_stack, _, xs) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, name) = _menhir_stack in
      let MenhirCell1_FN (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_32 body name x xs in
      _menhir_goto_fn_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_120 : type  ttv_stack. (ttv_stack, _menhir_box_program_file) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e) = _menhir_stack in
      let _v = _menhir_action_26 e in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_076 : type  ttv_stack. (((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState076
      | BOOL _ | CONTRACT | EOF | FLOAT _ | FN | IDENT _ | IF | INT _ | LBRACE | LBRACKET | LET | LPAREN | STRING _ ->
          let _ = _menhir_action_45 () in
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_084 : type  ttv_stack. (((ttv_stack, _menhir_box_program_file) _menhir_cell1_FN _menhir_cell0_IDENT, _menhir_box_program_file) _menhir_cell1_loption_separated_nonempty_list_COMMA_IDENT__ _menhir_cell0_engine_annot as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | BOOL _ | CONTRACT | EOF | FLOAT _ | FN | IDENT _ | IF | INT _ | LBRACE | LBRACKET | LET | LPAREN | STRING _ ->
          let _ = _menhir_action_45 () in
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_119 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program_file) _menhir_state -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState119
      | BOOL _ | CONTRACT | EOF | FLOAT _ | FN | IDENT _ | IF | INT _ | LBRACE | LBRACKET | LET | LPAREN | STRING _ ->
          let _ = _menhir_action_45 () in
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_036 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let e = _v in
      let _v = _menhir_action_48 e in
      _menhir_goto_pipe_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_035 : type  ttv_stack ttv_result. ((ttv_stack, ttv_result) _menhir_cell1_arith_expr _menhir_cell0_comp_op as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_arith_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | EQUAL_EQUAL | FLOAT _ | FN | GREATER | GREATER_EQUAL | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LESS | LESS_EQUAL | LET | LPAREN | PIPE | RBRACE | RBRACKET | RPAREN | SEMICOLON | SLASH | STAR | STRING _ | THEN ->
          let MenhirCell0_comp_op (_menhir_stack, op) = _menhir_stack in
          let MenhirCell1_arith_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_37 e1 e2 op in
          _menhir_goto_logic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_026 : type  ttv_stack ttv_result. ((ttv_stack, ttv_result) _menhir_cell1_arith_expr as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer
      | SLASH ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | EQUAL_EQUAL | FLOAT _ | FN | GREATER | GREATER_EQUAL | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LESS | LESS_EQUAL | LET | LPAREN | MINUS | PIPE | PLUS | RBRACE | RBRACKET | RPAREN | SEMICOLON | STRING _ | THEN ->
          let MenhirCell1_arith_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_04 e1 e2 in
          _menhir_goto_arith_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_028 : type  ttv_stack ttv_result. ((ttv_stack, ttv_result) _menhir_cell1_arith_expr as 'stack) -> _ -> _ -> _ -> ('stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | STAR ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer
      | SLASH ->
          let _menhir_stack = MenhirCell1_term_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL _ | COMMA | CONTRACT | ELSE | EOF | EQUAL_EQUAL | FLOAT _ | FN | GREATER | GREATER_EQUAL | IDENT _ | IF | IN | INT _ | LBRACE | LBRACKET | LESS | LESS_EQUAL | LET | LPAREN | MINUS | PIPE | PLUS | RBRACE | RBRACKET | RPAREN | SEMICOLON | STRING _ | THEN ->
          let MenhirCell1_arith_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_05 e1 e2 in
          _menhir_goto_arith_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_019 : type  ttv_stack ttv_result. (ttv_stack, ttv_result) _menhir_cell1_term_expr -> _ -> _ -> _ -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_term_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_62 e1 e2 in
      _menhir_goto_term_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_023 : type  ttv_stack ttv_result. ttv_stack -> _ -> _ -> _ -> (ttv_stack, ttv_result) _menhir_state -> _ -> ttv_result =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let e = _v in
      let _v = _menhir_action_63 e in
      _menhir_goto_term_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program_file =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | LET ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | FN ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | CONTRACT ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | EOF ->
          let _v = _menhir_action_33 () in
          _menhir_run_116 _menhir_stack _v
      | _ ->
          _eRR ()
  
  let _menhir_run_124 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_single_expr =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState124 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | STRING _v ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACKET ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LBRACE ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IF ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT _v ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL _v ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
end

let single_expr =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_single_expr v = _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

let program_file =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program_file v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
