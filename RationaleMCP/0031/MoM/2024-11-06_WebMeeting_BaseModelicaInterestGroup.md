# BaseModelica Interest Group web meeting Oct. 2, 2024

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [ ] Fabian Jarmolowitz (Bosch)
* [x] Christoff Bürger (Dassault Systemes)
* [ ] Gerd Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [ ] Jeff Hiller (COMSOL)
* [x] Francesco Casella (Politecnico di Milano, OSMC)
* [ ] Martin Sjölund (LiU, OSMC)
* [x] Henrik Tidefelt (Wolfram)
* [x] Hauke Neitzel (DIgSILENT)
* [ ] Ingo Czerwinski (DIgSILENT)
* [ ] Johannes Ruess (DIgSILENT)
* [ ] Chris Rackauckas (JuliaHub)
* [ ] Jadon Clugston (JuliaHub)
* [x] Joel Andersson (CasADi)
* [ ] James Goppert (Purdue University)

## Meeting notes

### Wolfram System Modeller

Worked on initialization handling
* observed that handling of 'start' requires more analysis than just being a syntactic sugar
* re-organized scalarization to get a reasonable representation 

Cross-check examples
* Not working yet due to unsupported type definitions.

Issues
* Currently collecting items rather than proposing changes.

### OpenModelica

Came across an issue exporting BaseModelica for some Media model.

Recently Matteo has been performing an analysis using BaseModelica to figure out scalability issues of an algebraic loop.
This shows that BaseModelica is quite useful in that sense also.

It could be interesting to get BaseModelica output also after index reduction.
Should be possible to express the output of these later stages of the compiler.

### CasADi

Oliver: Are Array-equations supported by CasADi?

Joel: Array equations can be handled, if the size is fixed.

Christoff: In the latest Dymola release we have addedd it as an experimental feature to preserver structural parameters to be changed after compilation, before simulation.
Main requirement behind this feature are tables of unknown size in SSP.

Status: Still overserving.

### Dymola

Did not work on BaseModelica.
Wants to analyze the difference in more detail first.

### DIgSILENT

Status: Still overserving.


## Issues

### BaseModelica as pure subset of Modelica.

Christoff:
* understandability of users
* having any Modelica tool being able to read BaseModelica
* extra effort having to maintain two parsers.

Henrik:
There are several reasons that led to this design decision.
The goal was to have something simple.
For instance synchronous is aiming to get rid of partitioning and is much clearer now, but goes beyond Modelica.
Other example is handling of constants.

We should not start over again on this fundamental design decision as we have started implementing prototypes.

Christoff:
Maybe we don't need clock partitions at all in BaseModelica.

Henrik:
The synchronous part will be the last thing to work on.

Christoff:
There might be things to carry back into Modelica.
At some point we will have to decide where it is specified.
Good reason could be to clarify the semantics of Modelica.

Henrik:
It will be a significant effort to write the spec.
Idea was always to have a shared expression structure and function syntax.
That part should not be duplicated.

It should be sufficient to read only the BaseModelica part and the shared sections, if that's the part you want to implement, rather than having to read everything.

Christoff:
Maybe we should ignore synchronous for now.

Henrik:
Once we have the rest working, we can look into it.
Supporting Synchronous will be a lot of work, but also a lot of value.

## Pending topics

* Issues:
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

## Next Meeting

Nov. 6, 2024 15.00 CET

Invite has been sent out by Oliver.
