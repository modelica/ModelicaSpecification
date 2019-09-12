parser grammar B24_component_clause;

// Component Clause

start_rule: component_clause;

component_clause :
  type_prefix type_specifier array_subscripts? component_list
  ;

type_prefix :
  ( 'flow' | 'stream' )?
  ( 'discrete' | 'parameter' | 'constant' )? ( 'input' | 'output' )?
  ;

component_list :
  component_declaration ( ',' component_declaration )*
  ;

component_declaration :
  declaration condition_attribute? comment
  ;

condition_attribute :
  'if' expression
  ;

declaration :
  IDENT array_subscripts? modification?
  ;

