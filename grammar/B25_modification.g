parser grammar B25_modification; // Modification
start_rule: modification;
modification :
  class_modification ( '=' expression )?
  | '=' expression
  | ':=' expression
  ;

class_modification :
  '(' argument_list? ')'
  ;

argument_list : 
  argument ( ',' argument )*
  ;

argument : 
    element_modification_or_replaceable
  | element_redeclaration
  ;

element_modification_or_replaceable : 
  'each'? 'final'? ( element_modification | element_replaceable )
  ;

element_modification : 
  name modification? string_comment
  ;

element_redeclaration :
  'redeclare' 'each'? 'final'?
  ( short_class_definition | component_clause1  | element_replaceable )
  ;

element_replaceable :
  'replaceable' ( short_class_definition | component_clause1 )
  constraining_clause?
  ;

component_clause1 :
  type_prefix type_specifier component_declaration1
  ;

component_declaration1 : 
  declaration comment
  ;

short_class_definition : 
  class_prefixes short_class_specifier
  ;
