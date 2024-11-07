# Modelica Change Proposal MCP-0031<br/>Base Modelica and MLS modularization
Peter Harman, Werther Kai, Gerd Kurzbach, Oliver Lenord, Hans Olsson, Michael Schellenberger, Martin Sjölund, Henrik Tidefelt

**(In Development)**

## Summary
This MCP is a new attempt at introducing a specification of an intermediate format which will be called _Base Modelica_.

### In a sentence (or two)
Base Modelica is a language to describe hybrid (continuous and discrete) systems with emphasis on defining the dynamic behavior.
It is an integral part of the Modelica specification, not a new separate standard.
We say that a Modelica model is _lowered_ when transforming it into Base Modelica.

### Use cases
Use cases to have in mind in the design of Base Modelica, also indicating the usefullness of the Base Modelica endeavor:
* Serve as intermediate stage in the Modelica specification, separating front end matters (the high level constructs of the Modelica language) from back end matters (simulation semantics).
  - Generally speaking, the two different matters will attract attention from people with quite different interests and areas of expertise (compuer science and numerical mathematics, respectively).
  - Separation will facilitate more efficient work and rapid development of the two aspects of the Modelica language.
  - Simulation semantics could then get some well deserved attention, which would be a necessary step towards true portability of models and libraries between tools.
  - Making it easier to organize the development work of a Modelica tool.
  - A working group with focus on the equation model and simulation semantics would also play a very important roll in future developments of new language features such as varying-structure systems, or integration with PDE solvers.
* Basis for the _Equation Code_ of eFMI, [see below](#Relation-to-eFMI).
* Help users understand the mysterious ways of the Modelica language by showing them the lowered models.
* Comparison of different Modelica back ends with the same lowered model.
* Plant model descriptions for use in control design.
* Equation analysis for fault detection and isolation.
* Integration with third party tools for equation analysis.  _(Could we be more specific about what this migh be?)_
* Platform for academic research on dynamic systems.  For example, numeric methods.
* Target language for new high level modeling languages.
* IP protection when combined with obfuscation.

### Relation to eFMI
One of the key use cases driving the development of Base Modelica is its use as basis for the _Equation Code_ of [eFMI](https://itea3.org/index.php/project/emphysis.html).  The requirements for eFMI are much smaller in terms of language features compared to the needs for serving as intermediate representation in the Modelica standard.  To accommodate both use cases, the Equation Code of eFMI will be defined as a restricted variant of Base Modelica.

### Requirements
From the use cases above, some implicit requirements follow:
* Simple enough to be attractive for applications that essentially just want a simple description of variables and equations, meaning that many of the complicated high level constructs of Modelica are removed.
* Expressive enough to allow the high level constructs of Modelica to be reduced to Base Modelica without loss of semantics.
* When Base Modelica serves as an intermediate representation of the translation of a higher level language (such as Modelica), errors detected in Base Modelica code shall be traceable to the original code.
* Human readable and writeable, since not all use cases assume Base Modelica being produced from a higher level language by a tool.

## Roadmap
Due to the large size of this MCP, it has been necessary to break it down into smaller subtopics.  Some of these may will be complicated enough to require their own discussion threads (in the form of pull requeststs to the MCP branch), while other may be resolved more easily during meetings and be implemented directly on the MCP branch.

### Base Modelica 0.1 (this MCP)
These are subtopics that are considered necessary to resolve for a first version of Base Modelica.  By keeping this list short, increase chances of ever getting to the release of a first version.
- [x] Base Modelica identifier naming scheme.
- [x] Principles for use of language constructs vs annotations.  [Design](annotations.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2459)
- [x] Get rid of the obviously irrelevant parts of the grammar.  [Design](grammar.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2465)
- [x] Get rid of `connect` equations.
- [x] Get rid of conditional components.  (The _condition-attribute_ is still present in grammar.) [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bconditional-component/RationaleMCP/0031/differences.md#conditional-components), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3149)
- [x] Settle the top level structure. [Design](grammar.md#start-rule), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2469)
- [x] List of supported built-in operators and functions. [Design](functions.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2513)
- [x] Get rid of unbalanced `if`-equations. [Design](differences.md#unbalanced-if-equations)
- [x] Restrict constant expressions for translation time evaluation. [Design](differences.md#constant-expressions), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2473)
- [x] Handle array dimensions with parameter variability. [Design](differences.md#array-size), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2471)
- [x] Decide on just one way to specify array dimensions. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bdimension-declaration/RationaleMCP/0031/grammar.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2468)
- [x] Define allowed forms of type aliases (related to _one way to specify array dimensions_). [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Btype-aliases/RationaleMCP/0031/type-aliases.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2555)
- [x] Allowing array subscripting on general expressions. [Design in progress](https://github.com/modelica/ModelicaSpecification/pull/2540/commits/b5eab9d5edcab8766a79637292be6a1e68b2bacc#diff-069d28cf3b6b78debdcada80b99b6c0b), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2540)
- [x] Get rid of `protected`. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031-protected/RationaleMCP/0031/grammar.md#b22-class-definition), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3162)
- [x] Investigate need for `final`. [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2994)
- [x] Origin of modifications (for start value prioritization). [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bstart-value-prioritization/RationaleMCP/0031/differences.md#guess-value-prioritization), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2997)
- [x] Get rid of `false` as default for `fixed`. [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2996)
- [x] Restricted rules for use of `start` attribute for parameter initialization. [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2995)
- [x] Get rid of record member variability prefixes `constant` and `parameter`. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Brecord-member-variability/RationaleMCP/0031/differences.md#variability-in-record-member-declaration), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2694) (Not gone, but restricted.)
- [x] Simplify modifications. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2BModifications/RationaleMCP/0031/differences.md#simplify-modifications), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2558) (Remaining parts covered by other items.)
- [x] Simplify value modifications. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bvalue-modification/RationaleMCP/0031/differences.md#Value-modification), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2747)
- [x] Simplify record construction and function default arguments. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Brecord-construction/RationaleMCP/0031/differences.md#function-default-arguments), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3038)
- [x] Express final modification. [Design in progress](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bfinal-modification/RationaleMCP/0031/differences.md#Final-modification), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/2748)
- [x] Make constants available to types. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Btop-level-structure/RationaleMCP/0031/grammar.md#Start-rule), [PR (closed?!)](https://github.com/modelica/ModelicaSpecification/pull/2746)
- [x] Get rid of `each`. [PR](https://github.com/modelica/ModelicaSpecification/pull/2583)
- [x] Investigate need for `for`-equations. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031-for-equations/RationaleMCP/0031/grammar.md#b26-equations), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3163)
- [x] Marking of top level inputs and outputs. [Design](differences.md#Input-output)
- [x] Add function `realParameterEqual` for use in automatically generated asserts on `Real` equality. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Breal-equality/RationaleMCP/0031/differences.md#connect-equations), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3175)
- [x] Figure out what to do with synchronous features. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bsynchronous/RationaleMCP/0031/differences.md#clock-partitions), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3240)
- [x] Event handling semantics is preserved as in Modelica.
- [x] Get rid of `when initial()` and `when`-equations inside `if` and `for`. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bsimplify-when/RationaleMCP/0031/differences.md#when-equations), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3258)
- [x] Source locations pointing back to the original Modelica code. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bsource-locations/RationaleMCP/0031/source-locations.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3295)
- [x] Settle the name (originally _Flat Modelica_), considering that scalarization isn't mandatory. [Design](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031%2Bname-of-the-game/RationaleMCP/0031/name-of-the-game.md), [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3224)
- [ ] Reject or add support for non-constant `nominal`-attribute.
- [x] Remove byte order mark, as it is already deprecated in full Modelica. [PR with discussion](https://github.com/modelica/ModelicaSpecification/pull/3528)
- [ ] Base Modelica package shall have no dependencies on other loaded classes.
- [ ] Management of resources and Modelica URIs.

### Base Modelica 0.1+…1.0 (future MCPs)
In future minor versions of Base Modelica 1, we could improve the language by incorporating smaller improvements that were not considered necessary for version 1.0.
- [ ] Handling of parameters treated as constants. [Previous discussion](https://github.com/modelica/ModelicaSpecification/pull/3161)
- [ ] Primitive operations for triggering of events, to which the current event generating functions can be reduced.
- [ ] Get rid of function calls with named arguments.
- [ ] Get rid of function argument defaults.
- [ ] Get rid of higher order functions.
- [ ] Get rid of record constructors.
- [ ] Allow to identify connector variables.
- [ ] Handle equations and algorithms derived from arrays of components efficiently.
- [ ] Reintroduce `each` for efficiency and to avoid code duplication.
- [ ] Figure out what to do with Connectors and FMI3.0 Terminals.

### Base Modelica 2.0 (future MCPs)
Big changes that don't make sense to even consider for a minor release of version 1 are listed here.  Being listed here shall not be interpreted as even being likely to ever happen; this is just a collection of all the ideas that don't fit in the more realistic roadmap for version 1.
- [ ] Allowing some simple form of `model` that makes it possible to preserve structure of the equations that will allow more efficient symbolic processing and production of executables of much smaller size.

## Prototype Development and Testing
### Deliverables
- [ ] Feature list
- [ ] Example models from MSL mapped against feature list
- [ ] Library of open source unit test models matching the feature list
- [ ] Flat Modelica v0.1: md documents ready for prototype development
- [ ] Flat Modelica v0.2: md documents ready for preliminary feedback of the language group
- [ ] Flat Modelica v0.3: Feedback of the language group addressed in md documents
- [ ] MCP0031 RC: Modelica specification changes  defined in the LaTeX sources based on Flat Modelica v1.0
- [ ] MCP0031 RC+: Ready for evaluation including the feedback of three reviews
- [ ] MCP0031 v1: Evaluated and formally accepted by the language group
### Plan of action
Iteratively extend the scope to be covered following these steps:
* Select the next non-working example ("lowest hanging fruit") from MSL, or hand craft one as needed.
* Enhance export of Flat Modelica code (functionality provided by at least one tool).
* Enhance import of Flat Modelica code (functionality provided by all tools).
* Map example model to roadmap items.
* Identify newly covered language features derived from roadmap items.
* Create unit tests for newly identified features.
* Support newly created unit tests.
* Capture language issues or ambiguities as they occur.

The captured issues shall then be resolved by the revised Flat Modelica specification v0.2 or considered as roadmap item for later versions.

### Milestones for reaching Flat Modelica v0.2
Prerequisite is that Flat Modelica v0.1 has been finalized.

* MS1: Initial example working
* MS2: 50% of MSL examples working
* MS3: 80% of MSL examples working
* MS4: 95% of MSL examples working
* MS5: ~100% of MSL examples working
* MS6: All features covered by examples/unit tests and working
* MS7: Flat Modelica specification v0.2 defined

### Timeline
|Time|EQ4-2022|EQ1-2023|EQ2-2023|EQ3-2023|EQ4-2023|EQ1-2024|
|--- |-------|-------|-------|-------|-------|-------|
|MS1 |       |   x   |        |       |       |         |        |
|MS2 |       |        |   x   |       |       |         |        |
|MS3 |       |        |        |   x   |       |         |        |
|MS4 |       |        |        |       |   x   |         |        |
|MS5 |       |        |        |       |       |   x   |       |
|MS6 |       |        |        |       |       |       |   x   |
|MS7 |       |        |        |       |       |       |   x   |

EQn: End of Quarter n

## Revisions
| Date | Description |
| --- | --- |
| 2019-01-09 | Henrik Tidefelt. Filling this document with initial content. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
The requirements on what Base Modelica should and shoudn't be are currently being developed in a [separate document](Base-Modelica-requirements.md).

## Backwards Compatibility
It is the goal of this MCP that it should only change the way the Modelica language is described, not either adding, removing, or changing any of the Modelica language features.  Hence, it should be completely backwards compatible.

## Tool Implementation
While existing Modelica implementations should work just as well before as after incorporation of this MCP, there should still be a proof of concept implementation showing how Base Modelica can be produced by a tool, and that the Base Modelica output can then be used as input to a Modelica back end for simulation.  Ideally, this should be demonstrated using different tools for the two tasks.

### Experience with Prototype
(None, so far.)

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
