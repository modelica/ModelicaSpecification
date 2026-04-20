# MCP Rationale
This directory should contain the rationale behind Modelica Change Proposals, MCPs,
(and possibly rationale behind other decisions as well).

Each MCP should use a separate sub-directory based on the MCP-number.

## Template for MCPs

A template for the rationale of the MCP is found as either [Markdown](MCPTemplate.MD) or [Word](MCP_Template_Overview.dotx).

## Workflow

The workflow for all changes (including MCPs), and releases is described as part of the [Development Process](DevelopmentProcess.md).
After a release is accepted, follow the [check-list for a new release](NewRelease.md).

New MCP should be added to the following list - on the main branch to keep track of them,
but the rest of the development on a branch/pull-request before being accepted.

## List of existing MCPs

|Status|Number|Name|Documents|Issue|
|------|------|----|----|-|
|Active|0039|Licensing and encryption|[MCP/0039](https://github.com/modelica/ModelicaSpecification/tree/MCP/0039/RationaleMCP/0039)|https://github.com/modelica/ModelicaSpecification/pull/2931|
|Active|0038|Initialization of Clocked Partitions|[MCP/0038](https://github.com/modelica/ModelicaSpecification/tree/MCP/0038/RationaleMCP/0038)||
|Active|0037|Generalized Modelica URIs|[MCP/0037](https://github.com/modelica/ModelicaSpecification/tree/MCP/0037/RationaleMCP/0037)|https://github.com/modelica/ModelicaSpecification/pull/2663|
|Active|0036|Setting states|[MCP/0036](https://github.com/modelica/ModelicaSpecification/tree/MCP/0036/RationaleMCP/0036)|https://github.com/modelica/ModelicaSpecification/pull/3164|
|Accepted in [3.6](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.6)|0035|Multilingual support of Modelica|[MCP/0035](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0035)|https://github.com/modelica/ModelicaSpecification/pull/2956|
|Active|0034|Ternary|[MCP/0034](https://github.com/modelica/ModelicaSpecification/tree/MCP/0034/RationaleMCP/0034)|https://github.com/modelica/ModelicaSpecification/pull/2477|
|Added in [3.5](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.5)|0033|Annotations for Predefined Plots|[MCP/0033](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0033)||
|Accepted in [3.6](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.6)|0032|Selective Model Extension|[MCP/0032](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0032)|https://github.com/modelica/ModelicaSpecification/pull/3166|
|Active|0031|Base Modelica and MLS modularization|[MCP/0031](https://github.com/modelica/ModelicaSpecification/tree/MCP/0031/RationaleMCP/0031)|
|On hold|0030|IsClocked Operator||[#2238](https://github.com/modelica/ModelicaSpecification/issues/2238)|
|Active|0029|License Export|[MCP/0029](https://github.com/modelica/ModelicaSpecification/tree/MCP/0029/RationaleMCP/0029)|https://github.com/modelica/ModelicaSpecification/pull/2900|
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0028|Record Derivatives mixing Real and non-Real||[#2137](https://github.com/modelica/ModelicaSpecification/issues/2137)|
|Active|0027|Unit checking|[MCP/0027](https://github.com/modelica/ModelicaSpecification/tree/MCP/0027/RationaleMCP/0027)|[#3255](https://github.com/modelica/ModelicaSpecification/issues/3255) ([#2127](https://github.com/modelica/ModelicaSpecification/issues/2127))|
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0026|Arc-only Ellipse||[#2045](https://github.com/modelica/ModelicaSpecification/issues/2045)|
|On hold|0025|Functions with input output||[#2012](https://github.com/modelica/ModelicaSpecification/issues/2012)|
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0024|Initialization of Clocked States||[#2007](https://github.com/modelica/ModelicaSpecification/issues/2007)|
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0023|Model to Record||[#1953](https://github.com/modelica/ModelicaSpecification/issues/1953)|
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0022|Integer to Enumeration||[#1842](https://github.com/modelica/ModelicaSpecification/issues/1842)|
|Active|0021|Component iterators|[MCP/0021](https://github.com/modelica/ModelicaSpecification/tree/MCP/0021/RationaleMCP/0021)||
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0020|Model as Arguments to Functions|||
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0019|Improvement of Flattening Description||[#1829](https://github.com/modelica/ModelicaSpecification/issues/1829)|
|Added for [3.5](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.5)|0018|Change specification format|||
|Active|0017|Portable import of FMUs|||
|Active|0016|Semantic Versions|||
|Active|0015|Language Version Header|[MCP/0015](https://github.com/modelica/ModelicaSpecification/tree/MCP/0015/RationaleMCP/0015)||
|Added in [3.4](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.4)|0014|Conversion|[MCP/0014](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0014)|[#1622](https://github.com/modelica/ModelicaSpecification/issues/1622)|
|On hold|0013|Introducing polymorphic functions||
|Active|0012|Calling blocks as functions|[MCP/0012](https://github.com/modelica/ModelicaSpecification/tree/MCP/0012/RationaleMCP/0012)||
|On hold|0011|Allow user-defined functions in reductions|||
|On hold|0010|Adding guards to reductions|||
|Accepted in [3.6](https://github.com/modelica/ModelicaSpecification/releases/tag/v3.6)|0009|Undefined modification|[MCP/0009](https://github.com/modelica/ModelicaSpecification/tree/master/RationaleMCP/0009)|https://github.com/modelica/ModelicaSpecification/pull/3167|
|On hold|0008|Custom annotations|||
|On hold|0007|Match expressions|||
|On hold|0006|Atomic blocks|||
|On hold|0005|Equivalent parameters|||
|On hold|0004|Handling uncertainties (need to consider MCP0008)|||
|On hold|0003|User defined annotations (superseded by MCP0008)|||
|On hold|0002|Improved class generation|||
|On hold|0001|Improved parametrization|||

Note that the documents for older issues (especially the ones on hold) have not been transferred to GitHub, but are found on an older svn-server.
