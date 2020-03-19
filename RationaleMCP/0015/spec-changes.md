#  Proposed Changes in Specification

## Overview
We propose the use of a language version comment directly following the optional byte order mark at the first line of a Modelica source file.  The language version is the same throughout any class or package, is required to be declared in the file of the top level class, and must not appear in any other file of the same class or package.  That is, the one and only place where the language version shall be specified is either a top level _A.mo_ or a top level _A/package.mo_ file.  The entire line containing the language version comment shall match the follow regular expression where `\U+FEFF` denotes the byte order mark:
```
^\U+FEFF?//![ ]\d+[.]\d+[r.]\d+$
```

For example, this is a valid language version comment:
```
//! 3.4r1
```

A tool shall assume that any valid language version comment correctly describes the language version being used in a file, regardless whether the meaning of a language version comment is defined for the specified language version.

## Implementation notes
Let R be the language version where this MCP gets implemented.  Let V be the highest language version number that a tool is aware of.

Since the language version comment is mandatory as of language version R, there are two likely interpretations of a top level Modelica source file without a language version comment:
* The file uses some unknown language version prior to R.  With this interpretation, a tool may give a warning because it has to guess a language version prior to R, and the user can address the warning by adding a language version comment, possibly specifying a version prior to R.
* The user intends to use a language version where the language version comment is required, but failed to add it.  With this interpretation, a tool may guess that the user intented to use the highest language version supported by the tool, and give a warning about the missing language version comment.  Again, the user can address the warning by adding a language version comment.

The tool is expected to know about all existing language versions up to and including V, and for all versions it knows about, it is expected to have a course of action.  Possible actions may include:
* Rejecting the file with a message about no longer supporting the language version.
* Reject the file with a message about not yet supporting the language version.
* Mapping several language versions to the same implementation.

When given a valid language version comment, the language version may be unrecognized for two reasons:
* The language version in the comment higher than V.  In this case the tool may issue a warning about not yet being aware of the version and try using its implementation for version V, or be more precautious and just reject the file.
* The language version is lower than V, but not one which have actually existed (like 3.1r17).  In this case the tool may issue a warning about the invalid version and use heuristics to find a similar-looking version among the ones that have actually existed, or be more precautious and just reject the file.

Reviewing the [key requirements](rationale.md#key-requirements):
* (1).  The position right after the optional byte order mark is easy to locate.
* (2).  Parsing a valid language version comment only requires a very basic regular expression engine (available in any language), not a Modelica parser.
* (3).  The language version comment uses the syntax of a comment that is allowed in all versions of the Modelica language, so it is syntactically backward compatible.
* (4).  By just allowing a single language version to be given for each top level class, and not permitting tools to issue warnings unless there actually is a problem to use the specified version, Modelica file authors should only occasionally need to alter the language version comment.  The rest of the time, the language version comment can be hidden behind the graphical user interfaces of typical Modelica implementations.  Also, the use of inheritance of language version within a package hierarchy reduces the maintenance burden.
* (5).  The requirement of occupying an entire line, the exclamation mark, and the case-sensitive fixed part of the comment, and that the language version comment must appear on the first line in a file, all contribute to low risk of unintended specification of language version when using a language version prior to R.
* (6).  Avoiding verbose content such as Modelica-Version as part of the language version comment minimizes amount of typing needed when creating one-off Modelica source files with a text editor.
* (7).  The specified language version consists only of the three components major, minor, and patch; it is not possible to also include caveats such as _with non-standard elements from: Dymola_.  If a user insists on putting such information in the file, it needs to appear on a different line and will not be considered part of the language version comment.
* (8).  See above for possible courses of actions for a tool to take when it encounters a language version comment.
* ~~(9).  Each Modelica source file contains the specification of the language version it uses.~~
* (10). This comment is ignored except as the first line of a top-level package definition.

## Version Numbers
The version number in the language version comment is required to have a major, minor and revision/patch component.  The form matches all existing versions of the Modelica language, by extending any release called just x.y to x.yr0.
This proposal makes no claims about the meanings of the version number components.  However, we’ve chosen this particular form in the hopes that the Modelica language itself will eventually adopt a version numbering scheme that would make it possible to reason about the compatibility between two different versions (e.g., version x.y.z is (or is not) compatible with version a.b.c).

At the time of writing this MCP, the complete list of existing language versions in Appendix E is given below, showing that the number of different versions to be recognized is not overwhelming.

| Language version comment | Full version name |
|--|--|
| //! 1.0r0 | Modelica 1.0 |
| //! 1.1r0 | Modelica 1.1 |
| //! 1.2r0 | Modelica 1.2 |
| //! 1.3r0 | Modelica 1.3 |
| //! 1.4r0 | Modelica 1.4 |
| //! 2.0r0 | Modelica 2.0 |
| //! 2.1r0 | Modelica 2.1 |
| //! 2.2r0 | Modelica 2.2 |
| //! 3.0r0 | Modelica 3.0 |
| //! 3.1r0 | Modelica 3.1 |
| //! 3.2r0 | Modelica 3.2 |
| //! 3.2r1 | Modelica 3.2 Revision 1 |
| //! 3.2r2 | Modelica 3.2 Revision 2 |
| //! 3.3r0 | Modelica 3.3 |
| //! 3.3r1 | Modelica 3.3 Revision 1 |
| //! 3.4r0 | Modelica 3.4 |
