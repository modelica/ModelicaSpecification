# Modelica Change Proposal MCP-0034<br/>Ternary
Henrik Tidefelt

**(In Development)**

## Summary
It was concluded in [#2211](https://github.com/modelica/ModelicaSpecification/issues/2211) that an MCP for _Ternary_ (3-valued logic) in Modelica should be created, and here it is.

The proposal is based on the following principles:
- A new built-in type, `Ternary`.
- A new top-level constant `unknown` for the third truth value.
- Explicit as well as implicit conversion from `Boolean`.
- No implicit conversion to `Boolean`.
- No new built-in functions.

See [design](ternary.md) for details.

## Revisions
| Date | Description |
| --- | --- |
| 2019-11-22 | Henrik Tidefelt. Filling this document with initial content. |
| 2021-10-25 | Henrik Tidefelt. Introducing collection of examples. |
| 2023-03-24 | Henrik Tidefelt. Changing `unknown` to be top-level constant. |

## Contributor License Agreement
All authors of this MCP or their organizations have signed the "Modelica Contributor License Agreement".

## Rationale
See [separate document](rationale.md).

## Backwards Compatibility
As built-in types are treated similar to keywords, the introduced `Ternary` introduces a backwards incompatibility with code making use of that name for identifiers.
By introducing `unknown` as a top-level constant rather than a keyword, this will not break code making use of this name for identifiers.
By deprecating uses of `unknown` that wouldn't work if `unknown` was a keyword, it will be possible to later align the syntaxes of `true`, `false`, and `unknown`.

## Tool Implementation
A prototype has been implemented in a development version of Wolfram SystemModeler.  In the prototype, the type is named `__Wolfram_Ternary`, and the third truth value is named `__Wolfram_unknown`.  The prototype currently has `__Wolfram_unknown` as a keyword, but will be updated to have a top-level constant instead.

The prototype is complemented with a collection of example models, provided in a separate repository: https://github.com/henrikt-ma/TernaryTest

### Experience with Prototype
Although introducing a new built-in type is a change that ammounts to a large number of smaller changes, finding the places in a code base that need attention is easy due to the similarity between `Ternary` and `Boolean`.  In a similar way, the implicit conversion from `Boolean` to `Ternary` is a feature that can be implemented by glancing at the handling of implicit conversion from `Integer` to `Real`.

There are still a few examples in the collection that are not supported by the prototype.  Fixing the the last examples is work in progress and none of them seem tricky.

Regarding the application of this MCP to a new attribute called `visible` in the `Dialog` annotation, the proposed choice of defining `not`, `and` and `or` in accordance with Kleene logic certainly gets the job done.  The default value of `unknown` which means _apply tool-specific rules for visibility_, a user can easily write a ternary logical expression to override the default in either way, and the expression may also evaluate to `unknown` in cases where the user doesn't want to fall back on the tool logic.  Thanks to the implicit cast from `Boolean`, most uses of `visible` would probably be in the simple forms `visible = true` or `visible = false`.  However, upon closer acquaintance with the Kleene logic – which still appears as the most natural basis for defining the logical connectives for `Ternary` – it has been questioned whether this is the best way to model the absence of information, see [rationale](rationale.md#The-option-type-alternative).

## Required Patents
To the best of our knowledge, there are no patents that would conflict with the incorporation of this MCP.

## References
- Wikipedia, _Three-valued logic_, https://en.wikipedia.org/wiki/Three-valued_logic
- Wikipedia, _Four-valued logic_, https://en.wikipedia.org/wiki/Four-valued_logic
