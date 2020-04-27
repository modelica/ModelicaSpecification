# Type aliases

This document presents some alternative designs for the allowed use of type aliases in Flat Modelica.  Ones the different alternatives are properly described together with their advantages and disadvantages, it will be possible to make an informed decision of which design to choose.


## Design alternatives for scalars

In #2468, we ended up discussing type aliases for scalar variables, and finally agreed to proceed with the alternative _Type aliases with default attributes_, where the following would be legal use of type aliases:

```
type Length = Real(quantity = "Length", unit = "m", displayUnit = "m");
Length x(min = 0, start = 1);
type BigLength = Length(nominal = 1e6);
```

That is, built-in types such as `Real` have default behavior (not all of which that can currently be expressed with values) for all built-in attributes.  A type alias can modify any subset of attributes.  The semantics of each type alias definition is simply to modify zero or more of the attributes of an existing scalar type.

The other design alternatives can be found in the #2468 discussions.


## Design alternatives for records

Consider making variants of this type:

```
record Interval
  Real low;
  Real high;
end Interval;
```

### No type aliases for records

Without type aliases for records, all type abstraction that requires modification of an existing type needs to use a record with dummy member:

```
record PositiveInterval
  Interval member(low(min = 0.0), high(min = 0.0));
end PositiveInterval;
```

### Record type aliases with attribute modifications

With attribute modifications allowed in a record type alias, one would do this:

```
record PositiveInterval = Interval(low(min = 0.0), high(min = 0.0));
```

Syntactically, `min` could have been the name of a normal record member being bound to 0.0, but this interpretation is forbidden in this design alternative.

One could consider restricting the depth of the modifications, but as seen here, a depth of 2 is needed to be of any use at all.  It is not clear what would be gained by retricting the depth to 2 given that some degree of nesting is required anyway.

### Record type aliases with modifications and bindings

With bindings allowed in record type aliases, one could even do this:

```
record IntervalFromZero = Interval(low = 0.0, high(min = 0.0));
```

If record type aliases were to be allowed in some form, the above would also make sense as long as the equivalent would be allowed in a long record definition.  This is still something we haven't discussed.


## Design alternatives for arrays

### No type aliases for arrays

Avoids potential problems with array type aliases, but forces users that still want the abstraction to introduce record with dummy member:

```
record Point3D "Workaround for lack of array type aliases"
  Length[3] member; /* More likely to be called something short, like 'x'. */
end Point3D;

record PositiveCone3D
  Length[3] member(each min = 0.0);
end PositiveCone3D;

record PositiveCone3DPair_A
  Length[2, 3] member(each min = 0.0, each max = {10.0, 11.0, 12.0}, each start = {5.0, 5.5, 6.0});
end PositiveCone3DPair_A;

record PositiveCone3D_Bounded "Bounded PositiveCone3D with different upper bounds"
  PositiveCone3D member(member(max = {10.0, 11.0, 12.0}, start = {5.0, 5.5, 6.0})); /* Note appearance of 'member' from PositiveCone3D. */
end PositiveCone3D_Bounded;

record PositiveCone3DPair_B
  PositiveCone3D_Bounded member[2];
end PositiveCone3DPair_B;

record PositiveCone3DPair_C
  PositiveCone3D member[2](each member(max = {10.0, 11.0, 12.0}, start = {5.0, 5.5, 6.0})); /* Note appearance of 'member' from PositiveCone3D. */
end PositiveCone3DPair_C;
```

### Array type aliases with implicit `each` on all modifications

Allow array dimensions to be added in a type alias, but don't allow the alias to introduce differences between array entries by taking all modifications as having an implicit `each`:

```
type Point3D = Length[3];

type PositiveCone3D = Length[3](min = 0.0);

type PositiveCone3DPair_A = Length[2, 3](min = 0.0, max = 10.0, start = 5.0);
```

It gets more complicated with nested array types:

```
type PositiveCone3DPair_B = PositiveCone3D[2](max = 10.0, start = 5.0); /* Allowed? */

type PositiveCone3DPair_C = PositiveCone3D[2](max = {10.0, 11.0, 12.0}, start = {5.0, 5.5, 6.0}); /* Allowed? */
```

If those are not allowed, one would be forced to use an intermediate record with dummy member as workaround:

```
record PositiveCone3D_Bounded "Bounded PositiveCone3D with different upper bounds"
  PositiveCone3D member(max = {10.0, 11.0, 12.0}, start = {5.0, 5.5, 6.0});
end PositiveCone3D_Bounded;

type PositiveCone3DPair_D = PositiveCone3D_Bounded[2];
```

The exact syntax for specifying the array dimensions is the topic of #2468, but unfortunately some of the early discussion has been lost due to rebasing the PR branch.  To summarize, the syntax used above has a non-intuitive effect when array dimensions are nested:

```
model ModelicaAppendDimensions
  type Arr = Real[3, 4];
  Arr[1, 2] x = fill(0.0, 1, 2, 3, 4); /* Note: (Real[k, l])[m, n] is *not* the same as Real[k, l, m, n]. */
end ModelicaAppendDimensions;
```

A remedy to this would be to place array dimensions before the element type:

```
model PrependDimensions
  type Arr = [3, 4] Real;
  [1, 2] Arr x = fill(0.0, 1, 2, 3, 4); /* Note: [k, l]([m, n]Real) is the same as [k, l, m, n]Real. */
end PrependDimensions;
```

With the dimensions prepended, the modifications would also appear more naturally as applied to the element type:
```
type PositiveCone3D = [3] Length(min = 0.0);
```

## Conclusions

(None yet.)
