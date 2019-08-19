# Name mangling

This document describes the Flat Modelica encoding of names of a flattended Modelica model.  In the world of (full) Modelica and Flat Modelica, it is assumed that the context of an identifier is always known, so that it is always clear whether names have been mangled or not.

## Terminology

A _component reference_ of a flattened Modelica model is a hierarchically structured string such as `axis.bearingFriction.sa`, or `foo[1,2].bar`, or just `k`.  For example, this is how we currently refer to variables in a simulation result.

An _identifier_ is something that may be used as a variable name in a Modelica or Flat Modelica class, such as `axis` or `bearingFriction`.  Valid identifiers must conform to the `IDENT` in Modelica's lexical structure (see below).

To refer to a component reference in Flat Modelica, its name needs to be _encoded_ as a Flat Modelica identifier.  This process is also known as _name mangling_ since the resulting identifiers will appear as more or less distorted variants of the original component references.  A tool reading Flat Modelica input will then need to _decode_ identifiers in order to reconstruct the original component references.


## Requirements

In order for Flat Modelica to be a subset of Modelica, the Flat Modelica identifiers must conform to the `IDENT` in Modelica's lexical structure:
```
IDENT    = NONDIGIT { DIGIT | NONDIGIT } | Q-IDENT
Q-IDENT  = "’" { Q-CHAR | S-ESCAPE | """ } "’"
NONDIGIT = "_" | letters "a" ... "z" | letters "A" ... "Z"
DIGIT    = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
Q-CHAR   = NONDIGIT | DIGIT | "!" | "#" | "$" | "%" | "&" | "(" | ")" | "*" |
"+" | "," | "-" | "." | "/" | ":" | ";" | "<" | ">" | "=" | "?" | "@" | "["
| "]" | "^" | "{" | "}" | "|" | "~" | " "_
S-ESCAPE = "\’" | "\"" | "\?" | "\\" | "\a" | "\b" | "\f" | "\n" | "\r" | "\t"
| "\v"
```

Additional requirements:
* Possible to distinguish between encoded component references and other identifiers
* Possible to reconstruct original component references
* Support different levels of scalarization
* Reserved namespace for generated names
* No collision with current and future Flat Modelica reserved names
* No ambiguity with array subscripting and record member reference expressions
* Allow systematic construction of names for things such as start attributes, that combine a variable name with additional specification


## Mangling rules

### Component references

In Modelica, a component reference is a very restricted form of a gneralized expression where literal array subscripting and record member referencing can be applied to any sub-expression.  As such, they are identified with their abstract syntax tree representation.  In particular, their textual input form is insensitive to whitespace and comments.

In Flat Modelica, a component reference appears as an encoded string that is to be parsed the same way as a generalized Modelica expression for a Modelica component reference.  However, a Flat Modelica component reference is not allowed to contain whitespace or comments.
 
Examples:

| String | Valid Flat Modelica component reference? |
|--|--|
| `foo[1,2].bar` | Yes |
| `foo[1, 2]` | No (whitespace not allowed) |
| `foo[1,,2]` | No (doesn't parse) |
| `foo(1,2)` | No (illegal kind of expression) |
| `foo[1/* one */,2/* two */]` | No (comments not allowed) |


### Upquoting and downquoting

Using `\` as escape character, many strings, including all component references, can be _upquoted_ by the following reversible procedure:
1. Insert a "`\`" before any of the characters: { "`\`", "`'`" }
1. Wrap the result in single quotes.

Upquoting a Modelica component reference always results in a valid (Flat) Modelica `Q-IDENT` identifier.  Examples:

| Input | Upquoted string | Remark |
|--|--|--|
| `axis.bearingFriction.sa` | `'axis.bearingFriction.sa'` | |
| `foo[1,2].bar` | `'foo[1,2].bar'` | |
| `'foo bar'` | `'\'foo bar\''` | |
| `'foo\''` | `'\'foo\\\'\''` | |
| `der(foo)` | `'der(foo)'` | Input is not valid component reference, but result is still valid identifier |
| `'foo\` | `'\'foo\\'` | Same as above. |

A substring consisting of "`\`" followed by one more character is called an _escape sequence_.

The reverse procedure is denoted _downquoting_:
1. Strip surrounding single quotes.
1. Remove the leading `\` in any escape sequence.

Unlike upquoting, downquoting breaks much more easily.  Examples:

| Input | Downquoted string | Remark |
|--|--|--|
| `'axis.bearingFriction.sa'` | `axis.bearingFriction.sa` | |
| `'foo\''` | `foo'` | Result is not valid component reference. |
| `'\'foo\\'` | `'foo\` | Result is not valid component reference. |
| `'fo\o'` | `foo` | Escape sequence does not have to encode "`'`" or "`\`". |
| `foo'` | **error** | Input is not a valid identifier. |
| `foo` | **error** | Input does not have surrounding quotes. |
| `'foo\'` | **error** | Incomplete escape sequence after stripping surrounding quotes. |


### Flat Modelica namespaces

To support fast categorization of identifiers in Flat Modelica, they are divided into easily recognizable categories:
* A `Q-IDENT` that cannot be decoded is an error.
* Any other `Q-IDENT` is categorized based on the first character of the decoded string:
  - A `NONDIGIT` or "`'`" means a component reference
  - A "`.`" is reserved for future use
  - Otherwise, it is a generated structured name
* An `IDENT` is categorized based on the first character:
  - A "`_`" means a generated non-structured name
  - Otherwise, it is a Flat Modelica reserved name

Examples:

| Flat Modelica identifier | Category |
|--|--|
| `class` | Flat Modelica reserved name (happens to be a keyword) |
| `sin` | Flat Modelica reserved name (name of built-in function) |
| `foo` | Flat Modelica reserved name (reserved for future use) |
| `_R123` | Generated non-structured name (such as an automatically generated record or introduced helper variable) |
| `'axis.bearingFriction.sa'` | Component reference: `axis.bearingFriction.sa` |
| `'\'foo bar!\'.x'` | Component reference: `'foo bar!'.x` |
| `'der(x'` | Component reference (can't be parsed) |
| `'=der(x)'` | Generated structured name (might refer to derivative of `x`) |
| `'/foo.bar/start'` | Generated structured name (might refer to `start` attribute of `foo.bar`) |
| `'foo\'` | **error** (can't be decoded) |


## Use cases

This section shows what the mangling would look like in the two extreme cases of amount of scalarization.

For the demonstration, the following simple Modelica model will be used:
```
model ManglingTest

  model M
    parameter Real p = 1.0;
    Real[2] arr;
    Real x = sum(arr);
  equation
    der(arr) = {p, 1.0};
  end M;

  model MArr
    M[2] mm(p = {2.0, 3.0});
    M m(p = 4.0);
  end MArr;

  MArr root;
  Real y = root.m.x;

end ManglingTest;
```

### Scalarized Flat Modelica

Here, every Flat Modelica component reference refers to a scalar variable.

```
model 'ManglingTest'
  parameter Real 'root.mm[1].p' = 2.0;
  Real 'root.mm[1].arr[1]';
  Real 'root.mm[1].arr[2]';
  Real 'root.mm[1].x' = 'root.mm[1].arr[1]' + 'root.mm[1].arr[2]';
  parameter Real 'root.mm[2].p' = 3.0;
  Real 'root.mm[2].arr[1]';
  Real 'root.mm[2].arr[2]';
  Real 'root.mm[2].x' = 'root.mm[2].arr[1]' + 'root.mm[2].arr[2]';
  parameter Real 'root.m.p' = 4.0;
  Real 'root.m.arr[1]';
  Real 'root.m.arr[2]';
  Real 'root.m.x' = 'root.m.arr[1]' + 'root.m.arr[2]';
  Real 'y' = 'root.m.x';
equation
  der('root.mm[1].arr[1]') = 'root.mm[1].p';
  der('root.mm[1].arr[2]') = 1.0;
  der('root.mm[2].arr[1]') = 'root.mm[2].p';
  der('root.mm[2].arr[2]') = 1.0;
  der('root.m.arr[1]') = 'root.m.p';
  der('root.m.arr[2]') = 1.0;
end 'ManglingTest';
```

### Hierarchical Flat Modelica

Here, automatically generated records are used to preserve the hierarchical structure of the original Modelica model, and arrays are not scalarized.

```
record _R1
  parameter Real 'p';
  Real[2] 'arr';
  Real 'x';
end _R1;

record _R2
  _R1[2] 'mm'('p' = {2.0, 3.0});
  _R1 'm'('p' = 4.0);
end _R2;

model 'ManglingTest'
  _R2 'root';
  Real 'y' = 'root'.'m'.'x';
equation
  'root'.'mm'[1].'x' = sum('root'.'mm'[1].'arr');
  'root'.'mm'[2].'x' = sum('root'.'mm'[2].'arr');
  'root'.'m'.'x' = sum('root'.'m'.'arr');
  der('root'.'mm'[1].'arr') = {'root'.'mm'[1].'p', 1.0};
  der('root'.'mm'[2].'arr') = {'root'.'mm'[2].'p', 1.0};
  der('root'.'m'.'arr') = {'root'.'m'.'p', 1.0};
end 'ManglingTest';
```
