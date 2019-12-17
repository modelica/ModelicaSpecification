# Modelica Change Proposal MCP-0034<br/>Ternary
Henrik Tidefelt

**(In Development)**

## Summary
It was concluded in https://github.com/modelica/ModelicaSpecification/issues/2211 that an MCP for _Ternary_ (3-valued logic) in Modelica should be created, and here it is.

The proposal is based on the following principles:
- A new built-in type, `Ternary`.
- A new literal constant `unknown` for the third truth value.
- Explicit as well as implicit conversion from `Boolean`.
- No implicit conversion to `Boolean`.
- No new built-in functions.

See [design](ternary.md) for details.

## Revisions
| Date | Description |
| --- | --- |
| 2019-11-22 | Henrik Tidefelt. Filling this document with initial content. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
See [separate document](rationale.md).

## Backwards Compatibility
The introduction of the keyword `unknown` introduces a backwards incompatibility with code making use of that name for identifiers.

## Tool Implementation
In progress.

### Experience with Prototype
None yet.

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
