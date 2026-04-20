# Minutes

The following list compiles minutes of all official events and discussions -- like _Modelica Design Meetings_ -- where selective model extension has been a topic. The list summarizes only the ideas, concerns and final decisions relevant for selective model extension and skips any further topics typically discussed at the listed meetings (such can be found in the official minutes linked to). On the other hand, the following summaries often contain more detailed notes on decision reasons, open problems and the scope of selective model extension than the official meeting minutes.

## _98th Modelica Design Meeting_

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min98_2019_Regensburg/); Issue #2329
- **Decision (discussion):** Align deselections with `extends`-clauses as part of the modifier.
  - No need for `extends`-clause independent, general deselection syntax (`for each extends` ) as used in the Modelica 2019 conference paper ([Modelica language extensions for practical non-monotonic modelling: on the need for selective model extension](https://modelica.org/events/modelica2019/proceedings/html/papers/Modelica2019paper3B1.pdf)).
  - Multiple inheritance: Elements inherited multiple times must be deselected at each `extends`-clause introducing them to deselect them completely. Thus, deselection is fine grained, only deselecting the element from the base-class of the respective `extends`-clause the deselection is part of.

- **Decision (discussion):** Only allow deselections _directly_ inside `extends`-modifier. No support for deselecting nested elements, likewise Modelica has no means to introduce such. To support _both_ is subject for later MCPs.

- **Decision (discussion):** No support for fine-grained connection deselection (i.e. removing only parts of a connection).

- **Decision (poll):** Use `break` as keyword like proposed in the Modelica 2019 conference paper; also use the same syntax for component and connection deselections (i.e., `break component-name` and `break connect(first-connector, second-connector)`).
  - Other suggestions, instead of `break`, have been `not`, `remove`, `ignore`, `redeclare Type component-name if false` after component, `notPresent`, `deselect`, `without`, `undeclare`, use new character `$ignore component-name` or use some new function syntax.
  - Advantage of `break` is that it does not introduce a new keyword; its backward compatibility outweighs gain of readability. `break` is readable enough.

## _99th Modelica Design Meeting_

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min99_2019_Linkoeping/)

- **Decision (discussion):** No need to support deselections within `long-class-specifier`. Support deselection only within `extends-clause`.

- **Decision (poll):** Only allow deselections _directly_ inside `extends-clause`, i.e., only as top-level/non-nested modification. This should be specified in terms of the context-free grammar of the Modelica specification, not as semantic rule. No ordering of modifications should be enforced; ordinary- and inheritance-modifications (deselections) can be in arbitrary order as long as inheritance modifications are top-level modifications.
  - **Rationale why only top-level inheritance modifications:** Defining the semantics of nested deselection modifications or supporting such is not a problem. But to be useful, it also has to be possible to add elements in terms of nested modifications; otherwise, deselecting connections of a nested sub-component will, for example, most likely result in non-fixable singular equation systems. In the long run, it therefore would be good to add both, (1) language means for adding elements to nested sub-components within modifications and analogous (2) deselecting nested sub-components.
  - **Rationale why modification order doesn't matter:** Modelica is declarative; it is a general objective of the Modelica language design that order doesn't matter.

- **Decision 99.3 (poll), reverted by decision 101.1:** For connection deselections, the order of the `connect` arguments does not matter; `break connect(a, b)` deselects the connection between `a` and `b` regardless if it is defined as `connect(a, b)` or `connect(b, a)` in the selectively extended base-class.
  - **Rationale 99.3.1 why order of `connect` arguments doesn't matter:** Modelica is declarative; it is a general objective of the Modelica language design that order doesn't matter. Also, a base-class refactoring just switching the order of a connection's arguments should not break existing deselections in models selectively extending the base-class.

- **Decision 99.4 (poll), further restricted by decision 101.1:** Connection deselection is based on syntactic equivalence, i.e., matching of ASTs. Let `a` and `b` be the arguments of a connection deselection _D_ (i.e., _D_ = `break connect(a, b)`). Let _C_ = `connect(c, d)` be a connection defined in the base-class selectively extended by the `extends`-clause _D_ is is a modifier of. _D_ deselects _C_, if, and only if, either, `c` is syntactically equivalent to `a` and `d` is syntactically equivalent to `b` or, vice versa, `c` is syntactically equivalent to `b` and `d` is syntactically equivalent to `a`.
  - Two code fragments `a` and `b` are syntactically equivalent, if, and only if, the context-free derivations of `a` and `b` according to the grammar given in Appendix B of the Modelica 3.4 specification are the same.

- **Discussion:** Is it permitted or prohibited to deselect connections defined inside `for-equation` and `if-equation`, i.e., connections that are conditionally defined?
  - Discussion has to be continued at the next _Modelica Design Meeting_, where we should try to achieve a decision.
  - **Open question (discussion to continue at the next meeting):** What have been the reasons for prohibiting deselection of conditionally defined connections? Is it just that such typically have no graphical representation such that deselecting them from within the diagram layer/graphically is typically not possible but we like deselections to be understandable in terms of graphical diagram edits? Or are there general conceptional issues?
  - **Open question (not discussed so far, but to do so at the next meeting):** What is about conditionally declared components? Are there conceptional or practical problems with deselecting such?

## _100th Modelica Design Meeting_

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min100_2019_Lund/Slides-and-Documents/Language/)

- **Decision (poll):** Deselection of conditionally declared components is permitted.
  - Deselections of extending classes have a higher priority than conditional declarations of base-classes; deselecting a conditionally declared component excludes it from inheritance irrespective of whether the component is declared or not (i.e., irrespective if the declaration's condition is satisfied).
  
- **Decision (poll):** Deselection of connections inside conditional equations is permitted.
  - Tight poll: Yes 4, No 2, Abstain 3
  - Again, deselections of extending classes have a higher priority than conditional connections of base-classes; deselecting a conditional connection excludes it from inheritance irrespective of whether the connection is established or not (i.e., irrespective if the connections condition is satisfied).
  
- **Decision 100.3 (poll):** Deselection of connect equations inside a `for-equation` are permitted.
  - Tight poll: Yes 3, No 3, Abstain 3
  - Such deselections are based on syntactic matching of ASTs like defined at the _99th Modelica Design Meeting_; deselecting an iterated connect equation therefore deselects all its instances, i.e., all connections it establishes. For example, `break connect(b[i].o, b[i + 1].i)` deselects all connections established by `for i in 1:size(b,1)-1 loop connect(b[i + 1].i, b[i].o); end for;`.
  
- **Decision 100.4 (discussion):** Syntactic equivalence as defined by decision 99.4 is the base-paradigm for connection deselections.

## _101th Modelica Design Meeting_

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min101_2019_Oberpfaffenhofen/)
- **Decision 101.1 (poll), changes decision 99.3, further restricts decision 99.4:** For connection deselections, the order of the `connect` arguments matters. `break connect(a, b)` only deselects the connection between `a` and `b` if it is defined as `connect(a, b)` in the selectively extended base-class; it does not deselect it if it is defined as `connect(b, a)` .
  - Clear poll: Yes 7, No 0, Abstain 3
  - **Rationale 101.1.1 why order of `connect` arguments matters:** In decision 100.4, syntactic equivalence has been established as base-paradigm for connection deselections; it is strange, if there are relaxing exceptions.
  - Rationale 101.1.1 is in conflict with rationale 99.3.1.
  - **Open question (discussion to continue at the next meeting):** We forgot to reconsider rationale 99.3.1 when doing this decision. We have to choose either, decision 99.3 or 101.1, weighting rationale 99.3.1 vs. rationale 101.1.1.
- **Discussion:** One result of decisions 100.3 and 100.4 is, that syntactic equivalence deselects _all_ matching base-class connections, regardless in which `for-equation` they are. For example, if the base class has two `for-equation`, each establishing connections `connect(b[i].o, b[i + 1].i)` -- like `for i in 1:3 loop connect(b[i + 1].i, b[i].o); end for;` and `for i in 5:7 loop connect(b[i + 1].i, b[i].o); end for;` -- the single `break connect(b[i].o, b[i + 1].i)` deselects all respective connections.

## _Modelica Phone Meeting (2021-09-28, 15:00)_

* Discussed further roadmap on how to get selective model extension soon into the Modelica Standard:
  * Proposal: Only one prototype implementation in Dymola (instead of the usual two) and instead comprehensive examples library and proof reading of the MCP by other tool implementors.
  * Open question: Do the MAP-Lang bylaws need to be adapted to support this process?
  * In general such a process is desired and should be supported by the bylaws.

