# Semantical differences between Flat Modelica and Modelica
This document describes differences between Flat Modelica and Modelica that aren't clear from the differences in the grammars.

## Unbalanced if-equations
In Flat Modelica, all branches of an `if`-equation must have the same equation size.
Absence of an else branch is equivalent to having an empty else branch with equation size 0.

An `if`-equation without `else` is useful for a conditional `assert` and similar checks.

Note: _The "equation size" count the number of equations as if the equations were expanded into scalar equations, 
but does not require that the equations can be expanded in this way._

### Change and reason for the change
In Modelica this restriction only applies for `if`-equations with non-parameter conditions.
For `if`-equations with parameter condition it does not hold, and if the equation sizes
differ those parameters have to be evaluated. In practice it can be complicated to separate those cases, 
and some tools attempt to evaluate the parameters even if the branches have the same equation size.

Flat Modelica is designed to avoid such implicit evaluation of parameters, and thus this restriction is necessary.

In Modelica a separate issue is that `if`-equations may contain connect and similar primitives 
that cannot easily be counted; but they are gone in Flat Modelica.

## Array dimensions with parameter variability
In Flat Modelica, an array dimension is allowed to have `parameter` variability, that is, the dimension isn't known until after solving the initialization problem in the simulation.  _TO BE ELABORATED…_
