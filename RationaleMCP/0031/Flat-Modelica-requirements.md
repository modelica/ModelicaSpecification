# Requirements on Flat Modelica
This document should contain a first draft of the requirements on what Flat Modelica should and shouldn't be, to be used as a starting point for discussions at the upcoming design meeting in Regensburg on March 7-8, 2019.  It also contains a rough separation of things belonging to the three main parts of the Modelica Language Specification (MLS) that would come out of this MCP.

## Flat Modelica features

Things that the Flat Modelica format should support:
- Basic scalar types with the same attributes as in Modelica.
- Record and enumeration types.
- Arrays.
- Component declarations (with both public and protected visibility).
- Equations and algorithms, both scalar, array-valued, and record-valued.
- Optional source locations to for use in error messages.  (This will require some thought in order to be flexible and precise enough without interfering with too much with the rest of the grammar.)
- Documentation strings.
- Vendor-specific annoations.
- All variabilities, but constant evaluation of parameters is not allowed.  (For example, this guarantees that all parameters will remain parameters if a Flat Modelica model is exported to an FMU for Model Exchange.)
- List of all `parameter` variables that were treated as `constant` due to use in _parameter expressions_, the `Evaluate=true` annotation, or subject to constant evaluation during flattening for other reasons.
- Values for all constants, even those that have been inlined everywhere, since the values should be part of the simulation result.
- Less restricted forms of record field access and array subscripting?
- Efficient handling of large constant arrays (constant evaluation is not an option, since the same large array literal might then be repeated in many places).

Examples of things that should be gone after flattening and shouldn't exist in Flat Modelica:
- Complex classes that may contain equations.
- Connectors.
- Conditional components.
- Un-balanced `if`-equations.
- Non-literal array dimensions (except in functions).
- Packages.
- Connect equations.
- Graphical and documentation annotations.

## New organization of MLS
This MCP proposes separation of the MLS into the three parts outlined below.

### Shared features: Expressions and functions
Content of that should go into this section:
- Built-in functions.
- Expressions.
- External functions.
- User-defined functions.
- Restricted forms of record field access and array subscripting (some or all of the restrictions may be lifted for Flat Modelica).
- Unit expressions.
- Syntax for synchronous language elements and state machines.

### Flat Modelica
Content of that should go into this section:
- Overview of execution model for hybrid differential-algebraic equations.
- Simulation initialization and priority of non-fixed start attributes.
- Event generation, event iteration, and other discrete-time behavior.
- Semantics of synchronous language elements and state machines.
- Solving of mixed systems.
- Hints for inlining, state selection, etc.

### Modelica
Content of that should go into this section:
- All sorts of restricted classes and rules for how they may be used.
- Inheritance, modification, and redeclaration.
- Connectors, including stream connectors.
- Connect equations.
- Overloaded operators.
- Global and local balancing of equations and variables.
- Instantiation.
- Flattening.
