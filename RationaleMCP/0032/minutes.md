# Minutes

The following list compiles minutes of all official events and discussions - like Modelica Design Meetings - where selective model extension has been a topic. The list summarizes only the ideas, concerns and final decisions relevant for selective model extension and skips any further topics typically discussed at the listed meetings (such can be found in the official minutes linked to).

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