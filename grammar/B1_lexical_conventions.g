lexer grammar B1_lexical_conventions;

// Whitespace and comments

BOM : '\u00EF' '\u00BB' '\u00BF' ;

WS : ( ' ' | '\t' | NL )+ { $channel=HIDDEN; }
  ;

LINE_COMMENT
    : '//' ( ~('\r'|'\n')* ) (NL|EOF) { $channel=HIDDEN; }
    ;

ML_COMMENT
    :   '/*' (options {greedy=false;} : .)* '*/' { $channel=HIDDEN;  }
    ;

fragment
NL: '\r\n' | '\n' | '\r';

// Lexical units except for keywords

IDENT : NONDIGIT ( DIGIT | NONDIGIT )* | Q_IDENT ;

fragment NONDIGIT : '_' | 'a' .. 'z' | 'A' .. 'Z' ;

STRING : '"' ( S_CHAR | S_ESCAPE )* '"' ;

fragment S_CHAR : NL | ~('\r' | '\n' | '\\' | '"'); // Unicode other than " and \

fragment DIGIT : '0' .. '9' ;

fragment Q_IDENT : '\'' ( Q_CHAR | S_ESCAPE ) ( Q_CHAR | S_ESCAPE | '"' )* '\'' ;

fragment Q_CHAR
   : NONDIGIT | DIGIT | '!' | '#' | '$' | '%' | '&' | '(' | ')' | '*'
   | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '>' | '=' | '?'
   | '@' | '[' | ']' | '^' | '{' | '}' | '|' | '~' | ' '
   ;
fragment S_ESCAPE : '\\'
  ( '\'' | '"' | '?' | '\\' | 'a' | 'b' | 'f' | 'n' | 'r' | 't' | 'v')
  ;

fragment UNSIGNED_INTEGER : DIGIT+ ;
fragment EXPONENT : ( 'e' | 'E' ) ( '+' | '-' )? DIGIT+ ;

UNSIGNED_NUMBER : DIGIT+ ( '.' (DIGIT)* )? ( EXPONENT )? ;

