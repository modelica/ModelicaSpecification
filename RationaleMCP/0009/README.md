Modelica Change Proposal MCP-0009

Removing Modifications 

Hans Olsson, Gerd Kurzbach, Hilding Elmqvist, Martin Otter, Michael Tiller
(In Development) 


# Summary
This MCP proposes a possibility to remove existing, in particular inherited, modifications.

# Revisions
| Date | Description |
| --- | --- |
| 2013-12-07 | Initial Draft under the name MCPI-0009_UndefinedModifications by Gerd Kurzbach (initial idea is from Hilding Elmqvist; contributions from Martin Otter and Michael Tiller to this draft are included).| |
| 2014-06-14 | Update. Added corrections and results from discussions (#1377), clarifications and other proposals|
| 2018-03-23 | Second Version with changed name, simplified and streamlined, no more related to custom annotations MCP-0008|
| 2021-03-17 | Converted to markdown, by Hans Olsson and added new syntax-variant from Gerd Kurzbach |
| 2021-03-18 | Hans Olsson - added experience from Dymola |
| 2021-03-24 | Hans Olsson - feedback on prototype |
| 2021-05-03 | Hans Olsson - additional feedback on prototype |
| 2021-05-05 | Hans Olsson - feedback at language meeting |
| 2021-06-16 | Hans Olsson - removed `<empty>` |
| 2022-05-11 | Hans Olsson - explained extended scope |

# Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement". 

# Rationale
To parametrize components of classes modifications can be added.
These modifications are merged with others, when the class is used as component in another class.
Once a modification is placed at a component, currently there is no way to remove this again at the place of usage of the surrounding class.
This prevents a more sophisticated determination of parameter values, e.g., by initial equations.
This MCP proposes a possibility to remove existing, in particular inherited, modifications.
The result are free parameters or variables, which then can be calculated by initial or transient equations or algorithms.
This allows more flexibility when using library elements because it enables a possibility to replace equations.

# Proposal

## Syntax
It is proposed to introduce a new keyword, when used as modification, removes an inherited modification and leaves the modified element as if it was never modified.

Requirements to this keyword are:
* It needs to be easily disdinguished from a modification expression, therefore it should not be part of the expression non terminal.
* It should be self explaining and not contain only control characters.
* It should not break existing models by leading to unpredictable results.

Because simple names are expressions and when becoming a keyword that may break existing models it was considered to extend a descriptive name with some special characters.
That lead to the proposal to use the keword `break` (after first considering `<empty>`), which fulfills the requirements.
  
Syntactically the rule of a modification is extended:

```
modification :
   class-modification [ "=" modification-expression ]
 | "=" modification-expression
 | ":=" modification-expression
 
modification-expression :
   expression
 | break
 ```

## Rules
Modifications containing `break` do not need special handling when they are merged during instantiation of models.
They either override other modifications or will be overridden as usual.
It is also not allowed to override modifications having the final prefix.
Only during flattening of an instantiated model, remaining `break` modifications are seen as not present.
They have no further influence on the model equations.

## Impact on balanced models.
The section on balanced model does in some cases have a restrictions on modifiers:
"The binding equations in modifiers for components may in these cases only be for parameters, constants, inputs and variables having a default binding equation."
The latter case interacts with `break`, and the simplest solution seems to be:
"For the latter case of variables having a default binding equation (that are not parameter, constant, or input) the modifier may not remove the binding equation using break."
  
Alternatives would be that it is allowed to remove the binding equation, as long as a normal binding equation is added later, or that it is allowed to remove it and replace it with a normal equation. Both variants seem more complicated and with unclear benefits - but might be considered for the future if the need arises.

# Discussion of effects

## In Equations

Because of the keyword `break` is not an expression, it cannot be used at other places than modifications, neither in equations nor in algorithms.
It is also not possible to use it as sub expression inside modifications, therefore no operators or functions must deal with it.
That eases the implementation in the compiler, because no runtime is needed.
`break` is not a value. It is just a marker to the modification, that it will be ignored.

A parameter or variable with the `break` modification behaves in the same way as with no modification.
If such a parameter is referenced at places, where the value must be known at compile time (structural parameter), an error is given.
Variables and parameters having ``break` modifications are free variables and must be calculated by an additional equation or algorithm.
Otherwise there would be one missing equation, which leads to an error.
From the point of the equation system they behave the same as variables without modification.

## In Annotations

The use in annotations is not really useful, because they are not merged in current Modelica.
Therefore no modification can be overridden.
Finally, if an annotation has the `break` modification but needs to have a value to work properly, a tool provided default value may be used  instead.
  
## In the GUI

In a dialog, a tool may hide the keyword `break` from the users and present them only an empty input field, not showing the overridden modification.
Then, there needs to be a possibility to remove it again to get back the overridden modification.
  
# Use cases

## Variables

If there is an inherited modification from a base class and you want to replace them by a (probably more sophisticated) equation or an algorithm in the `break` can be used in the derived class:
```
model A
    Real x=1;
end A;
model B
    extends A(x=break);
    algorithm
	  x:=0;
	  while(…)
		x:= x+ …
        end while;
end B;
```

## Parameters

Another similar use case is to make an initial state from a parameter:
```
model A
    parameter Real diameter  = 1;
    final parameter radius = diameter/2;
end A;

model B
    extends A(diameter(fixed=false)=break);
    parameter Real sqare;
    initial equation 
    //  assuming this cannot be solved symbolically for diameter
        square =f(diameter); 
end B;
```
## Removing unwanted defaults
As an practical example consider reusing `Modelica.Fluid.Pipes.StaticPipe` - when you don't like the defaults for `roughness` and `height_ab` and want to ensure that users provide both.

Previously you would have to create a complete wrapper for this model, since the bad defaults are in a base-class.

Now you can just write:
```
model MyPipe
  extends Modelica.Fluid.Pipes.StaticPipe(roughness=break, height_ab=break);
end MyPipe;
```
and use `MyPipe` instead.

# Backwards Compatibility
The new syntax ensures that it is backwards compatible.
Although the `break`-syntax overlaps with ([MCP/0032](https://github.com/modelica/ModelicaSpecification/tree/MCP/0032/RationaleMCP/0032)) they can be combined without problems.

# Tool Implementation
Implemented in SimulationX since a long time ago.
Test-implemented in Dymola 2022.

## Experience with Prototype
The experience with a simple prototype implementation in Dymola is that it can mostly be implemented in less than a day.
(There might be some rough spots remaining.)
The use cases above are relevant also for large industrial models.

One additional relevant use case is allowing re-using of models that have unwanted defaults; added above.

### Removing more?
From the user perspective there was feedback that it was seen as somewhat problematic that defaults (using `p(start=...)` for parameters) was not removed by a simple modifier `p=break` since that only undefine the value. Based on the proposal that is deliberate and also setting start=break is possible for users, and can be automated in tools.
The other simple option would be that `p=break` removed modifiers for all attributes, but that have the undesired consequence of undefining unit and displayUnit.
Undefining everything that isn't in the type would be counter-intuitive and sometimes fail to remove start-values and sometimes remove displayUnit.
Note that there is no requirement that the undefined modification actually override something.

# Required Patents
No patents needed.
# References
