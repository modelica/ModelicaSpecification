# BaseModelica Interest Group web meeting May 22, 2025

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
* [x] Christoff Bürger (Dassault Systemes)
* [x] Gerd Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [x] Jeff Hiller (COMSOL)
* [x] Francesco Casella (Politecnico di Milano, OSMC), hindered
* [ ] Martin Sjölund (LiU, OSMC)
* [x] Henrik Tidefelt (Wolfram)
* [ ] Hauke Neitzel (DIgSILENT)
* [ ] Ingo Czerwinski (DIgSILENT)
* [ ] Johannes Ruess (DIgSILENT)
* [ ] Chris Rackauckas (JuliaHub)
* [ ] Jadon Clugston (JuliaHub)
* [x] Joel Andersson (CasADi)
* [ ] James Goppert (Purdue University)

## Meeting notes

### OpenModelica/MARCO

Francesco:

Marco-Compiler:
Going forward with BaseModelica.
Ideas to preserve some modular structure to improve scalability.

Test infrastructure for Julia/ModelingToolkit importer still underway.
Many examples in the test cases are hybrid. Open question, whether events can be properly handled in modeling toolkit.

Henrik:

Similar challenge at Wolfram combing Modelica with the Wolfram language.
I would be surprised if Modeling Toolkit was aiming to treat hybrid systems in the Modelica way.

Francesco:

In literature there are very different and often incompatible approaches to handle hybrid systems.
It's a research question to evaluate and compare these approaches.

Henrik:

It will make a lot of sense to address this research question from BaseModelica.

### Wolfram

Henrik:

Progress on the initialization with no more final, no more fixed.
This is enough for what we need in Modelica and a good foundation for other tools.

External objects not yet addressed.

Work going forward with efforts to delay the scalarization in the compilation process.

Front-end is being refactored and will provide a better basis for BaseModelica.

In general a growing interest in BaseModelica because it helps to better understand how difficult equation system arise.
This applies to modellers as well as compiler builders.
It's much easier to derive a minimal example from complex model causing issues.

### rumoca/CasADi

Joel:

Submission to Modelica conference with focus on hybrid systems.

Big motivation in BaseModelica is to embrace hybrid systems.

### Keysight (former ESI)

Gerd:
Currently no resources available to work on this, but still interested to follow the discussion.

### Bosch

Fabian:

Followed the CasADi latest release.
Not yet tested in depth.

### Paper submissions to Modelica Conference in Sept 2025

- Modelica2Pyomo: group at Politecnico di Milano
- Rumoca: group at Purdue University
- MARCO: No submission. Rather keep it for some compiler conference.

### BaseModelica standardization

Oliver:

There was this notion to address the general question whether BaseModelica is a subset of Modelica or not towards standardizing BaseModelica.
Going back to our road map defined earlier, the plan was to first finalize the prototype implementations to proof the current design, reveal short comings, before picking up the discussion.

Henrik:

Currently BaseModelica is designed to enforce structural parameters to be constant.
This makes it much easier to implement than Modelica.

## Issues

- [ ] CauerLowPassFilter is missing constants of evaluated parameters.

## Pending topics

* Issues:
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

## Next Meeting

Wed. Sept. 3, 2025 14:00-15:00
Meeting invite has been sent out.
