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
| 2026-01-07 | Hans Olsson, improved - based on feedback |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
The basic rationale for using units is to reduce the risk of errors.

For the specific rules the rationale is that treating literals as having unit `"1"` in multiplicative contexts will catch many simple errors, without requriring excessive changes.
Thus e.g., `SI.Temperature T=293.15` and `SI.Enthalphy h=Medium.h_pT(1e5, 298.15)` are allowed.
In order to handle connectors in a good way, `zeros(n)` is treated the same as literals, allowing `a.f+b.f=zeros(3);` and `a.f=f0*zeros(3);`, but `a.f=T0*zeros(3);` (when `a.f` is a force and `T0` a temperature) is detected as an error.

The rationale for only giving the rules for variables instead of providing a specific implementation is to make the expectation clear for library authors.
And at the same time allow tool vendors to implement the rules to varying degrees (there is sufficient experience with the prototypes to ensure that it will work).

The rationale for considering implementing the rules to varying degrees, and even considering rules beyond the proposed ones is to ensure that they are consistent.
That means that rules are designed such that a model unit-consistent with the most restrictive rules will also be unit-consistent with less restrictive rules with a consistent subset of inferred units.

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

## Details

[Design details](design.md)


