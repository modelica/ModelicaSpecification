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

These are all the non-vendor specific annotations inherited from full Modelica that may influence the code generation process:
- `Inline` — Applied to a function, indicates it should be inlined
- `LateInline` — Applied to a function, indicates it should be inlined after symbolic transformations have been performed
- `InlineAfterIndexReduction` — Applied to a function, indicates it should be inlined after differentiation for index reduction and before other symbolic transformations are applied
- `GenerateEvents` — Applied to a function, indicates that zero crossing functions inside the function algorithm should generate events (e.g. by inlining the function)
- `smoothOrder` — Applied to a function, indicates the function is N times continuously differentiable, allowing it to be symbolically differentiated
- `derivative` — Applied to a function, points to the total derivative function
- `inverse` — Applied to a function, points to the inverse function

These are all the non-vendor specific annotations inherited from full Modelica that are relevant for parameter input and simulation output:
- `HideResult` — Applied to a parameter or variable, implies the variable should not be included in the simulation output
- `choices` — Applied to a parameter or variable, can be used to enumerate and tag different values for parameter input

These are the new annotations introduced in Flat Modelica, each explained in more detail below:
- [`Protected`](#protected) — Indicate whether component declaration comes from protected section in original full Modelica model


### `Protected`

Form:
```
Boolean protected = false;
```

The `Protected` annotation is only allowed on a non-function component declaration.

The annotation does not come with any hard semantics, but can be useful for things such as:
- equation system tearing heuristics
- guiding which variable name to keep when performing alias elimination
- criterion for selection of which variables to include in the simulation result stored to file

When the Flat Modelica is generated from a full Modelica model, a component coming from a protected section (except inside functions) in the full Modelica model shall have the annotation `Protected = true` in Flat Modelica.
A component coming from a public section must not have the `Protected = true` annotation.

When the Flat Modelica is not generated from a full Modelica model, the `protected` annotation needs to be understood by comparison to the case of full Modelica origin.

For example, consider the following full Modelica model:
```
model M
protected
  parameter Real p = 1.0;
end M;
```

Note that `p` can only be modified when extending the model, and that the `Protected = true` annotation does not enforce this constraint in Flat Modelica.
Hence, the correct conversion to Flat Modelica needs to combine `Protected = true` with treatment similar to a parameter declared `final`:
```
model 'M'
  parameter Real 'p' annotation(Protected = true);
initial equation
  'p' = 1.0; /* From full Modelica protected declaration equation. */
end 'M';
```

Note that the `Protected = true` annotation doesn't tell at which level of the component hierarchy that the original protected section was, as shown by the following example:
```
model M
   Real x;
protected
   Real p;
end M;

model N
  M m1;
protected
  M m2;
end N;
```
In Flat Modelica, the level of the original protected section is lost:
```
package 'M'
  model 'M'
    Real 'm1.x';
    Real 'm1.p' annotation(Protected = true); 
    Real 'm2.x' annotation(Protected = true);
    Real 'm2.p' annotation(Protected = true);
  end 'M';
end 'M';
```


## Vendor annotations

Flat Modelica allows for vendor-specific annoations in the same way as in full Modelica.
