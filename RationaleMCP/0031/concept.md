# Concept of Flat Modelica

Flat Modelica is a language to describe hybrid (continous and discrete) systems with emphasis on defining the dynamic behavior. 
It is an integral part of the Modelica specification, not a new separate standard. 

Use cases are:
* serves as intermediate stage in the Modelica specification
* describe equations occuring in intermediate stages during the transformation process from a Modelica model to an executable model
* separation of front end matters (the high level constructs of the Modelica language) from back end matters (simulation semantics) in the Modelica specification
   * to define structural transformations of Modelica (front end)
   * to define equation transformations (back end)
* support of compiler debugging
* external tools may use it to exploit the equations system further. 
* creation of models by humans 
* support of research on dynamic systems
* speedup the development process of new features of Modelica

In a first step we only concentate on structural transformations and keeping all information from that.

## Design Rules 

There are simple general rules for the design of Flat Modelica:

* The syntax is a subset of Modelica syntax with some extensions.
* Everything which has direct influence on the simulation results in an ideal mathematical sense has a special syntactical construct in the language.
* Information which has no direct influence to the result are handeled uniformly by one syntactical construct called annotation. For example, this applies to
   * prefixes
   * attributes of variables 
   * information lost in preceding transformation steps,
   * information to control further transformation steps,
   * information to support the numerical solution of the equation system
   * source code location information, 
   * other data for special use cases, e.g. packaging into a FMU, inputs and outputs of the whole model.
* Description strings (also called syntactic comments) are an exception. These are optionally copied as such.
* An external tool does not need any knowledge of special Modelica semantics, e.g. handling start attributes, behavior of relations and built-in operators for events,etc..

## Details

* All higher level syntactical and structural contructs of Modelica are removed, such as:
   * imports
   * inheritance
   * redeclarations
   * nested class definitions (There is no class definition inside another class definition)
   * packages, [expandable] connectors, models (only one model remains), blocks, operator definitions
   * functional inputs of functions
   * conditional declarations
   * modifications (therefore no merging of them)
   * connect statements
   * loops inside equation sections
   * `if`/`then`/`else` in equation sections (atleast with different sized branches)
   * `when` clauses
   * stream operators: `actualStream(...)`, `inStream(...)`
   * all prefixes, except `input` and `output`
* __TODO__ synchronous Modelica extensions, including state machines, possibly introduction of partitions

### Names

* Names are defined as the `IDENT` token in Modelica
* The hierarchy of the Modelica model is encoded into the names of the variables and types by separation of the levels by a dot.
* Names from Modelica are generally enclosed in single quotation marks, whether or not they contain a dot.  
* Generated helper variables do not need single quotes. 
* __TODO__: array components, combining names for helper variables

### Types

* Following types exist:
   * predefined types: `Real`, `Integer`, `Boolean`, `String`, `ExternalObject`,
   * record types
   * functions
   * simple types.
   
* Properties of record definitions are:
   * The components are defined as variable definitions. Declaration equations are not allowed.
   * There are no equations or algorithms.
   * record definitions can not nest.
   * There is no automatism to generate record constructors anymore. They have to be made explicit as functions.

* Simple types are aliases to predefined types enriched with annotations. 
   * They are used to avoid duplication of annotations in variable definitions. 
   * An annotation of a variable definition overrides the same annotation of the type.
   * They have no dimension.

* The order of definition is not important.

### Variables

* A variable definition consists of
   1. a prefix (e.g. `input`,`output`),
   1. a type name,
   1. a variable name
   1. an optional dimension specification,
   1. an optional declaration equations,
   1. an optional description string and
   1. an optional annotation.
* The dimension of an array is defined by a list of dimension sizes inside square brackets, e.g. `[2,3]`. The dimension sizes are allowed to be: 
   * integer literals,
   * `:`. In this case is determined from the dimension of the right side of the declaration equation, if exist and if it is possible. If not, the size is seen as unknown and no subscription is possible.
   * Only in functions: expressions containing literals and references to input parameters and other (predefined) pure functions
* Parameters and Constants from Modelica are mapped to variables with special annotations.
* It is assumed, that constants and parameters of the Modelica model was evaluated already evaluated if needed, i.e. because dimensions or branches or loops in equations depend from them.
* fixed start attributes are converted to initial equations, non fixed start attributes to annotations

### Expressions

* Expressions are defined as in Modelica.
* There are the predefined operators and functions of Modelica and some more to support runtime behavior, e.g. event handling
* There is no implied behavior of relations and builtin operators with regard to event handling any more. All has to be made explicit by introduction of helper variables and equations.
* The operators `pre(...)`, `previous(...)`, `sample(...)`, `delay(...)`, `spatialDistribution(...)` have the same semantics as in Modelica.
* Function calls have no default arguments, all must be explicitly specified in the correct order. There are no named arguments.

### Equations and Algorithms 
* Equation and algorithm sections are defined as in Modelica, including initial equations and algorithms.
* extension: equation and algorithm sections may have a dimension (to retain the information about vectorized components).
* There is no special initialization semantics of algorithms as in Modelica (this has to be made explicit by assignments)
* there are no `when` clauses in equaitons and algorithms. They must be transformed in if/then/else clauses.

### Functions

* Functions are defined as in Modelica.
* They contain exactly one algorithm section.
* Partial functions are not allowed.
* Input argument variables do not have declaration equations. 
* Functions may have an external specification, referring to some external resources (e.g. shared libraries, files etc.).
* If a function has functional inputs, for each different call a new function type without them is generated. _(this can be relaxed later if functional types are introduced)_

### Annotations

* Annotations are defined as in Modelica.
* They are `<name> = <expression>` pairs with hierarchical structure,
* An annotation can have sub annotations, which are a recursive list of annotations inside parenthesis, separated by colons.
* There are many more defined annotation names than in Modelica to hold additional information.

### Model Description
* A model description file is self contained. Apart from external resources (e.g. shared libraries), no further information is required.
* A model description contains
   * optional type definitions of
     * simple types
     * enumerations
     * records
     * functions
   * the model itself with
     * variable declarations of predefined and types defined in the model description; they may have dimension and a declaration equation 
     * (initial) equation sections
     * (initial) algorithm sections
     * annotations
   * Each element of the model may have attached annotations.
   * To have a frame around, all components are enclosed in `flat_model <name> ... end <name>;` (`<name>` is the name of the description)
   * In the first line, there is a comment with the version number of the Flat Modelica specification used throughout the model description.
