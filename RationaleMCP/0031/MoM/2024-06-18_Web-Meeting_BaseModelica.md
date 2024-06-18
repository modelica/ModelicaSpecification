# Minutes of meetings

## Participants
- [ ] Gerd Kurzbach <Gerd.Kurzbach@esi-group.com>; 
- [x] OLSSON Hans <Hans.OLSSON@3ds.com>; 
- [x] Martin Sjölund <martin.sjolund@liu.se>; 
- [x] Henrik Tidefelt <henrikt@wolfram.com>; 
- [ ] Francesco Casella <francesco.casella@polimi.it>
- [x] BÜRGER Christoff <Christoff.BUeRGER@3ds.com>
- [x] Lenord Oliver <Oliver.Lenord@de.bosch.com>

## Topics:
* Update on starting the discussion with other companies
* Sync on progress of test implementations
* Share working examples
* Find a place to share and cross-check the results
* Discuss specification issues, e.g. annotation

## To Do:
- [x] Provide feedback on the ticket [all]
- [x] Create a table of the examples including column to characterize the test case [Francesco]

### Update on the discussion with other companies
New poll was sent today.
No feedback so far.

### Sync on progress on test implementations
Wolfram: Plans to start develoment next Monday, has been delayed due to vacation.
OpenModelica: No update.
3DS: Not yet started. Planned to start within the next month.

### Share working examples
Examples processed by OpenModelica provided by Francesco, see issue [#3505](https://github.com/modelica/ModelicaSpecification/issues/3505)

### Find a place to share and cross-check the results
Oliver: Shall we have a separate repo or add it to this MCP.

Henrik: We should avoid merging a whole lot of data with this MCP.

Martin: We can create a new github repo under Modelica.

How to name it?
1. BaseModelicaCrossCheck
2. Base-Modelica-Cross-Check
3. base-modelica-cross-check
4. BaseModelica_cross-check
5. BaseModelica_CrossCheck

infavor 
of 1: Henrik, Martin
of 2: none
of 3: Christoff
of 4: none
of 5: Christoff, Martin, Oliver

__Decision__:
Option 5: [BaseModelica_CrossCheck](https://github.com/modelica/BaseModelica_CrossCheck)

Shall it be pulic or private?

Henrik: Could become sensitive for more complex examples. We should also ask Gerd. 

Oliver: We could create a private one later if needed. Like the idea of having it public to be able to share with others.

Christoff: I cannot upload generated code to a public repository for unpublished features.

__Conclusion__:
It has to be started private. 

New users can be added anytime anyone with maintain rights, e.g., Martin, Hans,... .

What should the structure of the repo look like?

Henrik:
directory structure
- tool name
  - Modelica-4.0.0
    - fully qualified name
      - .bmo
      - ReadMe.md
Content:
- generated .bmo file
- configuration variants???

Option 1:
OpenModelica/Modelica-4.0.0/Modelica.Mechanics.Rotational.Examples.First/
  First.bmo
  First-arrays-preserved.bmo
  ReadMe.md

Option 2:
OpenModelica/Modelica-4.0.0/Mechanics/Rotational/Examples/First/
  First.bmo
  First-array-preserved.bmo
  ReadMe.md

Henrik: The reference results library is organized according to option2.

in favor 
of 1: 
of 2: Henrik, Christoff, Martin
abstain: Oliver

__Decision:__
Option 2 using folder structure

### Discuss specification issues, e.g. annotation
Accepted: [Added experiment annotation
#3506](https://github.com/modelica/ModelicaSpecification/pull/3506)

Open issues:
* Add/Reject nominal attribute (item in the check list)

__Conclusion:__
Focus first on getting the first examples to work before solving the _nominal_ issue.


## Next: 

Test Implementation Meeting: June 18, 09:30-11:00 (subject to confirmation)
