grammar Modelica;

options {
  k=2;
}


import Lexer, Parser_stored_definition, Parser_class_definition, Parser_extends, Parser_component_clause, Parser_modification, Parser_equations, Parser_expressions;

start_rule: stored_definition;


