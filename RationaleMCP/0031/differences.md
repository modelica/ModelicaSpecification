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

### Variability of size-expressions
The variability of an `ndims` expression is constant, as it only depends on the type of the argument and is unaffected by flexible array sizes.

The variability of a `size` expression depends on the presence of flexible array sizes in the argument.  If the result depends on a flexible array size, the variability of the array argument is preserved, otherwise, the variability of the `size` expression is constant.

#### Change and reason for the change
In Modelica, size-expressions are described as function calls, meaning that they cannot be seen as acting on the type of the argument.  This had to be changed in order to give size-expressions constant variability for non-flexible array sizes.

### Array sizes with parameter variability
In Flat Modelica, component declarations outside functions may only specify non-flexible array sizes with `constant` variability.

**Is there a need to also restruct array constructor functions when used outside functions?**  Being built-in functions, the array constructor functions such as `fill` don't automatically play by the same rules as user functions (see below), meaning that the following would currently be allowed:
```
model FlexibleIntermediateResult
  parameter Integer n;
  Real x = sum(fill(1.0, n));
end FlexibleIntermediateResult;
```

#### Change and reason for the change
In Modelica, array sizes with parameter variability outside of functions are somehow allowed, at least not forbidden, but the semantics are not defined.
So it is easier to forbid this feature for now. If introduced in Modelica, it is still possible to introduce them here with the same semantics. It would be impossible the other way around.

### Flexible array sizes and function signatures
In Flat Modelica, an input component may be declared with a variability prefix to constrain the allowed variability of expressions given for this argument.  Inside the function the input component has the declared variability declared except that it cannot exceed discrete-time.  (It follows that it is only useful to specify the `constant` or `parameter` prefix.)

In Flat Modelica, the only component declarations that may specify a flexible array size (specified with `:`) are the inputs or protected components of a function.

Array dimensions index by `Integer` in output components of a function must be given by expressions that turn into constant expressions if all flexible array sizes in the input components are replaced by `Integer` values.

#### Change and reason for the change
In Modelica, a function output may be declared to have flexible array size, as demonstrated by the dreaded `collectPositive` example in the specification.  With the change, it is ensured that a function cannot be the origin of flexible array size, and that the function signature obtained by just considering the function input and output component declarations is sufficient to derive the result type of any function call.  The result type of a function call may contain flexible array sizes, but only when flexible array sizes are present in the types of the argument expressions.  Further, when flexible array sizes are present in the function call argument expressions, it will be possible to determine the concrete sizes of all array dimensions of the result at runtime, allowing output arrays to be allocated by the caller.

Combined with additional restrictions on the variability of sizing arguments to built-in array constructor functions such as `fill`, it can be ensured that types with flexible array sizes can only appear inside functions.