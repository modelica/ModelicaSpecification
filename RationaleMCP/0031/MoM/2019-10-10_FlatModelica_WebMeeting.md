Meeting Date: 10.10.2019 09:00
Location: Skype Meeting
	
### Participants
* Lenord Oliver (Bosch)
* Werther Kai (ETAS)
* Henrik Tildefeit (Wolfram)
* Martin Sjölund (LiU)

# Notes

Martin:

Will be important to get more tool vendors behind the idea of Equation Code within EMPHYSIS.

Henrik:
 Is trying to get support also on Wolfram side.

Oliver:

SimulationX were quite supportive.

# How to organize ourselves?
EqCode Language defined within the eFMI spec should be a reference to Flat Modelica.
On github a change proposal for Flat Modelica language exists: https://github.com/modelica/ModelicaSpecification/tree/MCP/0031/RationaleMCP/0031

Here we should share:
- Grammar for Flat Modelica
- Code examples 
Proposed changes to the initial grammar can be created as pull request with the opportunity to discuss the proposals.

Starting point:
- Use the current Modelica grammar.
- Or use the refactored and proposed Modelica grammar in antlr.
- Or use a first draft with removed parts

Conclusion:
- Take the current grammar file an commit it to the 0031 branch and notify Adrian --> Henrik.
- Commit the examples into a subfolder:
  - Original modelica model (models/*.mo)
  - Generated flat modelica by tool (<tool_name>/*.mof)
  - hand coded flat modelica (hand_coded/*.mof)
  - meeting notes folder
