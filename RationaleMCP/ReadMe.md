
# MCP Rationale
This directory should contain the rationale behind Modelica Change Proposals, MCPs,
(and possibly rationale behind other decisions as well). 

Each MCP should use a separate sub-directory based on the MCP-number.

## Template for MCPs

A template for the rationale of the MCP is found as either [Markdown](MCPTemplate.MD) or [Word](MCP_Template_Overview.dotx).

## Workflow

The workflow for all changes (including MCPs), and releases is described as part of the [Development Process](DevelopmentProcess.md).

New MCP should be added to the following list - on the main branch to keep track of them,
but the rest of the development on a branch/pull-request before being accepted.

## List of existing MCPs

|Status|Number|Name|Link|
-----------------------
|Active|0038|Initialization of Clocked Partitions|([MCP/0038](https://github.com/modelica/ModelicaSpecification/tree/MCP/0038/RationaleMCP/0038))|
|Active|0037|Generalized Modelica URIs|([MCP/0037](https://github.com/modelica/ModelicaSpecification/tree/MCP/0037/RationaleMCP/0037))|
|Active|0036|Setting states|([MCP/0036](https://github.com/modelica/ModelicaSpecification/tree/MCP/0036/RationaleMCP/0036))|
|Active|0035|Multilingual support of Modelica|([MCP/0035](https://github.com/modelica/ModelicaSpecification/tree/MCP/0035/RationaleMCP/0035))|
|Active|0034|Ternary|([MCP/0034](https://github.com/modelica/ModelicaSpecification/tree/MCP/0034/RationaleMCP/0034))|
|Added in 3.5|0033|Annotations for Predefined Plots|([MCP/0033](https://github.com/modelica/ModelicaSpecification/tree/MCP/0033/RationaleMCP/0033))|
|Active|0032|Selective Model Extension|([MCP/0032](https://github.com/modelica/ModelicaSpecification/tree/MCP/0032/RationaleMCP/0032))|
|Active|0031|Flat Modelica and MLS modularization|([MCP/0031](https://github.com/modelica/ModelicaSpecification/tree/MCP/0031/RationaleMCP/0031))|
|Suspended|0030|IsClocked Operator|([#2238](https://github.com/modelica/ModelicaSpecification/issues/2238))|

- MCP0029 License Export ([#2217](https://github.com/modelica/ModelicaSpecification/issues/2217))
- ~~MCP0028~~ Record Derivatives mixing Real and non-Real (added in Modelica 3.4) ([#2137](https://github.com/modelica/ModelicaSpecification/issues/2137))
- MCP0027 Units of Literal Constants (active) ([#2127](https://github.com/modelica/ModelicaSpecification/issues/2127))
- ~~MCP0026~~ Arc-only Ellipse (added in Modelica 3.4) ([#2045](https://github.com/modelica/ModelicaSpecification/issues/2045))
- ~~MCP0025~~ Functions with input output ([#2012](https://github.com/modelica/ModelicaSpecification/issues/2012))
- ~~MCP0024~~ Initialization of Clocked States (added in Modelica 3.4) ([#2007](https://github.com/modelica/ModelicaSpecification/issues/2007))
- ~~MCP0023~~ Model to Record (added in Modelica 3.4) ([#1953](https://github.com/modelica/ModelicaSpecification/issues/1953))
- ~~MCP0022~~ Integer to Enumeration (added in Modelica 3.4) ([#1842](https://github.com/modelica/ModelicaSpecification/issues/1842))
- MCP0021 Component iterators ([MCP/0021](https://github.com/modelica/ModelicaSpecification/tree/MCP/0021/RationaleMCP/0021))
- ~~MCP0020~~ Model as Arguments to Functions (added in Modelica 3.4)
- ~~MCP0019~~ Improvement of Flattening Description (added in Modelica 3.4) ([#1829](https://github.com/modelica/ModelicaSpecification/issues/1829))
- ~~MCP0018~~ Change specification format (done post Modelica 3.4)
- MCP0017 Portable import of FMUs
- MCP0016 Semantic Versions
- MCP0015 Language Version Header ([MCP/0015](https://github.com/modelica/ModelicaSpecification/tree/MCP/0015/RationaleMCP/0015))
- ~~MCP0014~~ Conversion (added in Modelica 3.4) ([#1622](https://github.com/modelica/ModelicaSpecification/issues/1622))
- ~~MCP0013~~ Introducing polymorphic functions
- MCP0012 Calling blocks as functions ([MCP/0012](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0012))
- ~~MCP0011~~ Allow user-defined functions in reductions
- ~~MCP0010~~ Adding guards to reductions
- ~~MCP0009~~ Undefined modification
- ~~MCP0008~~ Custom annotations
- ~~MCP0007~~ Match expressions
- ~~MCP0006~~ Atomic blocks
- ~~MCP0005~~ Equivalent parameters
- ~~MCP0004~~ Handling uncertainties (need to consider MCP0008)
- ~~MCP0003~~ User defined annotations (superseded by MCP0008)
- ~~MCP0002~~ Improved class generation
- ~~MCP0001~~ Improved parametrization

Note that the documents for older issues (especially the ones on hold) have not been transferred to GitHub, but are found on an older svn-server.
