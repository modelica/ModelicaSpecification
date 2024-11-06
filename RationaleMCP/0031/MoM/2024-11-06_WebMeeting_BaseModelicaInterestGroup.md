# BaseModelica Interest Group web meeting Nov. 6, 2024

## Agenda

* Status update on BaseModelica prototypical implementations
* Discuss cross check results
* Identify and resolve issues
* Q&A

## Participants

* [x] Oliver Lenord (Bosch)
* [ ] Fabian Jarmolowitz (Bosch)
* [x] Christoff Bürger (Dassault Systemes)
* [x] Gerd Kurzbach (ESI)
* [ ] Erik Danielsson (COMSOL)
* [ ] Jeff Hiller (COMSOL)
* [x] Francesco Casella (Politecnico di Milano, OSMC)
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

### Topics to be discussed

Francesco: Need to discuss BaseModelica being a strict subset.

Oliver: We have discussed this in the last meeting. 
My take away from this discussion was that during development of BaseModelica it became obvious that a srtict subset is not possible.
On this assumption BaseModelica has evolved.
Questioning this assumption would throw us back to the very beginning.
Therefore we should first continue to proof the current proposal by prototyping.

Then we should get back to this general question as we discuss how to integrate BaseModelica with the Modelica specification.

Christoff: This is an ok summary.
Henrik pointed out that there are strong reasons why BaseModelica is currently is not a subset.
But we should get back to this as it would be very valuable to reach a state with BaseModelica being a strict subset.
This may require so port some constructs from Basemodelica to Modelica.

Joel: How about GALEC and Modelica.
Isn't this a similar case with GALEC being a time discretized variant of the equations.

Christoff: GALEC is using Modelica syntax, but it has many extension that cannot be ported back to Modelica, e.g., Error Signaling.

Joel: It would pretty natural to support eFMI using GALEC. 
Would be nice if developing a parser that reads GALEC was already half the way to supporting BaseModelica.

Christoff: BaseModelica is equation-based, quite a long way to GALEC.

### Wolfram System Modeller (Henrik)

Making steady progress.
Issue with handling empty arrays.
Required to become better in representing empty arrays including type information, like fill in Modelica.

Noticed that many MSL examples use tables.
How to represent external objects.
Not too hard to do, but there are multiple possible designs one could choose.

Targetting the analog resistor example.
Getting close to reaching milestone 1, covering the intialization: getting rid of final, fixed, start,... .

Handling empty arrays will be some work to merge into the main branch.

### OpenModelica

Francesco: Regarding handling of empty arrays I'm not aware of any relevant case.

Henrik: There are function with an empty array as default.
Internally we translate this into an element where we kept the type separatly.

Francesco: Could you share an example of this case?
Would be interesting also for the MARCO compiler.

We started a discussion about tearing annotation using a very large Fuel Cell model (10.000 equations).
This caused some issue being exported as BaseModelica, which have finally be resolved, but reading this back still fails.

Currently preparing tests to read some 18.000 open source libraries to generate BaseModelica.
All these shall be loaded using the BaseModelica.jl into ModelingToolKit, to see how far we get.
ModelingToolKit can hanlde higher index problems, but it is not clear if this will work with dynamic state select.

This test will tell where we are also regarding performance of Julia as backend.

### CasADi

Joel: Currently setting up an optimization framework focussing on FMI.
Wait to try out once there are tools ready to provide symbolic representations.

I'll spend some time to analyze some exmples to 

### Dymola

Christoff had to leave earlier.

### DIgSILENT

Not present.

## Issues

Henrik: Stumbled upon nominal.

Joel: Is it well defined?

Henrik: It helps to scale.

Francesco: There is not much to it, it's defined the Modelica specification. 
But it's crucial for optimization, as Modelica is using SI units.

Joel: Is it about absolute ot relative measures?

Francesco: May this could be clarified. 
at the end it's about helping the scaling

## Pending topics

* Issues:
  * Henrik: Syntactic sugar related to declaration of discrete variables.
* Cross checks:
  * Feedback on reading and processing the cross check examples in BaseModelica.jl
  * Feedback on write and read BaseModelica in SystemModeller

## Next Meeting

Mon. Jan. 13, 2025 15.00 CET

Invite has been sent out by Oliver.
