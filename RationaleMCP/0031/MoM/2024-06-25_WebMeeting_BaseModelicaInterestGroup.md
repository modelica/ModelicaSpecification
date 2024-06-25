# BaseModelica Interest Group web meeting June 25, 2024

## Agenda

* Explain the idea and basic concepts of BaseModelica
* Learn about the business interest/potential of this approach from your perspective
* Discuss potential use cases for BaseModelica
* Get feedback if you're interested to be engaged, e.g. the prototype development

## Participants

- [x] Oliver Lenord
- [x] Fabian Jarmolowitz
- [x] Christoff Bürger
- [x] Erik Danielsson (COMSOL)
- [x] Francesco Casella (Politecnico di Milano, OSMC)
- [x] Henrik Tidefelt (Wolfram)
- [x] Ingo Czerwinski (DIgSILENT, SW Architect)
- [x] Jeff Hiller (COMSOL Buisness Development)
- [x] Joel Andersson (CasADi, Developer)
- [x] Johannes Rues (DIgSILENT, Team Manager dynamic simulation)
- [x] JadonClugston (JuliaHub, Sw Engineer)
- [x] James Goppert (Purdue University)

## Meeting notes

### Introduction

Oliver:

Slides from Modelica conference paper with some comments.

Henrik:

BaseModelica as an intermediate step towards a full Modelica tool in the sense of devide and conquer also interesting for tool vendors aiming for full Modelica support in their tool.

Joel:

Supporting Modelica by CasADi was a goal from the very beginning starting with xml, Optimica,...
Situation to avoid is the chicken and egg problem.
There was not sufficient support on the generation side to justify significant investments on the importing side.

In general it makes a lot of sense having this because all the parsers exist and BaseModelica being much easier to handle.
Full Modelica support is out of scope for CasADi.

Johannes:

New in the Modelica community.
Pleased to got in touch at the Modelica conference.
Main domain for power system simulation based on their own language.
Decision that integrating more and more Modelica would be beneficial.

* Benfit to enable exchange with other tools
* Power systems domain lacks standards
* BaseModelica seen as an opportunity to integrate controller models, overcomming FMI overhead.

Francesco:

Comment on chicken and egg issue.
Good news: BaseModelica output from OpenModelica is already used as input to the MARCO compiler working for some examples.
Very promissing results in terms of performance.
Currently working on a set of examples being exported and reimported for simulation in OpenModelica.
Cross checks with other tools will follow.
This will help to debug and refine the BaseModelica specification.

Recent work of a student is using BaseModelica to get large models (without algorithms and functions) into PYOMO by writing a Python script in few weeks.

Erik:

COMSOL is equation-based but coming from Finite Elements.
What we do with Modelica is to convert Modelica into our own representation.
Main goal is to combine Modelica with FE-methods.
But structures are very different than ODEs.

This is the first time to heard about BaseModelica, but the goal is quite clear.

Jeff:

Buisness perspective, still very new in this field.
We want our tool to be able to interact with other tools.
We want to adress a community as big as possible.
But we expect that we will have to support more than just BaseModelica.
BaseModelica is a good idea as it allows to reach more, but has the risk of having to two support standards.
There is a risk of canibalization, with extra costs without reaching a broader customer base.

Also you will have to explain to the market what is what in terms of Modelica vs. BaseModelica.
Communication costs money.
Who will spend this effort, the Modelica Association?

Do you want to have competitors supporting only BaseModelica, which may bring some tension into the community as some will push for BaseModelica to cover more, while others already have it with Modelica?

Oliver:

BaseModelica is intended as basis for the full Modelica language, rather than another language.
One proposal is to restructre the Modelica specification such that Modelica is defined by BaseModelica plus advanced features.
We see BaseModelica as an opportunity to bring Modelica into a new field, e.g., optimization, machine learning.

Francesco:

Original intend was not to use BaseModelica as authoring language.
BaseModelica is not a strict subset, but very close.


Next steps:

Who is interested to join follow-up meetings or be invited to the recurrent technical BaseModelica meetings?

Jeff: 

Interested to keep an eye on what is going on, without having the resources to contribute.

Francesco: 

Current proposal is mostly ready to be named version 1.
What is missing to make it a change proposal is the prototype inplementation.

Joel:

There are many other things going on, but I can see it in a one to two year time frame.
This is something that could go on in parallel with the on-going FMI support.
I'd like to take part in the techical meetings.

Johannes:

We will be interested to join the technical meetings.
Goal is the address high performance.
Especially the OpenModelica array preserving compilation is quite interesting.

Henrik:

BaseModelica working group is currently still in the early stage where there is room to influence the standard with demands from non-Modelica tools.
During the development it has been biased by Modelica tools.
It will be very good for the standard to get the perspective from other vendors.

Johannes:

We will be happy to share what we consider crucial for our domain and application.

James:

Very excited using CasADi and Modelica.
Happy to join the technical meeting.

Jadon:

Not audible.

### Conclusions:

All participants that joined the meeting shall be invited to the next technical meetings.

Will 
