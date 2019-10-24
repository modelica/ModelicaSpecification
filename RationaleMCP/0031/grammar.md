# Flat Modelica grammar

The starting point for this Flat Modelica grammar is the ANTLR grammar for Modelica as proposed by [this ModelicaSpecification PR](https://github.com/modelica/ModelicaSpecification/pull/2378).

The intention is to develop the Flat Modelica grammar as a modification (mainly consisting of restrictions) of the full Modelica grammar, and to make the differences clearly visible in this document.  Hence, rather than just erasing the parts of the Modelica grammar that shouldn't be brought to Flat Modelica, these parts will be marked with a strikeout.

The start rule of the Flat Modelica grammar below is [`flat_modelica`](#Start-rule).


## B1 Lexical conventions

Each grammar rule is written as a block quote.  Regular expressions for tokens are written as inline code, while parsing constructs and rule names are written in plain text.

### Whitespace and comments

> WS → ( `[ ]` | `\t` | NL )+

> LINE_COMMENT → `//[^\r\n]*` (NL | EOF)

> ML_COMMENT → `/[*]([^*]|([*][^/]))*[*]/`

> NL → `\r\n` | `\n` | `\r`

### Lexical units except for keywords

> IDENT → NONDIGIT ( DIGIT | NONDIGIT )* | Q_IDENT

> NONDIGIT → `_` | `[a-z]` | `[A-Z]`

> STRING → `"` ( S_CHAR | S_ESCAPE )* `"`

The S_CHAR accepts Unicode other than " and \\:
> S_CHAR → NL | `[^\r\n\\"]`

> DIGIT → `[0-9]`

> Q_IDENT → `'` ( Q_CHAR | S_ESCAPE ) ( Q_CHAR | S_ESCAPE | `"` )* `'`

> Q_CHAR → NONDIGIT | DIGIT | `[-!#$%&()*>+,./:;<>=?>@[]{}|~ ^]`

> S_ESCAPE → `\\['"?\\abfnrtv]`

> UNSIGNED_INTEGER → DIGIT+

> EXPONENT → ( `e` | `E` ) ( `[+]` | `-` )? DIGIT+

> UNSIGNED_NUMBER → DIGIT+ ( `[.]` (DIGIT)* )? ( EXPONENT )?


## Start rule
> flat_modelica →\
> &emsp; VERSION_HEADER\
> &emsp; `model` long_class_specifier `;`

Here, the VERSION_HEADER is a Flat Modelica variant of the not yet standardized language version header for Modelica proposed in [MCP-0015](https://github.com/modelica/ModelicaSpecification/tree/MCP/0015/RationaleMCP/0015):
> VERSION_HEADER → `^\U+FEFF?//![ ]flat[ ][0-9]+[.][0-9]+[r.][0-9]+$`

The `\U+FEFF?` at the very beginning is an optional byte order mark.

As an example of the flat_modelica rule, this is a minimal valid Flat Modelica source:
```
//! flat 3.5.0
model _F
end _F;
```


## B22 Class definition

> class_definition → `encapsulated`? class_prefixes class_specifier

> class_prefixes →\
> &emsp; `partial`?\
> &emsp; ( `class`\
> &emsp; | `model`\
> &emsp; | `operator`? `record`\
> &emsp; | `block`\
> &emsp; | `expandable`? `connector`\
> &emsp; | `type`\
> &emsp; | `package`\
> &emsp; | ( `pure` | `impure` )? `operator`? `function`\
> &emsp; | `operator`\
> &emsp; )

> class_specifier → long_class_specifier | short_class_specifier | der_class_specifier

> long_class_specifier\
> &emsp; → IDENT string_comment composition `end` IDENT\
> &emsp; | `extends` IDENT class_modification? string_comment composition `end` IDENT

> short_class_specifier →\
> &emsp; IDENT `=`\
> &emsp; ( base_prefix? type_specifier array_subscripts? class_modification?\
> &emsp; | `enumeration` `[(]` ( enum_list? | `:` ) `[)]`\
> &emsp; )\
> &emsp; comment

> der_class_specifier → IDENT `=` `der` `[(]` type_specifier `,` IDENT ( `,` IDENT )* `[)]` comment

> base_prefix → `input` | `output`

> enum_list → enumeration_literal ( `,` enumeration_literal )*

> enumeration_literal → IDENT comment

> composition →\
> &emsp; (generic_element `;`)* \
> &emsp; ( `public` (generic_element `;`)* \
> &emsp; | `protected` (generic_element `;`)* \
> &emsp; | `initial`? `equation` ( equation `;` )* \
> &emsp; | `initial`? `algorithm` ( statement `;` )* \
> &emsp; )* \
> &emsp; ( `external` language_specification?\
> &emsp;&emsp; external_function_call? annotation_comment? `;`\
> &emsp; )?\
> &emsp; ( annotation_comment `;` )?

> language_specification → STRING

> external_function_call → ( component_reference `=` )? IDENT `[(]` expression_list? `[)]`

> generic_element → import_clause | extends_clause | normal_element

> normal_element →\
> &emsp; ~~`redeclare`?~~\
> &emsp; `final`?\
> &emsp; `inner`? `outer`?\
> &emsp; ( class_definition\
> &emsp; | component_clause\
> &emsp; | ~~`replaceable`~~ ( class_definition | component_clause ) ( constraining_clause comment )?\
> &emsp; )

> import_clause →\
> &emsp; `import`\
> &emsp; ( IDENT `=` name\
> &emsp; | name ( `[.]` ( `[*]` | `[{]` import_list `[}]` ) | `[.][*]` )?\
> &emsp; )\
> &emsp; comment

> import_list → IDENT ( `,` IDENT )*


## B23 Extends

> extends_clause → `extends` type_specifier class_modification? annotation_comment?

> constraining_clause → `constrainedby` type_specifier class_modification?


## B24 Component clause

> component_clause → type_prefix type_specifier array_subscripts? component_list

> type_prefix →\
> &emsp; ( `flow` | `stream` )?\
> &emsp; ( `discrete` | `parameter` | `constant` )?\
> &emsp; ( `input` | `output` )?

> component_list → component_declaration ( `,` component_declaration )*

> component_declaration → declaration condition_attribute? comment

> condition_attribute → `if` expression

> declaration → IDENT array_subscripts? modification?


## B25 Modification

> modification\
> &emsp; → class_modification ( `=` expression )?\
> &emsp; | `=` expression\
> &emsp; | `:=` expression

> class_modification → `[(]` argument_list? `[)]`

> argument_list → argument ( `,` argument )*

> argument\
> &emsp; → element_modification_or_replaceable\
> &emsp; ~~| element_redeclaration~~

> element_modification_or_replaceable →\
> &emsp; `each`?\
> &emsp; `final`?\
> &emsp; ( element_modification\
> &emsp; ~~| element_replaceable~~\
> &emsp; )

> element_modification → name modification? string_comment

> ~~element_redeclaration →~~\
> ~~&emsp; `redeclare` `each`? `final`?~~\
> ~~&emsp; ( short_class_definition~~\
> ~~&emsp; | component_clause1~~\
> ~~&emsp; | element_replaceable~~\
> ~~&emsp; )~~

> ~~element_replaceable →~~\
> ~~&emsp; `replaceable`~~\
> ~~&emsp; ( short_class_definition~~\
> ~~&emsp; | component_clause1~~\
> ~~&emsp; )~~\
> ~~&emsp; constraining_clause?~~

> ~~component_clause1 → type_prefix type_specifier component_declaration1~~

> ~~component_declaration1 → declaration comment~~

> short_class_definition → class_prefixes short_class_specifier

## B26 Equations

> equation →\
> &emsp; ( simple_expression ( `=` expression )?\
> &emsp; | if_equation\
> &emsp; | for_equation\
> &emsp; | connect_clause\
> &emsp; | when_equation\
> &emsp; )\
> &emsp; comment

> statement →\
> &emsp; ( component_reference ( `:=` expression | function_call_args )\
> &emsp; | `[(]` output_expression_list `[)]` `:=` component_reference function_call_args\
> &emsp; | `break`\
> &emsp; | `return`\
> &emsp; | if_statement\
> &emsp; | for_statement\
> &emsp; | while_statement\
> &emsp; | when_statement\
> &emsp; )\
> &emsp; comment

> if_equation →\
> &emsp; `if` expression `then`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; ( `elseif` expression `then`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; )* \
> &emsp; ( `else`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; )?\
> &emsp; `end` `if`

> if_statement →\
> &emsp; `if` expression `then`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; ( `elseif` expression `then`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; )* \
> &emsp; ( `else`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; )?\
> &emsp; `end` `if`

> for_equation →\
> &emsp; `for` for_indices `loop`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; `end` `for`

> for_statement →\
> &emsp; `for` for_indices `loop`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; `end` `for`

> for_indices → for_index ( `,` for_index )*

> for_index → IDENT ( `in` expression )?

> while_statement →\
> &emsp; `while` expression `loop`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; `end` `while`

> when_equation →\
> &emsp; `when` expression `then`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; ( `elsewhen` expression `then`\
> &emsp;&emsp; ( equation `;` )* \
> &emsp; )* \
> &emsp; `end` `when`

> when_statement →\
> &emsp; `when` expression `then`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; ( `elsewhen` expression `then`\
> &emsp;&emsp; ( statement `;` )* \
> &emsp; )* \
> &emsp; `end` `when`

> connect_clause → `connect` `[(]` component_reference `,` component_reference `[)]`


## Expressions

> expression → simple_expression | if_expression

> if_expression →\
> &emsp; `if` expression `then` expression\
> &emsp; ( `elseif` expression `then` expression )* \
> &emsp; `else` expression

> simple_expression → logical_expression ( `:` logical_expression ( `:` logical_expression )? )?

> logical_expression → logical_term ( `or` logical_term )*

> logical_term → logical_factor ( `and` logical_factor )*

> logical_factor → `not`? relation

> relation → arithmetic_expression ( relational_operator arithmetic_expression )?

> relational_operator → `<` | `<=` | `>` | `>=` | `==` | `<>`

> arithmetic_expression → add_operator? term ( add_operator term )*

> add_operator → `[+]` | `[-]` | `[.][+]` | `[.][-]`

> term → factor ( mul_operator factor )*

> mul_operator → `[*]` | `/` | `[.][*]` | `[.]/`

> factor → primary ( (`[^]` | `[.][^]`) primary )?

>primary\
> &emsp; → UNSIGNED_NUMBER\
> &emsp; | STRING\
> &emsp; | `false`\
> &emsp; | `true`\
> &emsp; | ( `der` | `initial` | `pure` ) function_call_args\
> &emsp; | component_reference function_call_args?\
> &emsp; | `[(]` output_expression_list `[]])`\
> &emsp; | `[[]` expression_list ( `;` expression_list )* `[]]`\
> &emsp; | `[{]` array_arguments `[]]}`\
> &emsp; | `end`

> type_specifier → `[.]`? name

> name → IDENT ( `[.]` IDENT )*

> component_reference → `[.]`? IDENT array_subscripts? ( `[.]` IDENT array_subscripts? )*

> function_call_args → `[(]` function_arguments? `[)]`

> function_arguments\
> &emsp; → expression ( `,` function_arguments_non_first | `for` for_indices )?\
> &emsp; | function_partial_application ( `,` function_arguments_non_first )?\
> &emsp; | named_arguments

> function_arguments_non_first\
> &emsp; → function_argument ( `,` function_arguments_non_first )?\
> &emsp; | named_arguments

> array_arguments → expression ( ( `,` expression )* | `for` for_indices )

> named_arguments → named_argument ( `,` named_argument )*

> named_argument → IDENT `=` function_argument

> function_argument\
> &emsp; → function_partial_application\
> &emsp; | expression

> function_partial_application → `function` type_specifier `[(]` named_arguments? `[)]`

> output_expression_list → expression? ( `,` expression? )*

> expression_list → expression ( `,` expression )*

> array_subscripts → `[` subscript ( `,` subscript )* `]`

> subscript → `:` | expression

> comment → string_comment annotation_comment?

> string_comment → ( STRING ( `[+]` STRING )* )?

> annotation_comment → `annotation` class_modification
