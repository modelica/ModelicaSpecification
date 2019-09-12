parser grammar Parser_equations;

// Equations

start_rule: equation_section;

equation_section :
  'initial'? 'equation' ( equation ';' )*
  ;

algorithm_section :
  'initial'? 'algorithm' ( statement ';' )*
  ;

equation :
  (
  // TODO: Ambiguity
    simple_expression ( '=' expression )?
  | if_equation
  | for_equation
  | connect_clause
  | when_equation
  // TODO: Ambiguity
  // | component_reference function_call_args
  ) comment
  ;

statement :
  ( component_reference ( ':=' expression | function_call_args )
  | '(' output_expression_list ')' ':=' component_reference function_call_args
  | 'break'
  | 'return'
  | if_statement
  | for_statement
  | while_statement
  | when_statement )
  comment
  ;

if_equation :
  'if' expression 'then'
    ( equation ';' )*
  ( 'elseif' expression 'then'
    ( equation ';' )*
  )*
  ( 'else'
    ( equation ';' )*
  )?
  'end' 'if'
  ;

if_statement :
  'if' expression 'then'
    ( statement ';' )*
  ( 'elseif' expression 'then'
    ( statement ';' )*
  )*
  ( 'else'
    ( statement ';' )*
  )?
  'end' 'if'
  ;

for_equation :
  'for' for_indices 'loop'
    ( equation ';' )*
  'end' 'for'
  ;

for_statement :
  'for' for_indices 'loop'
    ( statement ';' )*
  'end' 'for'
  ;

for_indices :
  for_index ( ',' for_index )*
  ;

for_index :
  IDENT ( 'in' expression )?
  ;

while_statement :
  'while' expression 'loop'
    ( statement ';' )*
  'end' 'while'
  ;

when_equation :
  'when' expression 'then'
    ( equation ';' )*
  ( 'elsewhen' expression 'then'
    ( equation ';' )*
  )*
  'end' 'when'
  ;

when_statement :
  'when' expression 'then'
    ( statement ';' )*
  ( 'elsewhen' expression 'then'
    ( statement ';' )*
  )*
  'end' 'when'
  ;

connect_clause :
  'connect' '(' component_reference ',' component_reference ')'
  ;

