# Modelica Change Proposal MCP-0032: selective model extension

**Authors:** Christoff Bürger (Christoff.Buerger@3ds.com)

The minutes of _Modelica Design Meetings_ discussing this MCP are summarized in [`minutes.md`](minutes.md).

## Status: in development

- [x] **Concept:** completed and approved
- [x] **Design:** completed and approved
- [x] **Examples:** completed
- [x] **Prototype:** Fully implemented in _Dymola 2022x_
- [ ] **Specification-incorporation:** not started

## Summary
This MCP defines language extensions for structural non-monotonic model variation. The proposed language features enable selective model extension: the well-defined refinement of models by deselecting components and connections not of interest or inappropriate for a new design. Deselection is modeled in terms of non-exhaustive inheritance; to that end `extends`-clause modifiers now support exclusion of base-class elements from inheritance. Deselected elements are treated in extending models as if they never have been defined in their base-class. In case of deselected components, also all their connections are deselected.

### Applications

The main contribution of selective model extension is to enable unforeseen structural variability without requiring deliberately prepared base-models.

Such non-monotonic variations are for example required to incorporate clocking -- i.e., use Modelica Synchronous -- in existing continuous models, where the problem is that synchronous adaptations cannot be anticipated when continuous models are designed but require crosscutting structural changes that are often contradicting between different synchronous designs.

Other application areas are, for example, the extraction of FMUs from whole system models by replacing components providing test inputs with actual input connectors; or fault-behavior-testing where deselection can be used to intercept connections for introducing noise or exchanging components with faulty ones without base-model preparations for such tests.

A particularly important application area is interface adaptation, to enable the reuse of models in different simulation environments with varying interface requirements. Consider for example a flange interface. Such is not suited for FMU export, because the 0-sum equation system of a flange's Modelica flow variables cross-cuts the component interface; typically, the flange has to be replaced by a Real input connector acting as an external torque on the flange (i.e., attached to a `Modelica.Mecahnics.Rotational.Sources.Torque`). Selective model extension can be used to deselect the original flange connector and instead introduce the Real input connected acting on the flange, such that the original model can be exported as FMU without changing it or copy-and-pasting its code with hard to maintain and track modifications.

Another interface adaptation scenario are controllers, which depending on the used integration method, might require varying inputs; e.g., implicit methods like Rosenbrock might need the derivative of an input `I` depending on whether filters are applied on `I` or not; selective model extension can be used to (1) break connections and introduce respective filters and/or (2) deselect such a controller component and replace it with an interface incompatible one (`replaceable` and `redeclare` are not working well in such context due to the interface incompatibility).

## Prerequisites

The MCP is based on the paper [_Modelica language extensions for practical non-monotonic modelling: on the need for selective model extension_](https://modelica.org/events/modelica2019/proceedings/html/papers/Modelica2019paper3B1.pdf) published at the _13th International Modelica Conference 2019_ (cf. Section _References_). The motivation, concepts and examples presented in that paper are considered to be know.

## Syntax and semantic

### Syntax rules

Incorporating deselection into the current Modelica 3.4 grammar requires only very limited changes. The main change is the introduction of a new top-level -- i.e., non-nested -- modification called `class-or-inheritance-modification`, which is the only modification capable of performing deselections -- i.e., inheritance modifications. It can be used instead of `class-modification` in the contexts supposed to support deselections:

```
class-or-inheritance-modification :
    "(" [ argument-or-inheritance-modification-list ] ")"

argument-or-inheritance-modification-list :
    ( argument | inheritance-modification ) { "," ( argument | inheritance-modification ) }

inheritance-modification :
    break ( connect-clause | IDENT )
```

The order of ordinary modifications and deselections does not matter; an `inheritance-modification` can be comma separated followed by an `argument` and vice-versa. But deselections must be top-level modifications whereas `argument`-only based modifications can be nested as used too.

The new `class-or-inheritance-modification` is used instead of `class-modification` at all places of the Modelica 3.4 grammar that should be capable of deselections:

```
extends-clause :
    extends type-specifier [ class-or-inheritance-modification ] [annotation]
```

Thus, only `extends`-clauses can deselect entities they would otherwise inherit. Deselections are not supported in `short-class-specifier` (which can be part of a `short-class-definition`) and `constraining-clause` because both can be within nested `class-modification`; allowing deselections in such would enable deselections that are not top-level modifications. Also the `class-modification` application of `long-class-specifier` is not changed to `class-or-inheritance-modification`; deselection support for `long-class-specifier` is assumed to be of low interest and can be added later if considerable use-cases emerge.

Note that, deselection syntax is not supported within annotations. Thus,

```
annotation :
    annotation class-modification
```

is _not_ changed to

```
annotation :
    annotation class-or-inheritance-modification
```

### Semantic rules

Selective model extension adds only minor semantic rules and constraints. Given a class _C_ with an `extends`-clause _E_ extending class _B_ and with a deselection _D_, the following rules apply for _D_:

1. _D_ is applied before any other, non selective model extension related, modifications of _B_ via _E_; conditionally declared components of _B_ are assumed to be declared for all purposes of matching as described in point (2).

2. _D_ must match at least one element of _B_. All matched elements are excluded from inheritance to _C_ via _E_ (i.e., are removed from _B_ when adding its elements to instantiate _C_).

   1. A component deselection matches all equally named components of _B_ and all connections with such. Matched components must be models, blocks or connectors.
   2. A connection deselection matches all syntactical equivalent connections of _B_.

      * A connection `connect(c, d)`, with `c` and `d` arbitrary but valid connection arguments, is syntactically equivalent to a connection deselection _D_ = `break connect(a, b)`, if, and only if, either, `c` is syntactically equivalent to `a` and `d` is syntactically equivalent to `b` or, vice versa, `c` is syntactically equivalent to `b` and `d` is syntactically equivalent to `a`.

      * Two code fragments `a` and `b` are syntactically equivalent, if, and only if, the context-free derivations of `a` and `b` according to the grammar given in Appendix B of the Modelica specification are the same.

#### Non-normative explanation of some interesting consequences of the semantic rules

If not explicitly alternated by above syntax or semantic rules, the existing ordinary Modelica semantic completely applies; all in the current Modelica Standard given rules that are not explicitly changed by the MCP must be followed, without any exception. This comprises in particular name analysis rules (used names must be uniquely declared).

**I:** As a consequence of the `inheritance-modification` syntax rule, nested components can not be deselected since  deselection only works on simple names (`IDENT`) and not qualified. Thus, in a class *C* extending *B*, whereas *B* has a component _cb_ that has a component _ci_, we can not deselect _ci_ from *C* because `extends B(break cb.ci)` is a syntax error; qualified names in `break` clauses of deselections are not supported.

**II:** As a consequence of (1) and the existing ordinary Modelica name-analysis semantic, deselected components must not be modified because they do not exist anymore when modifications are applied (since modification of a deselected component will result in a name analysis error).

**III:** As a consequence of (1), it does not matter if the condition of a deselected conditional component evaluates to `true` or `false`. It is **not** an error to deselect a conditional component whose condition would have been evaluated to `false` (the result is the same, the component is just not defined/available in either case regardless if its conditional declaration would evaluate to `true` or `false`). Deselection can be conducted/decided without the need to evaluate conditions.

**IV:** As a consequence of **I**, deselection is independent of redeclaration (since redeclarations only change the elements **within** the redeclared component, but never the elements defined in the base-class; but the elements defined within the redeclared component cannot be deselected).

**V:** As a consequence of **I** - **IV**, deselection can be decided without the need to apply any base-class modifications (and therefore does not require an instance tree). From **I** - **IV** directly follows that:

1. Deselection does not require to evaluate the conditions of conditional declarations of any base-class.
2. Deselection does not depend on any values (even parameters).
3. Deselection is independent of redeclarations.

From these follows that:

1. Deselection is independent of any modification.
2. It can be decided on what is deselected without considering modification, neither of the extending class _C_ nor its base class _B_.
3. There is no need to instantiate any classes to know that some component is deselected (i.e., not there) for every possible instance of the model with the deselection. An instance tree is not required.
4. Selective model extension operates on the syntactic level only.

**VI:** As a consequence of (2), deselected elements must exist.

**VII:** As a consequence of (2), elements deselected by _E_ may still be introduced by inheritance via another `extends`-clause _E2_ of _C_ that extends the same _B_ directly or indirectly (multiple-inheritance of _B_), assuming _E2_ does not also deselect the elements. This mechanism can be used to solve modification conflicts of the inheritance diamond problem.

**VIII:** There are no special restrictions on the components _C_ introduces; _C_ or any further sub-class of it is free to **re**-introduce components named like deselected ones. Such re-introduced components are by no means restricted to be of the same type or even structurally equivalent compared to their equally named ones deselected from _B_ via _E_.

**IX:** As a consequence of the syntactical equivalent matching of (2.2), connections introduced by `for`-loops can be deselected. For example, if _B_ defines in its equations section

```
for i in 2:10 loop
  connect( // Let's add some whitespace for fun.
    a[i],
    b[2*i] /* Note, that there is no space within the indexing expression. */ );
end for;
```

the 9 connections introduced by the loop are deselected by _D_ = `break /* for i in 2:10 */ connect(b[2 * i], a[i])` (note the irrelevant whitespace changes and the switch of arguments in the `connect` statement). Syntactical equivalent matching also implies, that a single connection deselection can can match multiple base class connections; As an example consider the following base-class _B_:

```
model B
   ...
equation
   ...
   for i in 1:10 loop
      connect(a[i], b[i]);
   end for;
   for i in 20:30 loop
      connect(b[i], a[i]);
   end for;
end B;
```

The deselection _D_ = `extends B(break connect(a[i], b[i]))` in some class _C_ extending _B_ would deselect the connections established by both `for` loops. It doesn't matter if these loops are correct indexing-wise in the base-class _B_ nor in the extending class _C_; the indexes are not evaluated -- don't have to be -- for deselecting the connections.

## Backwards compatibility
The proposed language extensions do not introduce any new keywords. The new context-free derivations for `extends`-clause modifications to deselect connections and components -- using the proposed `break`-based syntax -- are syntax errors in current Modelica. As a consequence, selective model extension never changes the semantic of existing valid Modelica 3.4 models.

Models that are syntactically invalid could theoretically become valid however, but chances are extremely low. It is not likely that a syntax error happens to satisfy the proposed syntax. It is even less likely that the respective model will further satisfy the semantic constraints of selective model extension _and_ Modelica. Particularly, on the one hand deselections must actually deselect something whereas at the same time it is close to impossible that _just_ deselecting something results in a valid model (consider that deselected elements are likely used somehow and are therefore missing in the resulting model because of existing Modelica well-formedness constraints like _“referenced components must be declared”_ and _“the system of equations must be well-defined”_).

## Tool implementation

### _Dymola 2020_ prototype
A prototype of selective model extension has been developed by _Dassault Systèmes AB, Lund_. Selective extension is supported in _Dymola 2020_ in terms of tool vendor specific annotations for `extends`-clauses.

For example, to deselect the three connections `connect(voltageSensor.v, filter.u)`, `connect(speedSensor.w, setPointGain.u)` and `connect(voltageController.y, excitationVoltage.v)` of the `Modelica.Electrical.Machines.Examples.SynchronousInductionMachines.SMEE_Rectifier` SMEE rectifier example of the Modelica Standard Library one annotates the respective `extends`-clause as follows:

```
extends Modelica.Electrical.Machines.Examples.SynchronousInductionMachines.SMEE_Rectifier
    annotation(DiagramMap(__Dymola_deselect={
      "connect(voltageSensor.v, filter.u)",
      "connect(speedSensor.w, setPointGain.u)",
      "connect(voltageController.y, excitationVoltage.v)"}));
```

Likewise, components can be deselected via annotation. For example,

```
extends Modelica.Electrical.Machines.Examples.SynchronousInductionMachines.SMEE_Rectifier
    annotation(DiagramMap(__Dymola_deselect={
      "voltageController",
      "setPointGain"}));
```

deselects the `Modelica.Blocks.Continuous.LimPID voltageController` and `Modelica.Blocks.Math.Gain setPointGain` components and all connections they are part of. Of course, connector and component deselections can be mixed.

The _Dymola 2020_ prototype is not feature complete. Besides realizing deselections using annotations instead of the proposed syntax, it does not check all proposed semantic constraints, particularly that deselected elements indeed exist. The resulting diagrams are correctly rendered however, such that deselected elements are not shown. GUI support to deselect from within the diagram-layer is not supported yet.

Implementing the _Dymola 2020_ prototype took very little effort; less than 50 lines of code have been required.

### _Dymola 2022x_ prototype

_Dymola 2022x_ fully supports selective model extension with proper syntax for deselections instead of tool-vendor specific annotations and all required semantic checks. It passes the tests of the `SelectiveExtension_13th_Modelica_Conference` 0.4.0 library.

### Examples library

A library with application examples is provided (`SelectiveExtension_13th_Modelica_Conference` library); different versions of it can be found in the [`examples`](examples) sub-directory. The contained examples are discussed in detail in the paper _Modelica language extensions for practical non-monotonic modelling: on the need for selective model extension_ (cf. Section _References_); the conclusions drawn in the paper hold for all library versions.

The available versions are:

1. **Version 0.1.0** for _Dymola 2020_, based on `Modelica` 3.2.2 and `Modelica_Synchronous` 0.92.1 and using tool-vendor specific annotations for deselection.
2. **Version 0.2.0** for _Dymola 2020_, based on `Modelica` 3.2.3 and `Modelica_Synchronous` 0.93.0 and using tool-vendor specific annotations for deselection (incorporates layout-adjustments for selective extensions of MSL base-classes whose layout changed from MSL 3.2.2 to 3.2.3, otherwise very same examples with the very same modeling as in version 0.1.0).
3. **Version 0.3.0** for _Dymola 2021_, based on `Modelica` 3.2.3 and `Modelica_Synchronous` 0.93.0. This version uses the correct syntax instead of vendor specific annotations and serves as a reference test case (besides syntax changes, the provided examples are still the ones of versions 0.1.0 and 0.2.0).
4. **Version 0.4.0** for _Dymola 2022x_ and based on `Modelica` 3.2.3 and `Modelica_Synchronous` 0.93.0. This version adds unit-tests for correct and incorrect examples of advanced and corner case selective model extensions.

## Revisions

| Date             | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| 2021-December-06 | Christoff Bürger. Incorporated feedback from Leonardo Laguna Ruiz and Henrik Tidefelt (Wolfram Research, Inc., [System Modeler](https://www.wolfram.com/system-modeler/)) and Elena Shmoylova (Waterloo Maple Inc.) given on [GitHub](https://github.com/modelica/ModelicaSpecification/issues/3005), resulting in the new _"Non-normative explanation of some interesting consequences of the semantic rules"_ Section. |
| 2021-October-04  | Christoff Bürger. Incorporated feedback from Elena Shmoylova (Waterloo Maple Inc.) given on [GitHub](https://github.com/modelica/ModelicaSpecification/issues/3005), mostly clarification of rule 2.1 of _"Semantic rules"_-Section (deselected components must be models, blocks or connectors and deselecting a component also deselects all its connections). |
| 2021-June-06     | Christoff Bürger. Adding unit-tests to examples library (`SelectiveExtension_13th_Modelica_Conference` version 0.4.0). Added "Semantic rules" Section. The current _Dymola_ in development (next release _Dymola 2022x_) fully supports selective model extension. |
| 2020-February-20 | Christoff Bürger. Updated minutes with the results of the _101th Modelica Design Meeting_. |
| 2019-October-01  | Christoff Bürger. Updated examples library adopting final syntax (`SelectiveExtension_13th_Modelica_Conference` version 0.3.0). |
| 2019-May-20      | Christoff Bürger. Updated minutes with the results of the _99th Modelica Design Meeting_. Updated syntax. Updated examples library to `Modelica` 3.2.3 and `Modelica_Synchronous` 0.93.0 (`SelectiveExtension_13th_Modelica_Conference` version 0.2.0). |
| 2019-May-10      | Christoff Bürger. Initial version based on the discussion at the _98th Modelica Design Meeting_. Includes summary, syntax proposal, examples (`SelectiveExtension_13th_Modelica_Conference` version 0.1.0), prototype and minutes. |

## Contributor License Agreement

All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Required patents

To the best of our knowledge, there exist no conflicting or required patents to incorporate this MCP into the Modelica specification or implement it in Modelica tooling.

## References

The MCP is based on Modelica language extensions presented at the _13th International Modelica Conference 2019_:

> Christoff Bürger, [Modelica language extensions for practical non-monotonic modelling: on the need for selective model extension](https://modelica.org/events/modelica2019/proceedings/html/papers/Modelica2019paper3B1.pdf), 13th International Modelica Conference, March 4-6th 2019, Regensburg, Germany.

The provided `SelectiveExtension_13th_Modelica_Conference` library is documented in above publication.

The minutes of _Modelica Design Meetings_ discussing this MCP are summarized in [`minutes.md`](minutes.md).