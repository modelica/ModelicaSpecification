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

### Reason for change
By excluding `external` functions, translation time evaluation of constant expressions is greatly simplified.  By excluding `impure` functions and `pure(…)` expressions, it is ensured that it doesn't matter whether evaluation happens at translation time or at simulation (initialization) time.

Forbidding translation time evaluation of function calls in non-constant expressions generalizes the current Modelica rule for `impure` functions and makes it clear that this is not allowed regardless whether this is seen as an optimization or not.  (The current Modelica specification only has a non-normative paragraph saying that performing optimizations is not allowd.)

The change regarding parameter expressions could be extended to discrete-time expressions as well without loss of expressiveness due to the existing restrictions on where an impure function may be called.  This could also be expressed more generally by saying that a function call expression where the callee is impure is a non-discrete-time expression.  However, it was decided to not include this in the formal description of differences between Modelica and Flat Modelica in order to avoid describing changes that only clarify things without actually making a difference to semantics.

The shifts in variability of function calls could be summarized as _the variability of a function call expression is the highest variability among the argument expressions and the variability of the called function itself_, where the _variability of a function_ is defined by the following table:

| Function classification | Function variability |
| --- | --- |
| pure constant | constant |
| pure, otherwise | parameter |
| impure | continuous-time |

Seen this way, the rules about which functions may be called in the body of a function definition ends up being another case of variability enforcement.

This covers what one can currently express in full Modelica.  In the future, one might also introduce _pure discrete_ functions that don't have side effects, but that must be re-evaluated at events, even if the arguments are constant.

## Array size

### Array types
In Flat Modelica, array size is part of an array type.  Each dimension has a size that is either _constant_ or _flexible_.  A constant size is one that is an `Integer` number (of constant variability).  It follows that array dimensions index by `Boolean` or enumeration types have constant size (TODO: figure out correct terminology).  A flexible size is an `Integer` of non-constant variability, that is, it corresponds to an array dimension indexed by `Integer` and where the upper bound is a number unknown to the type system.

When determining expression types, every array dimension must be unambiguously typed as either constant or flexible.  Where there are constraints on array sizes, for instance when adding two arrays, a flexible array size is only compatible with another flexible array size.  It is a runtime error if the two flexible array sizes are found to be incompatible at runtime (a tool can optimize runtime checks away if it can prove that the sizes will be compatible).

In an array equation, the array type must have constant sizes.  On the other hand, a flexible size on the left hand size of an array assignment does not impose any size constraint on the right hand size, and is allowed.

When determining the type of a function call, the sizes of output array variables are determined based on the input expressions and the function's declarations of input and output components.  An output array size is constant (for the function call at hand) if it can be determined based on the types of input expressions and the constant variability values of input expressions.  When an array size cannot be determined based on this information (including the trivial case of a function output component declared with `:` size), the size is flexible.

Example:
```
model M
  function f
    input Integer n;
    input Real[:] x;
    output Real[n + size(x, 1)] y;
  protected
    Real[:] a;
  algorithm
    a := {0.5}; /* OK: Constant size can be assigned to flexible size. */
    ...
  end f;
  parameter Integer p = 2;
  constant Integer c = 3;
  Real[2] a = fill(1.0, p); /* Error: expression has flexible size. */
  Real[5] b = f(c, a); /* OK. */
end M;
```

#### Change and reason for the change
This draws a clear line between the constant and flexible array sizes.  This is important for portability (lack of clear separation opens up for different interpretations, where what is considered valid code in one tool is considered a type error in another).  The clear separation also means that flexible array size becomes an isolated Flat Modelica language feature that can be easily defined as an unsupported feature in eFMI.

To only consider a flexible size compatible with another flexible size is a restriction that may be removed in the future, allowing different forms of inference on the array sizes.  For now, however, such inference is not considered necessary for a first version of Flat Modelica, and defining such inference would also involve too much work at this stage of Flat Modelica development.

It is believed that the clear separation of constant and flexible array sizes is also a necessary starting point for a future extension to allow components with flexible array size outside functions.

### The `constsize` expression
A new `constsize` expression is introduced for making assertions on array sizes.

The expression comes in different forms.  In the first form, the `s1`, `s2`, …, `sn` are constant variability `Integer` expressions:
```
constsize(arrExp, s1, s2, ..., sn)
```
Here, `arrExp` has array type with at least _n_ dimensions.

In the second form, a constant variability array of `Integer` sizes is given instead:
```
constsize(arrExp, {s1, s2, ..., sn})
```

It is a type error if a constant array size of `arrExp` does not match the corresponding size of the `constsize` expression.  A flexible size of `arrExp` is asserted to be equal to the corresponding size of the `constsize` expression, and any error is typically not detected until runtime.

The `constsize` expression has the same type as `arrExp`, except that the flexible array dimensions are replaced by the specified constant sizes.

Example:
```
model M
  function f
    output Real[2, :] y;
    ...
  end f;
  function g
    output Real[2, :, 4] y;
    ...
  end f;
  Real[2, 3] a = constsize(f(), 2, 3); /* OK. */
  Real[2, 3] b = constsize(f(), size(b)); /* OK. */
  Real[2, 3, 4] c = constsize(f(), 2, 3); /* OK. */
end M;
```

Note: The `constsize` definition also applies to array dimensions with non-`Integer` upper bounds.  For example, any `Boolean` array dimension in `arrExp` must be matched by 2 in the `constsize` expression.

#### Limitation
Note: The current forms of `constsize` don't allow leaving some leading sizes flexible, while making other sizes constant.  It means that some full Modelica function algorithms cannot be directly converted to Flat Modelica:
```
function flexibleTrouble
protected
  Real[:, :] a; /* (That the second dimension doesn't have constant size matching 'b' is probably a sign of bad design.) */
  Real[2] b;
  Real[:] y;
algorithm
  /* Allowed in full Modelica, but not in Flat Modelica.
   * Size mismatch in array multiplication: ':' is not compatible with constant size.
   */
  y := a * b;
  /* Trying to address Flat Modelica type error.
   * Well-typed, but will generally fail at runtime, as 42 has nothing to do with the first size of 'a'.
   */
  y := constsize(a, 42, 2) * b;
end flexibleTrouble;
```

To support this, one could also add a third form where two constant variability `Integer` arrays of equal size are given, where the first array specifies dimensions, and the second array specifies the corresponding sizes:
```
constsize(arrExp, {d1, d2, ..., dn}, {sd1, sd2, ..., sdn})
```

Alternatively, one could make `constsize` a keyword and change the grammar to also allow `:` instead of a constant `Integer` (possibly causing some confusion for human readers that don't understand why a `:` is allowed in a place that looks like a function call argument):
```
constsize(arrExp, :, s2, ..., sn)
```

For now, however, we don't expect this to be a problem for real-world examples.  Regarding the example given above, the variable `a` should probably have been declared as `Real[:, 2]` to start with, and then the matrix multiplication would be fine also in Flat Modelica.  For this reason, and knowing that there are ways that the current `constsize` expressions can be generalized in the future, we leave the design of `constsize` for now with this known limitation.

Finally, note that a very cumbersome workaround that doesn't require generalization of `constsize` is to introduce a new function to do the job:
```
function _constsize_Real_flexible_2
  input Real[:, :] x;
  output Real[size(x, 1), 2] y;
algorithm
  assert(size(x, 2) == 2, "Expected second array dimension to have size 2.");
  for i in 1 : size(y, 1) loop
    for j in 1 : size(y, 2) loop
      y[i, j] := x[i, j];
    end for;
  end for;
end _constsize_Real_flexible_2;
```

#### Alternative syntax
Another syntax for `constsize` was also considered to make it easier to address the limitation of not being able to leave some leading sizes flexible.  Here, a `constsize` expression uses special syntax instead of taking the form of a normal function call:
```
constsize[s1, s2, ..., sn](arrExp)  /* "Square bracket form" reminding of component declaration. */
constsize(dimsExp)(arrExp)          /* dimsExp is a constant Integer array expression, such as size(...). */
```

Pros and cons leading to the current decision of going with the function call syntax instead:
- Syntax (square bracket form) is easily and naturally extended to also allow `:` sizes where the resulting size must not be constant (the use of `:` in a list of sizes given between square brackets is already established).
- Not using function call syntax means grammar has to be extended (with `constsize` as Flat Modelica keyword), without added value until generalized to also allow `:`.
- The currently proposed function call syntax would also be possible to extend, see above.

### Variability of size-expressions
The variability of an `ndims` expression is constant, as it only depends on the type of the argument and is unaffected by flexible array sizes.

The variability of a `size` expression depends on the presence of flexible array sizes in the argument.  If the result depends on a flexible array size, the variability of the array argument is preserved, otherwise, the variability of the `size` expression is constant.

#### Change and reason for the change
In Modelica, size-expressions are described as function calls, meaning that they cannot be seen as acting on the type of the argument.  This is changed in order to capture important cases of specifying array dimensions that would otherwise be typed as flexible sizes for no good reason.

### Component declaration with non-constant array size
In Flat Modelica, component declarations outside functions may only specify constant array sizes.

#### Change and reason for the change
In Modelica, array sizes with parameter variability outside of functions are somehow allowed, at least not forbidden, but the semantics are not defined.
So it is easier to forbid this feature for now. If introduced in Modelica, it is still possible to introduce them here with the same semantics. It would be impossible the other way around.
