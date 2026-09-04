{
  open Parser
  exception LexError of string
}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let digit = ['0'-'9']
let int_lit = digit+
let float_lit = digit+ '.' digit+
let ident = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule read = parse
  | white       { read lexbuf }
  | newline     { Lexing.new_line lexbuf; read lexbuf }
  | "//" [^ '\n' '\r']* { read lexbuf }
  
  (* Keywords *)
  | "let"             { LET }
  | "in"              { IN }
  | "if"              { IF }
  | "then"            { THEN }
  | "else"            { ELSE }
  | "true"            { BOOL true }
  | "false"           { BOOL false }
  | "fn"              { FN }
  | "contract"        { CONTRACT }
  | "rule"            { RULE }
  | "set_dosage"      { SET_DOSAGE }
  | "suppress_dosage" { SUPPRESS_DOSAGE }
  | "synthesis"       { SYNTHESIS }
  | "analysis"        { ANALYSIS }
  | "transformation"  { TRANSFORMATION }

  (* Operators *)
  | "|>"            { PIPE }
  | "->"            { ARROW }
  | "=="            { EQUAL_EQUAL }
  | "<="            { LESS_EQUAL }
  | ">="            { GREATER_EQUAL }
  | "<"             { LESS }
  | ">"             { GREATER }
  | "="             { EQUAL }
  | "+"             { PLUS }
  | "-"             { MINUS }
  | "*"             { STAR }
  | "/"             { SLASH }

  (* Punctuation *)
  | ".."            { DOT_DOT }
  | "("             { LPAREN }
  | ")"             { RPAREN }
  | "{"             { LBRACE }
  | "}"             { RBRACE }
  | "["             { LBRACKET }
  | "]"             { RBRACKET }
  | ","             { COMMA }
  | ":"             { COLON }
  | ";"             { SEMICOLON }

  (* Literals *)
  | float_lit as f  { FLOAT (float_of_string f) }
  | int_lit as i    { INT (int_of_string i) }
  | '"' ([^ '"']* as s) '"' { STRING s }
  | ident as id     { IDENT id }

  | eof             { EOF }
  | _ as c          { raise (LexError (Printf.sprintf "Unexpected character: %c" c)) }
