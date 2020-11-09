Modelica Change Proposal MCP-0038 Initialization of Clocked Partitions
Hans Olsson
(In Development) 
--

# Summary
Currently we have the unsatisfactory situation that clocked partitions don't support normal initialization 
in particular not initial equations, and at the same time we have 
https://specification.modelica.org/master/synchronous-language-elements.html#continuous-time-equations-in-clocked-partitions
stating: "The goal is that every continuous-time Modelica model can be utilized in a sampled data control system."

# Revisions
| Date | Description |
| --- | --- |
| 2020-11-09 | Hans Olsson. Prepared document based on ticket https://github.com/modelica/ModelicaSpecification/issues/2624 |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
To move closer to the goal that every continuous-time Modelica model can be utilized in a sampled data control system, as already stated in the specification;
especially as embedded code generation can be built on clocked partitions.

As indicated in https://github.com/modelica/ModelicaSpecification/issues/2624 initialization can either be done at firstTick or initially;
as indicated in that ticket firstTick seems more consistent with the rest of the clocked semantics - and avoids having initialization dependencies between
different clock partitions.

# Proposed Changes in Specification
The precise updated text of the specification will be part of this branch/pull-request.

The outline is as follows:

For a variable that is part of a continuous time partition discretized with explicit Euler:

    when Clock() then
      if “firstTick(x)” then
        // first clock tick (initialize system)
       if x.fixed=true then 
           x=x.start
         else
           INITIAL EQUATIONS FOR x;
        end if;
      else
        // second and further clock tick, the discretization equation:
        x = previous(x) + interval()*previous(der_x);
      end if;
      der_x = -x + u;
    end when;

For a normal clocked variable we replace:

    initially: previous(x)=x.start; 
    when clk1 then
       x = previous(x) + hold(u);
    end when;
    
by:

    when clk1 then
      if “firstTick(x)” then
         if x.fixed=true then 
           previous_x=x.start
         else
           INITIAL EQUATIONS for x;
         end if;
       else
         previous_x = previous(x);
       end if;
       // The above is new
       x = previous_x + hold(u);
    end when;

# Backwards Compatibility
Since initialization is currently severly limited in clock partitions this proposal is fully backwards compatibile.

# Tool Implementation
None yet.

## Experience with Prototype
None yet.

# Required Patents
At best of your knowledge state any patents that would be required for implementation of this proposal. 
# References
