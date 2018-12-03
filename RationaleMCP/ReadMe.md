This directory should contain the rationale behind Modelica Change Proposals, MCPs, 
(and possibly rationale behind other decisions as well).

Each MCP should use a separate sub-directory based on the MCP-number.

The MCPs will be handled as pull-request also containing the actual specification changes, but
before focusing on that it is preferable to explain the reason for the changes, investigation of alternatives,
and give some indication of the implementation effort.

New MCP should be added to the following list - on the main branch to keep track of them, 
but the rest of the development on a branch/pull-request before being accepted.

The existing MCPs are:

- MCP0029 License Export
- MCP0028 Record Derivatives mixing Real and non-Real (added in Modelica 3.4), #2137
- MCP0027 Units of Literal Constants (active)
- MCP0026 Arc-only Ellipse (added in Modelica 3.4), #2045
- MCP0025 Functions with input output
- MCP0024 Initialization of Clocked States (added in Modelica 3.4), #2007
- MCP0023 Model to Record (added in Modelica 3.4), #1953
- MCP0022 Integer to Enumeration (added in Modelica 3.4), #1842
- MCP0021 Component iterators (active)
- MCP0020 Model as Arguments to Functions (added in Modelica 3.4)
- MCP0019 Improvement of Flattening Description (added in Modelica 3.4), #1829
- MCP0018 Change specification format (done post Modelica 3.4)
- MCP0017 Portable import of FMUs
- MCP0016 Semantic Versions
- MCP0015 Language Version Header
- MCP0014 Conversion (added in Modelica 3.4), #1622
- MCP0013 Introducing polymorphic functions
- MCP0012 Calling blocks as functions
- MCP0011 Allow user-defined functions in reductions
- MCP0010 Adding guards to reductions
- MCP0009 Undefined modification
- MCP0008 Custom annotations
- MCP0007 Match expressions
- MCP0006 Atomic blocks
- MCP0005 Equvialent parameters 
- MCP0004 Handling uncertainties (need to consider MCP0008)
- MCP0003 User defined annotations (superseded by MCP0008)
- MCP0002 Improved class generation
- MCP0001 Improved parametrization
