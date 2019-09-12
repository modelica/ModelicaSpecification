parser grammar B23_extends;

// Extends

start_rule: extends_clause;

extends_clause :
  'extends' type_specifier class_modification? annotation_comment? // TODO: No such rule annotation
  ;

constraining_clause :
  'constrainedby' type_specifier class_modification?
  ;

