%{
  open Ast
%}

%token <int> INT
%token <float> FLOAT
%token <string> STRING IDENT
%token <bool> BOOL

%token LET IN IF THEN ELSE FN
%token CONTRACT RULE SET_DOSAGE SUPPRESS_DOSAGE
%token SPLIT SCATTER DECOMPOSE COVER SHIFT CAST
%token PLUS MINUS STAR SLASH
%token EQUAL_EQUAL LESS_EQUAL GREATER_EQUAL LESS GREATER
%token PIPE ARROW EQUAL
%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token COMMA COLON SEMICOLON DOT_DOT
%token SYNTHESIS ANALYSIS TRANSFORMATION
%token EOF

%right ARROW PIPE
%left PLUS MINUS
%left STAR SLASH
%nonassoc EQUAL_EQUAL LESS_EQUAL GREATER_EQUAL LESS GREATER

%start <Ast.program> program_file
%start <Ast.expr> single_expr

%%

program_file:
  | decls = list(decl); EOF { decls }

decl:
  | d = contract_decl { d }
  | d = fn_decl       { d }
  | LET; id = IDENT; EQUAL; e = expr; SEMICOLON? { DeclLet (id, e) }
  | e = expr; SEMICOLON? { DeclExpr e }

contract_decl:
  | CONTRACT; name = IDENT; LBRACE;
      rules = list(rule_spec);
    RBRACE
    {
      DeclContract {
        contract_name = name;
        min_glucose = 70;
        max_dosage = 50;
        basal_dosage = 10;
        steep_fall_threshold = -2;
        rules = rules;
      }
    }

signed_int:
  | i = INT        { i }
  | MINUS; i = INT { -i }

rule_spec:
  | RULE; p = INT; COLON;
      g_low = signed_int; DOT_DOT; g_high = signed_int; COMMA;
      d_low = signed_int; DOT_DOT; d_high = signed_int; ARROW;
      act = action_spec; inv = STRING; SEMICOLON?
    {
      {
        priority = p;
        glucose_range = (g_low, g_high);
        delta_range = (d_low, d_high);
        action = act;
        invariant_id = inv;
      }
    }

action_spec:
  | SET_DOSAGE; LPAREN; u = signed_int; RPAREN { SetDosage u }
  | SUPPRESS_DOSAGE                            { SuppressDosage }

fn_decl:
  | FN; name = IDENT; LPAREN; params = separated_list(COMMA, IDENT); RPAREN;
    eng = ioption(engine_annot); EQUAL; body = expr; SEMICOLON?
    { DeclFn (name, params, eng, body) }

engine_annot:
  | COLON; SYNTHESIS      { Synthesis }
  | COLON; ANALYSIS       { Analysis }
  | COLON; TRANSFORMATION { Transformation }

single_expr:
  | e = expr; EOF { e }

expr:
  | e = flow_expr { e }

flow_expr:
  | e1 = flow_expr; ARROW; e2 = logic_expr { Flow (e1, e2) }
  | e1 = flow_expr; PIPE; e2 = logic_expr  { Pipe (e1, e2) }
  | e = logic_expr { e }

logic_expr:
  | e1 = arith_expr; op = comp_op; e2 = arith_expr { BinOp (op, e1, e2) }
  | e = arith_expr { e }

comp_op:
  | EQUAL_EQUAL   { "==" }
  | LESS_EQUAL    { "<=" }
  | GREATER_EQUAL { ">=" }
  | LESS          { "<" }
  | GREATER       { ">" }

arith_expr:
  | e1 = arith_expr; PLUS; e2 = term_expr  { BinOp ("+", e1, e2) }
  | e1 = arith_expr; MINUS; e2 = term_expr { BinOp ("-", e1, e2) }
  | e = term_expr { e }

term_expr:
  | e1 = term_expr; STAR; e2 = atom_expr  { BinOp ("*", e1, e2) }
  | e1 = term_expr; SLASH; e2 = atom_expr { BinOp ("/", e1, e2) }
  | e = atom_expr { e }

atom_expr:
  | i = INT    { Int i }
  | f = FLOAT  { Float f }
  | b = BOOL   { Bool b }
  | s = STRING { String s }
  | id = IDENT { Ident id }
  | LBRACKET; items = separated_list(COMMA, expr); RBRACKET { Vec items }
  | LBRACE; fields = separated_list(COMMA, record_field); RBRACE { Record fields }
  | SPLIT; LBRACE; branches = separated_list(COMMA, expr); RBRACE { Split branches }
  | SPLIT; LPAREN; branches = separated_list(COMMA, expr); RPAREN { Split branches }
  | SCATTER; LPAREN; target = expr; RPAREN { Scatter target }
  | DECOMPOSE; LPAREN; basis = expr; RPAREN { Decompose basis }
  | COVER; LPAREN; w = expr; COMMA; s = expr; RPAREN { Cover (w, s) }
  | SHIFT; LPAREN; d = expr; RPAREN { Shift d }
  | CAST; LPAREN; t = IDENT; RPAREN { Cast t }
  | LET; id = IDENT; EQUAL; e1 = expr; IN; e2 = expr { Let (id, e1, e2) }
  | IF; c = expr; THEN; e1 = expr; ELSE; e2 = expr { If (c, e1, e2) }
  | LPAREN; e = expr; RPAREN { e }

record_field:
  | key = IDENT; COLON; value = expr { (key, value) }
