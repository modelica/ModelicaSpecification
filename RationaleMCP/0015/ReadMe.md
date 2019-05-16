# Modelica Change Proposal MCP-0015<br/>Language Version Header
Peter Harman, Christoph Höger, Michael Tiller, Henrik Tidefelt

**(In Development)**

## Summary
During a recent design meeting, the topic of semantic version numbers was discussed.  A proposal was discussed to leverage the notions of compatibility from the semantic version specification.  However, it was recognized that if we did this, it would then be important for tools to know that these notions of compatibility were in effect.  Initially, there was a discussion of adding a special annotation to indicate that semantic versions were being used.  But it was recognized that if the tool knew what version of the language applied to the library, then this would be a more general solution since it could address other questions about language syntax and semantics.

Much of this was discussed in [Ticket 643](https://trac.modelica.org/Modelica/ticket/643).  This MCP is an attempt to generate a concrete proposal around the ideas discussed in that ticket.


## Revisions
| Date | Description |
| --- | --- |
| Version 0.0.0 | Peter Harman’s proposal which predates the MCP process. |
| Version 1.0.0 | Michael Tiller.  Initial draft written up based on discussions from June 2nd, 2015 web meeting and review of ticket 643. |
| Version 1.0.1 | Fixed some inconsistencies pointed out by Dag Brück. |
| Version 1.0.2 | Language fixes based on feedback from Michael Sasena. |
| Version 1.1.0 | Bringing this MCP to live again with input from Modelica Trac ticket discussions. |
| Version 1.1.1 | Fixed spelling. |
| Version 1.2.0 | Incorporating Trac ticket discussions from 96th design meeting. |
| Version 1.2.1 | Remove non-applicable _Contributor License Agreement_ section. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the _Modelica Contributor License Agreement_.

## Rationale
See separate documents:
* [Rationale](rationmale.md)
* [Proposed Changes in Specification](spec-changes.md)

## Backwards Compatibility
Requirements #4 and #5 in Section 1.4 state this as an explicit requirement, and Section 2.1 show that the requirement is satisfied.

## Tool Implementation
A minimal implementation of this MCP doesn’t require many changes to a tool:
* Decide to only use a single Modelica implementation.
* Figure out the language versions it is fully compatible with.
* Figure out the language versions to be rejected.
* Extract the language version information before starting to parse a file, and propagate language version information down through directory hierarchies.
* Issue warning or error unless there is perfect compatibility with the implementation.

Since the MCP in itself doesn’t affect the Modelica grammar or introduce any semantical changes, the tool can then proceed as before the implementation of this MCP unless a language version error was issued.

A more complete implementation might additionally:
* Write a language version comment in each new top level Modelica file it creates.
* Make it possible to change the language version from a graphical user interface.
* Provide language version conversion, to make change of language version for a file or library as smooth as possible, and inform the user when automatic conversion is not possible.
* Support simple cases of working with several incompatible language versions at the same time, by attaching the language version information to constructs with different semantics in different language versions.
* When saving a file after making changes, update the language version comment to correspond to the language implementation currently used to process the file, to avoid accidentally introducing Modelica code that is inconsistent with the language version comment at the time of reading the file.
* Be pedantic about not allowing constructs that didn’t yet exist in the declared language version, but that are accepted by a parser user to parse several different language versions.  This would make it possible to avoid changing the language version comment unless necessary after having made changes to a file (see previous item).


### Experience with Prototype
Unfortunately, implementing the above in a test implementation doesn’t say much about the MCP.  The real test is to rely on the language version comment when we introduce backwards-incompatible changes to the language in the future, for instance, when starting to make semantic interpretation of Modelica library version numbers in `version` annotations.

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References

Peter Harman (2011) _Indication of language version in file or class definitions_<br/>
https://trac.modelica.org/Modelica/ticket/643

Michael Tiller and language group (2014-) _MCP-0015: Language Version_<br/>
https://trac.modelica.org/Modelica/ticket/1726
