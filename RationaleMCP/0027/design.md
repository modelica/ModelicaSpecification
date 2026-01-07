## References
https://doi.org/10.3384/ecp21817 and its references.

## Detailed rules

Unit restrictions for variables
- Each scalar variable and array element may only have one unit during the simulation.
- Arrays may have heterogenous units. Notes:
  - This is for each instance of the variable, so different component instances and function calls (of the same model/function) may have different units.
  - This applies for each value of the [evaluable parameters](#evaluable-parameter).
  - The s-parametrization needed for diodes and friction requires special work-arounds in models.

General rules

- Expressions (including equations, binding equations, and start values) must be unit consistent, except for listed exceptions, and can be used to infer units.
- If a variable has a non-empty unit-attribute that is the unit of the variable. The unit-attributes should preferable be in base SI-units.
- Variables that are declared without unit-attribute (or with empty one) have unspecified unit, which may be inferred if there is a unique unit that makes the expressions unit consistent.

Detailed default rules:

- Literals without unit and zeros() are treated as empty unit except in multiplicative context (multiplication and division operators) where it has multiplicative-unit with the following rules:
  - If both operands have multiplicative-unit the result has multiplicative-unit.
  - If one operand has multiplicative-unit and the other not, the multiplicative-unit decays to unit `"1"`.
  - There's a future refinement for the literal 0 (both real and integer) and `zeros()` in arrays see [advanced arrays](#advanced-array-handling) for details.
- If a constant is declared without unit, and with a binding equation that lacks units (even after inference) the constant is treated as empty unit. (This is primarily for package constants, where we don't want to infer a unit for `pi` and use it at unrelated places; but that also applies in models.)
- An expression having empty unit will match any constraint, and inference will not give it a unit.
- The rules for operands are fairly logical, but see appendix A in https://doi.org/10.3384/ecp21817 for the details.

## Arrays

Arrays with heterogenous units are somewhat rare but needed for state-space forms etc, and for some connectors in the electrical library.

Without scalarizing arrays there are a number of options:
- Ignore units for arrays.
- Only infer units for elements, and arrays that are inferred/declared to be homogenous. (Proposed here.)
- Something more advanced. (Not proposed as it hasn't been tested.)

This simple array handling implies that unit-handling is consistent between MultiBody mechanics and Rotational/Translational mechanics.

### Advanced array handling

The advanced array handling is not included yet as part of the proposal as it is not fully clear and not test-implemented, even if models ideally should fulfill something along these lines.

It is included in this document, because there are some non-trivial issues if tools were to support this.
Based on the experience with existing models it will likely infer units for a number of variables, but find few, if any, new errors.

One considerations is whether the arrays are just arrays or have more structure.
Many (likely most) arrays are used as vectors, matrices, etc in the linear algebra sense, but not all.
E.g., Modelica.Blocks.Tables.CombiTable2Ds has a table where the first row and column effectively has different units from the rest of the table.
It seems that tools could identify whether a 2d-array is used as a matrix (or even bilinear form) based on the equations, i.e. `A*x` imply that `A` is a matrix, and `x*A*x` that it is a bilinear form.

The changes needed to support a more advanced array handling would be something like:
- Arrays built using `cat`, `[,;]` should (at least in some cases) support heterogenous inputs giving heterogenous unit-results, replacing parts of appendix A of https://doi.org/10.3384/ecp21817
- Literal 0 (both real and integer) and `zeros()` inside arrays should be treated as the empty unit, and not decay to unit `"1"` as other literals without unit.
- If something is used as a matrix its units are restricted (it must be representable as an outer product); as noted above.
- Potentially more.

The reason for the second rule can be seen from considering structured matrices in equations.
E.g., a simple state-space system without direct terms:
`[der(x);y]=[A,B;C,zeros(...)]*[x;u]`
(and correspondingly with a literal 0 if it has a single input and a single output).
In text books those zeros are often omitted, but that is not allowed in Modelica.

Basically the zeros are seen as structural zeros and one would expand it as `y=C*x` (not `y=C*x+zeros(...)*u`), imposing no unit-constraint between `u` and `y`.
In contrast for `f1+f2=0*f1` it seems natural to have unit `"1"` for the literal.
And if one writes `[der(x);y]=[A,B;C,1]*[x;u]` then `u` and `y` should be scalars (or vectors of length 1) that both have the same unit.

This also apply to the literal zeros in `diagonal()` and `skew()`, they are seen as having empty unit - not impacting the result.

## Evaluable parameter

The reason it applies for each value of the evaluable parameters is to make it sufficiently general to handle even models where evaluable parameters switch between different unit-configurations.
If the evaluable parameter has been evaluated this is fairly unproblematic.

The issue is if it has not been evaluated.
Tools should avoid having the unit-handling (except for the unit-attribute) cause evaluation of evaluable parameters.

In many cases it does not matter, e.g., an evaluable mass-parameter will have unit `"kg"` regardless of its value.

When it does matter (in particular for boolean conditions) it's a quality-of-implementation issue for tools to handle it in a good way, and possibilities include:
- Ignore those constraints. (Not good.)
- Temporarily evaluate the evaluable parameters, without impacting the translation. (This will only check the model for one set of values.)
- Treat them as conditional constraint in some advanced way. (Should check conditional constraint in https://github.com/modelica/ModelicaSpecification/pull/3491 )

## Notes

These are just rules for models, and doesn't require tools to diagnose all issues in models.

The rules are compatible with:
- The traditional unit inference in Dymola (Mattsson&Elmqvist https://modelica.org/events/conference2008/sessions/session1a2.pdf )
- Hindley-Milner for scalars (https://github.com/modelica/ModelicaSpecification/pull/3491)
- The advanced combination(s) thereof in https://doi.org/10.3384/ecp21817

They are seen as different quality-of-implementations, but we could recommend a minimum for tools.

It says:
- "default rules" to allow allow stricter or less strict variants, e.g., as described in https://github.com/modelica/ModelicaSpecification/issues/3690
- "except for the listed exceptions" to allow exceptions for specific equations etc https://github.com/modelica/ModelicaSpecification/issues/3690#issuecomment-2866443687
- "multiplicative context", but it is for both multiplication and division (the division explains why the multiplicative-unit decays to `"1"` instead of just using the other one).

Treating the empty unit-attribute as unspecified is needed, since it is the default - but it normally doesn't make sense to explicitly give `unit=""` for a variable declaration.

Specific exceptions for equations, and libraries, should preferably be added to the proposal.

The restriction that variables only having one unit could be violated in different ways in models:
- Temporaries in algorithms in functions (and even models) may be re-used to store expressions with different units.
- The s-parametrization is an example of a variable that switches e.g., from voltage to current.

For s-parametrization one solution is to divide out the unit and generate an expression with unit `"1"` and store that.