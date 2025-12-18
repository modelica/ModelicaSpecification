# Modelica Change Proposal MCP-0027<br/>Units of Literal Constants
Francesco Casella, Henrik Tidefelt, Hans Olsson

**(In Development)**

## Summary
The purpose of this MCP is to allow more unit errors to be detected by giving more expressions the unit `"1"` instead of having an undefined unit.
The problem with undefined unit is that it gets in the way of carrying out checking of units (which tools tend to deal with by not checking units at all where this happens).

## Revisions
| Date | Description |
| --- | --- |
| 2022-10-04 | Henrik Tidefelt. Filling this document with initial content. |
| 2025-12-18 | Hans Olsson, simple proposal https://github.com/modelica/ModelicaSpecification/issues/2127#issuecomment-349162852 |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
The basic rationale for using units is to reduce the risk of errors.

For the specific rules the rationale is that treating literals as having unit `"1"` in multiplicative contexts will catch many simple errors, without requriring excessive changes.
Thus e.g., `SI.Temperature T=293.15` and `SI.Enthalphy h=Medium.h_pT(1e5, 298.15)` are allowed.
In order to handle connectors in a good way, `zeros(n)` is treated the same as literals, allowing `a.f+b.f=zeros(3);` and `a.f=f0*zeros(3);`, but `a.f=T0*zeros(3);` (when `a.f` is a force and `T0` a temperature) is detected as an error.

The rationale for only giving the rules for variables instead of providing a specific implementation is to make the expectation clear for library authors.
And at the same time allow tool vendors to implement the rules to varying degrees (there is sufficient experience with the prototypes to ensure that it will work).

Many libraries, including the Modelica Standard Library already largely follow this rule.

## Backwards Compatibility
As current Modelica doesn't clearly reject some models with non-sensical combination of units, this MCP will break backwards compatibility by turning at least some of these invalid.

It is thus necessary to have the possibility to disable the rules for specific libraries (and specific equations in other libraries) to ease the adoption.

## Tool Implementation
For scalars implemented in some version of Wolfram System Modeler (to be given).
Almost fully implemented on a flag in Dymola 2026x, and 3D Experience platform.

### Experience with Prototype
Generally it correctly finds some issues in libraries, but some libraries have systematic issues.
E.g., the buildings library uses a large number of multiplicative literals without unit for converting between different time and power units. 

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
https://doi.org/10.3384/ecp21817 and its references.

## Detailed rules

Unit restrictions for variables
- Each scalar variable and array element may only have one unit during the simulation.
- Arrays may have heterogenous units. Notes:
  - This is for each instance of the variable, so different component instances and function calls (of the same model/function) may have different units.
  - This applies after evaluating evaluable parameters.
  - The s-parametrization needed for diodes and friction requires special work-arounds in models.

General rules

- Expressions (including equations, binding equations, and start values) must be unit consistent, except for listed exceptions, and can be used to infer units.
- If a variable has a non-empty unit-attribute that is the unit of the variable. The unit-attributes should preferable be in base SI-units.
- Variables that are declared without (non-empty) unit-attribute have unspecified unit, which may be inferred if there is a unique unit that makes the expressions unit consistent.

Detailed default rules:

- Literals without unit and zeros() are treated as empty unit except in multiplicative context (multiplication and division operators) where it has multiplicative-unit with the following rules:
  - If both operands have multiplicative-unit the result has multiplicative-unit.
  - If one operand has multiplicative-unit and the other not, the multiplicative-unit decays to unit `"1"`.
- If a constant is declared without unit, and with a binding equation that lacks units (even after inference) the constant is treated as empty unit. (This is primarily for package constants, where we don't want to infer a unit for `pi` and use it at unrelated places; but that also applies in models.)
- An expression having empty unit will match any constraint, and inference will not give it a unit.
- The rules for operands are fairly logical, but see appendix A in https://doi.org/10.3384/ecp21817 for the details.

## Notes

These are just rules for models, and doesn't require tools to diagnose all issues in models.

Arrays with heterogenous units are somewhat rare but needed for state-space forms etc, and for some connectors in the electrical library.

The rules are compatible with:
- The traditional unit inference in Dymola (Mattsson&Elmqvist https://modelica.org/events/conference2008/sessions/session1a2.pdf )
- Hindley-Milner for scalars (https://github.com/modelica/ModelicaSpecification/pull/3491)
- The advanced combination(s) thereof in https://doi.org/10.3384/ecp21817

They are seen as different quality-of-implementations, but we could recommend a minimum for tools.

It says:
- "default rules" to allow allow stricter or less strict variants, e.g., as described in https://github.com/modelica/ModelicaSpecification/issues/3690
- "except for the listed exceptions" to allow exceptions for specific equations etc https://github.com/modelica/ModelicaSpecification/issues/3690#issuecomment-2866443687
- "multiplicative context", but it is for both multiplication and division (the division explains why the multiplicative-unit decays to `"1"` instead of just using the other one).

Treating the empty unit-attribute as unspecified is needed, since it is the default - but it normally doesn't make sense to explicitly give it for a variable declaration.

Specific exceptions for equations, and libraries, should preferably be added to the proposal.

The restriction that variables only having one unit could be violated in different ways in models:
- Temporaries in algorithms in functions (and even models) may be re-used to store expressions with different units.
- The s-parametrization is an example of a variable that switches e.g., from voltage to current.

For s-parametrization one solution is to divide out the unit and generate an expression with unit `"1"` and store that.

