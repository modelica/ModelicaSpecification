Modelica Change Proposal MCP-0036 
Setting states
Hans Olsson
(In Development) 
--

# Summary
The main idea is that in many cases we use a model within a model (e.g. in Model-Predictive-Control and Feedback Linearization), 
and we need to update those states in the model within the model based on more accurate measurements of during the simulation, 
and have the state-updating as part of the model (and not as some tool-specific solution).

# Revisions
| Date | Description |
| --- | --- |
| 2020-04-22 | Hans Olsson. Created. |
| 2020-07-08 | Hans Olsson. Updated with reinit. |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
See previous discussion https://github.com/modelica/ModelicaSpecification/issues/2285
and paper https://modelica.org/events/modelica2017/proceedings/html/submissions/ecp17132517_OlssonMattssonOtterPfeifferBurgerHenriksson.pdf

This is still work in progress as the main challenge is figuring out a specific syntax.

The alternatives considered are:
 - stateSelect.Measurement and binding equation
 - possibly reinit within a Clock – check if possible
 - replace "reinit" by "measurement"-operator, or forceState(…)
 - the implemented annotation does not seem like a good idea

# Alternatives such as reinit
As discussed in https://github.com/modelica/ModelicaSpecification/issues/2285#issuecomment-641275627 the conclusion of
https://github.com/modelica/ModelicaSpecification/issues/578 was that all reinits are done at the end of the event iteration using previously computed values.

Thus the current reinit(v, -v/2); does not lead to a loop with reinit, but first evaluates -v/2 (and other reinit-values) and then sets v (and other reinit-values).
One goal of "Clocked Discretized Continuous-Time Partition" is to preserve the behaviour of a restricted set of continuous-time models; having two different variants of reinit (with same syntax but different semantics) is counter to that.
In addition the current reinit might possibly in the future be replaced by some form of impulses, indicating that the changes are physical and influence other parts of the system, this does not seem consistent with how states are set in this MCP.
Finally having a conditional setting of states is more complicated, and reinit and other similar operators naturally suggest that - and we either need to determine what it means or forbid it.

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
