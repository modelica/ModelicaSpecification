# Semantical differences between Flat Modelica and Modelica
This document describes differences between Flat Modelica and Modelica that aren't clear from the differences in the grammars.

## Unbalanced if-equations
In Flat Modelica, all branches of an `if`-equation must have the same equation size.
Absence of an else branch is equivalent to having an empty else branch with equation size 0.

An `if`-equation without `else` is useful for a conditional `assert` and similar checks.

Note: _The "equation size" count the number of equations as if the equations were expanded into scalar equations, 
but does not require that the equations can be expanded in this way._

### Change and reason for the change
In Modelica this restriction only applies for `if`-equations with non-parameter conditions.
For `if`-equations with parameter condition it does not hold, and if the equation sizes
differ those parameters have to be evaluated. In practice it can be complicated to separate those cases, 
and some tools attempt to evaluate the parameters even if the branches have the same equation size.

Flat Modelica is designed to avoid such implicit evaluation of parameters, and thus this restriction is necessary.

In Modelica a separate issue is that `if`-equations may contain connect and similar primitives 
that cannot easily be counted; but they are gone in Flat Modelica.

# Pure Modelica functions

In addition to full Modelica's classification into _pure_ and _impure_, Flat Modelica adds the concept of a `pure constant` function, informally characterized by the following properties:
- Only the output values of a function call influence the simulation result (considered free of side effects for purposes of program analysis).
- The function itself only contributes with `constant` variability to expressions where it is called.  That is, when the function is called with constant arguments, the result is assumed to be the same when evaluated at translation time and when evaluated at any point during simulation.
- It is straight-forward to evaluate a call to a `pure constant` function at translation time.

The built-in functions are `pure constant`, and a user-defined pure `function` or `operator function` can be declared as `pure constant` by adding `constant` in the class prefix right after `pure`.  For example:
```
pure constant function add1
```

The implementation of a `pure constant` functions is more restricted than that of pure functions in general:
- It may not have `external` implementation.
- It may not contain any `pure(…)` expression.
- All called functions must be `pure constant`.

The rule for `pure(impureFunctionCall(...))` needs to be rephrased to not say _allows calling impure functions in any pure context_, since the body of a `pure constant` function is also a pure context.  Perhaps something like this instead:
> meaning that the present occurrence of `impureFunctionCall` should be considered pure (not `pure constant`) for purposes of purity analysis.

### Reason for change

This change was made to support the [changed definitions of _constant expression_](#Constant-expressions).

## Variability of expressions

### Constant expressions
In Flat Modelica, a _constant expression_ is more restricted than in full Modelica, by adding the following requirement:
- Functions called in a constant expression must be `pure constant`.

By requiring functions called in a constant expression to be `pure constant`, it is ensured that a constant expression can always be evaluated to a value at translation time.  A function call that is not a constant expression must not be evaluated before simulation starts.

### Parameter expressions

In Flat Modelica, a _parameter expression_ is more restricted than in full Modelica, by adding the following requirement:
- Functions called in a parameter expression must be pure.

As a consequence, the full Modelica syntactic sugar of using an impure function in the binding equation of a parameter is not allowed in Flat Modelica.  Such initialization has to be expressed explicitly using an initial equation.  Hence, the rules of variability hold without exception also in the case of components declared as parameter.

### Discrete-time expressions

In Flat Modelica, a _discrete expression_ is more restricted than in full Modelica, by adding the following requirement (with emphasis on the difference compared to full Modelica):
- Function calls where all input arguments of the function are discrete-time expressions _are discrete-time provided that the callee is pure_.

The rule about when-clause bodies, initial equations, and initial algorithms still holds without exception, so purity of functions doesn't matter there.

### Continuous-time expressions

Note that a function call expression where the callee is impure is a non-discrete-time expression, regardless of the variability of the argument expressions.

### Reason for change
By excluding `external` functions, translation time evaluation of constant expressions is greatly simplified.  By excluding `impure` functions and `pure(…)` expressions, it is ensured that it doesn't matter whether evaluation happens at translation time or at simulation (initialization) time.

Forbidding translation time evaluation of function calls in non-constant expressions generalizes the current Modelica rule for `impure` functions and makes it clear that this is not allowed regardless whether this is seen as an optimization or not.  (The current Modelica specification only has a non-normative paragraph saying that performing optimizations is not allowd.)

The shifts in variability of function calls could be summarized as _the variability of a function call expression is the highest variability among the argument expressions and the variability of the called function itself_, where the _variability of a function_ is defined by the following table:

| Function classification | Function variability |
| --- | --- |
| pure constant | constant |
| pure, otherwise | parameter |
| impure | continuous-time |

This covers what one can currently express in full Modelica.  In the future, one might also introduce _pure discrete_ functions that don't have side effects, but that must be re-evaluated at events, even if the arguments are constant.

## Array dimensions with parameter variability
In Flat Modelica, an array dimension is allowed to have `parameter` variability, that is, the dimension isn't known until after solving the initialization problem in the simulation.  _TO BE ELABORATED…_
