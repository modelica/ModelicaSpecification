# Modelica Change Proposal MCP-0027<br/>Units of Literal Constants
Francesco Casella, Henrik Tidefelt

**(In Development)**

## Summary
The purpose of this MCP is to allow more unit errors to be detected by giving more expressions the unit `"1"` instead of having an undefined unit.
The problem with undefined unit is that it gets in the way of carrying out checking of units (which tools tend to deal with by not checking units at all where this happens).

## Revisions
| Date | Description |
| --- | --- |
| 2022-10-04 | Henrik Tidefelt. Filling this document with initial content. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
FIXME

## Backwards Compatibility
As current Modelica doesn't clearly reject some models with non-sensical combination of units, this MCP will break backwards compatibility by turning at least some of these invalid.

## Tool Implementation
None, so far.

### Experience with Prototype
N/A

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
(None.)
