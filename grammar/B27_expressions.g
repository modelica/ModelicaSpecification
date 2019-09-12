parser grammar B27_expressions;

// Expressions

start_rule: expression;

expression :
  simple_expression
  | 'if' expression 'then' expression ( 'elseif' expression 'then' expression )*
    'else' expression
  ;

simple_expression :
  logical_expression ( ':' logical_expression ( ':' logical_expression )? )?
  ;

logical_expression :
  logical_term ( 'or' logical_term )*
  ;

logical_term :
  logical_factor ( 'and' logical_factor )*
  ;

logical_factor :
  'not'? relation
  ;

relation :
  arithmetic_expression ( relational_operator arithmetic_expression )?
  ;

relational_operator :
  '<' | '<=' | '>' | '>=' | '==' | '<>'
  ;

arithmetic_expression :
  add_operator? term ( add_operator term )*
  ;

add_operator :
  '+' | '-' | '.+' | '.-'
  ;

term :
  factor ( mul_operator factor )*
  ;

mul_operator :
  '*' | '/' | '.*' | './'
  ;

factor :
  primary ( ('^' | '.^') primary )?
  ;

primary :
  UNSIGNED_NUMBER
  | STRING
  | 'false'
  | 'true'
  | ('der' | 'initial' | 'pure' ) function_call_args
  | component_reference function_call_args?
  | '(' output_expression_list ')'
  | '[' expression_list ( ';' expression_list )* ']'
  | '{' array_arguments '}'
  | 'end'
  ;

type_specifier :
  '.'? name
  ;

name :
  IDENT ( '.' IDENT )*
  ;

component_reference :
  '.'? IDENT array_subscripts? ( '.' IDENT array_subscripts? )*
  ;

function_call_args :
  '(' function_arguments? ')'
  ;

function_arguments
  : expression ( ',' function_arguments_non_first | 'for' for_indices )?
  | function_partial_application (',' function_arguments_non_first)?
  | named_arguments
  ;

function_arguments_non_first
  : ( function_argument (',' function_arguments_non_first)?
    | named_arguments
    )
  ;

array_arguments :
  expression ( ( ',' expression /* TODO: This changed the grammar */ )* | 'for' for_indices )
  ;

named_arguments :
  named_argument ( ',' named_argument )* /* TODO: Changed to repetition */
  ;

named_argument :
  IDENT '=' function_argument
  ;

function_argument
  : function_partial_application
  | expression
  ;

function_partial_application /* TODO: This is a new rule; refactored out */
  : 'function' type_specifier '(' named_arguments? ')'
  ;

output_expression_list :
  expression? ( ',' expression? )*
  ;

expression_list :
  expression ( ',' expression? )*
  ;

array_subscripts :
  '[' subscript ( ',' subscript )* ']'
  ;

subscript :
  ':' | expression
  ;

comment :
  string_comment annotation_comment?
  ;

string_comment :
  ( STRING ( '+' STRING )* )?
  ;

annotation_comment :
  'annotation' class_modification
  ;
