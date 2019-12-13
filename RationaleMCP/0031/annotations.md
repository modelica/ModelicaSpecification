# Annotations

## Use of annotations vs attributes
This section describes the design question of when to use an annotation and when to use a first class attribute in the language.

### Design guidelines
The following guidelines tell when to use or not to use annotations in Flat Modelica:
- Whenever possible, primitive language constructs such as built-in attributes should be used for anything that shall have or may have an impact on symbolic processing or numeric solving of the equations.
- Annotations should be used for things that have no impact on symbolic processing or numeric solving of the equations.  (In Modelica, `displayUnit` doesn't follow this rule, so it isn't obvious that the rule should be followed strictly in Flat Modelica either.)
- For now, annotations are acceptable for attaching any sort of information at the class level, such as the inlining hints of a `function` class.  However, alternatives could be considered ([see below](#class-properties)), as it would simplify understanding of Flat Modelica if one could safely say that annotations can always be disregarded for purposes of symbolic processing or numeric solving.

### Class properties
Regarding the use of annotations a the class level, it should be noted that Flat Modelica can be more easily extended without breaking backwards compatibility, compared to full Modelica.  The reason is that the identifier naming scheme can be designed so that keywords can easily be introduced without conflict with name spaces for user variables etc.

As an example, instead of using a class annotation for the `GenerateEvents` and `derivative` of a `function` class, other possible designs that don't make abuse of annotations include:
```
function f
  (
    GenerateEvents = true,
    derivative(zeroDerivative = k) = f_der,
    derivative = f_general_der
  )
  input Real x;
  input Real k;
  output Real y;
algorithm
  …
end f;
```
and
```
function f
  input Real x;
  input Real k;
  output Real y;
algorithm
  …
attribute
  GenerateEvents = true;
derivative
  f_der(zeroDerivative = k);
  f_general_der;
end f;
```

Note that the examples above are just examples to illustrate that there are alternatives to using class annotations when designing Flat Modelica.  The actual design of what to do with `function` properties is outside the scope of this document.

### Rationale
With the flexible structure of annoations, it is possible to use annotations for anything that could also have been a first class attribute in the language.  These are the main arguments for and against the proposed guidelines versus more extensive use of annotations:
- (+) For a Modelica user, it is unexpected to find things that impact the simulation result hidden away in annotations.
- (+) The (overly) flexible structure of annoatations makes it harder to detect mistakes, whereas the exact syntax of primitive language constructs can be expressed in the language grammar.
- (-) Users with non-Modelica background may be put off by large amount of attributes that they don't have an intuition for.
- (-) Some Modelica users would be suprised to find out if something like `GenerateEvents = true` (which is an annotation in Modelica) wasn't an annotation in Flat Modelica.

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
