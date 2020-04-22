# Modelica Change Proposal MCP-0031<br/>Flat Modelica and MLS modularization
Peter Harman, Werther Kai, Gerd Kurzbach, Oliver Lenord, Hans Olsson, Michael Schellenberger, Martin Sjölund, Henrik Tidefelt

**(In Development)**

## Summary
This MCP is a new attempt at introducing a specification of an intermediate format which will be called _Flat Modelica_.

### In a sentence (or two)
Flat Modelica is a language to describe hybrid (continuous and discrete) systems with emphasis on defining the dynamic behavior.  It is an integral part of the Modelica specification, not a new separate standard.

### Use cases
Use cases to have in mind in the design of Flat Modelica, also indicating the usefullness of the Flat Modelica endeavor:
* Serve as intermediate stage in the Modelica specification, separating front end matters (the high level constructs of the Modelica language) from back end matters (simulation semantics).
  - Generally speaking, the two different matters will attract attention from people with quite different interests and areas of expertise (compuer science and numerical mathematics, respectively).
  - Separation will facilitate more efficient work and rapid development of the two aspects of the Modelica language.
  - Simulation semantics could then get some well deserved attention after many years of almost no attention at all, which would be a necessary step towards true portability of models and libraries between tools.
  - Making it easier to organize the development work of a Modelica tool.
  - A working gorup with focus on the equation model and simulation semantics would also play a very important roll in future developments of new language features such as varying-structure systems, or integration with PDE solvers.
* Basis for the _Equation Code_ of eFMI, [see below](#Relation-to-eFMI).
* Help users understand the mysterious ways of the Modelica language by showing them the flattened models.
* Comparison of different Modelica back ends with the same flattened model.
* Plant model descriptions for use in control design.
* Equation analysis for fault detection and isolation.
* Integration with third party tools for equation analysis.  _(Could we be more specific about what this migh be?)_
* Platform for academic research on dynamic systems.  For example, numeric methods.
* Target language for new high level modeling languages.

### Relation to eFMI
One of the key use cases driving the development of Flat Modelica is its use as basis for the _Equation Code_ of [eFMI](https://itea3.org/index.php/project/emphysis.html).  The requirements for eFMI are much smaller in terms of language features compared to the needs for serving as intermediate representation in the Modelica standard.  To accommodate both use cases, the Equation Code of eFMI will be defined as a restricted variant of Flat Modelica.

### Requirements
From the use cases above, some implicit requirements follow:
* Simple enough to be attractive for applications that essentially just want a simple description of variables and equations, meaning that many of the complicated high level constructs of Modelica are removed.
* Expressive enough to allow the high level constructs of Modelica to be reduced to Flat Modelica without loss of semantics.
* When Flat Modelica serves as an intermediate representation of the translation of a higher level language (such as Modelica), errors detected in Flat Modelica code shall be traceable to the original code.
* Human readable and writeable, since not all use cases assume Flat Modelica being produced from a higher level language by a tool.

## Roadmap
Due to the large size of this MCP, it has been necessary to break it down into smaller subtopics.  Some of these may will be complicated enough to require their own discussion threads (in the form of pull requeststs to the MCP branch), while other may be resolved more easily during meetings and be implemented directly on the MCP branch.

### Flat Modelica 0.1 (this MCP)
These are subtopics that are considered necessary to resolve for a first version of Flat Modelica.  By keeping this list short, increase chances of ever getting to the release of a first version.
- [x] Flat Modelica identifier naming scheme.
- [x] Principles for use of language constructs vs annotations.  [Design](annotations.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2459)
- [x] Get rid of the obviously irrelevant parts of the grammar.  [Design](grammar.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2465)
- [x] Get rid of `connect` equations.
- [x] Get rid of conditional components.
- [x] Settle the top level structure. [Design](grammar.md#start-rule), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2469)
- [x] List of supported built-in operators and functions [Design](functions.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2513)
- [x] Get rid of unbalanced `if`-equations. [Design](differences.md#unbalanced-if-equations)
- [x] Restrict constant expressions for translation time evaluation. [Design](differences.md#constant-expressions), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2473)
- [x] Handle array dimensions with parameter variability. [Design](differences.md#array-size), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2471)
- [ ] Decide on just one way to specify array dimensions. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bdimension-declaration/RationaleMCP/0031/grammar.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2468)
- [ ] Define allowed forms of type aliases. (related to #2468)
- [ ] Allowing array subscripting on general expressions. [Design in progress](https://github.com/modelica/ModelicaSpecification/pull/2540/commits/b5eab9d5edcab8766a79637292be6a1e68b2bacc#diff-069d28cf3b6b78debdcada80b99b6c0b), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2540)
- [ ] Handling of parameters treated as constants.
- [ ] Investigate need for `final`.
- [ ] Origin of modifications (for start value prioritization).
- [ ] Get rid of `false` as default for `fixed`.
- [ ] Restricted rules for use of `start` attribute for parameter initialization.
- [ ] Simplify modifications.
- [ ] Handling of `each`.
- [ ] Investigate need for `for`-equations.
- [ ] Marking of top level inputs and outputs.
- [ ] Get rid of higher order functions.
- [ ] Figure out what to do with synchronous features.
- [ ] Source locations pointing back to the original Modelica code.
- [ ] Settle the name (currently _Flat Modelica_), considering that scalarization isn't mandatory.
- [ ] Event handling semantics is preserved as in Modelica.

### Flat Modelica 0.1+…1.0 (future MCPs)
In future minor versions of Flat Modelica 1, we could improve the language by incorporating smaller improvements that were not considered necessary for version 1.0.
- [ ] Primitive operations for triggering of events, to which the current event generating functions can be reduced.
- [ ] Get rid of function calls with named arguments.
- [ ] Get rid of function argument defaults.
- [ ] Get rid of record constructors.
- [ ] Allow to identify connector variables.
- [ ] Handle equations and algorithms derived from arrays of components efficiently.

### Flat Modelica 2.0 (future MCPs)
Big changes that don't make sense to even consider for a minor release of version 1 are listed here.  Being listed here shall not be interpreted as even being likely to ever happen; this is just a collection of all the ideas that don't fit in the more realistic roadmap for version 1.
- [ ] Allowing some simple form of `model` that makes it possible to preserve structure of the equations that will allow more efficient symbolic processing and production of executables of much smaller size.

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
