# Base Modelica grammar

The starting point for this Base Modelica grammar is the ANTLR grammar for Modelica as proposed by [this ModelicaSpecification PR](https://github.com/modelica/ModelicaSpecification/pull/2378).

The intention is to develop the Base Modelica grammar as a modification (mainly consisting of restrictions) of the full Modelica grammar, and to make the differences clearly visible in this document.  Hence, rather than just erasing the parts of the Modelica grammar that shouldn't be brought to Base Modelica, these parts will be marked with a strikeout.

The start rule of the Base Modelica grammar below is [_base-modelica_](#Start-rule).


## B1 Lexical conventions

Each grammar rule is written as a block quote.  Regular expressions for tokens are written as `inline code`, literal tokens are written in **upright boldface** (this is useful for avoiding the use of regular expressions when doing so would require protection of active characters), production rule names are written in _italics_, while parsing constructs are written in plain text.

Parsing constructs:
- _x_ | _y_ — alternatives; either _x_ or _y_
- _x_ _y_ — sequencing; _x_ followed by _y_
- _x_* — zero or more repetitions
- _x_+ — one or more repetitions
- _x_? — zero or one repetitions
- EOF — end of file
- (…) — parentheses for grouping

Repetition posfix operators have higher precedence than sequencing, which in turn has higher precedence than alternatives.

To avoid risk of confusion with the parentheses parsing construct ( _a_ | _b_ ), literal parentheses are written in regular expression form, `[(]` _a_ | _b_ `[)]`, rather than in upright boldface, **(** _a_ | _b_ **)**.

There are no empty productions.  Hence, where there is no risk of ambiguity, the left side of an alternative is allowed to be ommitted, meaning the same as just having the right side alternative.  For example, ( | _a_ | _b_ ) is the same as ( _a_ | _b_ ).

### Whitespace and comments

> _WS_ → ( `[ ]` | `\t` | _NL_ )+

> _LINE-COMMENT_ → `//[^\r\n]*` (_NL_ | EOF)

> _ML-COMMENT_ → `/[*]([^*]|([*][^/]))*[*]/`

> _NL_ → `\r\n` | `\n` | `\r`

### Lexical units except for keywords

> _IDENT_ → _NONDIGIT_ ( _DIGIT_ | _NONDIGIT_ )* | _Q-IDENT_

> _NONDIGIT_ → `_` | `[a-z]` | `[A-Z]`

> _STRING_ → `"` ( _S-CHAR_ | _S-ESCAPE_ )* `"`

The _S-CHAR_ accepts Unicode other than " and \\:
> _S-CHAR_ → _NL_ | `[^\r\n\\"]`

> _DIGIT_ → `[0-9]`

> _Q-IDENT_ → `'` ( _Q-CHAR_ | _S-ESCAPE_ ) ( _Q-CHAR_ | _S-ESCAPE_ | `"` )* `'`

> _Q-CHAR_ → _NONDIGIT_ | _DIGIT_ | `[-!#$%&()*>+,./:;<>=?>@[]{}|~ ^]`

> _S-ESCAPE_ → `\\['"?\\abfnrtv]`

> _UNSIGNED-INTEGER_ → _DIGIT_+

> _EXPONENT_ → ( `e` | `E` ) ( `[+]` | `-` )? _DIGIT_+

> _UNSIGNED-NUMBER_ → _DIGIT_+ ( `[.]` (_DIGIT_)* )? ( _EXPONENT_ )?


## Start rule
> _base-modelica_ →\
> &emsp; _VERSION-HEADER_\
> &emsp; **package** _IDENT_\
> &emsp;&emsp; ( _decoration_? _class-definition_ **;**\
> &emsp;&emsp; | _decoration_? _global-constant_ **;**\
> &emsp;&emsp; )*\
> &emsp;&emsp; _decoration_? **model** _long-class-specifier_ **;**\
> &emsp;&emsp; ( _annotation-comment_ **;** )?\
> &emsp; **end** _IDENT_ **;**

Here, the _VERSION-HEADER_ is a Base Modelica variant of the not yet standardized language version header for Modelica proposed in [MCP-0015](https://github.com/modelica/ModelicaSpecification/tree/MCP/0015/RationaleMCP/0015):
> _VERSION-HEADER_ → `^//![ ]base[ ][0-9]+[.][0-9]+[r.][0-9]+$`

The _IDENT_ in the _base-modelica_ rule must be the same identifier as in the _long-class-specifier_ following **model**.

As an example of the _base-modelica_ rule, this is a minimal valid Base Modelica source:
```
//! base 3.5.0
package _F
  model _F
  end _F;
end _F;
```

Note that there is no optional byte order mark, in agreement with the use of byte order mark being deprecated in full Modelica.


## B22 Class definition

> _class-definition_ → ~~**encapsulated**?~~ _class-prefixes_ _class-specifier_

> _class-prefixes_ →\
> &emsp; ~~**partial**?~~\
> &emsp; (\
> &emsp; | **type**\
> &emsp; | ~~**operator**?~~ **record**\
> &emsp; | ( ( **pure** **constant**? ) | **impure** )? ~~**operator**?~~ **function**\
> &emsp; ~~| **class**~~\
> &emsp; ~~| **model**~~\
> &emsp; ~~| **block**~~\
> &emsp; ~~| **expandable**? **connector**~~\
> &emsp; ~~| **package**~~\
> &emsp; ~~| **operator**~~\
> &emsp; )

> _class-specifier_ → _long-class-specifier_ | _short-class-specifier_ | _der-class-specifier_

> _long-class-specifier_\
> &emsp; → _IDENT_ _string-comment_ _composition_ **end** _IDENT_\
> &emsp; ~~| **extends** _IDENT_ _class-modification_? _string-comment_ _composition_ **end** _IDENT_~~

> _short-class-specifier_ →\
> &emsp; _IDENT_ **=**\
> &emsp; ( _base-prefix_? _type-specifier_ ~~_array-subscripts_?~~ _class-modification_?\
> &emsp; | **enumeration** `[(]` ( _enum-list_? | **:** ) `[)]`\
> &emsp; )\
> &emsp; _comment_

> _der-class-specifier_ → _IDENT_ **=** **der** `[(]` _type-specifier_ **,** _IDENT_ ( **,** _IDENT_ )* `[)]` _comment_

> _base-prefix_ → **input** | **output**

> _enum-list_ → _enumeration-literal_ ( **,** _enumeration-literal_ )*

> _enumeration-literal_ → _IDENT_ _comment_

> _composition_ →\
> &emsp; (_decoration_? _generic-element_ **;**)* \
> &emsp; ( **equation** ( _equation_ **;** )* \
> &emsp; | **initial** **equation** ( _initial-equation_ **;** )* \
> &emsp; | **initial**? **algorithm** ( _statement_ **;** )* \
> &emsp; ~~| **public** (_generic-element_ **;**)*~~ \
> &emsp; ~~| **protected** (_generic-element_ **;**)*~~ \
> &emsp; )* \
> &emsp; ( _decoration_? **external** _language-specification_?\
> &emsp;&emsp; _external-function-call_? _annotation-comment_? **;**\
> &emsp; )?\
> &emsp; _base-partition_* \
> &emsp; ( _annotation-comment_ **;** )?

> _language-specification_ → _STRING_

> _external-function-call_ → ( _component-reference_ **=** )? _IDENT_ `[(]` _expression-list_? `[)]`

> _generic-element_ → ~~_import-clause_ | _extends-clause_ |~~ _normal-element_ | _parameter-equation_

> _normal-element_ →\
> &emsp; ~~**redeclare**?~~\
> &emsp; ~~**final**?~~\
> &emsp; ~~**inner**? **outer**?~~\
> &emsp; ( ~~_class-definition_~~\
> &emsp; | _component-clause_\
> &emsp; ~~| **replaceable** ( _class-definition_ | _component-clause_ ) ( _constraining-clause_ _comment_ )?~~\
> &emsp; )

> _parameter-equation_ →\
> &emsp; **parameter** **equation** _guess-value_ **=**\
> &emsp; ( _expression_ | _prioritize-expression_ )\
> &emsp; _comment_

> _guess-value_ → **guess** `[(]` _component-reference_ `[)]`

> ~~_import-clause_ →\
> &emsp; **import**\
> &emsp; ( _IDENT_ **=** _name_\
> &emsp; | _name_ ( `[.]` ( `[*]` | **{** _import-list_ **}** ) | `[.][*]` )?\
> &emsp; )\
> &emsp; _comment_~~

> ~~_import-list_ → _IDENT_ ( **,** _IDENT_ )*~~


## Clock partitions

> _base-partition_ →\
> &emsp; **partition** _string-comment_\
> &emsp; ( _annotation-comment_ **;** )?
> &emsp; ( _clock-clause_ **;** )*\
> &emsp; _sub-partition_*

> _sub-partition_ →\
> &emsp; **subpartition** `[(]` _argument-list_ `[)]` _string-comment_\
> &emsp; ( _annotation-comment_ **;** )?
> &emsp; ( **equation** ( _equation_ **;** )* \
> &emsp; | **algorithm** ( _statement_ **;** )* \
> &emsp; )*

> _clock-clause_ → _decoration_? **Clock** _IDENT_ **=** _expression_ _comment_


## B23 Extends

> ~~_extends-clause_ → **extends** _type-specifier_ _class-modification_? _annotation-comment_?~~

> ~~_constraining-clause_ → **constrainedby** _type-specifier_ _class-modification_?~~


## B24 Component clause
> _component-clause_ → _type-prefix_ _type-specifier_ ~~_array-subscripts_?~~ _component-list_

> _global-constant_ → **constant** _type-specifier_ _declaration_ _comment_

> _type-prefix_ →\
> &emsp; ~~( **flow** | **stream** )?~~\
> &emsp; ( **discrete** | **parameter** | **constant** )?\
> &emsp; ( **input** | **output** )?

> _component-list_ → _component-declaration_ ( **,** _component-declaration_ )*

> _component-declaration_ → _declaration_ ~~_condition-attribute_?~~ _comment_

> ~~_condition-attribute_ → **if** _expression_~~

> _declaration_ → _IDENT_ _array-subscripts_? _modification_?


## B25 Modification

> _modification_\
> &emsp; → _class-modification_ ( **=** _expression_ )?\
> &emsp; | **=** _expression_\
> &emsp; | **:=** _expression_

> _class-modification_ → `[(]` _argument-list_? `[)]`

> _argument-list_ → _argument_ ( **,** _argument_ )*

> _argument_\
> &emsp; → _decoration_? _element-modification-or-replaceable_\
> &emsp; ~~| _element-redeclaration_~~

> _element-modification-or-replaceable_ →\
> &emsp; ~~**each**?~~\
> &emsp; ~~**final**?~~\
> &emsp; ( _element-modification_\
> &emsp; ~~| _element-replaceable_~~\
> &emsp; )

> _element-modification_ → _name_ _modification_? _string-comment_

> ~~_element-redeclaration_ →\
> &emsp; **redeclare** **each**? ~~**final**?~~\
> &emsp; ( _short-class-definition_\
> &emsp; | _component-clause1_\
> &emsp; | _element-replaceable_\
> &emsp; )~~

> ~~_element-replaceable_ →\
> &emsp; **replaceable**\
> &emsp; ( _short-class-definition_\
> &emsp; | _component-clause1_\
> &emsp; )\
> &emsp; _constraining-clause_?~~

> ~~_component-clause1_ → _type-prefix_ _type-specifier_ _component-declaration1_~~

> ~~_component-declaration1_ → _declaration_ _comment_~~

> ~~_short-class-definition_ → _class-prefixes_ _short-class-specifier_~~

## B26 Equations

> _equation_ →\
> &emsp; _decoration_?\
> &emsp; ( _simple-expression_ _decoration_? ( **=** _expression_ )?\
> &emsp; | _if-equation_\
> &emsp; | _for-equation_\
> &emsp; ~~| _connect-clause_~~\
> &emsp; | _when-equation_\
> &emsp; )\
> &emsp; _comment_

> _initial-equation_ → _equation_ | _prioritize-equation_

> _statement_ →\
> &emsp; _decoration_?\
> &emsp; ( _component-reference_ ( **:=** _expression_ | _function-call-args_ )\
> &emsp; | `[(]` _output-expression-list_ `[)]` **:=** _component-reference_ _function-call-args_\
> &emsp; | **break**\
> &emsp; | **return**\
> &emsp; | _if-statement_\
> &emsp; | _for-statement_\
> &emsp; | _while-statement_\
> &emsp; | _when-statement_\
> &emsp; )\
> &emsp; _comment_

> _if-equation_ →\
> &emsp; **if** _expression_ **then**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; ( **elseif** _expression_ **then**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; )* \
> &emsp; ( **else**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; )?\
> &emsp; **end** **if**

> _if-statement_ →\
> &emsp; **if** _expression_ **then**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; ( **elseif** _expression_ **then**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; )* \
> &emsp; ( **else**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; )?\
> &emsp; **end** **if**

> _for-equation_ →\
> &emsp; **for** _for-index_ **loop**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; **end** **for**

> _for-statement_ →\
> &emsp; **for** _for-index_ **loop**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; **end** **for**

> ~~_for-indices_ → _for-index_ ( **,** _for-index_ )*~~

> _for-index_ → _IDENT_ **in** _expression_

> _while-statement_ →\
> &emsp; **while** _expression_ **loop**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; **end** **while**

> _when-equation_ →\
> &emsp; **when** _expression_ **then**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; ( **elsewhen** _expression_ **then**\
> &emsp;&emsp; ( _equation_ **;** )* \
> &emsp; )* \
> &emsp; **end** **when**

> _when-statement_ →\
> &emsp; **when** _expression_ **then**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; ( **elsewhen** _expression_ **then**\
> &emsp;&emsp; ( _statement_ **;** )* \
> &emsp; )* \
> &emsp; **end** **when**

> ~~_connect-clause_ → **connect** `[(]` _component-reference_ **,** _component-reference_ `[)]`~~

> _prioritize-equation_ → **prioritize** `[(]` _component-reference_ **,** _priority_ `[)]`

> _prioritize-expression_ → **prioritize** `[(]` _expression_ **,** _priority_ `[)]`

> _priority_ → _expression_


## Expressions

> _decoration_ → **@** UNSIGNED-INTEGER

> _expression_ → _expression-no-decoration_ _decoration_?

> _expression-no-decoration_ → _simple-expression_ | _if-expression_

> _if-expression_ →\
> &emsp; **if** _expression-no-decoration_ **then** _expression-no-decoration_\
> &emsp; ( **elseif** _expression-no-decoration_ **then** _expression-no-decoration_ )* \
> &emsp; **else** _expression-no-decoration_

> _simple-expression_ → _logical-expression_ ( **:** _logical-expression_ ( **:** _logical-expression_ )? )?

> _logical-expression_ → _logical-term_ ( **or** _logical-term_ )*

> _logical-term_ → _logical-factor_ ( **and** _logical-factor_ )*

> _logical-factor_ → **not**? _relation_

> _relation_ → _arithmetic-expression_ ( _relational-operator_ _arithmetic-expression_ )?

> _relational-operator_ → **<** | **<=** | **>** | **>=** | **==** | **<>**

> _arithmetic-expression_ → _add-operator_? _term_ ( _add-operator_ _term_ )*

> _add-operator_ → **+** | **-** | **.+** | **.-**

> _term_ → _factor_ ( _mul-operator_ _factor_ )*

> _mul-operator_ → ** * ** | ** / ** | ** .* ** | ** ./ **

> _factor_ → _primary_ ( (**^** | **.^**) _primary_ )?

>_primary_\
> &emsp; → _UNSIGNED-NUMBER_\
> &emsp; | _STRING_\
> &emsp; | **false**\
> &emsp; | **true**\
> &emsp; | ( **der** | **initial** | **pure** ) _function-call-args_\
> &emsp; | _component-reference_ _function-call-args_?\
> &emsp; | `[(]` _output-expression-list_ `[)]` _array-subscripts_?\
> &emsp; | `[[]` _expression-list_ ( **;** _expression-list_ )* `[]]`\
> &emsp; | **{** _array-arguments_ **}**\
> &emsp; | **end**

> _type-specifier_ → **.**? _name_

> _name_ → _IDENT_ ( **.** _IDENT_ )*

> _component-reference_ → **.**? _IDENT_ _array-subscripts_? ( **.** _IDENT_ _array-subscripts_? )*

> _function-call-args_ → `[(]` _function-arguments_? `[)]`

> _function-arguments_\
> &emsp; → _expression_ ( **,** _function-arguments-non-first_ | **for** _for-index_ )?\
> &emsp; | _function-partial-application_ ( **,** _function-arguments-non-first_ )?\
> &emsp; | _named-arguments_

> _function-arguments-non-first_\
> &emsp; → _function-argument_ ( **,** _function-arguments-non-first_ )?\
> &emsp; | _named-arguments_

> _array-arguments_ → _expression_ ( ( **,** _expression_ )* | **for** _for-index_ )

> _named-arguments_ → _named-argument_ ( **,** _named-argument_ )*

> _named-argument_ → _IDENT_ **=** _function-argument_

> _function-argument_\
> &emsp; → _function-partial-application_\
> &emsp; | _expression_

> _function-partial-application_ → **function** _type-specifier_ `[(]` _named-arguments_? `[)]`

> _output-expression-list_ → _expression_? ( **,** _expression_? )*

> _expression-list_ → _expression_ ( **,** _expression_ )*

> _array-subscripts_ → **[** _subscript_ ( **,** _subscript_ )* **]**

> _subscript_ → **:** | _expression_

> _comment_ → _string-comment_ _annotation-comment_?

> _string-comment_ → ( _STRING_ ( **+** _STRING_ )* )?

> _annotation-comment_ → **annotation** _class-modification_
