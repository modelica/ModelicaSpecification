# Modelica Change Proposal MCP-0037<br/>Generalized Modelica URIs
Henrik Tidefelt

**(In Development)**

## Summary
This MCP defines the next generation handling of external resources in Modelica.  The current forms of a Modelica URI have a problem with the case insensitivity of the _host_ part of the URI, so they need to be replaced one way or another.  This MCP takes the opportunity to combine a solution to the case insensitivity problem with a few other improvements to the Modelica URIs as well as handling of external resources more generally, see [below](#Rationale).

## Revisions
| Date | Description |
| --- | --- |
| 2020-07-22 | Henrik Tidefelt. Filling this document with initial content. |
| 2023-03-23 | Henrik Tidefelt. Updates after design meeting discussions. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
This MCP consists of three parts:
- `resolveURI` a new operator with function syntax to replace the MSL function `loadResource`, see [separate document](resolve-uri.md).
- New forms of Modelica URIs, see [separate document](modelica-uris.md).
- New structure for storing external resources with a Modelica class on a file system, see [separate document](resource-directory.md).

See [#2387](https://github.com/modelica/ModelicaSpecification/pull/2387) for an extensive early discussion about the goals for this MCP.  Since then, the [MCP for figure annotations](https://github.com/modelica/ModelicaSpecification/pull/2482) has matured, adding new use cases for referencing resource within and across classes.

Having `resolveURI` in the Modelica Language Specification instead of `loadResource` in the Modelica Standard Library is the natural place for the basic utility for dealing with a concept entirely defined in the Modelica Language Specification.  In addition, making it an operator with function syntax means we can use it to resolve Modelica URIs in ways that aren't possible with a normal function.

Besides addressing the problem with case insensitivity of the _host_ part of a URI, the new forms are designed to address two major shortcomings of the current forms of Modelica URIs:
- A class should be able to refer to its own resources without hard-coding its own fully qualified name.
- References to special views of a class (_icon_, etc) shouldn't interfere with user-defined anchors and fragment specifiers.  Instead, Modelica URIs must have a flexible form allowing for new kinds of resources attached to a class, for example:
  - Figures and plots.
  - Figure style sheets (topic for future MCP).
  - Named experiments (topic for future MCP).
  - A component of the instantiated class.

The file system storage of external resources together with a Modelica class makes use of a new, special, directory name for external resources, removing ambiguity in how to reference an external resource, as well as making it easier to determine which parts of a file system hierarchy that might contain external resources.

## Backwards Compatibility
Introducing the new operator with function syntax `resolveURI` means that Modelica code using this name for other purposes will break.  However, the name is unlikely to be in use in existing Modelica libraries.

The new Modelica URIs are distinct from the existing Modelica URIs, making this part of the MCP fully backwards compatible.

The new file system storage structure uses a directory name that couldn't be the name of a Modelica class.  Hence, the only kind of backwards incompatibility caused by this part of the MCP would be if a Modelica class is already using that name in the file hierarchy for something else.  Again, the name is unlikely to be used in existing Modelica libraries.

## Tool Implementation

### Experience with Prototype
None yet.

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
