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
A new `constsize` expression is introduced for making assertions on array sizes.  A limitation of the current design, and ways it can be addressed in the future are described in a separate [rationale](constsize.md).

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

The `constsize` expression has the same type as `arrExp`, except that the flexible array dimensions are replaced by the specified constant sizes.  Note that this definition also applies to array dimensions with non-`Integer` upper bounds.  For example, any `Boolean` array dimension in `arrExp` must be matched by 2 in the `constsize` expression.

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
  end g;
  function h
    output Real[Boolean, :] y;
    ...
  end h;
  Real[2, 3] a = constsize(f(), 2, 3); /* OK. */
  Real[2, 3] b = constsize(f(), size(b)); /* OK. */
  Real[2, 3, 4] c = constsize(g(), 2, 3); /* OK. */
  Real[Boolean, 3] b = constsize(f(), 2, 3); /* OK; a Boolean dimension has size 2. */
end M;
```

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

## Subscripting of general expressions
In Flat Modelica it is possible to have a subscript on any (parenthesized) expression.
The reason for this generalization is that some manipulations, in particular inlining of function calls, can lead to such
expressions and without the slight generalization we could not generate flat Modelica for them. It does not add any real complication
to the translator.

The reason it is  restricted to parenthesized expressions is that `a.x[1]` (according to normal Modelica semantics) and `(a.x)[1]` will often work differently.
Consider
```
record R
  Real x[2];
end R;
R a[3];
```
Here  `a.x[1]` is a slice operation in Modelica generating the array  `{a[1].x[1],a[2].x[1],a[3].x[1]}`, whereas `(a.x)[1]`
is a subscripted slice operation generating the array `{a[1].x[1],a[1].x[2]}`
(assuming trailing subscripts can be skipped, otherwise it is illegal).
It would be possible to extend subscripting to `{a,b}[1]`, `[a,b][1,1]`,
and `foo()[1]` without causing any similar ambiguity - but it was not deemed necessary at the moment.

## Input output

The input and output causality shall only be present at the top of the model (and in functions).

For converting a Modelica model it means that input or output shall only be preserved
for variables that are:
* public top-level connector variables
* declared inside top-level connector variables
* public top-level non-connector scalar
* public top-level non-connector record

Consider:
```
connector C
  input Real x;
  output Real y;
end C;
record R
  Real x;
end R;
connector RealInput=input Real;
model MSub
  input R r;
  RealInput a;
  C c;
  output Real z;
protected
  RealInput a2;
  C c2;
  output Real z2;
end MSub;
model M
  extends MSub;
  MSub msub(r=r);
end M;
```
The Flat Modelica for `M` should only preserve input for `r`, `a`, `c.x` and output for `c.y`, `z`,
and thus not preserve it for protected variables and for variables in `msub`.

## Simplify modifications

Flat Modelica has different rules for modifications applied to:
- Model component declarations
- Types (records and short class declarations) and functions (function component declarations)

### Common restrictions

Some restrictions compared to full Modelica apply to both modifications in types and in model component declarations:
- Flat Modelica does not allow hierarchical names in modifiers, meaning that all modifiers must use the nested form with just a single identifier at each level.
- At each level, all identifiers must be unique, so that conflicting modifications are trivially detected.

### Restrictions for model component declarations

A _model component declaration_ is a component declaration belonging to the single `model` of a Flat Modelica source.

Aside from the common restrictions, there are no other restrictions on the modifications in model component declarations.

### Restrictions for types and functions

Named types can be introduced in two different ways in flat modelica, where both make use of modifications:
- When defining `record` types, each _record component declaration_ can have modifications.  For example:
```
record 'PosPoint'
  'Length' 'x'(min = 0);
  'Length' 'y'(min = 0);
end 'PosPoint';
```
- When defining type aliases (also known as _short class declarations_).  For example:
  - ```type 'Length' = Real(unit = "m");``` (just modify existing scalar type)
  - ```type 'Cube' = 'Length'[3](min = 0, max = 1);``` (make array type)
  - ```type 'Square' = 'PosPoint'('x'(max = 1), 'y'(max = 1))``` (nested modification)

The third and last category of component declarations (beside model component declarations and record component declarations), _function component declarations_, has the same restrictions as record component declarations, see below.  This includes both public and protected function component declarations.  For example:
```
function 'fun'
  input Real 'u'(min = 0); /* Public function component declaration. */
  output Real 'y'(min = 0); /* Public function component declaration. */
protected
  Real 'x'(min = 0); /* Protected function component declaration. */
  …
end 'fun';
```

The following restriction applies to modifications in types and functions, making types and function signatures in Flat Modelica easier to represent and reason about compared to full Modelica:
- Modifiers must have constant variability.
- Modifiers must be scalar, giving all elements of an array the same element type.  Details of how the scalar modifier is applied to all elements of an array is described [below](#Single-array-element-type).  For example, an array in a type cannot have individual element types with different `unit` attributes.

The modifications that are not allowed in types must be applied to the model component declarations instead.  For attributes such as `start`, `fixed` and `stateSelect`, this will often be the case.

The reason for placing the same restrictions on protected function component declarations as on public function component declarations is that the handling of types inside functions gets significantly simplified without much loss of generality.  To see the kind of loss of generlity, one needs to consider that many attributes have no use in functions at all: `start`, `fixed`, `nominal`, `unbounded`, `stateSelect`, and `displayUnit`.  This leaves two goups of attributes with minor loss of generality:
- The strings `unit` and `quantity` can be used to enable more static checking of units and quantities in the function body.  Since such checks are performed during static analysis, the constant variability requirement should hold in general, not just inside functions.  Regarding the other requirement, it is hard to come up with realistic examples where `unit` and `quantity` would not be equal for all elements of an array.
- Outside functions, `min` and `max` both provide information that may be useful for symbolic manipulations and define conditions that shall be monitored at runtime.  While the symbolic manipulations benefit greatly from constant variability of the limits, the runtime checking is more easily applicable to other variabilities, and different limits for different array elements is not as inconceivable as having different units.  Inside functions, on the other hand, limits on protected variables is not going to provide important information for symbolic manipulations, since function body evaluation does not involve equation solving.  If one would like to have non-constant limits, or limits that are different for different elements of an array, this is possible to express using `assert` statements instead of `min` and `max` attributes.

#### Single array element type

As stated above, an array in a type must have the same type for all its elements, which is to be expressed somehow using only scalar modifiers.  Exactly how this shall be enforced is left to depend on a clarification regarding the use of `each` in full Modelica, see https://github.com/modelica/ModelicaSpecification/issues/2630#issuecomment-669868185 and related comments.

The two variants in `'LineA'` and `'LineB'` below are considered, with the aim of expressing the same thing that would be expressed as `FullModelicaLine` in full Modelica:
```
type 'P' = Real[3];

record FullModelicaLine
  /* Basic way of setting all 'start' attributes is to provide an array with all values:
   */
  'P' q[2](start = fill(4, 2, 3), fixed = fill(false, 2, 3));

  /* Alternatively, one can (no full Modelica controversy here) use 'each' to
   * propagate the same modifier to all elements of the surrounding array:
   */
  'P' p[2](each start = fill(4, 3), each fixed = fill(false, 3));
end FullModelicaLine;

record 'LineA'
  /* Unclear whether or not valid Modelica. */
  'P' 'p'[2](each start = 4, each fixed = false);
end 'LineA';

record 'LineB'
  /* Do not use 'each' at all in Flat Modelica types. */
  'P' 'p'[2](start = 4, fixed = false);
end 'LineB';
```

If the `LineA` variant ends up being valid in full Modelica, then this is the form that will also be used for Flat Modelica.  Otherwise, Flat Modelica will use the `LineB` form.
