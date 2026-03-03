# Should Base Modelica be a strict subset of Modelica?

Base Modelica was mostly defined by subtraction, removing features from the Modelica language. However, for some specific reasons, some grammar
and language features were also added. This is seen as problematic by some working group members, whose requirement is for Base Modelica
to be a strict subset of Modelica, to avoid the need of having two separate parsers, etc. 

This document summarizes the parts of Base Modelica which are not Modelica, as a basis for discussion.

References:
- [Base Modelica grammar](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/grammar.md) defined starting
  from the Modelica grammar by striking out the removed parts. Unfortunately, additions to the Modelica syntax are not specifically identified.
- [Differences](https://github.com/modelica/ModelicaSpecification/blob/MCP/0031/RationaleMCP/0031/differences.md) between Base Modelica and Modelica.

