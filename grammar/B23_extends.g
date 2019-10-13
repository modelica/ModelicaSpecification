parser grammar B23_extends; // Extends
start_rule: extends_clause;
extends_clause :
  'extends' type_specifier class_modification? annotation_comment?
  ;

constraining_clause :
  'constrainedby' type_specifier class_modification?
  ;

