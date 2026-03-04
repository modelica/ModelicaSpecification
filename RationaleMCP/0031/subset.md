# Should Base Modelica be a strict subset of Modelica?

Base Modelica was mostly defined by subtraction, removing features from the Modelica language. However, for some specific reasons, some grammar
and language features were also added. This is seen as problematic by some working group members, whose requirement is for Base Modelica
to be a strict subset of Modelica, to avoid the need of having two separate parsers, etc. 

This (editable!) document summarizes the parts of Base Modelica which are not Modelica, as a basis for discussion in the working group and in ticket [#3539](https://github.com/modelica/ModelicaSpecification/issues/3569).

## References:
- [Base Modelica grammar](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/grammar.md) defined starting
  from the Modelica grammar by striking out the removed parts. Unfortunately, additions to the Modelica syntax are not specifically identified.
- [Differences](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md) between Base Modelica and Modelica.

## List of Base Modelica constructs not in Modelica
1. [Implicitly declared guess value parameters](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#implicitly-declared-guess-value-parameter)  `guess('x')`, defined by `parameter equation` declarations, with priority defined by `priority()` initial equations.
2. [Explicitly declared clock partitions](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#clock-partitions): the Base Modelica exporting tool is expected to carry out the synchronous system partitioning; partitions and sub-partitions, each with its respective clock, are declared explicitly in the Base Modelica model, so that the importing tool is spared the pain of taking care of that.
3. [constsize() expressions](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#the-constsize-expression)
   are meant to declare that flexible array inputs to function have constant size.
4. [pure constant](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#pure-modelica-functions) functions,
   a further restriction of pure functions.
5. [Subscripting of parenthesized general expressions](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#pure-modelica-functions) which is needed to represent the result of certain flattening operations, e.g., the inlining of function calls. In fact, this has already been addressed in the draft MSL 3.7, [Section 10.5](https://specification.modelica.org/master/arrays.html#array-indexing) and [PR #3395](https://github.com/modelica/ModelicaSpecification/pull/3395), so this is already part of Modelica.
6. [No protected section in function declarations](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md#protected). Base Modelica doesn't have a protected section for non-input, non-output variables in functions, since anything that is not input or output is assumed to be a local variable. In fact, the protected keyword was outright removed from the [grammar](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/grammar.md). Hence, Base Modelica functions with non-input, non-output variables are invalid in Modelica, because those variables are not explicitly declared as protected.
