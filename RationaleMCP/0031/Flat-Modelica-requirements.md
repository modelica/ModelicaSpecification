# Requirements on Flat Modelica
This document should contain a first draft of the requirements on what Flat Modelica should and shouldn't be, to be used as a starting point for discussions at the upcoming design meeting in Regensburg on March 7-8, 2019.  It also contains a rough separation of things belonging to the three main parts of the Modelica Language Specification (MLS) that would come out of this MCP.

## Flat Modelica features

Things that the Flat Modelica format should support:
- Basic scalar types with the same attributes as in Modelica.
- Record and enumeration types.
- Arrays.
- Component declarations (with both public and protected visibility).
  - Comment (@mtiller): It doesn't seem very flat if we preserve (potentially deeply nested) components instances
- Equations and algorithms, both scalar, array-valued, and record-valued.
- Optional source locations for use in error messages.
   - Add this to the formal grammar?  If so, this will require some thought in order to be flexible and precise enough without interfering with too much with the rest of the grammar.
   - Add this as standard annotations?  Already supported by current grammar. (@mtiller)
- Documentation strings.
- Vendor-specific annotations.
  - Comment (@mtiller): So annotations are present in the grammar but all annotations except vendor annotations are stripped.  If the concern is bloat from annotations that are no longer relevant in the flattened form (*e.g.,* graphical annotations), why not identify what gets excluded vs. what gets included? (see comment about source locations above)
- All variabilities, but constant evaluation of parameters is not allowed.  (For example, this guarantees that all parameters will remain parameters if a Flat Modelica model is exported to an FMU for Model Exchange.)
  - Comment (@mtiller): The semantics of this are unclear.  When you say constant evaluation, do you mean constant folding?  What about `final` parameters?  Should those be parameters in an FMU? I wouldn't think so.  It seems like they should just be `output`s. 
- List of all `parameter` variables that were treated as `constant` due to use in _parameter expressions_, the `Evaluate=true` annotation, or subject to constant evaluation during flattening for other reasons.
  - Comment (@mtiller): Why not just add an `Evaluate=true` annotation to indicate these.
- Values for all constants, even those that have been inlined everywhere, since the values should be part of the simulation result.
- Less restricted forms of record field access and array subscripting?
  - Comment (@mtiller): Wouldn't we expect to restrict forms of record field access and array subscripting?  If so, then I would suggest saying "Restrict some forms of record field access and array subscripting" or "A more restrictive subset of record field access and array subscripting".
- Efficient handling of large constant arrays (constant evaluation is not an option, since the same large array literal might then be repeated in many places).
  - Comment (@mtiller): Factor out constant subexpressions to unique variables?  Perhaps filter all literals (scalars and arrays) completely out of the flattened form and provide them in a separate file?
- Expressions for all variables that were treated as aliases during flattening, specifying the variable that it is an alias of and the sign of the relationship
  - Comment (@mtiller): Doesn't the expression already tell us all that (*e.g.,* `b = -a`...`-a` is an expression and it tells us that `b` is an alias of `a` with the opposite sign?  Or did you want something more explicit?
- Function declarations that are utilised in the model.
  - Comment (@mtiller): Do we flatten the functions?  I say that because functions can use features like `extends` or `redeclare` in their definitions.  Presumably we want all that removed in a flattened form, no?

Examples of things that should be gone after flattening and shouldn't exist in Flat Modelica:
- Complex classes that may contain equations.
- Connectors.
- Conditional components.
- Un-balanced `if`-equations.
- Non-literal array dimensions (except in functions).
- Packages.
- Connect equations.
- Graphical and documentation annotations.
- All redeclarations
- Anything overloaded
- Imports
- Extends clauses?
- Hierarchical modifications?
- Package structure?
  - If you keep components, restrict class definitions to a flat global namespace to avoid having to apply lookup rules.

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

## An alternative view of grouping Modelica semantics (@mtiller)

One advantage to this approach would be to organize the semantics of Modelica by when they apply.  In this sense, I'd like to see a description of:

- Semantics needed in order to create a Modelica editor
  - Package structure
  - Name lookup
  - Graphical appearance
  - Connection semantics
  - Inheritance
- Semantics needed to represent mathematical structure and behavior
  - Variables
  - Equations
  - Functions
  
From this perspective, expressions can almost be treated as "pass through".  The editor doesn't really need to
interpret them in any way. For the most part they just pass through to the flattened form (but with some
potential simplifications or restrictions, as described above).
