parser grammar B22_class_definition; // Class Definition
start_rule: class_definition;
class_definition :
  'encapsulated'? class_prefixes
  class_specifier
  ;

class_prefixes :
  'partial'?
  ( 'class' | 'model' | 'operator'? 'record' | 'block' | 'expandable'? 'connector' | 'type' | 
    'package' | ( 'pure' | 'impure' )? 'operator'? 'function' | 'operator' )
  ;

class_specifier :
  long_class_specifier | short_class_specifier | der_class_specifier
  ;

long_class_specifier :
  IDENT string_comment composition 'end' IDENT
  | 'extends' IDENT class_modification? string_comment composition
    'end' IDENT
  ;

short_class_specifier :
  IDENT '='
  ( 
    base_prefix type_specifier array_subscripts? class_modification?
  | 'enumeration' '(' ( enum_list? | ':' ) ')'
  )
  comment
  ;

der_class_specifier :
  IDENT '=' 'der' '(' type_specifier ',' IDENT ( ',' IDENT )* ')' comment
  ;

base_prefix : 
  ( 'input' | 'output' )?
  ;

enum_list : enumeration_literal ( ',' enumeration_literal )*
  ;

enumeration_literal : IDENT comment
  ;

composition :
  element_list
  ( 'public' element_list |
    'protected' element_list |
    equation_section |
    algorithm_section
  )*
  ( 'external' language_specification?
  external_function_call? annotation_comment? ';' )?
  ( annotation_comment ';' )?
  ;

language_specification :
  STRING
  ;

external_function_call :
  ( component_reference '=' )?
  IDENT '(' expression_list? ')'
  ;

element_list :
  ( element ';' )*
  ;

element :
  import_clause |
  extends_clause |
  'redeclare'?
  'final'?
  'inner'? 'outer'?
  ( class_definition | component_clause | 
  'replaceable' ( class_definition | component_clause )
  ( constraining_clause comment )? )
  ;

import_clause :
  'import' ( IDENT '=' name | name ( '.' ( '*' | '{' import_list '}' ) | '.*' )? ) comment
  ;

import_list :
  IDENT ( ',' IDENT )*
  ;

