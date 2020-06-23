# Initialization of variables

The concepts used to define how a variable is initialized are different in Flat Modelica compared to full Modelica.  What is described here is thus a replacement for what in full Modelica is a combination of `final`, `start`, `fixed`, declaration equation, and `initial equation`.  The goal is to reduce the number of concepts involved, and making it more clear how the initialization problem is parameterized (that is, what freedom there is to steer the initialization after translation by setting initialization parameters).

The `initial equation` concept is the same in Flat Modelica as in full Modelica, and any `initial equation` in a full Modelica model will be preserved in the Flat Modelica model.  However, the Flat Modelica model may contain additional `initial equation` coming from the rewriting of other concepts.

Since a constant in Flat Modelica can always be evaluated during translation, constants are excluded from the current discussion of variable initialization.

## Causal equation

In the following, an equation in the form
```
equation /* or 'initial equation' */
  <var> := <expr>;
```
is an equation with prescribed causality, meaning that the perfect matching rule is only allowed to match the equation to the variable on the left hand side, and that the variability of `<expr>` must not exceed the variability of `<var>`.

When `<var>` is a parameter, it is illegal for the causal equation to end up in an equation system together with other equations.  This is a natural way to capture the full Modelica requirement that the must not be any cyclic dependencies between parameters.

When a causal equation exists with `<var>` on the left hand side, we say that `<var>` _has a causal equation_.  Determining the set of variables having causal equation just requires a scan of the model equations, and testing whether a variable has a causal equation then becomes a constant time operation.

## Flat Modelica variable initialization

The initialization of the `Real` variable `'v'` is described using the associated _initialization parameters_ `start('v')` and `guess('v')`.  The initialization parameters are not declared separately, but exist implicitly for any non-constant variable `'v'`.  (Here, `start('v')` takes the role of the full Modelica built-in attribute `start`.)  The only built-in attribute of `'v'` involved in the initialization process is the constant `Boolean` `start_final` which defaults to `false`.

The initialization parameters must be determined by causal initial equations.  When an initialization parameter doesn't have a causal equation, the following are used:
```
initial equation
  /* Default causal equation for start('v') */
  start('v') := 0.0;

  /* Default causal equation for guess('v') */
  guess('v') :=
    if not 'v'.start_final and userOverridesStart('v') then
      getUserStart('v')
    else
      start('v');
```

Here `userOverridesStart` and `getUserStart` represent tool-specific ways to set parameters of the translated model's initialization problem.

Similar to causal equations for parameters, a causal equations for an initialization parameter may not end up in an equation system together with other equations.  Among other, this means that solving for the initialization parameters will never require guess values for the initialization parameters themselves.

(Note that providing a non-causal equation that can only be solved for, say, `start('v')` will result in an overdetermined initialization problem, as the addition of the default causal equation will result in two equations that can only be solved for the same variable.)

Like in full Modelica, the initialization equations provided by a Flat Modelica model are generally forming an underdetermined system of equations for the initialization of all variables.  The given equations are extended with default
equations in the following form, so that a well-determined (balanced) system of equations is obtained:
```
'v' := guess('v');
```
(The default equation could also be given as a non-causal equation, as the known existence of a causal equation for `guess('v')` implies that the default equation would only be possible to solve for `'v'`.)

In addition, if `'v'` needs a guess value for initialization, the guess is taken from `guess('v')`.  Hence, any equation where `'v'` occurs has a hidden dependency on the causal equation for `guess('v')`.  Since the causal equation for `guess('v')` will be solved with no other equations in the same equation system, this means that `'v'` is guaranteed to not end up being solved in the same equation system as `guess('v')`, and hence that any guess value will be computed by the time it is needed.

Whether the initialization parameters for `'v'` end up being used or not depends on the initializability of `'v'`.  Since the initializability isn't known until after processing the equations of the initialization problem, the actual role of `start('v')` and `guess('v')` cannot be understood without a deeper analysis, and may even be tool-dependent (due to differences in selection of default initialization equations, equation tearing, etc).

A simulation result is not required to contain values for any of the initialization parameters.  Hence, a tool may find that a single memory location is enough to represent both `start('v')`, `guess('v')`, and `'v'`.

### Flat Modelica parameter declaration equations

For convenience, a Flat Modelica parameter declaration may have a declaration equation,
```
parameter Real 'p' = <expr>;
```
This is a shorthand notation for the following initialization of the parameter:
```
  parameter Real 'p';
initial equation
  start('p') := <expr>;
```

**This is how it works:** First, `'p'.start_final` will determine whether `guess('p')` will be identical to `start('p')` or if the user can override `<expr>`.  Since the initialization of `'p'` is under-determined, a default initialization equation will be added, finally propagating `guess('p')` to `'p'` itself.

Note that the use of a declaration equation in Flat Modelica is not an option for a Full Modelica final parameter.  In Flat Modelica, this is expressed by giving an equation directly for `'p'`:
```
  parameter Real 'p';
initial equation
  'p' := <expr>;
```
Here, `start('p')` and `guess('p')` never come into play for the initialization of `'p'`.

## Reducing full Modelica initialization to Flat Modelica (IN PROGRESS)

### Full Modelica declaration equations

Since the presence of declaration equations are among the things adding to the complexity of variable initialization sementics in full Modelica, the first step of transforming the initialization to Flat Modelica is to get rid of declaration equations for all variables except constants.  (Due to the special requirements on constants in Flat Modelica, it makes good sense to require a constant to be given by a declaration equation.)  A declaration equation is transformed into modification of `start`, an `initial equation` or a normal `equation`, depending on variability and `fixed`, as described below.

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

### Reduction of `fixed`

We begin by considering variables with non-`final` modification of `start`.

A full Modelica parameter with `fixed = true` (and no declaration equation) is interpreted in the simplest possible way, as full Modelica provides no way of specifying the corresponding guess value:
```
parameter Real p(start = <exact>, fixed = true);
```
In Flat Modelica, the `start` attribute only provides the default for `start('p')`:
```
  parameter Real 'p'(start = <exact>);
initial equation
  'p' := start('p'); /* May differ from 'start' attribute. */
```
(Since `start('p')` is assumed not being solved in a nonlinear equation system, the initializability of `p` is _exact_.)

Example 2: When the full Modelica parameter as `fixed = false`, there will also be a corresponding equation somewhere else:
```
parameter Real p(start = <guess>, fixed = false);
```
In Flat Modelica all we need to do is drop the `fixed`, as the guess value for a variable in a nonlinear system is always `start('p')`:
```
  parameter Real 'p'(start = <guess>);
```
(A tool will need to analyze the equations in order to tell whether `start('p')` is ever used, marking the difference between `approx` and `calculated` initializability of `p`.)


### Rewriting of `final`

#### Using causal equation

The rule above for introducing the hidden equation for `start('v')` was made so that a causal equation can be used to express `final` as follows.

First, `final` modification of `start` with `fixed = true`:
```
parameter Real p(final start = <exact>, fixed = true);
```
In Flat Modelica, the key part of the `final` can be expressed by bypassing `start('p')` in the `initial equation`:
```
  parameter Real 'p'; /* No need to keep 'start' attribute. */
initial equation
  'p' := <exact>; /* Cannot be part of system of equations; won't need guess. */
```
If the equation for `'p'` ends up in a nonlinear equation system, `start('p')` will still be used, but it could be acceptable that the Flat Modelica tool allows the user to modify `start('p')` as long as the solution still satisfies the `initial equation`.  A remedy to this is proposed below using a new built-in attribute `start_final`.

For a non-parameter,
```
Real x(final start = <exact>, fixed = true);
```
the difference is that one also needs to keep the `start` attribute:
```
  Real 'x'(start = <exact>); /* As long as we don't know whether a guess value is needed, the 'start' must be kept. */
initial equation
  'x' := <exact>; /* May become part of system of equations; might need guess. */
```

#### Using built-in attribute `start_final`

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

For the case of `fixed = true`, first consider a parameter, where it is known that no guess value will be needed:
```
parameter Real p(final start = <exact>, fixed = true);
```
we don't need to keep the `start` attribute at all:
```
  parameter Real 'p';
initial equation
  'p' := <exact>; /* Won't need guess value. */
```

For a non-parameter,
```
Real x(final start = <exact>, fixed = true);
```
we can use `start_final` to express two alternatives for how to treat the guess value:
```
  parameter Real 'x'(start = <exact>, start_final = false); /* Allow guess value to be changed after translation. */
  parameter Real 'x'(start = <exact>, start_final = true); /* Don't allow changing guess value. */
initial equation
  'x' := <exact>; /* May need guess value */
```
