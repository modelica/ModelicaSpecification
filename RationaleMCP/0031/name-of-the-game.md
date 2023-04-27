# Name of the game

At the time of writing, the name of this MCP is _Flat Modelica and MLS modularization_, suggesting that name name of the simplified modeling language being designed would be _Flat Modelica_.
That name, however, comes with connotations that could imply there is a better name to be used instead.


## Name candidates

Below, pros and cons of the name candidates are given.

### Flat Modelica

Filename extension alternatives: _.mof_, _.fmo_, _.flm_

Name of action for producing: flattening

Pros:
- Historically established for similar representations

Cons:
- Not same as things called _Flat Modelica_ in the past
- "Flat" could mean scalarized (not allowing records and arrays) to some readers
- Is very closely tied to the compilation process.
- May be confused with the flattening of Modelica, which is only partially true.
- Introducing "Flat Modelica" will make people believe that flattening is generating "Flat Modelica" code.

### Modelica Intermediate Representation

Filename extension alternatives: _.mir_, _.moi_

Name of action for producing: transform

Pros:
- No historical baggage
- Free of misleading connotations
- Many engineers will have intuitive understanding of "intermediate representation"

Cons:
- Doesn't immediately suggest similarity to things called _Flat Modelica_ in the past

### Lowered Modelica

Filename extension alternatives: _.lmo_, _.mol_

Name of action for producing: lower

Pros:
- "Lowered" reflects closeness to full Modelica
- No historical baggage
- Free of misleading connotations

Cons:
- Only some engineers have intuitive understanding of "lowered"
- Doesn't immediately suggest similarity to things called _Flat Modelica_ in the past.
- Having "lowered", as a past tense action term, in the name suggest that it would always be produced from a Modelica model being lowered.

### Base Modelica

Filename extension alternatives: _.bmo_

Name of action for producing: base
- base, doesn't mean reducing to basic representation but "base on something"
- lower
- constitute
- ground, easily confused
- simplify, easily confused
- reduce, easily confused

Pros:
- Refers to the idea of splitting the complex modelica langugae specification into a _base_ part and an _advanced_ part. 
- Stress that it's a more basic (simpler) langugage than Modelica.
- Is less technical than _lowered_ and _intermediate representation_, which leaves more room for us to decide on the interpretation.

Cons:
- May raise the expectation that _Modelica_ is an extension of _Base Modelica_, which will strictly speaking not be the case.
