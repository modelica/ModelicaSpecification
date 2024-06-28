# Semantical differences between Base Modelica and Modelica
This document describes differences between Base Modelica and Modelica that aren't clear from the differences in the grammars.


## Top level structure

The top level structure (see [grammar](grammar.md#Start-rule)) of a Base Modelica description can have several top level definitions, with a mandatory `model` definition at the end.
The definitions before the `model` either define types or global constants.


## Lexical scoping and record definitions

Lookup in Base Modelica is significantly simplified compared to full Modelica due to the restricted top level structure of a Base Modelica program, but there are two more restrictions on top of that explained in this section.

Taken together, the two restrictions can be summarized concisely as follows:
- In Base Modelica, a member of a record can only be accessed through an instance of the record.
  (This can also be described in terms of lexical look-up rules.)

### No package constant access for records

Base Modelica – unlike Full Modelica — doesn't allow a record to be treated as a package for purposes of lookup just because it satisfies the package restrictions.
For example, this is illegal:
```
package 'RecordIsNotPackage'
  record 'R' "Record fulfilling the requirements of a package"
    constant Real 'c' = 1.5;
  end 'R';
  model 'RecordIsNotPackage'
    Real 'x' = 'R'.'c'; /* Error: Illegal attempt to access member 'c' inside definition of record 'R'. */
  end 'RecordIsNotPackage';
end 'RecordIsNotPackage';
```

### Inside record definitions

Inside a record definition, members of the same record are not in scope.

For example, this is illegal:
```
package 'OutOfScope'
  record 'R'
    constant Integer 'n';
    Real['n'] 'x';         /* Error: Unknown variable 'n'. */
    parameter Real 'p';
    Real 'y'(start = 'p'); /* Error: Unknown variable 'p'. */
  end 'R';
  model 'OutOfScope'
    'R' 'r'('n' = 3);
  end 'OutOfScope';
end 'OutOfScope';
```
Instead, constants may need to be evaluated and modifications moved to the model component declarations:
```
package 'OutOfScope'
  record _R1 "Automatically generated specialization of R(n = 3)"
    constant Integer 'n' = 3;
    Real[3] 'x';
    parameter Real 'p';
    Real 'y';
  end _R1;
  model 'OutOfScope'
    _R1 'r'('y'(start = 'r'.'p'));
  end 'OutOfScope';
end 'OutOfScope';
```

One of the sought effects of this restriction is that all only constant modifications can be expressed in Base Modelica type definitions, greatly simplifying reasoning about types and their representation in tools.


## Unbalanced if-equations

In Base Modelica, all branches of an `if`-equation must have the same equation size.
Absence of an else branch is equivalent to having an empty else branch with equation size 0.

An `if`-equation without `else` is useful for a conditional `assert` and similar checks.

Note: _The "equation size" count the number of equations as if the equations were expanded into scalar equations,
but does not require that the equations can be expanded in this way._

### Change and reason for the change
In Modelica this restriction only applies for `if`-equations with non-parameter conditions.
For `if`-equations with parameter condition it does not hold, and if the equation sizes
differ those parameters have to be evaluated. In practice it can be complicated to separate those cases,
and some tools attempt to evaluate the parameters even if the branches have the same equation size.

Base Modelica is designed to avoid such implicit evaluation of parameters, and thus this restriction is necessary.

In Modelica a separate issue is that `if`-equations may contain `connect` and similar primitives that cannot easily be counted; but they are gone in Base Modelica.


## Conditional components

Base Modelica does not have conditional components (see `condition-attribute` in the [grammar](grammar.md)).
All checks that apply to inactivated components in Full Modelica will need to be checked while generating Base Modelica.

The full Modelica PR https://github.com/modelica/ModelicaSpecification/pull/3129 regarding conditional connectors is expected to make this restriction easier to handle when generating Base Modelica.


## Connect equations

There are no `connect` equations in Base Modelica.

To make this possible, a new builtin function `realParameterEqual` is provided.
The two arguments to `realParameterEqual` must be `Real` parameter expressions, and the result is a `Boolean` (of variability determined from the arguments as usual).

The function returns `true` if and only if the two arguments are exactly equal up to the precision of a stored parameter value.
The non-trivial case for the function is thus when one or both of the arguments have extra bits of precision stored in registers, as illustrated by the example `ExtraPrecisionProblems` below.

For a basic example of how the function can be used, consider the following model:
```
model M
  connector C
    parameter Real p;
  end C;

  model A
    C c;
  end A;

  A a1(c.p = 1.0);
  A a2(c.p = 1.1);
equation
  connect(a1.c, a2.c);
end M;
```
In Base Modelica one needs to use the `realParameterEqual` function:
```
package 'M'
model 'M'
  parameter Real 'a1.c.p' = 1.0;
  parameter Real 'a2.c.p' = 1.0;
equation
  assert(realParameterEqual('a1.c.p', 'a2.c.p'), "Connector parameters a1.c.p and a2.c.p must be equal due to connect equation.");
end 'M';
end 'M';
```

Regarding the problem with extra bits of precision hiding in registers, consider the following model:
```
model 'M'
  parameter Real 'p' = 1.1;
  parameter Real 'q' = sin('p');
equation
  /* While 'q' has the precision of a Real stored in memory, the value of sin('p') might exist with
   * higher precision in a register.  When comparing the two, realParameterEqual must make sure that
   * the extra bits of precision does not make the assertion fail.
   */
  assert(realParameterEqual('q', sin('p')), "Incorrect implementation of realParameterEqual!");
end 'M';
```


## When-Equations

The `when`-equations in Base Modelica are more restricted compared to full Modelica.
In summary:
- `when`-equations have no meaning at all for the initialization problem:
  * No special treatment of `initial()` as a `when`-clause trigger expression.
  * No implicit initial equations in the form `x = pre(x)` for a variable `x` assigned in the `when`-equation.
- It is not allowed to have `when`-equations inside `if`-equations and `for`-equations.

Here, the _special treatment_ of `when initial() then` refers to the special meaning of such a `when`-equation in the initialization problem, including the special meaning of `reinit` when activated by `initial()`.
Hence, the first `when`-clause triggered by `initial()` in full Modelica needs to be turned into `initial equation` form in Base Modelica, with `reinit`-equations replaced by equality-equations.
This also means that in Base Modelica, the triggering condition `initial()` will have the same effect as the triggering condition `true and initial()`, namely that they will never trigger the `when`-clause because the expression never undergoes a positive edge.

The implicit initial equations `x = pre(x)` in full Modelica (in case no `when`-clause is activated with `initial()`) need to be made explicit in Base Modelica.

Regarding `when`-equations inside `if`-equations and `for`-equations, full Modelica only allows this where the `if`-equation conditions and `for`-equation ranges are parameter expressions.
Hence, it is only with a small loss of generality that it is being assumed that these conditions and ranges should be possible to evaluate during translation, allowing an `if`-equation to be reduced to one of its branches, or a `for`-equation to be unrolled.


## When-Statements

Unlike the `when`-equations, there are no restrictions on the `when`-statements in Base Modelica relative to full Modelica.

Note that `reinit` is not allowed in a `when`-statement, so the notable thing about `when`-statements in Base Modelica is that they may be triggerd by `initial()` just like in Full Modelica.

### Rationale

The reason for not further restricting the `when`-statements is that it it was considered too complicated to reduce `when initial()` in an algorithm to something more elementary.  As an example, consider the following full Modelica `when`-statement with a clause triggered by `initial()`:
```
  Real x;
  Real y;
algorithm
  x := 0.5;
  x := x + time;
  when {x^2 > 2.0, initial()} then
    y := pre(x);
  end when;
  x := x + 0.5;
```

Note that putting the following `if`-statement in the algorithm would be illegal since the argument of `pre` needs to be discrete-time:
```
  if initial() then
    'y' := pre('x'); /* 'x' is continuous-time, since no longer inside when-clause. */
  end if;
```

To get around this problem, one could try making separate variants of the algorithm depending on `initial()`:
```
  Real 'x';
  Real 'y';
initial algorithm
  'x' := 0.5;
  'x' := 'x' + time;
  'y' := pre('x'); /* 'x' is discrete-time, since inside initial algorithm. */
  'x' := 'x' + 0.5;
algorithm
  if not initial() then
    'x' := 0.5;
    'x' := 'x' + time;
    when 'x'^2 > 2.0 then
      'y' := pre('x');
    end when;
    'x' := 'x' + 0.5;
  end if;
```

However, this doesn't work either, as the initialization problem will have two algorithms assigning to `'x'` and `'y'`, even though one of the algorithm has a disabled body.


## Pure Modelica functions

In addition to full Modelica's classification into _pure_ and _impure_, Base Modelica adds the concept of a `pure constant` function, informally characterized by the following properties:
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


## Function default arguments

Base Modelica functions cannot have function default arguments.
A tool producing Base Modelica from full Modelica can accommodate this by automatically generating a helper function for every present subset of arguments used in the model.
(The helpers can be omitted if the defaults are literal or otherwise independent of the other inputs, since those values can be added in each call. 
No helper function needs to be created for argument combinations that aren't used in the model, which means that the potential combinatorial explosion of possible argument combinations is avoided.)

For example, consider this full Modelica model:
```
model M
  function f
    input Real a;
    input Real b = a + 1;
    input Real c = 2 * b;
    output Real y = a + b + c;
  end f;

  Real x = f(0.5, c = time);
end M;
```
Here, there is only one call to the function `f` making use of argument defaults.
Hence, out of the three possible combinations of absent arguments (not counting all arguments being present, as this will correspond to the base variant of `f` in Base Modelica), only one needs a helper function in Base Modelica:
```
package 'M'
  function 'M.f'
    input Real 'a';
    input Real 'b';
    input Real 'c';
    output Real 'y' = 'a' + 'b' + 'c';
  end 'M.f';

  function '-M.f:1,3' "Automatically generated helper for passing only the first and third arguments to 'M.f'"
    input Real 'a';
    input Real 'c';
    Real 'b' = 'a' + 1;
    output Real 'y' = 'M.f'('a', 'b', 'c');
  end '-M.f:1,3';

  model 'M'
    Real 'x' = '-M.f:1,3'(0.5, time);
  end 'M';
end 'M';
```

Note the name chosen for the automatically generated helper, `'-M.f:1,3'`.
Due to the leading hyphen, it belongs to the part of the variable namespace that is available for automatically generated names, meaning that there is no risk of collision with names coming from the original full Modelica source.

A Base Modelica function may still have declaration equations on its inputs, but unlike full Modelica, these are ignored.
They are only allowed for the sake of consistency with how deeper value modifiers on functions inputs are handled, see [record construction](#record-construction).
```
function 'f'
  input Real 'a';
  input Real 'b' = 'a' + 1; /* No default; declaration equation is ignored in Base Modelica. */
  input Real 'c' = 2 * 'b'; /* No default; declaration equation is ignored in Base Modelica. */
  output Real 'y' = 'a' + 'b' + 'c'; /* Declaration equations are useful for outputs and local variables. */
end 'f';
```


## Records

### Record construction

Unlike full Modelica, there are no implicitly defined record constructor functions in Base Modelica.
A tool producing Base Modelica from full Modelica can accommodate this by automatically generating helper functions as needed.
The default arguments of the full Modelica record constructor can be handled just like default arguments of other functions, see [above](#function-default-arguments).
In addition to the helper functions for handling default argumnets, tools producing Base Modelica from full Modelica can also create a base function for record construction based on values for all record members.

For example, consider this full Modelica model:
```
model M
  record R
    Real a;
    Real b = 1;
    Real c = a + 1;
  end R;

  R r = R(3);
end M;
```
To convert this to Base Modelica, a tool can automatically create two functions:
```
package 'M'
  record 'M.R'
    Real 'a';
    Real 'b';
    Real 'c';
  end 'M.R';

  function '-M.R' "Automatically generated constructor for 'M.R'"
    input Real 'a';
    input Real 'b';
    input Real 'c';
    output 'M.R' _result('a' = 'a', 'b' = 'b', 'c' = 'c');
  end '-M.R';

  function '-M.R:1' "Automatically generated helper for passing only the first argument to '-M.R'"
    input Real 'a';
    Real 'b' = 1;
    Real 'c' = 'a' + 1;
    output 'M.R' _result = '-M.R'('a', 'b', 'c');
  end '-M.R:1';

  model 'M'
    'M.R' 'r' = '-M.R:1'(3);
  end 'M';
end 'M';
```

### Record member value modifications

Even though Base Modelica doesn't come with implicitly defined record constructor functions — that in full Modelica are derived based on value modifications in the record type definition – it is still allowed to have value modifications for the members of a record type in Base Modelica.
Note that the top level structure of a Base Modelica model ensures that the value modifications that are part of record types can only contain constant values (possibly obtained by evaluation of constant expressions).
As usual, such value modifications can be overridden when declaring a component of the record type, and when made in a model component declaration, it is possible to also have non-constant expressions in the modifications.
The only semantics of value modifications in record types is that they will be used as the basis for the effective modifications of a component declaration, but the semantics of value modifications in a component declaration are different depending on the kind of component declaration (function/record/model component declaration).

#### Record component declarations

Value modifications on a record component declaration are simply stored as part of the record type being defined.
All modifications must be given by constant expressions, allowing them to be evaluated.

For example:
```
record 'R'
  Real 'x' = 1; /* Constant value is stored as part of the type 'R'. */
end 'R';

record 'S'
  'R' 'r1';          /* Keeps modification from component type. */
  'R' 'r2'('x' = 2); /* Overrides modification from component type. */
end 'S';
```

Note that in the example above, a tool's internal representation of the record type 'S' does not need to remember the origin of the modifications; it is sufficient to just remember that the modification of `'r1'.'x'` is `1`, and that the modification of `'r2'.'x'` is `2`.

#### Model component declarations

A value modification in a model component declaration is equivalent to having a normal equation for the record member.

Example (omitting the `package` wrapper for brevity):
```
record 'R'
  Real 'x';
  Real 'y' = 1;
end 'R';

function 'makeR'
  output 'R' 'r'('x' = 2);
end 'makeR'

model 'M'
  'R' 'r1';
  'R' 'r2';
  'R' 'r3' = 'makeR'(); /* OK: Declaration equation removes all modifications. */
equation
  'r1'.'x' = 2; /* OK, making 'r1' fully determined. */
  'r2' = 'makeR'(); /* Error: 'r2'.'y' becomes overdetermined. */
end 'M'
```

#### Function input component declarations

All value modifications of a function input component declaration are ignored.

For example, this is valid:
```
record 'R'
  Real x;
end 'R';

function 'foo'
  input 'R' 'u'('x' = 10); /* Value modification is ignored. */
  output Real 'y' = 'u'.'x'; /* Completely determined by record passed to function. */
end 'foo';
```

It follows that record types containing value modifications are usable in function input component declarations, but that the value modifications do not make any difference here.

Note the analogy between the example above and the following:
```
pure function 'makeR10' "Pure constant function returning value of type 'R'"
  output 'R' 'r'('x' = 10);
end 'makeR10';

function 'foo'
  input 'R' 'u' = 'makeR10'(); /* Not a default; declaration equation is ignored. */
  output Real 'y' = 'u'.'x'; /* Completely determined by record passed to function. */
end 'foo';
```

#### Function output and local component declarations

For output and local (that is, neither input nor output) function component declarations the value modifications are used for initial assignments, and are then ignored during the remaining part of the function call evaluation.

For example:
```
record 'R'
  Real 'x';
  Real 'y';
end 'R';

function 'f'
  output 'R' 'result'('y' = 5); /* Assigning initial value to 'result'.'y'. */
algorithm
  'result'.'x' = 6;
end 'f';
```

For the purpose of analyzing uninitialized use of variables in functions, a record variable is considered assigned when all it's members have been assigned.
(A record-valued assignment to the entire variable is a special case of this, with all record members being assigned at once.)
It follows that a function output (of record type) can be completely determined using only modifications in the component declaration.

Note that one consequence of the initial assignment semantics is that this is valid:
```
record 'R'
  Real 'x' = 1;
end 'R';

function 'f'
  output 'R' 'result'; /* Hidden initial assignment to 'result'.'x', making 'result' fully assigned. */
end 'f';
```


## Variability of expressions

### Constant expressions
In Base Modelica, a _constant expression_ is more restricted than in full Modelica, by adding the following requirement:
- Functions called in a constant expression must be `pure constant`.

By requiring functions called in a constant expression to be `pure constant`, it is ensured that a constant expression can always be evaluated to a value at translation time.  A function call that is not a constant expression must not be evaluated before simulation starts.

### Parameter expressions

In Base Modelica, a _parameter expression_ is more restricted than in full Modelica, by adding the following requirement:
- Functions called in a parameter expression must be pure.

As a consequence, the full Modelica syntactic sugar of using an impure function in the binding equation of a parameter is not allowed in Base Modelica.  Such initialization has to be expressed explicitly using an initial equation.  Hence, the rules of variability hold without exception also in the case of components declared as parameter.

### Reason for change
By excluding `external` functions, translation time evaluation of constant expressions is greatly simplified.  By excluding `impure` functions and `pure(…)` expressions, it is ensured that it doesn't matter whether evaluation happens at translation time or at simulation (initialization) time.

Forbidding translation time evaluation of function calls in non-constant expressions generalizes the current Modelica rule for `impure` functions and makes it clear that this is not allowed regardless whether this is seen as an optimization or not.  (The current Modelica specification only has a non-normative paragraph saying that performing optimizations is not allowd.)

The change regarding parameter expressions could be extended to discrete-time expressions as well without loss of expressiveness due to the existing restrictions on where an impure function may be called.  This could also be expressed more generally by saying that a function call expression where the callee is impure is a non-discrete-time expression.  However, it was decided to not include this in the formal description of differences between Modelica and Base Modelica in order to avoid describing changes that only clarify things without actually making a difference to semantics.

The shifts in variability of function calls could be summarized as _the variability of a function call expression is the highest variability among the argument expressions and the variability of the called function itself_, where the _variability of a function_ is defined by the following table:

| Function classification | Function variability |
| --- | --- |
| pure constant | constant |
| pure, otherwise | parameter |
| impure | continuous-time |

Seen this way, the rules about which functions may be called in the body of a function definition ends up being another case of variability enforcement.

This covers what one can currently express in full Modelica.  In the future, one might also introduce _pure discrete_ functions that don't have side effects, but that must be re-evaluated at events, even if the arguments are constant.


## Variability specification inside types

In a record definition it is possible to have variability prefixes (`parameter` or `constant`) on the record member component declarations.  This results in a type containing variability specification, referred to as a _variability-constrained type_.  Unless clear from context, types that are not variability-constrained should be referred to as _variability-free types_.

Variability-constrained types may only be used in the following restrictive ways:
- Definition of new types (that will also be variability-constrained).
- Model component declaration.
- A (sub-) expression of variability-constrained type (such as a reference to a model component declared with such type) may only be used in one of the following ways:
  - Component references.  That is, accessing a member of a record, application of array subscripts, and combinations thereof.  Note that the resulting expression might again be of variability-constrained type, in which case these restrictions must also be met recursively.
  - Passing as argument to a function.  It is possible for a variability-constrained record member to be received by a record member without variability constraint, and structural subtyping also allows the receiving record type to not have members corresponding to the variability-constrained members of the passed record.
  - Alone on one side of an equation in solved form, or as left hand side of an assignment statement.  In this case a variability-constrained record member (at any depth) that does not have a corresponding record member on the other side of the equation (right side of assignment) is not considered part of the equation or assignment.

The restrictions above should be considered preliminary, as we have yet to find out in more details how these restrictions can be met in real world applications.

It is expected that the restrictions on variability-constrained types will sometime require a type to exist in both a variability-constrained and variability-free variant.  It remains to find out whether the most useful variability-free variants are such that the variability-constrained members of records have been removed, or such that just the variability-constraints have been removed.

The last of the ways that an expression of variability-constrained type may be used – that is, in a solved equation or assignment – is an extension of full Modelica that is provided to mitigate potential problems caused by needing to have two Base Modelica variants of the same full Modelica type.

A [separate document](variability-constrained-types.md) gives examples of how variability-constrained types may arise in Base Modelica, and how their constraints can be handled.


## Array size

### Array types
In Base Modelica, array size is part of an array type.  Each dimension has a size that is either _constant_ or _flexible_.  A constant size is one that is an `Integer` number (of constant variability).  It follows that array dimensions index by `Boolean` or enumeration types have constant size (TODO: figure out correct terminology).  A flexible size is an `Integer` of non-constant variability, that is, it corresponds to an array dimension indexed by `Integer` and where the upper bound is a number unknown to the type system.

When determining expression types, every array dimension must be unambiguously typed as either constant or flexible.  Where there are constraints on array sizes, for instance when adding two arrays, a flexible array size is only compatible with another flexible array size.  It is a runtime error if the two flexible array sizes are found to be incompatible at runtime (a tool can optimize runtime checks away if it can prove that the sizes will be compatible).

In an array equation, the array type must have constant sizes.  On the other hand, a flexible size on the left hand size of an array assignment does not impose any size constraint on the right hand size, and is allowed.

When determining the type of a function call, the sizes of output array variables are determined based on the input expressions and the function's declarations of input and output components.  An output array size is constant (for the function call at hand) if it can be determined based on the types of input expressions and the constant variability values of input expressions.  When an array size cannot be determined based on this information (including the trivial case of a function output component declared with `:` size), the size is flexible.

Example:
```
function 'f'
  input Integer 'n';
  input Real[:] 'x';
  output Real['n' + size('x', 1)] 'y';
  Real[:] 'a';
algorithm
  'a' := {0.5}; /* OK: Constant size can be assigned to flexible size. */
  ...
end 'f';

model 'M'
  parameter Integer 'p' = 2;
  constant Integer 'c' = 3;
  Real[2] 'a' = fill(1.0, 'p'); /* Error: expression has flexible size. */
  Real[5] 'b' = f('c', 'a'); /* OK. */
end 'M';
```

#### Change and reason for the change
This draws a clear line between the constant and flexible array sizes.  This is important for portability (lack of clear separation opens up for different interpretations, where what is considered valid code in one tool is considered a type error in another).  The clear separation also means that flexible array size becomes an isolated Base Modelica language feature that can be easily defined as an unsupported feature in eFMI.

To only consider a flexible size compatible with another flexible size is a restriction that may be removed in the future, allowing different forms of inference on the array sizes.  For now, however, such inference is not considered necessary for a first version of Base Modelica, and defining such inference would also involve too much work at this stage of Base Modelica development.

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
In Base Modelica, component declarations outside functions may only specify constant array sizes.

#### Change and reason for the change
In Modelica, array sizes with parameter variability outside of functions are somehow allowed, at least not forbidden, but the semantics are not defined.
So it is easier to forbid this feature for now. If introduced in Modelica, it is still possible to introduce them here with the same semantics. It would be impossible the other way around.


## Subscripting of general expressions

In Base Modelica it is possible to have a subscript on any (parenthesized) expression.
The reason for this generalization is that some manipulations, in particular inlining of function calls, can lead to such
expressions and without the slight generalization we could not generate Base Modelica for them. It does not add any real complication
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
The Base Modelica for `M` should only preserve input for `r`, `a`, `c.x` and output for `c.y`, `z`,
and thus not preserve it for protected variables and for variables in `msub`.


## Simplify modifications

Base Modelica has different rules for modifications applied to:
- Model component declarations
- Types (records and short class declarations) and functions (function component declarations)

### Common restrictions

Some restrictions compared to full Modelica apply to both modifications in types and in model component declarations:
- Base Modelica does not allow hierarchical names in modifiers, meaning that all modifiers must use the nested form with just a single identifier at each level.
- At each level, all identifiers must be unique, so that conflicting modifications are trivially detected.

### Restrictions for model component declarations

A _model component declaration_ is a component declaration belonging to the single `model` of a Base Modelica source.

Aside from the common restrictions, there are no other restrictions on the modifications in model component declarations.

### Restrictions for types and functions

Named types can be introduced in two different ways in Base modelica, where both make use of modifications:
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

The third and last category of component declarations (beside model component declarations and record component declarations), _function component declarations_, has the same restrictions as record component declarations, see below.  This includes both public and local function component declarations.  For example:
```
function 'fun'
  input Real 'u'(min = 0); /* Public function component declaration. */
  output Real 'y'(min = 0); /* Public function component declaration. */
  Real 'x'(min = 0); /* Local function component declaration. */
  …
end 'fun';
```

The following restrictions apply to modifications in types and functions, making types and function signatures in Base Modelica easier to represent and reason about compared to full Modelica:
- Attribute modifiers must have constant variability.
- Value modifiers in types can only have constant variability due to Base Modelica scoping rules.
- Value modifiers in functions can make use of non-constant components in the same function definition, but with simplified semantics compared to full Modelica.
- Attribute modifiers must be scalar, giving all elements of an array the same element type.  Details of how the scalar modifier is applied to all elements of an array is described [below](#Single-array-element-type).  For example, an array in a type cannot have individual element types with different `unit` attributes.

The modifications that are not allowed in types must be applied to the model component declarations instead.  For attributes such as `start`, `fixed` and `stateSelect`, this will often be the case.

The reason for placing the same restrictions on local function component declarations as on public function component declarations is that the handling of types inside functions gets significantly simplified without much loss of generality.  To see the kind of loss of generlity, one needs to consider that many attributes have no use in functions at all: `start`, `fixed`, `nominal`, `unbounded`, `stateSelect`, and `displayUnit`.  This leaves two groups of attributes with minor loss of generality:
- The strings `unit` and `quantity` can be used to enable more static checking of units and quantities in the function body.  Since such checks are performed during static analysis, the constant variability requirement should hold in general, not just inside functions.  Regarding the other requirement, it is hard to come up with realistic examples where `unit` and `quantity` would not be equal for all elements of an array.
- Outside functions, `min` and `max` both provide information that may be useful for symbolic manipulations and define conditions that shall be monitored at runtime.  While the symbolic manipulations benefit greatly from constant variability of the limits, the runtime checking is more easily applicable to other variabilities, and different limits for different array elements is not as inconceivable as having different units.  Inside functions, on the other hand, limits on local variables is not going to provide important information for symbolic manipulations, since function body evaluation does not involve equation solving.  If one would like to have non-constant limits, or limits that are different for different elements of an array, this is possible to express using `assert` statements instead of `min` and `max` attributes.

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
  /* Do not use 'each' at all in Base Modelica types. */
  'P' 'p'[2](start = 4, fixed = false);
end 'LineB';
```

If the `LineA` variant ends up being valid in full Modelica, then this is the form that will also be used for Base Modelica.  Otherwise, Base Modelica will use the `LineB` form.

### Final modification

The concept of being final in full Modelica implies two different things:
- Further modification is not possible.  This can be verified in the reduction from full Modelica to Base Modelica, and there is no real need to express this constraint also in the Base Modelica model.  (It could be useful for expressing constraints for hand-written Base Modelica, but it is a language feature we could add later if requested.)
- Parameter values and `start` attributes cannot be modified after translation.  This is something that can't just be verified during the reduction from full Modelica to Base Modelica.  Instead, final parameter declaration equations are turned into initial equations, and then the same technique is used to handle final modification of `start`.  Details of this are given the sections below on initialization of parameters and time-varying variables.


## Initialization of parameters

In Base Modelica, a parameter's declaration equation shall be solved with respect to the parameter, allowing the right hand side to be overridden during initialization (that is, after translation).  This is similar to a full Modelica non-final parameter with `fixed = true`.

For example, the full Modelica
```
parameter Real p(fixed = true) = 4.2;
```
translates to the Base Modelica
```
parameter Real 'p' = 4.2; /* Presence of declaration equation corresponds to full Modelica fixed = true. */
```

In Base Modelica, a parameter without declaration equation shall be solvable from equations given in the `initial equation` section.  This corresponds directly to the full Modelica parameters with `fixed = false`.

For example, the full Modelica
```
  parameter Real p(fixed = false);
initial equation
  p^2 + p = 1;
```
translates to the Base Modelica
```
  parameter Real 'p'; /* Full Modelica parameter with fixed = false. */
initial equation
  'p'^2 + 'p' = 1;
```

The same mechanism is also able to represent a full Modelica final declaration equation.

For example, the full Modelica
```
  final parameter Real p = 4.2;
```
translates to the Base Modelica
```
  parameter Real 'p'; /* Full Modelica final parameter has no declaration equation in Base Modelica. */
initial equation
  'p' = 4.2; /* From full Modelica final declaration equation. */
```

The handling of guess values needed to solve parameters from nonlinear equations is the same as for time-varying variables, and is described in the next section.


## Attributes `start`, `fixed`, and final modification of `start`

### Background for start-values in Modelica

The handling of start-values in Modelica is complicated by several aspects:
- The interaction between start and fixed.
- The priorities for non-fixed start-values.
- Whether start-values can be modified or not afterwards. This is related to final start-values.
This information is hidden and not easy to understand, and is not even easy to modify in Modelica.
As a simplifying assumption we could assume that only literal start-values can be modified afterwards (but not that all literal start-values can be modified).

Base Modelica cannot simply preserve the priorities, since they are based on where a modification occurs - and that information is gone.
Removing the complexity of priorities would require that start-values have been prioritized before generating Base Modelica, which requires that index-reduction and state-selection is performed earlier, which is contrary to the goal.
Replacing start-values by initial equations would require that prioritization has been done, and also prevent experimenting with novel ideas for initialization; see "Investigating Steady State Initialization for Modelica models" by Olsson & Henningsson (Modelica 2021 conference).
Treating fixed and non-fixed variables differently doesn't work if we want to preserve arrays, since different array elements may have different values for `fixed`.

To consider different start-values consider the following Modelica model:
```
model A
  model B
    model M
      Real x(start = 1.0);
      Real y;
      Real z;
    equation 
      y = 5 * x;
      z = 7 * x;
      x + y + z = sin(time + x + y + z);
    end M;
    M m1;
    M m2(z(start = 2.0));
    M m3(y(start = 3.0));
  end B;
  B b(m2(y(start = 4.0)))
end A;
```
Variable | Start-value | Priority in Modelica
--------|--------------|------
`b.m1.x` | 1.0 | 3
`b.m1.y` | |
`b.m1.z` | |
||
`b.m2.x` | 1.0 | 3
`b.m2.y` | 4.0 | 1
`b.m2.z` | 2.0 | 2
||
`b.m3.x` | 1.0 | 3
`b.m3.y` | 3.0 | 2
`b.m3.z` | |

In this case it is recommended to use `b.m1.x`, `b.m2.y`, and `b.m3.y` as iteration variables in the non-linear equations.

For initialization these start-values can also be used for selecting additional start-values while also considering fixed-attributes.

#### Heterongenous arrays with fixed
The `fixed` attribute can vary between array elements in Modelica.

A non-contrived example is:
```
block SimpleFilter
  parameter Real k = 2;
  Real x[3](each start = 0.0, fixed = {false, true, true});
  output Real y(start = 1.0, fixed = true) = k * x[1];
  input Real u;
equation
  der(x) = cat(1, x[2 : end], {u});
end SimpleFilter;
```
In this case the first state is not fixed, instead the output is fixed (in some cases the output may be in another sub-model).

#### Start-value for parameters
For parameters the start-value is normally irrelevant and not specified.
If the parameter lacks a value modification the `start` attribute can be used as parameter-value after a warning, this can be done before generating Base Modelica (if `fixed = true`).

The real problem is if the parameter has `fixed = false` and no value (but possibly a start-value).

As an example:
```
model SteadyStateInit
  parameter Real p(start = 2, fixed = false);
  Real x(start = 10, fixed = true);
initial equation
  der(x) = 0;
equation
  der(x) = 10 - p * x;
end SteadyStateInit;
```
In more a complicated situation, this could be the length of a mechnical arm that must be adjusted based on initial configuration.

### Implicitly declared guess value parameter

Instead of controlling the guess values for the variable `x` via its `start` attribute as in full Modelica, Base Modelica makes use of an implicitly declared parameter `guess('x')`.  This is called the _guess value parameter_ for `'x'`, and has the same type as `x`.

The syntax makes use of the new keyword `guess` which is not present in full Modelica.
(Note that introducing a new keyword will not cause conflict with identifiers used in full Modelica code thanks to name mangling.)
The _component-reference_ argument to `guess` in the grammar is restricted to not contain any _array-subscripts_.

Since the declaration of `guess('x')` is implicit, a declaration equation cannot be provided in the same was as for a declared parameter.  Instead, a special form of _parameter equation_ is used, where the parameter being solved must appear on the left hand side, and the equation shall be solved with causality so that the right hand side can be overridden during initialization (that is, after translation).  In the grammar, it is an new alternative in _generic-element_:

> _generic-element_ → ~~_import-clause_ | _extends-clause_ |~~ _normal-element_ | _parameter-equation_

> _parameter-equation_ → **parameter** **equation** _guess-value_ **=** _expression_ _comment_

> _guess-value_ → **guess** `[(]` _component-reference_ `[)]`

(One can consider more general use of parameter equations in the future, but for now they are only used for guess value parameters.)

For example:
```
Real 'x';
parameter equation guess('x') = 1.5;
Real 'y'; /* Parameter equation above does not leave public section. */
```

Similar to `pre('x')`, `guess('x')` acts as an independent variable in the initialization problem, and instead of providing a parameter equation, it can be determiend by an initial equation.  Since an initial equation cannot be modified after translation, this form is useful when the full Modelica modification of `start` was final.

For example:
```
  Real 'x';
initial equation
  guess('x') - 1.5 = 0;
```

When a guess value for `'x'` is needed to solve an equation (or system of equations), this equation has an implicit dependency on `guess('x')`, and it is an error if `guess('x')` cannot be determined first.  For example, this is illegal:
```
model 'IllegalGuessDependency'
  Real 'x';
initial equation
  guess('x') = 0.5 * 'x'; /* Cannot determine guess('x') before solving for 'x'. */
equation
  'x' * 'x' = time * time; /* Initialization depends on guess('x'). */
model 'IllegalGuessDependency'
```

While a guess value parameter is allowed to appear in equations in the same ways as a normal parameter, Base Modelica models originating from full Modelica are only expected to have `guess('x')` appearing in an initial equation in solved form, if appearing at all:
```
  Real 'x';
initial equation
  guess('x') = 1.5;
```

Default parameter equations for guess value parameters shall be added as needed to obtain a balanced initialization problem.  For example:
```
  Real 'x';
initial equation
  'x'^2 + 'x' = 1; /* Needs guess value for 'x' */
```
should be conceptually extended to:
```
  Real 'x';
  parameter equation guess('x') = 0.0; /* Default guess value. */
initial equation
  'x'^2 + 'x' = 1; /* Needs guess value for 'x' */
```

The need for a default equation can also come from direct use of `guess('x')`:
```
  Real 'x';
initial equation
  'x' = guess('x');
```

With the use of guess value parameters, the `SteadyStateInit` full Modelica example above can be turned into Base Modelica:
```
model 'SteadyStateInit'
  parameter Real 'p';
  parameter equation guess('p') = 2;
  Real 'x';
  parameter equation guess('x') = 10;
initial equation
  der('x') = 0;
  'x' = guess('x');
equation
  der('x') = 10 - 'p' * 'x';
end 'SteadyStateInit';
```

#### Arrays and records

For arrays, full Modelica modification of `start` with `each` will be described below.  Here is a simple example without `each`:
```
  Real[3] 'x';
  parameter equation guess('x') = fill(1.5, 3);
  Real[3] 'y';
  Real[2] 'z';
initial equation
  guess('y') = fill(1.5, 3);
  guess('z'[1]) = 1.5;
  guess('z'[2]) = 1.5;
```

Records are similar to arrays:
```
  record 'R'
    Real 'a';
    Real 'b';
  end 'R';
  'R' 'x';
  parameter equation guess('x') = R(1.1, 1.2);
  'R' 'y';
  'R' 'z';
initial equation
  guess('y') = R(1.1, 1.2);
  guess('z'.'a') = 1.1;
  guess('z'.'b') = 1.2;
```

Combining arrays and records:
```
  record 'R'
    Real[3] 'a';
    Real 'b';
  end 'R';
  'R'[2] 'x';
  parameter equation guess('x') = fill(R(fill(1.5, 3), 1.2), ,2);
  'R'[2] 'y';
  'R'[2] 'z';
initial equation
  /* Some of the many ways to give equations for all guess values: */
  guess('y') = fill(R(fill(1.5, 3), 1.2), 2);
  guess('z'.'a') = fill(1.5, 2, 3);
  guess('z'[1].'b') = 1.2;
  guess('z'[2].'b') = 1.2;
```

#### Implementation notes

Unlike normal parameters, the value of `guess('x')` is not considered part of a simulation result, allowing tools to strip all unused guess value parameters from the initialization problem.

### Final modification of `start`

Consider the full Modelica:
```
  Real x(final start = 1.0);
```

In Base Modelica, the fact that the modification of `start` is final means that the guess value parameter shall be determined by an initial equation rather than a parameter equation:
```
  Real 'x';
initial equation
  guess('x') = 1.0; /* From final modification of start in full Modelica. */
```

As another example, consider a final non-fixed parameter in full Modelica:
```
  final parameter Real p(fixed = false, start = 1.0); /* All modifications are final. */
initial equation
  p * p = 2;
```
Base Modelica:
```
  parameter Real 'p';
initial equation
  'p' * 'p' = 2;
  guess('p') = 1.0; /* From final modification of start in full Modelica. */
```

### Modification of `start` with `each`

When modifying arrays of `start` attributes in full Modelica, one can take advantage of `each` to avoid the need to use `fill` to create an array of suitable size with equal elements.  As shown in the examples above, using `fill` can actually work as a replacement for `each` when it comes to setting guess value parameters, and the design proposed in this section may not add enough value compared to added complexity of the design.

Consider the following full Modelica model:
```
  record R
    Real[3] a;
    Real b;
  end R;
  R[2] x(a(each start = 1.5), b(each start = 1.2));
  R[2] y(each a(start = {1.5, 1.6, 1.7}), each b(start = 1.2));
```

In Base Modelica, the parameter equation syntax can be extended to allow `each` in a similar way:
```
  parameter equation each guess('x'.'a') = 1.5;
  parameter equation each guess('x'.'b') = 1.2;
  parameter equation each guess('y'.'a') = {1.5, 1.6, 1.7};
  parameter equation each guess('y'.'b') = 1.2;
```

Just like for normal modifications, the `each` is actually redundant and could be removed from the design; the array dimensions of the right hand side must match the trailing array dimensions of the component reference on the left hand side, and the `each` is required just to make it more obvious that the right hand side value will be used to fill an array of values.  (To make an actually meaninful use of `each` one needs the expressive power of selecting which array dimensions to fill, and this can be added in a backwards compatible way to future versions of Base Modelica, by allowing `each` at different positions inside the component reference of `guess`.)

Finally, consider a full Modelica model with final modifications of `start`:
```
  final R[2] x(a(each start = 1.5), b(each start = 1.2));
  final R[2] y(each a(start = {1.5, 1.6, 1.7}), each b(start = 1.2));
```
Here, the general equation syntax could be extended similar to the parameter equations:
```
initial equation
  each guess('x'.'a') = 1.5;
  each guess('x'.'b') = 1.2;
  each guess('y'.'a') = {1.5, 1.6, 1.7};
  each guess('y'.'b') = 1.2;
```

Here, the `each` is associated with the equation's entire left hand side, and for clarity at the cost of symmetry, it should only be allowed for the left hand side of an equation.  As for modification with `each`, the array dimensions of the right hand side must match the trailing array dimensions of the left hand side, and the `each` corresponds to a `fill` on the right hand side, adding the missing dimensions needed to match the left hand side.

Again: The two new uses of `each` (in parameter equations and in normal equations) add non-essential complexity to the first version of Base Modelica, and might make more sense to add in future versions.  At the same time, the proposed use of `each` in normal equations have applications beyond guess value parameters, in particular when a full Modelica model has a final modification with `each` for an array of parameter values.

### The `fixed` attribute

The `fixed` attribute has been completely removed in Base Modelica.  This was described above for parameters, and is described here for time-varying variables.

When the full Modelica variable has `fixed = true`, this is represented explicitly with an initial equation in Base Modelica.  Having `fixed = false` in full Modelica doesn't turn into anything in Base Modelica.

For example, the full Modelica
```
  Real x(fixed = true, start = 1.0);
```
is translated to the Base Modelica
```
  Real 'x';
  parameter equation guess('x') = 1.0; /* From non-final modification of start in full Modelica. */
initial equation
  'x' = guess('x'); /* From fixed = true in full Modelica. */
```

Just like in Full Modelica, such equations shall also be added as needed to obtain a balanced initialization problem.  For example,
```
  Real 'x';
  parameter equation guess('x') = 1.0;
```
may be conceptually extended to:
```
  Real 'x';
  parameter equation guess('x') = 1.0;
initial equation
  'x' = guess('x'); /* Default initial equation for 'x'. */
```

This can happen in combination with default parameter equations for guess values.  For example,
```
  Real 'x';
```
may be conceptually extended to:
```
  Real 'x';
  parameter equation guess('x') = 0.0; /* Default guess value. */
initial equation
  'x' = guess('x'); /* Default initial equation for 'x'. */
```

Note that omitting the guess value parameter would not give the same result:
```
  Real 'x';
initial equation
  'x' = 0.0; /* Wrong: No way to override after translation. */
```

#### Arrays with `each` modification of `fixed`

Nothing special is needed when a full Modelica array has a homogeneous modificaiton of `fixed` using `each`.  The modification `each fixed = false` doesn't turn into anything in Base Modelica, while `each fixed = true` turns into an array equation.

For example, the full Modelica
```
  Real[3] x(each fixed = true, start = {1.1, 1.2, 1.3});
```
is translated to the Base Modelica
```
  Real[3] 'x';
  parameter equation guess('x') = {1.1, 1.2, 1.3}; /* From non-final modification of start in full Modelica. */
initial equation
  'x' = guess('x'); /* Array equation from each fixed = true in full Modelica. */
```

#### Arrays with heterogeneous modification of `fixed`

Nothing special is needed to handle arrays with heterogeneous modification of `fixed`.  For example, the full Modelica
```
Real[3] x(each start = 1.0, fixed = {true, false, true});
```
is translated to the Base Modelica
```
  Real[3] 'x';
  parameter equation guess('x') = fill(1.0, 3);
initial equation
  'x'[1] = guess('x'[1]);
  'x'[3] = guess('x')[3]; /* One can also apply guess to the entire 'x'. */
```

### Guess value prioritization

In full Modelica, there is a priority associated with the effective modifier for a variable's `start` attribute.  Details of how the priority is determined are outside the scope of Base Modelica specification, but Base Modelica needs a way to directly express a variable's guess value priority as a number (computed based on the full Modelica definition of priority).

The basic Base Modelica way of expressing a variable's guess value priority take the form of a special kind of initial equation:
```
initial equation
  prioritize('x', 2); /* The guess value priority of 'x' is 2. */
```

The _component-reference_ argument to `prioritize` in the grammar is restricted to not contain any _array-subscripts_.
The second argument of `prioritize` – denoted _priority_ in the grammar – shall be an `Integer` constant.
Lower value means higher priority; that is, when making a choice based on priority, the variable with lower _priority_ value should be given precedence.

Specification of priority is only allowed for components whose guess value parameter is explicitly present in the model.  Example:
```
  Real 'x';
  parameter equation guess('x') = 1.1;
  Real 'y';
  Real 'z';
initial equation
  guess('y') = 1.2;
  prioritize('x', 1); /* OK: Mentioned in guess value parameter equation. */
  prioritize('y', 2); /* OK: Mentioned in initial equation. */
  prioritize('z', 3); /* Error: Guess value is not explicitly mentioned anywhere. */
```

Array variables are no exception:
```
  Real[3] 'x';
  parameter equation guess('x') = {1.1, 1.2, 1.3};
initial equation
  prioritize('x', 2);
```

Multiple specification is an error.  For example:
```
  Real 'x';
  parameter equation guess('x') = 1.1;
initial equation
  prioritize('x', 100);
  prioritize('x', 100); /* Not allowed, even though it is consistent with earlier specification. */
```

Since records themselves don't have `start` in full Modelica, the guess value parameter and prioritization mechanism gets applied to the members of the record:
```
  'R' 'r'; /* 'R' is a record type. */
  parameter equation guess('r'.'x') = 1.1;
initial equation
  prioritize('r'.'x', 100);
```

#### Syntactic sugar: Prioritized guess value parameter equations

A syntactic sugar is provided for guess value parameter equations:
```
  parameter equation guess('x') = prioritize(0.5, 2);
```
This is defined to mean the same as:
```
  parameter equation guess('x') = 0.5;
initial equation
  prioritize('x', 2)
```
That is, in the syntactic sugar form, `prioritize` is used with different arguments compared to its basic form in an initial equation.
In the syntactic sugar form, `prioritize` is wrapped around the right hand side of the parameter equation, and the variable to which the priority belongs is given by the left hand side, extracted from the `guess` wrapper.
Note that the _component-reference_ restriction for the first argument of `prioritize` is only applicable within _prioritize-equation_, not within the syntactic sugar form _prioritize-expression_.

### The `nominal` attribute

TODO: If we proceed with the design where `start` is no longer a type attribute, we should probably deal with `nominal` similarly, so that we get rid of all non-constant type attributes (`nominal` currently has parameter variability, but there are also applications where a time-varying `nominal` would be useful).

### Syntactic sugars

For convenience and recognition among full Modelica users, a model component declaration may include modifications of `fixed` and `start` as syntactic sugar.  Note that this does not make `fixed` and `start` actual attributes in Base Modelica; the syntactic sugar is only piggy-backing on the syntax for modification of attributes.

Setting `fixed = true` on the continuous-time variable `'x'` is syntactic sugar for having:
```
initial equation
  'x' = guess('x');
```

For a discrete-time variable, `fixed = true` is syntactic sugar for having:
```
initial equation
  pre('x') = guess('x');
```


For `start`,
```
Real 'x'(start = startExpr);
```
is syntactic sugar for
```
Real 'x';
parameter equation guess('x') = startExpr; /* Non-final modification of start in full Modelica. */
```

Note that it is not possible to use the syntactic sugar for a final modification of `start` in full Modelica, as this shall not be turned into a parameter equation for the guess value.


## Protected

Base Modelica does not distinguish between protected and public sections of a class definition.
For functions, this means that all component declarations with prefix `input` or `output` are considered part of the functions public interface, while all other component declarations are considered local to the implementation of the function.
Accordingly, a function component declaration which is neither input nor output is called a _local component declaration_ or _local variable_ in Base Modelica.

The new annotation `protected = true` provides a standardized way to indicate that a component declaration in Base Modelica comes from a protected section in the full Modelica model.
See [`protected` annotation](annotations.md#protected).


## Clock partitions

The implicit clock partitioning carried out by tools for full Modelica is made explicit in Base Modelica.
The equations solved in a clocked sub-partition are placed in a dedicated `subpartition` construct, and the variables being determined by the sub-partition can be determined by a simple inspection of the equations, as explained below.
See _base-partition_ and related rules in the [grammar](grammar.md#clock-partitions) for details on the syntax.

Note that the component declarations for variables solved in a sub-partition are not syntactically placed inside the `subpartition` construct because of the way that the sub-clocks and base-clocks cut across the instance hierarchy.

In Base Modelica, every clock is declared as a component with a name, at the top of some `partition`.
Sometimes, this name will correspond to the name of a clock in full Modelica, sometimes it will be an automatically generated name.
Tools may find it useful to include the clock components in a simulation result, but doing so is not required and there is no standard for what to store.

Instead of the binary clocked `sample` operator in full Modelica, Base Modelica has an unary `sample(…)` operator.
It is only allowed inside the equations and algorithms of a `subpartition`, and the semantics is that the argument expression is sampled at the clock ticks of the current sub-partition.

A Base Modelica model with clock partitioning can look like this:
```
package 'M'
model 'M'
  Real 'x';
  Real 'baseVar', 'cVar1', 'cVar2', 'cVar3';
  Real 'mixedVar1';

/* Equations and algorithms before the start of the first base-partition belong to the continuous-time partition. */
equation
  der('x') = 1;

partition /* Beginning of base-partition */
  Clock 'myClock' = Clock(1); /* Clock name originating from full Modelica model. */
  Clock _subClock0 = subSample('myClock', 2); /* Automatically generated clock name. */
  Clock _subClock1 = superSample(subSample('myClock', 2), 8);

  subpartition (clock = 'myClock') /* Beginning of sub-partition within base-partition. */
  equation
    'baseVar' = sample('x');

  subpartition (clock = _subClock0, solverMethod = "ImplicitEuler")
  equation
    der('cVar1') = noClock('baseVar');

  subpartition (clock = _subClock1)
  equation
    'cVar2' = noClock('baseVar');
    'cVar3' = noClock('cVar1');
  algorithm
    'mixedVar1' := 'cVar2' + 'cVar3';

partition
  Clock _baseClock0 = Clock(1.1);
  ...
  /* Base-partition ends at the start of another base-partition, or at the end of the model. */

end 'M';
end 'M';
```

A `partition` begins with the definition of all clocks belonging to the base-partition and its sub-partitions.
A clock is only accessible within the `partition` where it is declared, and may only be used to define other clocks and to specify the `clock` of a `subpartition`.

A sub-partition begins with the `subpartition` keyword, followed by a specification of some sub-partition details in the form of the named argument syntax.
The following are the only valid named arguments:
- `clock` `=` _clock-name_
- `solverMethod` `=` _method-name_

Here, _clock-name_ must be the name of a `Clock` declared within the current `partition`, and _method-name_ must be a constant `String` expression.
`clock` is required for every `subpartition`.
`solverMethod` is only required when the sub-partition contains continuous-time equations, and specifies the time discretization method.
It is an error if a named argument is specified multiple times.

In the equations and algorithms of a `subpartition`, references to variables from the continuous-time partition must appear inside the Base Modelica unary `sample(…)` operator.
Similarly, references to variables from another sub-partition must appear inside the `noClock(…)` or `previous(…)` operators.
It is not allowed to reference variables determined in another clocked base-partition, except when wrapped in `hold()`.
(The expression `hold(x)` is a continuous-time expression and needs to be sampled before it can appear in a clocked partition.)
Hence, the variables determined by a `subpartition` are found as all component references appearing in the `subpartition`'s equations and algorithms, except:
- Parameters and constants.
- Variables inside `noClock(…)`, `sample(…)`, or `previous(…)`.

The `noClock(…)` may only be used to refer to variables determined by an earlier `subpartition` of the same `partition`.
This means that there cannot be cyclic dependencies between the sub-partitions, and that evaluation of a `partition` at a clock tick can always be performed by executing the `subpartitions` in order of appearance.
Note that `noClock(…)` in may sometimes be wrapped around a variable in Base Modelica where there was no wrapping in the original full Modelica model.

Note that if we want to extend Base Modelica to be used as sub-components this implies that we have to decide whether to clock the component or not; that is similar to the need for external sampling in eFMI.
