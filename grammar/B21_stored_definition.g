parser grammar B21_stored_definition;

// Stored Definition - Within

stored_definition  :
  '\uFEFF'? // BOM
  ( 'within' name? ';' )?
  ( 'final'? class_definition ';' )?
  EOF
  ;
  
