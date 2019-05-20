# Minutes

The following list compiles minutes of all official events and discussions - like _Modelica Design Meetings_ - where selective model extension has been a topic. The list summarizes only the ideas, concerns and final decisions relevant for selective model extension and skips any further topics typically discussed at the listed meetings (such can be found in the official minutes linked to). On the other hand, the following summaries often contain more detailed notes on decision reasons, open problems and the scope of selective model extension than the official meeting minutes.

## 98th Modelica Design Meeting

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min98_2019_Regensburg/); Issue #2329
- **Decision (discussion):** Align deselections with `extends`-clauses as part of the modifier.
  - No need for `extends`-clause independent, general deselection syntax (`for each extends` ) as used in the Modelica 2019 conference paper ([Modelica language extensions for practical non-monotonic modelling: on the need for selective model extension](https://modelica.org/events/modelica2019/proceedings/html/papers/Modelica2019paper3B1.pdf)).
  - Multiple inheritance: Elements inherited multiple times must be deselected at each `extends`-clause introducing them to deselect them completely. Thus, deselection is fine grained, only deselecting the element from the base-class of the respective `extends`-clause the deselection is part of.
- **Decision (discussion):** Only allow deselections _directly_ inside `extends`-modifier. No support for deselecting nested elements, likewise Modelica has no means to introduce such. To support _both_ is subject for later MCPs.
- **Decision (discussion):** No support for fine-grained connection deselection (i.e. removing only parts of a connection).
- **Decision (poll):** Use `break` as keyword like proposed in the Modelica 2019 conference paper; also use the same syntax for component and connection deselections (i.e., `break component-name` and `break connect(first-connector, second-connector)`).
  - Other suggestions, instead of `break`, have been `not`, `remove`, `ignore`, `redeclare Type component-name if false` after component, `notPresent`, `deselect`, `without`, `undeclare`, use new character `$ignore component-name` or use some new function syntax.
  - Advantage of `break` is that it does not introduce a new keyword; its backward compatibility outweighs gain of readability. `break` is readable enough.

## 99th Modelica Design Meeting

- [**Original minutes**](https://svn.modelica.org/projects/ModelicaDesign/trunk/MeetingMinutesMaterial/min99_2019_Linkoeping/)

- **Decision (discussion):** No need to support deselections within `long-class-specifier`. Support deselection only within `extends-clause`.

- **Decision (poll):** Only allow deselections _directly_ inside `extends-clause`, i.e., only as top-level/non-nested modification. This should be specified in terms of the context-free grammar of the Modelica specification, not as semantic rule. No ordering of modifications should be enforced; ordinary- and inheritance-modifications (deselections) can be in arbitrary order as long as inheritance modifications are top-level modifications.

  - **Rationale why only top-level inheritance modifications:** Defining the semantics of nested deselection modifications or supporting such is not a problem. But to be useful, it also has to be possible to add elements in terms of nested modifications; otherwise, deselecting connections of a nested sub-component will, for example, most likely result in non-fixable singular equation systems. In the long run, it therefore would be good to add both, (1) language means for adding elements to nested sub-components within modifications and analogous (2) deselecting nested sub-components.

  - **Rationale why modification order doesn't matter:** Modelica is declarative; it is a general objective of the Modelica language design that order doesn't matter.

- **Decision (poll):** For connection deselections, the order of the `connect` arguments does not matter; `break connect(a, b)` deselects the connection between `a` and `b` regardless if it is defined as `connect(a, b)` or `connect(b, a)` in the selectively extended base-class.

  - **Rationale why order of `connect` arguments doesn't matter:** Modelica is declarative; it is a general objective of the Modelica language design that order doesn't matter. Also, a base-class refactoring just switching the order of a connection's arguments should not break existing deselections in models selectively extending the base-class.

- **Decision (poll):** Let `a` and `b` be the arguments of a connection deselection _D_ (i.e., _D_ = `break connect(a, b)`). Let _C_ = `connect(c, d)` be a connection defined in the base-class selectively extended by the `extends`-clause _D_ is is a modifier of. _D_ deselects _C_, if, and only if, either, `c` is syntactically equivalent to `a` and `d` is syntactically equivalent to `b` or, vice versa, `c` is syntactically equivalent to `b` and `d` is syntactically equivalent to `a`.

  - Two code fragments `a` and `b` are syntactically equivalent, if, and only if, the context-free derivations of `a` and `b` according to the grammar given in Appendix B of the Modelica 3.4 specification are the same.

- **Decision (discussion):** It is prohibited/not possible to deselect connections defined inside `for-equation` and `if-equation`, i.e., connections that are conditionally defined.

  - **Open question (to discuss next meeting):** What have been the reasons for prohibiting deselection of conditionally defined connections? Is it just that such typically have no graphical representation such that deselecting them from within the diagram layer/graphically is typically not possible but we like deselections to be understandable in terms of graphical diagram edits? Or are there general conceptional issues?

  - **Open question (not discussed):** What is about conditionally declared components? Are there conceptional or practical problems with deselecting such?