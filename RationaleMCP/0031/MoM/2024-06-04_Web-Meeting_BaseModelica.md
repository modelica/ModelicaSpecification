# Minutes of meetings

## Participants
- [ ] Gerd Kurzbach <Gerd.Kurzbach@esi-group.com>; 
- [x] OLSSON Hans <Hans.OLSSON@3ds.com>; 
- [x] Martin Sjölund <martin.sjolund@liu.se>; 
- [x] Henrik Tidefelt <henrikt@wolfram.com>; 
- [x] Francesco Casella <francesco.casella@polimi.it>
- [x] BÜRGER Christoff <Christoff.BUeRGER@3ds.com>
- [x] Lenord Oliver <Oliver.Lenord@de.bosch.com>

## Topics:
* Update on starting the discussion with other companies
* Sync on progress of test implementations
* Share working examples

### Update on the discussion with other companies

Persons and organizations contacted so far:

#### COMSOL

Jean-Francois (Jeff) Hiller
SVP of Business Development

Intersted to join

#### DIGSILENT
Johannes Ruess <J.Ruess@digsilent.de>

Intersted to join

#### CasADi
Joel Andersson <joel@jaeandersson.com> 

#### JuliaComputing
Jadon Clugston <jadonclugston@gmail.com>
Chris Rackauckas <chris.rackauckas@juliahub.com>
Michael Tiller

Others to invite to this meeting:
Francesco, Martin, Henrik

Objective/agenda: Business model related discussion w.r.t. BaseModelica
* Explain the idea of BaseModelica
* Learn about business interest/potential seen in this effort
* Discuss potential business use cases for BaseModelica
* Get feedback if they are interested to be engaged in the prototype development

Shall we have this meeting as soon as possible?
in favor: Francesco, Oliver, Henrik
against: 
abstain: Hans, Martin

Invite JuliaHub, COMSOL, DigSilent to our technical meeting soon after the business related meeting, but within the next month.
in favor: all
against: none

Next: June 4, 9:30-11:00
Test Implementation Meeting: June 18, 09:30-11:00 (subject to confirmation)

### Sync on progress
Wolfram: has been delayed
OpenModelica: incomplete implementation, tested on a few cases imported into MARCO, prepared test cases
3DS: not yet started

### Share working examples

Examples processed by OpenModelica provided by Francesco, see issue [#3505](https://github.com/modelica/ModelicaSpecification/issues/3505)

- Modelica.Blocks.Examples.PID_Controller: [PID_Controller.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15299978/PID_Controller.mo.txt). Export and import successful in OpenModelica.
- Modelica.Electrical.Analog.Examples.CauerLowPassAnalog: [CauerLowPassAnalog.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15299983/CauerLowPassAnalog.mo.txt). Export and import successful in OpenModelica.
- Modelica.Mechanics.Rotational.Examples.First: [First.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15300046/First.mo.txt). Export and import successful in OpenModelica.
- Modelica.Fluid.Examples.Tanks.ThreeTanks: [ThreeTanks.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15300211/ThreeTanks.mo.txt): issue with PositiveMax
- ScalableTestSuite.Electrical.TransmissionLine.ScaledExperiments.TransmissionLineModelica_N_10: [TransmissionLineModelica_N_10.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15300280/TransmissionLineModelica_N_10.mo.txt). Export and import successful in OpenModelica
- ScalableTestSuite.Electrical.TransmissionLine.ScaledExperiments.TransmissionLineModelica_N_10 array version: 
[TransmissionLineModelica_N_10_array.mo.txt](https://github.com/modelica/ModelicaSpecification/files/15300291/TransmissionLineModelica_N_10_array.mo.txt): Export and import successful, but something wrong in the imported results. To be investigated.

Idea for BaseModelica: 
Obfuscated BaseModelica as an alternative approach for IP protection

## To Do:
* Provide feedback on the ticket [all]
* Create a table of the examples including column to characterize the test case [Francesco]

## Next:
* Find a place to share and cross-check the results
* Discuss specification issues, e.g. annotation
