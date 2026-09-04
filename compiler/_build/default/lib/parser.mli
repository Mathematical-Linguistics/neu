
(* The type of tokens. *)

type token = 
  | TRANSFORMATION
  | THEN
  | SYNTHESIS
  | SUPPRESS_DOSAGE
  | STRING of (string)
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
  | INT of (int)
  | IN
  | IF
  | IDENT of (string)
  | GREATER_EQUAL
  | GREATER
  | FN
  | FLOAT of (float)
  | EQUAL_EQUAL
  | EQUAL
  | EOF
  | ELSE
  | DOT_DOT
  | CONTRACT
  | COMMA
  | COLON
  | BOOL of (bool)
  | ARROW
  | ANALYSIS

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val single_expr: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)

val program_file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.program)
