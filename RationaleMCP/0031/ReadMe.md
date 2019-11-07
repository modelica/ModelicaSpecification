# Modelica Change Proposal MCP-0031<br/>Flat Modelica and MLS modularization
Henrik Tidefelt, Peter Harman, …

**(In Development)**

## Summary
This MCP is a new attempt at introducing a specification of an intermediate format which will be called _Flat Modelica_.  There are several reasons for specifying such a format, but the driving reason this time is the need to separate Modelica front end matters (the high level constructs of the Modelica language) from back end matters (simulation semantics).  Generally speaking, the two different matters will attract attention from people with quite different interests and areas of expertise (compuer science and numerical mathematics, respectively), and a separation will facilitate more efficient work and rapid development of the two aspects of the Modelica language.  The simulation semantics could then get some well deserved attention after many years of almost no attention at all, which would be a necessary step towards true portability of models and libraries between tools.

Other important reasons for having a specification of Flat Modelica include making it easier to organize the development work of a Modelica tool, helping users understand the mysterious ways of the Modelica language by showing them the flattened models, and making it possible to compare different Modelica back ends with the same flattened model.

A working gorup with focus on the equation model and simulation semantics would also play a very important roll in future developments of new language features such as varying-structure systems, or integration with PDE solvers.

## Subtopics
Due to the large size of this MCP, it has been necessary to break it down into smaller subtopics.  Some of these may will be complicated enough to require their own discussion threads (in the form of pull requeststs to the MCP branch), while other may be resolved more easily during meetings and be implemented directly on the MCP branch.

- [ ] State main objectives for introducing Flat Modelca:
  - Use cases.
  - Relation to eFMI.
  - Long term roadmap, including great ideas for future versions of Flat Modelica.
- [x] Flat Modelica identifier naming scheme.
- [ ] Get rid of the obviously irrelevant parts of the grammar.
- [ ] Handling of parameters treated as constants.
- [ ] Restricted rules for use of `start` attribute for parameter initialization.
- [ ] Investigate need for `final`.
- [ ] Get rid of conditional components and unbalanced `if`-equations.
- [ ] Get rid of arrays with non-constant dimensions.
- [ ] Soruce locations pointing back to the original Modelica code.
- [ ] Origin of modifications (for start value prioritization).


## Revisions
| Date | Description |
| --- | --- |
| 2019-01-09 | Henrik Tidefelt. Filling this document with initial content. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

## Rationale
The requirements on what Flat Modelica should and shoudn't be are currently being developed in a [separate document](Flat-Modelica-requirements.md).

## Backwards Compatibility
It is the goal of this MCP that it should only change the way the Modelica language is described, not either adding, removing, or changing any of the Modelica language features.  Hence, it should be completely backwards compatible.

## Tool Implementation
While existing Modelica implementations should work just as well before as after incorporation of this MCP, there should still be a proof of concept implementation showing how Flat Modelica can be produced by a tool, and that the Flat Modelica output can then be used as input to a Modelica back end for simulation.  Ideally, this should be demonstrated using different tools for the two tasks.

### Experience with Prototype
(None, so far.)

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
