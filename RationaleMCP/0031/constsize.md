# The `constsize` expression rationale
The `constsize` expression is introduced and defined in [differences.md](differences.md#the-constsize-expression).  This document provides background that may be helpful for understanding the current design, as well as points out possible directions for future developments of `constsize` that could be useful in case it turns out that the current design doesn't solve all the problems it is faced with when applied to actual Modelica test cases.

## Leaving leading sizes flexible
This section describes a limitation of the current design, and ways in which it can be remedied in the future.

### Limitation
The current forms of `constsize` don't allow leaving some leading sizes flexible, while making other sizes constant.  It means that some full Modelica function algorithms cannot be directly converted to Flat Modelica:
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

### Remedies

To remedy this, one could also add a third form where two constant variability `Integer` arrays of equal size are given, where the first array specifies dimensions, and the second array specifies the corresponding sizes:
```
constsize(arrExp, {d1, d2, ..., dn}, {sd1, sd2, ..., sdn})
```

Alternatively, one could make `constsize` a keyword and change the grammar to also allow `:` instead of a constant `Integer` (possibly causing some confusion for human readers that don't understand why a `:` is allowed in a place that looks like a function call argument):
```
constsize(arrExp, :, s2, ..., sn)
```

For now, however, we don't expect this to be a problem for real-world examples.  Regarding the example given above, the variable `a` should probably have been declared as `Real[:, 2]` to start with, and then the matrix multiplication would be fine also in Flat Modelica.  For this reason, and knowing that there are ways that the current `constsize` expressions can be generalized in the future, we leave the design of `constsize` for now with this known limitation.

With a way to specify `:` in the `constsize` expression, one would have to define if a `:` specified for a constant dimension should turn that dimension into a flexible size, or if it should be defined as leaving the size constant.  This could be particularly useful when dealing with dimensions indexed by enumerations:
```
model EnumerationCardinality
  function f
    output Real[:, MyEnumType, :] y;
    ...
  end f;
  function h
  protected
    Real[:, MyEnumType, 3] z;
  algorithm
    /* Cumbersome way to assign the result of f() to z:
     */
    z := constsize(f(), :, size(z, 2), 3); /* OK. */
    /* Trying to just use size(z) doesn't work because size(z) has non-constant
     * variability due to the flexible size of the first dimension:
     */
    z := constsize(f(), size(z)); /* Error. */
    /* Possible interpretations of specifying a ':' size where the expression
     * type has constant size (here given by the cardinality of MyEnumType):
     * - If the resulting size is still the original constant size, this
     *   is a convenient way to avoid need to figure out cardinality.
     * - If the resulting size is flexible, it will be a type error to assign
     *   to 'z' where the size needs to be constant.
     */
    z := constsize(f(), :, :, 3); /* Convenient or error depending on design. */
  end h;
end EnumerationCardinality;
```

As long as there are no known use cases for turning a constant size into flexible using a `constsize` expression, choosing the design where a `:` doesn't turn a constant size into flexible seems attractive.  However, more experience is needed in order to determine the need for turning constant sizes into flexible.  It should be noted that turning constant into flexible is rather easy even without `constsize` inside a function; all one has to do is assign to a helper variable where the dimension in question has flexible size.

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

## Alternative syntax
Another syntax for `constsize` was also considered to make it easier to address the limitation of not being able to leave some leading sizes flexible.  Here, a `constsize` expression uses special syntax instead of taking the form of a normal function call:
```
constsize[s1, s2, ..., sn](arrExp)  /* "Square bracket form" reminding of component declaration. */
constsize(dimsExp)(arrExp)          /* dimsExp is a constant Integer array expression, such as size(...). */
```

Pros and cons leading to the current decision of going with the function call syntax instead:
- Syntax (square bracket form) is easily and naturally extended to also allow `:` sizes where the resulting size must not be constant (the use of `:` in a list of sizes given between square brackets is already established).
- Syntax (square bracket form) is easily and naturally extended to allow non-`Integer` sizes to be given as declared, rather than as the integer measuring the size of the dimension.  That is, to allow `Boolean` instead of the integer `2`.
- Not using function call syntax means grammar has to be extended (with `constsize` as Flat Modelica keyword), without added value until generalized to also allow `:`.
- The currently proposed function call syntax would also be possible to extend, see above.

Example (compare [example using current design](differences.md#the-constsize-expression)):
```
model M
  function f
    output Real[Boolean, :] y;
    ...
  end f;
  Real[Boolean, 3] b = constsize[Boolean, 3](f()); /*  */
end M;
```
