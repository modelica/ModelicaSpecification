# BaseModelica Interest Group web meeting Mar. 10, 2025

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
* [ ] Christoff Bürger (Dassault Systemes)
* [ ] Gerd Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [ ] Jeff Hiller (COMSOL)
* [ ] Francesco Casella (Politecnico di Milano, OSMC), hindered
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

### Bosch

Followed closely the CasADi improvements.

Interesting aspect, how much overhead is produced by FMU used for optimization.
This seems to heavily depend on the implementation of the gradient calculation.

### CasADi/rumoca
Upcoming CasADi release with a lot of work on FMI/Modelica interoperability
- event support (still primitive, but able to handle state events)
- FMI3  export improved, including adjoined derivatives
- working on few examples
- Aiming to apply to the test suite on the long run.

Try to leverage on FMI as much as possible, e.g., variable descriptions, but use BaseModelica for equations.

Henrik:
Is there any difficulty to get the variable declarations from BaseModelica?

Joel:
rumoca is a parser of Modelica, which can export FMU + extra symbolic information in some xml format.
Aiming to get rumoca ready to able to handle BaseModelica + some more, but not full Modelica.

### OpenModelica

Francesco: 

Current work:
- Prototype Julia script importing Base Modelica flat models into ModellingToolkit from Jadon Clugston.
- Used to test the workflow omc frontend -> Base Modelica -> ModellingToolkit
- Applied to the entire OMC library testsuite, which encompasses over 18,000 models. 

Outlook:
- Run the whole library testsuite by flattening the models to Base Modelica and then re-importing them into OMC.
- Spot obvious errors, such as missing equations in the flat model. 
- Need to fix a bug in OMC that currently prevents using quoted identifiers in some cases.
- Plan would be to have some results in time to write a paper at the next Modelica conference in Luzern. This depends on how much time Adrian can put on that task.

### Wolfram
- Still looking into initialization and external functions.
- Started with the constraint for import to expect the model to be flat, which is hindering external objects (constructor, destructor).
- Type aliasing of enumerators still open to be fixed, hopefully soon.
- Lowering of parameters being evaluated treated as constant, marked by an annotation.
  - Constants that cannot be evaluated converted into final parameter in need of an annotation, e.g., impure function called by only constants (not clear in full Modelica, becomes explicit in BaseModelica) 

Question:
- Is there already a solution in place how to name objects (constructor, destructor).

### Dymola
Not present.

### DIgSILENT
- BaseModelica is not on the road map, but some tasks planned to push towards a future support.
- No concrete results right now.

## Issues

- [ ] CauerLowPassFilter is missing constants of evaluated parameters.

## Pending topics

* Issues:
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

## Next Meeting

Align with Francesco, if we shall have a call close to the submission deadline of the Modelica Conference.

Poll to be send out by Oliver.
