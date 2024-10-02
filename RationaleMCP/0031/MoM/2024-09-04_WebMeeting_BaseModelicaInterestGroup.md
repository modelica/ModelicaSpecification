# BaseModelica Interest Group web meeting September 09, 2024

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
* [x] Hans Olsson on behalf of Christoff Bürger (Dassault Systemes)
* [x] Gred Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [ ] Jeff Hiller (COMSOL)
* [x] Francesco Casella (Politecnico di Milano, OSMC)
* [x] Martin Sjölund (LiU, OSMC)
* [x] Henrik Tidefelt (Wolfram)
* [x] Ingo Czerwinski (DIgSILENT)
* [x] Johannes Ruess (DIgSILENT)
* [x] Chris Rackauckas (JuliaHub)
* [ ] Jadon Clugston (JuliaHub)
* [x] Joel Andersson (CasADi)
* [x] James Goppert (Purdue University)

## Meeting notes

### OpenModelica

[BaseModelica_CrossCheck](https://github.com/modelica/BaseModelica_CrossCheck)

* examples added according to the agreed structure
* simple examples and more advanced cases
* examples with different level of processing of arrays and records
* reference to original models
* BaseModelica code generated
* array equations expressed as for loops
* connect equation currently always expanded
* all models can be reimported into OpenModelica and produce same results

PhD Matteo successfully implemented a Python parser to read BaseModelica into Pyomo.
Limited to scalarized models.
Applied to fuel cell model with 9.000 equations.
Pyomo cannot handle index reduction.

### Wolfram

Investigated differences in the grammar to make sure that they can be handled properly.

Finding that existing technology was capable of handling all cases.
No related issues discovered.
Growing internal support to work on this.

Current status BaseModelica can be generated and automatically read back.

Nothing contributed to the cross checks yet.
Do so is next

### Dassault Systemes

Maintaining two different versions of the parser will be hard.
Still under investigation by Christoff.

Need to avoid that the BaseModelica messes up the diagnostics of the Modelica part.
There are things that have to be maintained manually.

### JuliaHub

First prototype implemented working rather straight forward.

https://github.com/SciML/BaseModelica.jl/pull/22

Not yet aware of the cross checks but will look into this try to find someone to run these examples.

Add reference results as csv to the cross checks would be helpful to test consistency of the model behavior.

## Next Meeting

* Issues:
  * Christoff: Concerns about extra effort having to maintain two parsers.
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

Wed. Oct. 2, 2024 15.00 CET

Invite has been sent out by Oliver.
