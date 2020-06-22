# Initialization of variables

The concepts used to define how a variable is initialized are different in Flat Modelica compared to full Modelica.  What is described here is thus a replacement for what in Full Modelica is a combination of `final`, `start`, `fixed`, declaration equation, and `initial equation`.  The goal is to reduce the number of concepts involved, and making it more clear how the initialization problem is parameterized (that is, what freedom there is to steer the initialization after translation by setting initialization parameters).

The `initial equation` concept is the same in Flat Modelica as in full Modelica, and any `initial equation` in a full Modelica model will be preserved in the Flat Modelica model.  However, the Flat Modelica model may contain additional `initial equation` coming from the rewriting of other concepts.

Since a constant in Flat Modelica can always be evaluated during translation, constants are excluded from the current discussion of variable initialization.

## Causal equation

In the following, an equation in the form
```
equation /* or 'initial equation' */
  <var> := <expr>;
```
is an equation with prescribed causality, meaning that the perfect matching rule is only allowed to match the equation to the variable on the left hand side, and that the variability of `<expr>` must not exceed the variability of `<var>`.

## Full Modelica declaration equations

Since the presence of declaration equations are among the things adding to the complexity of variable initialization sementics in Full Modelica, the first step of transforming the initialization to Flat Modelica is to get rid of declaration equations for all variables except constants.  (Due to the special requirements on constants in Flat Modelica, it makes good sense to require a constant to be given by a declaration equation.)  A declaration equation is transformed into modification of `start`, an `initial equation` or a normal `equation`, depending on variability and `fixed`, as described below.

For a (full Modelica) variable with declaration equation and `fixed = true`, the only variability to consider is `parameter`.  Then, this combination has the special interpretation that the `start` shall be ignored in favor of the declaration equation, and there is (as defined currently) no way to set a guess value for the event that the parameter ends up in a nonlinear equation system.  Hence, the parameter (only writing out the default `fixed = true` for clarity)
```
parameter Real p(start = <foo>, fixed = true) = <binding>;
```
is transformed into
```
parameter Real p(start = <binding>, fixed = true);
```
Before applying this rewriting rule, one must first issue any warning in case `p` has a present `start` with `fixed = true` but no declaration equation.

If the `start` is removed in the example above, we get the most basic form of full Modelica parameter initialization:
```
parameter Real p = <binding>; /* (A parameter has fixed = true by default.) */
```
This is rewritten in the same way as when `start` was present:
```
parameter Real p(start = <binding>, fixed = true);
```

For a variable with declaration equation and `fixed = false`, the `start` is always a guess value, and the declaration equation simply moved to either `initial equation` (for parameters) or `equation` (otherwise).  This is done using a causal equation, so that variability checking isn't affected.  For example,
```
Real y(start = <guess>, fixed = false) = <binding>;
```
becomes
```
  Real y(start = <guess>, fixed = false);
equation
  y := <binding>;
```

## Parameterization of initialization

To describe parameterization of variable initialization in Flat Modelica, a Flat Modelica variable `'v'` has an associated parameter written as `start('v')`.  This parameter is not explicitly declared, any may or may not have an actual impact on the initialization depending on the initializability of `'v'`.  Since the initializability isn't known until after processing the equations of the initialization problem, the actual role of `start('v')` cannot be understood without a deeper analysis, and may even be tool-dependent (due to differences in equation tearing, etc).  The purpose of `start('v')` is just to make it more clear where there _could_ be a place to affect the initialization problem after translation.

Unless assigned in a causal equation, the `start('v')` of a variable with `start = <expr>` (explicit for the variable or coming from the type) has a hidden implicit equation, in pseudo-code:
```
start('p') := if userOverridesStart('p') then getUserStart('p') else <expr>;
```

Here `userOverridesStart` and `getUserStart` represent tool-specific ways to set parameters of the translated model's initialization problem.

The presence of `start('v')` is only conceptual; a tool may find that a single memory location is enough to represent both `'v'` and `start('v')`.

When a Flat Modelica variable `'v'` needs a guess value for initialization, the guess is always taken from `start('v')`.  Hence, any equation where `'v'` occurs has a hidden dependency on the causal equation for `start('v')`.

There is a problem if `start('p')` ends up being solved in a nonlinear equation system, as there is no way to provide a guess value.  Similarly, there is a problem if `start('p')` ends up in the same nonlinear equation system as `'p'`, as this means that the solution for `start('p')` won't be available in time to be used as guess value for `'p'`. We will return to the characterization of these problem below.


## Variability of `start`

The user interaction with the translated initialization problem is expressed through `start('p')` instead of through `'p'.start` doesn't mean that the variability of `start` no longer need to be parameter, as the expression for `start` may itself have non-constant variability.  Therefore, one should consider replacing the built-in attribute `start` with a something similar to `start('v')`, but for controlling the default expression in the hidden equation for `start('v')`.


## Reduction of `fixed`

We begin by considering variables with non-`final` modification of `start`.

A Full Modelica parameter with `fixed = true` (and no declaration equation) is interpreted in the simplest possible way, as Full Modelica provides no way of specifying the corresponding guess value:
```
parameter Real p(start = <exact>, fixed = true);
```
In Flat Modelica, the `start` attribute only provides the default for `start('p')`:
```
  parameter Real 'p'(start = <exact>); /* (Attribute has constant variability.) */
initial equation
  'p' := start('p'); /* May differ from 'start' attribute. */
```
(Since `start('p')` is assumed not being solved in a nonlinear equation system, the initializability of `p` is _exact_.)

Example 2: When the Full Modelica parameter as `fixed = false`, there will also be a corresponding equation somewhere else:
```
parameter Real p(start = <guess>, fixed = false);
```
In Flat Modelica all we need to do is drop the `fixed`, as the guess value for a variable in a nonlinear system is always `start('p')`:
```
  parameter Real 'p'(start = <guess>);
```
(A tool will need to analyze the equations in order to tell whether `start('p')` is ever used, marking the difference between `approx` and `calculated` initializability of `p`.)



## Rewriting of `final`

### Using causal equation

The rule above for introducing the hidden equation for `start('v')` was made so that a causal equation can be used to express `final` as follows.

First, `final` modification of `start` with `fixed = true`:
```
parameter Real p(final start = <exact>, fixed = true);
```
In Flat Modelica, the key part of the `final` can be expressed by bypassing `start('p')` in the `initial equation`:
```
  parameter Real 'p'(start = <exact>); /* As long as we don't know whether a guess value is needed, the 'start' must be kept. */
initial equation
  'p' := <exact>;
```
If the equation for `'p'` ends up in a nonlinear equation system, `start('p')` will still be used, but it could be acceptable that the Flat Modelica tool allows the user to modify `start('p')` as long as the solution still satisfies the `initial equation`.  A remedy to this is proposed below using a new built-in attribute `start_final`.


### Using built-in attribute `start_final`

By introducing a built-in attribute called `start_final` (`false` by default), the use of a causal equation assigning to `start('p')` can be replaced by a small modification of the hidden equation:
```
start('p') := if not 'p'.start_final and userOverridesStart('p') then getUserStart('p') else <expr>;
```

This way,
```
parameter Real p(final start = <guess>, fixed = false);
```
turns into
```
parameter Real p(start = <guess>, start_final = true);
```

For the case of `fixed = true`,
```
parameter Real p(final start = <exact>, fixed = true);
```
we get the choice of what value to set for `start_final`:
```
  parameter Real 'p'(start = <exact>, start_final = false); /* Allow guess value to be changed after translation. */
  parameter Real 'p'(start = <exact>, start_final = true); /* Don't allow changing guess value. */
initial equation
  'p' := <exact>;
```
