# BaseModelica Interest Group web meeting Jan. 6, 2025

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [x] Fabian Jarmolowitz (Bosch)
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

### Bosch
Oliver: Created inverted pendulum examples, shared with Joel to try deriving an MPC function using CasADi from BaseModelica code.

Francesco: Can this be shared?

Oliver: Will try to find out what is needed to make this publicly available. 
This is not as easy as it seems.

### CasADi/rumoca

Joel: rumoca applied to quadrotor.mo
Rust based translator from Modelica to other symbolic representations, e.g., CasADi, Jax.

Looked at the specification:

* when and while equations have no correspondence in CasADi
    * Would it be possible to restrict the expressions allowed and enforce to make the indicator functions explicit?

Henrik: Event handling is already supported in the most general form and it require some hard design work to agree on something else, therefore is has been left out for now.

We always create helper variables to handle the potentially complex mixed real boolean systems.
This could be standardized.

Joel: What is the prioritization of variables good for?

Henrik: In systems with many alias variables and start values assigned it is important to decide which value is consider as guess value.
In Modelica there are rules in place considering the hierarchy to specify this.
In the MSL it is considered a bad practice to be dependent on the prioritization of start values.

Francesco: Still we would be in trouble not having these rules in case of nonlinear equation systems.

### OpenModelica

Francesco: 
Few bug fixes of minor issues.

Idea to try connecting ACADOS through BaseModelica.
Designed for high performance MPC, which are typically relatively small.
Create a BaseModelica interface for ACADOS.

Joel: ACADOS uses CasADi symbolics.

Francesco: We will make sure that no double work is done.

### Wolfram

Henrik: Fixed some minor issues.
Added two output files today.
One example looks very similar to OpenModelica output.

The CauerLowPassFilter contained some constants, while OpenModelica did not consider some parameters as constants.

Francesco: Do you have test case for this.

Henrik: Justs look for evaluate=true.

Looked into external functions.
This will require some work.

It turned out that handling enumerations requires some special treatment to ensure that the type compatibility is preserved in BaseModelica. 

We should have a place to document the history of issues with test models.

Francesco: There is a ReadMe for each test case.

Henrik: We should make sure that comments in the ReadMe have been addressed.
Maybe we could tag them.

We have reached 18% coverage processing the MSL4.0.0

Francesco: It's on the to do list to automate the process of BaseModelica code generation and checking as part of the nightly build.

### Dymola

Christoff: Still observing.
This week we will have a meeting to discuss how we want to proceed with this.

### DIgSILENT

Hauke: Still observing with high interest.

## Issues

- [ ] CauerLowPassFilter is missing constants of evaluated parameters.

## Pending topics

* Issues:
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

## Next Meeting

Mon. Mar. 10, 2025 11.00 - 12.00 CET

Invite has been sent out by Oliver.
