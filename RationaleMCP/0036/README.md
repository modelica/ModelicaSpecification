Modelica Change Proposal MCP-0036 
Setting states
Hans Olsson
(In Development) 
--

# Summary
The main idea is that in many cases we use a model within a model (e.g. in Model-Predictive-Control and Feedback Linearization), 
and we need to update those states in the model within the modle based on more accurate measurements of during the simulation, 
and have the state-updating as part of the model (and not as some tool-specific solution).

# Revisions
| Date | Description |
| --- | --- |
| 2020-04-22 | Hans Olsson. Created. |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
See previous discussion https://github.com/modelica/ModelicaSpecification/issues/2285
and paper https://modelica.org/events/modelica2017/proceedings/html/submissions/ecp17132517_OlssonMattssonOtterPfeifferBurgerHenriksson.pdf

This is still work in progress as the main challenge is figuring out a specific syntax.

The alternatives considered are:
 - stateSelect.Measurement and binding equation
 - replace "reinit" by "measurement"-operator, or forceState(…)
 - possibly reinit within a Clock – check if possible
 - the implemented annotation does not seem like a good idea

# Backwards Compatibility
Will depend on exact syntax.

# Tool Implementation
The preliminary variant with annotation has been implemented in Dymola.

## Experience with Prototype
The implementation effort was small and it works.
However, as noted in the paper the procedure for using it is still slightly messy.
 - Attempt to translate the model
 - For each input add appropriate number of integrators and the state-update-component
 - Have parameters for those integrators etc.

# Required Patents
At best of your knowledge state any patents that would be required for implementation of this proposal. 
# References
