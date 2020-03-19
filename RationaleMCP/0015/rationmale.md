#  Rational
The goal of this proposal is to allow Modelica library developers to inform tools about the particular set of language syntax and semantics that should be applied to Modelica source code.

## Limitations
This proposal does not address the potential need to express that a file is compatible with several language versions.  For example, even the most elementary model of Dahlqvist’s test equation will need to specify a single language version, even though it almost certainly will be compatible will all past and future language versions.

On the other hand, allowing multiple versions to be specified would come with a complicated maintenance burden for Modelica file authors that could only be handled with strong tool support.  The tool could then no longer just select one implementation for each file, but each such implementation would also need to be aware of all constructs that can’t be used (or that would have different semantics) in any of the other language versions that the file is declared to be compatible with.  As it doesn’t seem realistic to get this level of tool support, the language version specifications would end up being poorly maintained and not possible to rely on, which would defeat the purpose of this MCP.

This proposal does not allow a Modelica library stored in several files to use different language versions in the different files.  For a monolithic collection of sub-libraries, such as the MSL, this could become a problem if not all sub-libraries are equally actively maintained.  The benefit of not allowing multiple language versions in the same library is a significant reduction of complexity, both for defining the meaning of mixing constructs from different language versions, and for the implementation in a tool that would actually handle it properly.  In case the current restriction is found too limiting in the future, the only difference regarding the language comment itself would be to also allow it (in the sense of giving it the meaning of specifying lanugage version) deeper down in the package hierarchy.

## Use Case 1: Syntax Changes
Many times during the development of Modelica, the grammar of the language has been changed.  In some cases, this has been backward compatible.  But in other cases it has not been.  In order to know what grammar to use when parsing Modelica source code, it is necessary for the tool to know what version of the language specification applies to that source code.  Such information cannot be provided in an annotation because the annotation must be parsed (and the parser cannot yet be chosen).  So introducing a way to determine the language version without parsing any Modelica code is useful to address this issue.

## Use Case 2: Semantic Changes
Semantic changes in the language also occur.  For example, there is a proposal to move to semantic version numbering for libraries.  If we wish to transitively apply the semantic versioning semantics to Modelica libraries (thereby changing the semantics of the Modelica Language), tools need to know that those semantics are in effect.  Again, having a way to specify the language version informs tools of which semantics to apply.  To support this use case, tools would not need to have parallel implementations active, but simply make sure that the language version information of the library is available when resolving uses annotations pointing to the library.

## [Key Requirements](#key-requirements)
Based on discussion in [ticket 1726](https://trac.modelica.org/Modelica/ticket/1726) and the original formulation of this MCP, the requirements for a solution to address this issue are as follows:
* (1).  The information should be easy to locate.
* (2).  The information should be easy to parse — in particular not require parsing of full Modelica grammar.
* (3).  Backward compatibility with previous Modelica parsers.
* (4).  Minimal maintenance burden on Modelica file authors.
* (5).  Minimal amount of typing needed when editing files with a text editor.
* (6).  Low risk of unintentional specification of language version.
* (7).  Avoid promotion of non-standard variants of Modelica.
* (8).  A tool will be able to take reasonable action for any valid language version comment it encounters.
* ~~(9).  The information should be tightly coupled to the Modelica code it applies to (thereby avoiding synchronization issues).~~
* (10). It should only apply to top level packages (so each top-level package is written in exactly one version of Modelica).
