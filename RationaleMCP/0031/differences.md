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

## Array size

### Array types
In Flat Modelica, array size is part of an array type.  Each dimension has a size that is either _constant_ or _flexible_.  A constant size is one that is an `Integer` number (of constant variability).  It follows that array dimensions index by `Boolean` or enumeration types have constant size (TODO: figure out correct terminology).  A flexible size is an `Integer` of non-constant variability, that is, it corresponds to an array dimension indexed by `Integer` and where the upper bound is a number unknown to the type system.

When determining expression types, every array dimension must be unambiguously typed as either constant or flexible.  Where there are constraints on array sizes, for instance when adding two arrays, a flexible array size is only compatible with another flexible array size.  It is a runtime error if the two flexible array sizes are found to be incompatible at runtime (a tool can optimize runtime checks away if it can prove that the sizes will be compatible).

In an array equation, the array type must have constant sizes.

When determining the type of a function call, the sizes of output array variables are determined based on the input expressions and the function's declarations of input and output components.  An output array size is constant (for the function call at hand) if it can be determined based on the types of input expressions and the constant variability values of input expressions.  When an array size cannot be determined based on this information (including the trivial case of a function output component declared with `:` size), the size is flexible.

Example:
```
model M
  function f
    input Integer n;
    input Real[:] x;
    output Real[n + size(x, 1)] y;
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

Note: The current forms of `constsize` does not allow leaving some leading sizes flexible, while making other sizes constant.  To support this, one could also add a third form where two constant variability `Integer` arrays of equal size are given, where the first array specifies dimensions, and the second array specifies the corresponding sizes:
```
constsize(arrExp, {d1, d2, ..., dn}, {sd1, sd2, ..., sdn})
```

Alternative design: Use some variant of type conversion syntax, for instance:
```
  Real[2, 3] a = Real[2, 3](f());
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
