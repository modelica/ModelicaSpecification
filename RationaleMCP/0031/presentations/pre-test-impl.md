# Check before starting test implementation

Presentation to the Modelica Language Group to seek confirmation that it is meaningful to begin work on test implementations.


## Outline

### Introduction
- Activity start
- # of meetings
- # of PRs and/or commits
- mode of operation
- related publicly funded projects (EMPHYSIS, PHyMoS)
- Contributors

### Problem Statement
- complexity of the Modelica language
- compatibility issues
- tool dependent and incompatible flat Modelica outputs

### Solution approach
- Base Modelica
- <what is it?>

### Benefits
- Modelica Language Group perspective
 - ...
- Tool vendor perspective
 - ...
- End-user perspective
 - ...

### Base Modelica Design Goals

### Base Modelica Key Features
- Get rid of the obviously irrelevant parts of the grammar
- Get rid of connect equations
- Get rid of conditional components
- Get rid of unbalanced if-equations
- Array dimensions [Henrik]
- Define allowed forms of type aliases
- Allowing array subscripting on general expressions
- Investigate need for final
- More explicit initialization
- Get rid of record member variability prefixes constant and parameter
- Base Modelica types are constant
- Simplify modifications
- Simplify record construction and function default arguments
- Figure out what to do with synchronous features
- Source locations pointing back to the original Modelica code

### Base Modelica Examples

### Base Modelica Open Issues

### Outlook
- Feedback from the Modelica Language Group
- Test implementations (<tool list>)
- Refactoring of the Modelica Specification


## Slide content

### Base Modelica Key Features: Array dimensions

References:
- [Array size](../differences.md#array-size)
- [`constsize`](differences.md#the-constsize-expression), [rationale](../constsize.md)

Main points:
- In an array type, each dimension has a size that is either _constant_ or _flexible_
- Component declarations outside functions may only specify constant array sizes
- The `constsize`-expression allows expressing constant assertions on array dimensions
- In an array equation, the array type must have constant sizes
