Modelica Change Proposal MCP-0031 
Flat Modelica and MLS modularization
Henrik Tidefelt, ...
(In Development) 
--

# Summary
This MCP is a new attempt at introducing a specification of an intermediate format which will be called _Flat Modelica_.  There are several reasons for specifying such a format, but the driving reason this time is the need to separate Modelica front end matters (the high level constructs of the Modelica language) from back end matters (the execution model for the hybrid differential-algebraic equations).  Generally speaking, the two different matters will attract attention from people with quite different interests and areas of expertise, and a separation will facilitate more efficient work and rapid development of the two aspects of the Modelica language.  The back end matters could then get some well deserved attention after many years of almost no attention at all.

Other important reasons for having a specification of Flat Modelica include making it easier to organize the development work of a Modelica tool, helping users understand the mysterious ways of the Modelica language by showing them the flattened models, and making it possible to compare different Modelica back ends with the same flattened model.

# Revisions
| Date | Description |
| --- | --- |
| 2019-01-09 | Henrik Tidefelt. Filling this document with initial content. |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
The requirements on what Flat Modelica should and shoudn't be are currently being developed in a [separate document](Flat-Modelica-requirements.md).

# Backwards Compatibility
It is the goal of this MCP that it should only change the way the Modelica language is described, not either adding, removing, or changing any of the Modelica language features.  Hence, it should be completely backwards compatible.

# Tool Implementation
While existing Modelica implementations should work just as well before as after incorporation of this MCP, there should still be a proof of concept implementation showing how Flat Modelica can be produced by a tool, and that the Flat Modelica output can then be used as input to a Modelica back end for simulation.  Ideally, this should be demonstrated using different tools for the two tasks.

## Experience with Prototype
(None, so far.)

# Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

# References
