# Veriability-constrained types by example

As described in differences.md, a variability-constrained type is one where some record members have been declared with variability prefix (`parameter` or `constant` – `discrete` is currently _not_ an actual variability prefix in Modelica, but implies being discrete-time in a way that makes it impossible to use in a type).  In Flat Modelica, such types are only allowed in model component declarations, and this document gives examples of how this constraint be handled.

## Hierarchical representation of model structure

This model represents the typical situation in full Modelica, where parameters live side by side with time-varying variables at different levels of the component hierarchy:
```
model M
  model Resistor
    parameter Real r;
    Real i;
  equation
    i = 1 / r;
  end Resistor;

  parameter Real r1
  Resistor comp1(r = r1);
  Resistor comp2;
  Real i1 = comp1.i;
end M;
```

The same hierarchical structure can be represented in Flat Modelica:
```
record 'M.Resistor' /* Variability-constrained type */
  parameter Real 'r';
  Real 'i';
end 'M.Resistor';

model 'M'
  parameter Real 'r1'
  'M.Resistor' 'comp1'('r' = 'r1');
  'M.Resistor' 'comp2';
  Real 'i1' = 'comp1'.'i';
equation
  'comp1'.'i' = 1 / 'comp1'.'r';
  'comp2'.'i' = 1 / 'comp2'.'r';
end 'M';
```

For this use of a variability-constrained Flat Modelica record, there is typcailly no need to have a variability-free variant of the same type, and the interesting part is to verify that the Flat Modelica equations don't have illegal sub-expressions of variability-constrained type.  Consider the first equation,
```
  'comp1'.'i' = 1 / 'comp1'.'r';
```
To start with each occurrence of `'comp1'` (which has variability-constrained type) is in the form of a component reference.  The first of these, `'comp1'.'i'` is a continuous-time expression of type `Real`.  The other, `'comp1'.'r'` is a parameter expression of type `Real`.  That is, `'comp1'.'r'` does not have variability-constrained type; it is just a normal expression having parameter variability.  Hence, there are no illegal occurrences of sub-expressions of variability-constrained type.

## Records with the same constrain on all members

An easy example to start with is a record that is only meant to be used for parameters (such records can be found, for example, in `Modelica.Electrical.Batteries.ParameterRecords`):
```
model M
  model Parameters
    parameter Real x;
    parameter Real y;
  end Parameters;

  parameter Parameters[2] data = {Parameters(1, 2), Parameters(3, 4)};
  Analog.Basic.Resistor[2] r(final R = data.x, final T_ref = data.y);
end M;
```

(Someone has to remind us why the `data` was additionally declared `parameter`.)

In this case, there seems to be no need to preserve the variability-constraints in the Flat Modelica type:
```
record 'M.Parameters'
    Real 'x';
    Real 'y';
end 'M.Parameters';

model 'M'
  parameter 'M.Parameters'[2] 'data' = {'M.Parameters'(1, 2), 'M.Parameters'(3, 4)};
  'Analog.Basic.Resistor'[2] 'r'('R' = 'data'.'x', T_ref = 'data'.'y');
end 'M';
```

## Record including its own array dimension

TODO: Example with time-varying polynomial.
