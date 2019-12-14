# Annotations

## Use of annotations vs attributes
This section describes the design question of when to use an annotation and when to use a first class attribute in the language.

### Design guidelines
The following guideline shall be applied when determining whether to use an annotation to convey information in Flat Modelica:
- Information kept in annotations in Modelica shall remain annotations in Flat Modelica.

There are no design guidelines for how to convey information needed for Flat Modelica when there is no counterpart in Modelica.  Design decisions will be have to be made case by case.

### Rationale
With the flexible structure of annoations, it is possible to use annotations for anything that could also have been a first class attribute in the language.  These are the main arguments for and against the proposed guidelines versus a restriction not not use annotations for anything that may impact symbolic or numeric processing:
- (+) Some Modelica users would be suprised to find out if something like `GenerateEvents = true` (which is an annotation in Modelica) wasn't an annotation in Flat Modelica.
- (+) Disregarding annotations allows users non-Modelica background to not be put off by things such as `LateInline` that they don't have an intuition for.
- (-) Seeing the annotations that impact the simulation result among all other information stored in annotations will require tool support beyond simply collapsing all annotations.
- (-) The (overly) flexible structure of annoatations makes it harder to detect mistakes, whereas the exact syntax of primitive language constructs could have been expressed in the language grammar.


## Summary of Flat Modelica annotations
These are all the non-vendor specific annotations that may influence the code generation process
- `Evaluate` — Applied to a parameter, indicates that the parameter should be constant-evaluated
- `Inline` — Applied to a function, indicates it should be inlined
- `LateInline` — Applied to a function, indicates it should be inlined after symbolic transformations have been performed
- `InlineAfterIndexReduction` — Applied to a function, indicates it should be inlined after differentiation for index reduction and before other symbolic transformations are applied
- `GenerateEvents` — Applied to a function, indicates that zero crossing functions inside the function algorithm should generate events (e.g. by inlining the function)
- `smoothOrder` — Applied to a function, indicates the function is N times continuously differentiable, allowing it to be symbolically differentiated
- `derivative` — Applied to a function, points to the total derivative function
- `inverse` — Applied to a function, points to the inverse function

These are all the non-vendor specific annotations that are relevant for parameter input and simulation output
- `hideResult` — Applied to a parameter or variable, implies the variable should not be included in the simulation output
- `choices` — Applied to a parameter or variable, can be used to enumerate and tag different values for parameter input


## Vendor annotations
Flat Modelica allows for vendor-specific annoations in the same way as in full Modelica.
