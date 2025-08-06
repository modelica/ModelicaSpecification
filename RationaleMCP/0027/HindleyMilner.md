# Unit checking

Unit checking is the process of inferring the units of Modelica variables, and ensuring the variables are used consistently in expressions and equations.

It takes place after any evaluation of evaluable parameters and no evaluable parameters shall be evaluated during this process.
(This must be true as long as tools allow the users to opt-out from unit-checking.)

It is performed by using a type inference algorithm, albeit adapted to work with units.
The algorithm proposed here is based on the Hindley-Milner algorithm.
At a high level the algorithm collects a set of constraints on the units of expressions.
It extracts a set of substitutions from these constraints which once applied determine whether a variable has a unit and what that unit would be.
Any inconsistency discovered during this process is a unit error, and any unit expression that contains remaining unknowns at the end of the process is considered unknown.

The document is organized as follows:
* [Introduction of what is meant by the unit of a variable](#the-unit-of-a-modelica-variable)
* [Description of the objects used in the inference algorithm](#unit-constraints-and-meta-expressions)
* [Definition of unit equivalence and convertibility](#unit-equivalence-and-convertibility)
* [Unit inference algorithm](#unit-inference)
* [Application to Modelica](#unit-constraints-of-a-modelica-model)
* [Modelica operators on units](#modelica-operators-on-units)
* [Extensions and limitations](#possible-extensions-and-current-limits)

## The unit of a Modelica variable

The unit of a Modelica variable is the unit associated with the variable after unit-checking has been performed, possibly remaining unknown.

Note that the unit of a variable is not the same concept as the `unit`-attribute of the variable, but in a unit-consistent model, the unit will be equal to the `unit`-attribute when present.

## Unit constraints and meta-expressions

Unit constraints are introduced in the form of an [equivalence](#equivalence) of two unit _meta-expressions_.
After an evaluation stage, a unit constraint of the form _`u1` is equivalent to `u2`_ will be represented by the _single-sided form_ `u1*u2^-1`.

This section outlines the different constructs that comprise meta-expressions.

### Variables
The unit of the Modelica variable `var` is represented by the unit variable `var.unit`.
These are unknowns for the inference algorithm to determine.

### Literals

#### `well-formed` unit
The `well-formed` units correspond to [Modelica unit expressions](https://specification.modelica.org/master/unit-expressions.html).

For the purposes of unit checking, they can be uniquely represented by their base unit factorization and scaling, up to the order of the base units.

(We discuss why we ignore unit offsets later.)

#### `empty` unit
An expression with `empty` unit won't contribute to the unit of a parent expression, and will meet any constraints imposed on it.
In practice, these are used to represent the unit of literal values.
They provide a more flexible solution than considering any literal value to have unit `"1"`.
They also provide a stricter solution than letting the unit of literals be inferred, which would effectively make literals wildcard from the perspective of the unit system.

#### `undefined` unit
An expression with `undefined` unit is used to represent unspecified or error cases, and will meet any constraints imposed on it.

### Operators

#### *
Consider the meta-expression `e1 * e2`.
* If both `e1` and `e2` are `well-formed`, it evaluates to a `well-formed` unit resulting from multiplying `e1` by `e2`.
* If one of them is `empty`, it evaluates to the other one. (In effect, the `empty` unit becomes unit `"1"`)
* If one of them is `undefined`, it evaluates to `undefined`.

#### ^
Consider the meta-expression `b ^ e`, where `e` is a rational.
* If `b` is `well-formed`, it evaluates to a `well-formed` unit resulting from raising `b` to the power `e`.
* If `b` is `empty`, it evaluates to `empty`.
* If `b` is `undefined`, it evaluates to `undefined`.

#### der
Consider the meta-expression `der(e)`.
* In a constraint where a `well-formed` unit is present, it evaluates to `e * ("s" ^ -1)`.
* If `e` is `empty`, it evaluates to `empty`.
* If `e` is `undefined`, it evaluates to `undefined`.

This definition keeps `der(e)` in symbolic form in a model that does not contain any units.
Otherwise, `der(x) = x` would lead to unit errors even if `x` has no declared unit.
This also means that in `k*der(x) = -x`, the unit of `k` won't be inferred to be `"s"`.

### Evaluation
Unit variables can't be found to be `empty` or `undefined` unit.
This means that after evaluation, a unit meta-expression is either `undefined`, `empty` or does not contain any `undefined` or `empty` unit.

After evaluation a constraint will not contain both a well-formed unit and a `der` meta-expression.
This means that all constraints can be simplified to have at most one well-formed unit.

## Unit equivalence and convertibility

### Equivalence
Two well-formed units are said to be equivalent if both of the following are true:
* Their base unit factorizations are equal.
* Their base unit scalings are equal.

Examples:
- `"N"` and `"m/s2"` have different base unit factorizations, they are not equivalent.
- `"s"` and `"ms"` have different base unit scaling, they are not equivalent.
- `"K"` and `"degC"` are equivalent.
- `"kN"` and `"W.s/mm"` are equivalent.

It is a quality of implementation how equality of scalings are checked.

`empty` units and `undefined` units are always equivalent to each other, themselves and any `well-formed` units.

### Convertibility
A well-formed unit `u1` is said to be convertible to another well-formed unit `u2` if:
* Their base unit factorizations are equal.

Examples:
- `"N"` is not convertible to `"m/s2"`, since they have different base unit factorizations.
- `"s"` is convertible to `"ms"`, since they differ by base unit scaling.
- `"K"` is convertible to `"degC"`.
- `"kN"` is convertible to `"W.s/mm"`.

`empty` units and `undefined` units are never convertible to each other, themselves or any `well-formed` units.

## Unit inference

### Modified Hindley-Milner

The original Hindley-Milner algorithm is designed to infer types, and consists of building a set of substitutions that returns the type of any expression of a given program.
Applying this algorithm to perform unit inference in Modelica comes with two important differences:
  * Not all variables must have a unit in a given model.
  * There are operations on meta-expressions, that is, not all constraints are of the form  _`var1.unit` is equivalent to `var2.unit`_.

#### Solvability of constraints

After meta-expression evaluation and gathering of variables in the single-sided form, a constraint's solvability can be determined using:
* A set `V` of unit variables present with non-zero exponent.
* A set `D` of unit variables, present inside a `der` meta-expression.

With this information, a variable `var.unit` can be solved from a given constraint if:
* `var.unit` is present in `V`, but not in `D`.

If a constraint has such a variable, the constraint is solvable.

#### Conditional constraints

One notion that doesn't exist in the original Hindley-Milner algorithm is that of a conditional constraint.
In Modelica, errors that are in unused part of a simulation model should typically be ignored (e.g., removed conditional components).
In the context of unit inference, some Modelica constructs generate constraints that are predicated on certain expressions having been evaluated or not.
The constraint conditions are conjunctive, in other words, if even a single condition evaluates to `false` the constraint should be discarded.

#### The algorithm

The Hindley-Milner algorithm modified to perform unit inference in Modelica:
* Traverse the flattened equation system and collect constraints before any evaluation has occured.
* After evaluable parameters have been evaluated, and expressions have been reduced to values when possible, evaluate the constraints, as well as their conditions. (This propagates `empty` and `undefined` units to the top of the constraints.)
* Discard any constraints of the form _`u` must be equivalent to empty unit_, or _`u` must be equivalent to undefined unit_, as they are trivially satisfied.
* Discard any constraints having at least a condition that was evaluated to `false`.
* Represent all constraints in their single-sided form.
* Start with an empty set `S` of substitutions.
* Loop:
    * Select a solvable constraint or one that can be checked, if no such constraint exists exit the loop.
    * If the constaint is in the form of just a `well-formed` unit, check that it is equivalent to `"1"`, it is an error otherwise.
    * If it can be solved for `var.unit`:
        * Replace the constraint by the substitution _`var.unit` => `u`_, where `var.unit` is not present in `u`.
        * Apply the substitution to the right-hand side of the substitutions already in `S`.
        * Add the substitution to `S`.
        * Apply the substitution to all remaining constraints.
* The unit of a variable for which there is no substitution in `S` is unknown.
* For a variable `var` that has a substitution `var.unit` => `u` in `S`:
    * If `u` is a `well-formed` unit, then this is the unit of `var`. (Given that no unit errors have been detected, a variable with a `unit`-attribute will get the given unit.)
    * Otherwise, the unit of `var` is unknown.

## Unit constraints of a Modelica model

The following rules describe the unit meta-expression of a given Modelica expression, where it makes sense.
They also provide the constraints that arise from different Modelica constructs.

When it is specified that _`u1` must be equivalent to `u2`_, the corresponding constraint should be collected.

In this section, the unit meta-expression of expression `e` is called `e.unit` and conditions of conditional constraints are highlighted with [].

### Variables
If `var` has a declared `unit`-attribute, `var.unit` must be equivalent to it.

`var.unit` must be equivalent to the unit of the following attributes if present:
 * `start`
 * `min`
 * `max`
 * `nominal`

(`var.unit` should be convertible to the `displayUnit`-attribute of `var` if it is present, but there is no corresponding constraints for the unit inference.)

Consider the expression `e` of the form `var`, where `var` is a Modelica variable.
* If `var` is a constant without declared `unit`-attribute, `e.unit` is determined by evaluating the unit of the declaration equation.
  When the declaration equation's unit is well-formed, it is propagated to `e.unit`.
  Otherwise, `e.unit` is the `empty` unit, preventing it from being determined by general unit inference.
* Otherwise, `e.unit` is `var.unit`.

### Literals
`Real` literals have `empty` unit.

### Binary operations
Consider an expression `e` of the form `e1 op e2`.

#### Additive operators
* `e.unit` must be equivalent to `e1.unit`.
* `e.unit` must be equivalent to `e2.unit`.

Note that this requires introducing an intermediate variable to represent `e.unit`.
This allows unit propagation when one of the operand has `empty` unit.

#### Multiplication
`e.unit` is `e1.unit * e2.unit`.

#### Division
`e.unit` is `e1.unit * (e2.unit ^ -1)`.

#### Relational operators
`e1.unit` must be equivalent to `e2.unit`

#### Power operator
* `e.unit` must be equivalent to `e1.unit ^ e2`.
* If [`e2` wasn't evaluated or is a `Real` expression], `e1.unit` must be equivalent to `"1"`.

Note that this requires introducing an intermediate variable to represent `e.unit`.
Technically, `e2` is a Modelica expression rather than a rational number, which means that `e1.unit ^ e2` cannot be represented as a unit meta-expression.
In practice, if the condition of the second constraint is verified, `e1.unit ^ e2` is `"1"` and if it isn't verified, then it can be represented as a meta-expression.

(If the exponent was not evaluated or is a `Real`, the unit of the base should be `"1"`.)
(It is up for discussion, when `e2` is `Real`, whether `e2.unit` should be equivalent to `"1"`. It could be handled in a similar way as transcendental functions. See below.)

### Function calls
Consider the expression `e` of the form `f(e1, e2, …, en)`.
* If the output of the function has a declared unit, `e.unit` is the declared unit.
* `e.unit` is `undefined` otherwise.

If function input `i` has a declared unit, `ei.unit` must be equivalent to this unit.

The natural generalization to functions with multiple outputs applies.

### Transcendental functions
As examples of transcendental functions, consider `sin`, `sign`, and `atan2`.
Other transcendental functions can be handled similarly.

Consider expression `e` of the form `sin(e1)`.
* If `e1.unit` is `empty`, then so is `e.unit`.
* If `e1.unit` is not `empty`, then it must be equivalent to `"1"` and `e.unit` is `"1"`.

Note that some of these constraints can only be processed once `e1.unit` has been determined.
This avoids introducing a unit `"1"` in the inference algorithm.

Implementation note: The rule above can be implemented as making `e.unit` equivalent to `e1.unit`, and if `e1.unit` is `well-formed` after completed unit inference, then verify that it is equivalent to `"1"`.

Consider an expression `e` of the form `sign(e1)`.
* If `e1.unit` is `empty`, then so is `e.unit`.
* If `e1.unit` is not `empty`, then `e.unit` is `"1"`.

Consider an expression `e` of the form `atan2(e1, e2)`.
* If `e1.unit` must be equivalent to `e2.unit`.
* If `e1.unit` or `e2.unit` is `undefined`, then so is `e.unit`.
* If `e1.unit` and `e2.unit` are `empty`, then so is `e.unit`.
* If `e1.unit` or `e2.unit` is not `empty`, then `e.unit` is `"1"`.

Implementation note: The rule above can be implemented as making `e.unit` equivalent to both `e1.unit * e1.unit^-1` and `e2.unit * e2.unit^-1`.

### Operator der
The unit of the expression `der(e)` is `der(e.unit)`.

### If-expressions
Consider the expression `e` of the form `if cond then e1 else e2`.
If [`cond` was not evaluated]:
* `e.unit` must be equivalent to `e1.unit`.
* `e.unit` must be equivalent to `e2.unit`.

If [`cond` was evaluated], `e.unit` must be equivalent to the unit of the selected branch.

Note that this requires introducing a intermediate variable to represent `e.unit`.

### Equations
Both sides of binding equations, equality equations and connect equations must be unit equivalent.

## Modelica operators on units

The following operators facilitate writing unit-consistent models.

### `withUnit($value$, $unit$)`
Creates an expression with unit `$unit$`, and value `$value$`.
Argument $value$ needs to be a `Real` expression, with `empty` unit.

One application of this operator is to attach a unit to a literal.

### `withoutUnit($value$, $unit$)`
Creates an expression with empty unit, whose value is the numerical value of `$value$` expressed in `$unit$`.
Argument `$value$` needs to be a `Real` expression, with a well-formed unit.
The unit of `$value$` must be convertible to `$unit$`.

### `inUnit($value$, $unit$)`
Creates an expression with unit `$unit$`, whose value is the conversion of `$value$` to `$unit$`.
Argument `$value$` needs to be a `Real` expression, with a well-formed unit.
The unit of `$value$` must be convertible to `$unit$`.

## Possible extensions and current limits

### Units with offset
The current proposal doesn't allow distinguishing `"K"` and `"degC"`.
In order to do that one needs to keep track of whether a variable is meant to represent a difference or not.
We have a proof of concept for such a feature, and the mechanism is similar and orthogonal to the one described here.

### Builtin operators and functions
The current state of this proposal does not cover the unit checking of all Modelica builtin operators and functions.

### Arrays
We don't try to specify how this would work on arrays, although the current proposal works straight-forwardly with element-wise operators.
We are confident that it could be extended to matrix computations too, but haven't a proof of concept for that part.

### Constants
This proposal takes a stance regarding how the unit of constants should be handled but we recognise that this is still very much up for discussion.
It is also somewhat orthogonal to the rest of the proposal.

### Functions
The Hindler-Milner algorithm provides a way to infer unit attributes of the inputs and outputs of functions.
Concretely, it would imply computing the bundles of constraints from the body of each functions and adding them to the algorithm, after adequate substitutions, when processing a function call.

### Variable initialisation pattern
A common pattern used in the MSL is the following:
```
model M
  Real d(unit = "s") = 12;
  Real v(unit = "m/s") = 0.1 / (3 * d);
end M;
```
where a modeler knows how to express a variable with unit as a function of another, with help of literal values that should really carry a unit.
The way to fix that, with this proposal, is to attach a unit to the literal values using `withUnit`.

### Syntax extension
We could extend the Modelica language to add syntactic sugar for `withUnit`.
The following variants have all been successfully test implemented:
* `0.1["m"]`
* `0.1 'm'` (or as `0.1'm'` to show more clearly that the quoted unit belongs to the literal)
* `0.1."m"`

### unsafeUnit operator
Another way to deal with the pattern described above would be to provide an unsafe operator that effectively drops any constraints generated in its subexpression.
The whole expression would have `undefined` unit.
