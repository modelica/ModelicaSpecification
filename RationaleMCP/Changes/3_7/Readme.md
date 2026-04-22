# Changes in Modelica Language Specification 3.7

## New features

### Main highlights

- License annotation to automatically include license files in exported code, https://github.com/modelica/ModelicaSpecification/pull/2900
- Cleaner rules for variability:
  - Evaluable parameter, https://github.com/modelica/ModelicaSpecification/pull/2754
  - Additional discrete-time variability for functions and generalized delay operator
- Rules for pure functions improved to allow gradual introduction, https://github.com/modelica/ModelicaSpecification/pull/3755

### Variability - Evaluable

The fundamental definition of 'evaluable parameter' is in https://github.com/modelica/ModelicaSpecification/pull/2754
It defines parameters that could in principle be evaluated, compare the previously used informal term 'structural parameter' that corresponds to the sub-set of 'evaluable parameters' that has been evaluated.

Also:
- Used in the specification, https://github.com/modelica/ModelicaSpecification/pull/3383
- Some variable attributes must be evaluable, https://github.com/modelica/ModelicaSpecification/pull/3386
- Evaluable requirements are consistently applied across the specification https://github.com/modelica/ModelicaSpecification/pull/3861

### Variability - discrete-time

The previously introduced annotation GenerateEvents now implies discrete-time variability as if it were in a block and not a function [breaking change](3610.md), https://github.com/modelica/ModelicaSpecification/pull/3610 

Also:
- Similarly as in models equality between Reals is forbidden in such functions, https://github.com/modelica/ModelicaSpecification/pull/3825

The delay-operator is generalized to non-Reals and to generate events for significant discontinuities, https://github.com/modelica/ModelicaSpecification/pull/3730

### Pure function

Pure functions were introduced in Modelica 3.4.
- Rules for pure functions improved to allow gradual introduction, https://github.com/modelica/ModelicaSpecification/pull/3755

### Units and Quantities

- Unit handling generalized to non-integer exponents for rare cases:
  - Syntax for declaring such units, https://github.com/modelica/ModelicaSpecification/pull/3439
  - New nthRoot generalizing square root, https://github.com/modelica/ModelicaSpecification/pull/3439
- New SI prefixes, https://github.com/modelica/ModelicaSpecification/pull/3507
- Compatible non-SI units are listed, https://github.com/modelica/ModelicaSpecification/pull/3522
- Make absoluteValue inferred by default, https://github.com/modelica/ModelicaSpecification/pull/3645

### Visualization 

- Gradients in the graphical layers are now defined, https://github.com/modelica/ModelicaSpecification/pull/3789
- Texts on connection lines can now use Automatic alignment instead of relying on left-to-right drawing, https://github.com/modelica/ModelicaSpecification/pull/3845/
- Default icon graphics, https://github.com/modelica/ModelicaSpecification/pull/3624

### Documentation

- Stylesheets are supported, https://github.com/modelica/ModelicaSpecification/pull/3409
- Replace modelica:// by modelica: https://github.com/modelica/ModelicaSpecification/pull/3254
- Introduce EllipseClosure.Default https://github.com/modelica/ModelicaSpecification/pull/3655

### Plotting

- Logarithmic axis support, https://github.com/modelica/ModelicaSpecification/pull/3297
-Generalize vendor-specific markup in figures, https://github.com/modelica/ModelicaSpecification/pull/3630
- Define order within legend and plotting order, https://github.com/modelica/ModelicaSpecification/pull/3483--

### Balanced models

- Cleaner definition of local balance:
  - The local balance was clarified, https://github.com/modelica/ModelicaSpecification/pull/3750
  - The local balance of variables and equations now apply separately for each type, https://github.com/modelica/ModelicaSpecification/pull/3818
- Generalize stream connectors to records, https://github.com/modelica/ModelicaSpecification/pull/3358
- Connector classes don't have to be balanced, only used connector components, https://github.com/modelica/ModelicaSpecification/pull/3356
- Require evaluable ranges and conditions around 'connect', https://github.com/modelica/ModelicaSpecification/pull/3582

### Clocked

- Real interval clock is now similar to rational interval clock (bug fix), https://github.com/modelica/ModelicaSpecification/pull/3754
- Discretized non clocked, https://github.com/modelica/ModelicaSpecification/pull/3399
- Explain the delay for event clock https://github.com/modelica/ModelicaSpecification/pull/3567

### Cleaner semantics

- Vectorized min/max of two arrays, https://github.com/modelica/ModelicaSpecification/pull/3728
- Derivative are allowed in the left-hand-side of algorithms, https://github.com/modelica/ModelicaSpecification/pull/3838
- Generalize to allow Integer flow, https://github.com/modelica/ModelicaSpecification/pull/3408
- General record member referencing, https://github.com/modelica/ModelicaSpecification/pull/3516
- Generalize stream connectors to records, https://github.com/modelica/ModelicaSpecification/pull/3358
- size(A,j) defined as syntactic sugar for size(A)[j] https://github.com/modelica/ModelicaSpecification/pull/3792
- Define time as keyword, https://github.com/modelica/ModelicaSpecification/pull/3797
- Inherit experiment annotation, https://github.com/modelica/ModelicaSpecification/pull/2535
- Solvability for non-real equations, https://github.com/modelica/ModelicaSpecification/pull/3798
- spatialDistribution require that initialPoints span the range 0 to 1 (bug fix), https://github.com/modelica/ModelicaSpecification/pull/3648
- While loop event generation (bug fix), https://github.com/modelica/ModelicaSpecification/pull/3360
- Special cases for reinit function, https://github.com/modelica/ModelicaSpecification/pull/3568
- Define empty class and allow extends from empty base-class, https://github.com/modelica/ModelicaSpecification/pull/3362
- Show value of variables for asserts - to avoid having to use String-operator for that, https://github.com/modelica/ModelicaSpecification/pull/3641
- Uniform treatment of variables in initial algorithms (bug fix), https://github.com/modelica/ModelicaSpecification/pull/3562

## Breaking changes

- [GenerateEvents](3610.md)
- 

## Main readability improvements of the document

- The Tutorial is finally updated, https://github.com/modelica/ModelicaSpecification/blob/master/Tutorial.md
- The generated HTML-pages use MathML instead of MathJax - which should work better in modern browsers, https://github.com/modelica/ModelicaSpecification/pull/3877
- Links to all production rules in the grammar, https://github.com/modelica/ModelicaSpecification/pull/3863
- Cleaner terminology for clock partitions, https://specification.modelica.org/master/synchronous-language-elements.html#base-clock-and-sub-clock-partitions https://github.com/modelica/ModelicaSpecification/pull/3313

Note that minor changes (without any semantic impact) are not listed here.

The following should list all included changes:
https://github.com/search?q=repo%3Amodelica%2FModelicaSpecification+label%3AM37+is%3Apr&type=pullrequests

