# Session on Flat Modelica at the 100th Modelica Design Meeting

## Agenda
* Introduction of eFMI Equation Code
* Align goals of eFMI with Flat Modelica MCP of MAP_Lang
* Discuss the prepared simple example: PID controller
* Next steps
 
 
## Introduction of eFMI EqCode

See ppt slides (https://emphysis.org/svn/EMPHYSIS/trunk/30_Work_Documents/WP3_eFMI-Standardization/WP3_1_Working_group_Eq-Code/eFMI_EqCode-Summary.pptx).

## Align goals of eFMI with Flat Modelica MCP of MAP_Lang
Comments:
Francesco: functions are crucial
Martin: Could be realized as call to C-function or inline.
Gerd: Flattened Modelica might need few extension, e.g. annotations for index reduction and tearing.

* EqCode is not the same as Flat Modelica, but we're heading in the same direction.
* The scope of EqCode is more narrow, never-the-less it makes sense to work on this in a joint effort considering EqCode as a MVP (minimal viable product) towards Flat Modelica.

## Discuss the prepared simple EqCode example: PID controller
Below only the first lines of code discussed during the meeting are listed. The file will be made available once we have decided how to manage this work on github.

```
flat_model PID

  type _Time Real (final quantity="Time", final unit="s");	
	
  parameter _Time 'period' = 0.1 "Period of clock (defined as Real number)";
  constant Boolean 'enbDiscretize' = true "discretize system?";
  input Real 'r' "Connector of Real input signal";
  input Real 'y' "Connector of Real input signal";
  parameter _Time 'periodicClock.period' = period "Period of clock (defined as Real number)";
```

### flat_model
* agreed to have a new kind of class

### type
enumerations require type declarations, but types could be limited to enumerations.
Having types requires handling of modifiers, but could be avoided by allowing modifications only for build-in attributes.

* Type declarations should be supported to avoid code repetition and improve readability.
* Support predefined scalar types: Real, Integer, Boolean.
	
### type names
* Should have leading "_" to avoid confusion with variable names and keywords, see name-mapping and related discussion pull 2389.

### parameter
How to treat a parameter without a value?
In this case the start value will be used, which is zero for Real.
Tools could restrict parameters having to have a value.
What is the meaning of a start value for parameters in the context of eFMI?

Side note (added after the meeting):
On ECU there are different kinds of initializations:
	- After power on the device is launched (start_up) all memory is brought into a state that is always the same no matter which state other devices are in. This means all inputs must be ignored.
	- After the launch the device can be initialized.
	- Anytime during operation the device can be re-initialized, e.g. after a certain event.

If the semantics of Moldelica cannot be mapped in reasonable way parameters could be handled by applying a restriction that requires parameters to have values for EqCode to avoid deviation of Flat Modelica from Modelica.
* topic should be revisited.

### variable names
* Always use quoted names according to name-mapping 
Example has been adopted accordingly.

## Requirements derived from the discussion
* Shall be a self-contained definition in a single file.
* Shall not be limited to scalars to enable efficient handling of multibody and similar.
* Flat Modelica shall be fully compatible with Modelica, no exceptions.
* EqCode can apply additional restrictions to Flat Modelica.

## Issues from github and emails

### [Michael Tiller] from github
Although I must say I disagree with the premise that Flat Modelica should be a subset of Modelica. It certainly doesn't need to be. You could reuse a huge amount of the grammar between them without having to prescribe this requirement. 
* Having Flat Modelica as a separate language will sooner or later lead to compatibility problems. Therefore we see good reasons to consider Flat Modelica as a subset of Modelica.


### [Hans] from github
I would say that there are two alternatives - either we standardize such a mangling syntax for names, or we allow the declaration of variables with hierarchical names in Flat Modelica.
* see above variable names

### [Henrik] from email
1) Flat Modelica needs to fulfill the needs to process full Modelica.  The Equation Code Language should then impose restrictions on what Flat Modelica it allows.  As an obvious example of this, Flat Modelica needs to allow functions with algorithmic bodies and side effects.  Other things that come to mind here include algorithms, looping constructs, if-equations, when-equations, when-statements, etc. 
* Agreed, see above Requirements.
	
2) There are many Modelica constructs that are not deeply involved in the complicated flattening process, and that need to be allowed also in Flat Modelica in order to preserve structure that is necessary for efficient handling of the equations.  These include record and array types. 
* Agreed, see above Requirements.
	
3) The "Identifier" section should probably be merged into the thing I did here:
https://github.com/modelica/ModelicaSpecification/pull/2389
I think the main topic here is the relation to array and record types.  Then, to avoid confusion, we need to make sure that example code isn't using any other form of identifier.  (To me, the examples under "Identifier" and "Variable name" seem to contradict each other.)

Questions
a) What is an "explicit declaration"?  What would a non-explicit ("reference") look like?
An explicit variable declaration is one that has the type declaration inline, vs. using referring to type name declared elsewhere.
 
b) Isn't "statically evaluatable" just the same as a constant expression?  (No need to introduce new terms.)
Good point. Will be adopted.
 
c) Why would "declare before use" be needed in a declarative setting such as Flat Modelica?
To be discussed.
 
d) Why remove "each"?  This would remove structural information that would just be tedious to recover for the tool processing Flat Modelica.
To be discussed.
 
e) Why restrict "der" to only operate on a "free variable"? 
To be discussed with Kai.
