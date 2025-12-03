# BaseModelica Interest Group web meeting Dec. 03, 2025

## Agenda

* Status on CI pipeline with OpenModelica generated Base Modelica parsed by BaseModelica.jl 
* Base Modelica standardization go forward plan

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
* [ ] Christoff Bürger (Dassault Systemes)
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
* [x] Joel Andersson (CasADi)
* [ ] James Goppert (Purdue University)
* [x] Micah Condie (Purdue University)

## Meeting notes

### Base Modelica being a pure subset of Modelica

Francesco:

There are many things that can be simplified by the compiler, like function inlining, ... , that enable using very simple parsers to process the output, like MARCO.

The same model can be rendered in Base Modelica in various ways, depending on the level of flattening that is applied.

Henrik:

On can develop a tool that supports only a part, but the standard should describe all that is possible in a concise way, avoiding variants.

At Wolfram we have now started to have a shared part that can be extended depending on whether it is Modelica or Base Modelica.
It turned out that it's much easier from a developer perspective to ignore Modelica-only features.

### Testing OpenModelica to BaseModelica.jl

Francesco:

- Test infrastructure has been setup to automate cross checking
- Reported blockers to Jadon
- Jadon worked on fixes
- Improved from 0 to 10 (much better, but still only 2% of MSL)
- Modelica.Electrical.Analog caused many models to fail due to arrays.
 - configured OpenModelica to avoid arrays
 - StateSelect not recognized
- Other issues related to if equations 

Hence, Modelica is complicated and Base Modelica still is.

Jadon:

Wasn't prepared for arrays and similar.

To name the biggest hurdles I'd have to dig into the errors.

- Modification is a big thing.
- Parameters being defined by an expression depending on other parameters

Francesco: 

Dependencies are required to be acyclic, but the compiler can be instructed to evaluate parameters, which should avoid this challenge for many examples.

Jadon: That would be helpful for the time being.

Henrik:

Could be that local type definitions, e.g., enumerations are over looked.

Francesco:

We can share the produced Base Modelica files for all of MSL.
These can be processed all the way to simulation, though some 10 model that fail during simulation.
All this goes through Base Modelica, but can currently not verify that it is proper Base Modelica.

Henrik:

I could invest a bit of time to move the rules from our grammar file into the parser to check imported Base Modelica.

We could also enforce more restrictive variability rules.
This is easily missed. 


## Topics for next meeting

- Apply compiler settings that will lead to the discussed simplified Base Modelica [Francesco] 
- Prepare few minimal examples highlighting the Base Modelica simplifying language features. [Francesco, Henrik]
- Feedback from Jadon how valuable he considers theses features.
- Consider the risks of Base Modelica not being a pure subset seen by Christoff


## Next Meeting

Wed. Feb 28, 2026, 16.00-17.00 CET 

Wed. Dec. 3, 2025 16:00-17:00
Meeting invite has been sent out.
