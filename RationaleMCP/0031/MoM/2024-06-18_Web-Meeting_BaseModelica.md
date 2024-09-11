# Minutes of meetings
Web meeting June 18, 2024 09.40-11.00

## Participants
- [x] Gerd Kurzbach <Gerd.Kurzbach@esi-group.com>; 
- [ ] OLSSON Hans <Hans.OLSSON@3ds.com>; 
- [x] Martin Sjölund <martin.sjolund@liu.se>; 
- [x] Henrik Tidefelt <henrikt@wolfram.com>; 
- [x] Francesco Casella <francesco.casella@polimi.it>
- [x] BÜRGER Christoff <Christoff.BUeRGER@3ds.com>
- [x] Lenord Oliver <Oliver.Lenord@de.bosch.com>

## Topics:
* Update on starting the discussion with other companies
* Sync on progress of test implementations
* Share working examples
* Find a place to share and cross-check the results
* Discuss specification issues, e.g. annotation

## To Do:
- [ ] Share working examples of OpenModelica on the repo [BaseModelica_CrossCheck](https://github.com/modelica/BaseModelica_CrossCheck) [Francesco]
- [ ] Create new pull request constraining the guess operator [Henrik]

  
### Update on the discussion with other companies
Web Meeting scheduled for June 25, 2024, 15.00h.

Meeting accepted by:
- [x] Lenord Oliver (Bosch)	Meeting Organizer
- [ ] Chris Rackauckas (JuliaComputing)
- [x] Buerger Christoff (3DS)
- [x] Francesco Casella (Politecnico di Milano)
- [ ] Gerd Kurzbach (ESI Group)
- [x] Goppert, James Michael (Purdue University)
- [x] Henrik Tiedfelt (Wolfram)
- [ ] Jadon Clugston (JuliaComputing)
- [x] Jean-Francois Hiller (COMSOL)
- [x] Joel Andersson (CasADi)
- [x] Johannes Ruess (DigSilent)
- [ ] Martin Sjölund (LiU)
- [ ] Michael Tiller (JuliaComputing)

### Sync on progress on test implementations
ESI-Germany: 
No activity planned for this year. Management is expecting a concrete user request first.

Wolfram: 
Implementation started focussing on initialization, with different minimal examples.
Goal to get these cases translated to BaseModelica and reading it back.

OpenModelica: 

Two usages of BaseModelica:
1. Using OpenModelica as front-end to produce BaseModelica for MARCO compiler producing highly efficient code.
2. Using OpenModelica to produce an as simple as possible scalar structure.

There will be no single output of BaseModelica.
It will depend on the tool and objective of the user.

Henrik: This is intended by design.
It's alreaday considered in the cross-checks that there will be multi variants.
The cross-checks shall help to identify outputs that are not valid BaseModelica and should be rejected.
We may not find bse modelica models that are not perfect for the own back-end, but still we need to be able to precess them consistently.

3DS: Nothing noted.

### Share working examples
Examples processed by OpenModelica provided by Francesco, see issue [#3505](https://github.com/modelica/ModelicaSpecification/issues/3505)

Repo available: [BaseModelica_CrossCheck](https://github.com/modelica/BaseModelica_CrossCheck)

There shall be a way to share minimal examples without dependecies as well as advanced examples from or using existing libraries.

How to share the original model used to produce the bmo?

- root
  - models
    - BaseModelicaTest (no dependecies)
      - package.mo
      - Initialization
        - package.mo
        - InitTest1.mo
    - MSLExamples (uses Modelica4.0.0)
      - package.mo
      - Example1.mo
    - PowerGridExamples (uses PowerGrid library)
      - package.mo
      - Example1.mo

xxxExamples contains models created using the corresponding library "xxx", but not examples already existing in that library.

Already existing examples, e.g., from the MSL, shall not be replicated under _models_.
Instead the produced bmo shall be shared in a folder structure as agreed last time and documented in the ReadMe.md 

### Discuss specification issues, e.g. annotation
* Henrik: Added pull request removing the byte order mark (bom).
* Henrik: Create new pull request constraining the guess operator

## Next: 
Test Implementation Meeting: Sept. 03, 10:00-11:00
