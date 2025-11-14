# BaseModelica Interest Group web meeting May 22, 2025

## Agenda

* Status on CI pipeline with OpenModelica generated Base Modelica parsed by BaseModelica.jl 
* Base Modelica standardization go forward plan

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
* [x] Christoff Bürger (Dassault Systemes)
* [ ] Gerd Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [ ] Jeff Hiller (COMSOL)
* [x] Francesco Casella (Politecnico di Milano, OSMC), hindered
* [ ] Martin Sjölund (LiU, OSMC)
* [x] Henrik Tidefelt (Wolfram)
* [ ] Hauke Neitzel (DIgSILENT)
* [ ] Ingo Czerwinski (DIgSILENT)
* [ ] Johannes Ruess (DIgSILENT)
* [ ] Chris Rackauckas (JuliaHub)
* [x] Jadon Clugston (JuliaHub)
* [ ] Joel Andersson (CasADi)
* [ ] James Goppert (Purdue University)
* [x] Micah Condie (Purdue University)

## Meeting notes

### Testing OpenModelica to BaseModelica.jl

Francesco:

Test infrastructure has been setup to automate cross checking
- Base Modelica output from OpenModelica
- Import into BaseModelica.jl

MSL models currently too complex.

Hand code works.

Possible simplifications
- avoid hybrid (discrete/continuous)

Jadon:

Current status
- Recently added support for conditional equations and if-expressions
- modifiers ignored
- assert ignored
- CauerLowPass can be parsed, results not checked
- Other examples never finalized parsing, probably due to incomplete grammar
 
Francesco:
- Could be that the Base Modelica is not error free.


### OpenModelica/MARCO

First working industry grade example using Base Modelica to integrate with PYOMO.

High interest to get Base Modelica standardized to push more into this direction.

### Wolfram

Henrik:
We have some functionality, but as a commercial tool we need to avoid the situation of users starting to use is before there is an official standard.

Currently prefer to exchange examples to test the language.
https://github.com/modelica/BaseModelica_CrossCheck

At the moment Base Modelica is generated after flattening, but this is not as interesting.
Export Base Modelica before requires more work to restructure the code.
This work in progress.

### Standardization of Base Modelica

Fabian:
Is there a Grammar available for Base Modelica.

Henrik:
Yes, there is the Grammar as a diff to the full Modelica.
https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/grammar.md

Idea was to highlight what the simplifications are about and how different it is.

Jadon:
A bit difficult to interpret as non-Modelica user.

Francesco:
Having a very fist limited version 1 is crucial to not loose momentum and break the chicken and egg problem of having no users without tools and no tools without users.
FMI1 was a first shot and has been forgotten by now, but it was the crucial first step to later success.

Henrik:
We had a lot of momentum on the technical side 2 years ago.
But this was based on the assumption that Base Modelica is __not__ a pure subset of Modelica.

Oliver:
When we decided to not yet work on the Base Modelica standard, the rational was to first proof to management:
- feasibility
- benefits for the users and developers
- get feedback from the community

Benefits have been demonstrated, e.g., https://github.com/looms-polimi/SOFCPoliMi Modelica models of Solid Oxyde Fuel Cells developed at Politecnico di Milano, or at least could be show cased, e.g., if we had first examples running in ModelingToolkit. Wolfram experienced that their tool structure can be improved.
 
Proof of feasibility has made significant progress.

Towards the general concern of Base Modelica being a pure subset this not only a technical but also a political question.

Henrik:
We should ask Jadon, whether or not the new Base Modelica constructs make his live easier?

Jadon:

Models with only variables, parameters and equations have been straight forward to implement.

Biggest issues have been related to:
- records
- functions

Oliver:
How about initialization?
Like the explicit guess values.

Jadon:

Well, ModelingToolkit can handle that.

Francesco:
I can compile a set of examples using these language features.

Christoff:

From tool vendor perspective there are a couple of reasons why a pure subset is crucial:
- for internal communication within DS, to not give the impression we develop a new language,
- also for educational reasons, to avoid confusion among users,
- avoid the risk of having to deal with two languages when integrating models into an existing structure

Henrik:
Getting a full Modelica model from a Base Modelica model should be easy and lead to a simpler model.

Francesco:

Problematic are Modelica models with records and functions.

Modelica functions could be expresses as external functions.

Regarding going back and forth between Modelica and Base Modelica: Would it be possible to tansform one into the other in both directions?

Henrik:
I expect AI tooling to have a good chance to produce good results.

Jadon mentioned that he has thrown away the modifiers.
Until he got to the point of understanding this complexity in Modelica he will not be able to appreciate the simplifications we have in Base Modelica.


### rumoca/CasADi

Micah:
Haven't really started looking into Base Modelica, but for the next meeting we could see how far we get and give a status update.

What we discovered is that we'd like to preserve some structural information like what is a rigid body.
We could also give an overview of this type of things we'd like to see

Oliver:
This would be really interesting.
Probably too much for one meeting together with the other points we have, but surely something for future meetings.

## Topics for next meeting

- [ ] Prepare few minimal examples highlighting the Base Modelica simplifying language features.
- [ ] Feedback from Jadon how valuable he considers theses features.
- [ ] Consider the risks of Base Modelica not being a pure subset seen by Christoff

## Next Meeting

Wed. Dec. 3, 2025 16:00-17:00
Meeting invite has been sent out.
