# Design of Ternary
This document just presents the design part of the MCP.  There is also a [rationale](rationale.md).


## The `Ternary` type
The new build-in type `Ternary` is similar to `Boolean`:
```
type Ternary // Note: Defined with Modelica syntax although predefined
  TernaryType value; // Accessed without dot-notation
  parameter StringType quantity = "";
  parameter BooleanType start = unknown;
  parameter BooleanType fixed = true;
end Ternary;
```

## New top-level constant `unknown`
The top-level constant `unknown` is introduced to refer to the _unknown_ truth value.

Using `unknown` as if it were not a reserved name similar to `Real` is deprecated.  It is also deprecated to refer to the top-level constant using its fully qualified component reference `.unknown`.


## Conversion from Boolean

### Explicit conversion
The two known ternary truth values can be constructed by explicit conversion from the `Boolean` value `x` using the syntax `Ternary(x)`.  This is the primitive way of constructing the other two ternary values besides `unknown`.

### Implicit conversion
A `Boolean` expression can be used wherever a `Ternary` is expected, via implicit conversion.  For example `true and unknown` is a valid expression of type `Ternary`, since the operator `and` requires both operands to be `Ternary` as soons as one of them is.


## Total order of values
There is a total order of the possible `Ternary` values given by `Ternary(false)` < `unknown` < `Ternary(true)`.  This allows `Ternary` to be used as array dimension, and gives meaning to the [relational operators](#Boolean-valued-relations).


## Expressions with Ternary

The logical connectives `not`, `and` and `or` on `Ternary` are defined in accordance with Kleene, where `unknown` can be thought of as representinc uncertainty about being `true` or `false`.  With this interpretation the truth tables then follow from the Boolean logic.

For example, to evaluate `false or unknown`, one has to consider both possible outcomes for the uncertain operand, meaning that the result might be ither `false or false` or `false or true`.  Since the different outcomes don't agree, the result of the operation is uncertain, represented by `unknown`.

Although the truth tables of `not`, `and` and `or` agree with Kleene logic, the set of logical connectives on `Ternary` is deliberately not meant to model any particular ternary logic.  In particular, by not defining an operator for material implication, `Ternary` cannot be considered a complete model of Kleene logic.  Applications requiring a complete model of one of the many possible ways to define ternary logic may use `Ternary` to represent the three truth values, but should define all the logical connectives of the logic in question as a package (library) of functions.

### Unary operators
Unary operators on `Ternary`, where `x` is an expression of type `Ternary`:

| Expression    | Result type   |
| ------------- | ------------- |
| `not x`       | `Ternary`     |

Truth table for `not x`:

| `x`              | `not x`          |
| ---------------- | ---------------- |
| `Ternary(false)` | `Ternary(true)`  |
| `unknown`        | `unknown`        |
| `Ternary(true)`  | `Ternary(false)` |


### Binary operators
Binary operators on `Ternary`, where `x` and `y` are an expressions of type `Ternary`:

| Expression    | Result type   |
| ------------- | ------------- |
| `x and y`     | `Ternary`     |
| `x or y`      | `Ternary`     |

Truth table for `x and y`:

| `x and y`            | `y = Ternary(false)` | `y = unknown`    | `y = Ternary(true)` |
| -------------------- | -------------------- | ---------------- | ------------------- |
| `x = Ternary(false)` | `Ternary(false)`     | `Ternary(false)` | `Ternary(false)`    |
| `x = unknown`        | `Ternary(false)`     | `unknown`        | `unknown`           |
| `x = Ternary(true)`  | `Ternary(false)`     | `unknown`        | `Ternary(true)`     |

Truth table for `x or y`:

| `x or y`             | `y = Ternary(false)` | `y = unknown`    | `y = Ternary(true)` |
| -------------------- | -------------------- | ---------------- | ------------------- |
| `x = Ternary(false)` | `Ternary(false)`     | `unknown`        | `Ternary(true)`     |
| `x = unknown`        | `unknown`            | `unknown`        | `Ternary(true)`     |
| `x = Ternary(true)`  | `Ternary(true)`      | `Ternary(true)`  | `Ternary(true)`     |


### Boolean-valued relations
Relational operators for `Ternary` are defined according to the total order.  Here, `x` and `y` are an expressions of type `Ternary`:

| Expression    | Result type   | Equivalent to    |
| ------------- | ------------- | ---------------- |
| `x < y`       | `Boolean`     |                  |
| `x <= y`      | `Boolean`     | `not (y > x)`    |
| `x > y`       | `Boolean`     | `y < x`          |
| `x >= y`      | `Boolean`     | `not (x < y)`    |
| `x != y`      | `Boolean`     | `x < y or y < x` |
| `x == y`      | `Boolean`     | `not (x != y)`   |

The truth tables follow directly from the total order, so there is no point in listing them all.  Here is an example which is just another way of saying `Ternary(false)` < `unknown` < `Ternary(true)`:

| `x < y`              | `y = Ternary(false)` | `y = unknown`    | `y = Ternary(true)` |
| -------------------- | -------------------- | ---------------- | ------------------- |
| `x = Ternary(false)` | `false`              | `true`           | `true`              |
| `x = unknown`        | `false`              | `false`          | `true`              |
| `x = Ternary(true)`  | `false`              | `false`          | `false`             |


## Ternary equations
As a discrete-valued type, `Ternary` is treated analogous to `Boolean` in equations.  In equations, there is no special meaning of `unknown`.


## External language interface
External type corresponding to `Ternary`:

| External language | Input type    | Output type   |
| ----------------- | ------------- | ------------- |
| `"C"`             | `int`         | `int *`       |
| `"FORTRAN 77"`    | `INTEGER`     | `INTEGER`     |

Mapping of values:

| `Ternary`         | External language |
| ----------------- | ----------------- |
| `Ternary(false)`  | 1                 |
| `unknown`         | 2                 |
| `Ternary(true)`   | 3                 |

Unlike `Boolean` for which there is a natural interpretation of any non-zero value from C as meaning `true`, there is a unique way to represent each of the three different values of `Ternary`.  This is analogous to the external language mapping for enumerations and helps detecting errors in the external language code.
