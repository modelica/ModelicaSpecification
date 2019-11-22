# Annotations

## Use of annotations vs attributes
This section describes the design question of when to use an annotation and when to use a first class attribute in the language.

### Design alternatives
With the flexible structure of annoations, it is possible to use annotations for anything that could also have been a first class attribute in the language.  In Modelica, the principle for when one may use an annotation has been roughly to use an annotation whenever it doesn't have an impact on the simulation result.  The question is what principle to use in Flat Modelica.

Possible alternatives being discussed are:
- Only use annotations for information that has no impact on the simulation result (possibly applying this rule more strictly than for Modelica).
- Use annoations for anything that isn't necessary to convey the very basic structure of equations and variables.

Main arguments for and against the difference approaches:
- Users with non-Modelica background may be put off by large amount of attributes that they don't have an ituition for.
- For a Modelica user, it is unexpected to find things that impact the simulation result hidden away in annotations.
- The (overly) flexible structure of annoatations makes it harder to detect mistakes.

### Chosen design
To be discussed…


## Summary of Flat Modelica annotations
These are all the non-vendor specific annotations:
- `Constified = true` — For a Flat Modelica `constant` that was declared with a different variability in the original Modelica code.  (This item is just an example at this point, the details of how to express this hasn't been discussed yet.)


## Vendor annotations
Flat Modelica allows for vendor-specific annoations in the same way as in full Modelica.
