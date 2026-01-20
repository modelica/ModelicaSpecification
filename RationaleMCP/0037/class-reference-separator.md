# Class reference separator

Two different choice of separator in Modelica URI class references have been considered, namely `/` and `.`.  The currently proposed separator in this MCP is `/`, while the legacy form of Modelica URIs use `.`.  This document gives reasons for and against the current proposal.


## Reasons for using `.` (dot)

Advantages of using `.` as separator in class references are given below.

### Simple text editor copy/paste workflows

Most class names using normal Modelica syntax can be directly copied and pasted to/from the class reference part of a Modelica URI.  (However this only works in most cases, not in general, see below.)

### Possibility to use URI path to point out external resources

The URI path could be used to specify a relative file path to an external resource of the class, just like in the legacy Modelica URI format:
* _modelica:/Modelica.Electrical.Analog/media/foo.png_

(Reasons are given below for why we shouldn't use this form of references to external resources anyway.)


## Reasons for using `/` (slash)

Now to the reasons behind `/` being the proposed separator after all.

### The URI path should be used for external resource file paths anyway

The external resources is only one of several kinds of resources referenced by Modelica URIs, and it makes sense to use the query part for all kinds instead of making an exception for external resources.

### Splitting on `/` is part of standard URI handling

Using `.` as separator would then mean a missed opportunity to use the split into path segments one gets for free from the general URI syntax when using `/` as separator.

### URL encoding gives protection of `/`, not `.`

There is also a technical detail speaking in the favor of `/` as separator, namely that URL encoding doesn't protect `.`, which means that the URI syntax can't be used to trivially split the class reference into its identifiers, needed to translate the class reference into a directory path.  Further, splitting the class references into its identifiers requires non-trivial string processing due to the potential presence of `.` inside single-quoted identifiers.  To illustrate, consider the Modelica class `MyPack.'A.B'.'C/D'`.  With `/` as separator and URL encoding of the path segments, one obtains:
- _modelica:/MyPack/'A.B'/'C%2FD'_ — trivially split into its three (URL encoded) Modelica identifiers.
With `.` as separator, on the other hand, one obtains:
- _modelica:.MyPack.'A.B'.'C%2FD'_ — not so easily split into its three identifiers.

### External resources with empty relative class reference

In case one wants to point out external resources using the URI path, one also has to watch out for the pitfal of just leaving the _relclass_ empty when there are additional path segments:
  * Wrong: _modelica://media?resource=foo.png_ (malformed, reminding of legacy form where _media_ would be the class reference)
  * Wrong: _modelica:/media?resource=foo.png_ (fully qualified form — not the intention)
  * Correct: _modelica:.//media?resource=foo.png_ (empty _relclass_; just a `.` cannot be mistaken for )

### Modelica tools should support handling of Modelica URIs

Many users will not be writing Modelica URIs by hand, but use a Modelica tool for creating the URI.  Among other, the tool should help with the URL encoding, and it is unlikely to matter much with separator it should produce, so it might as well be `/`.

A Modelica tool can also provide functionality to copy the class reference of a Modelica URI in the form of a Modelica class name.  Compared to producing Modelica URIs from class names, however, this is probably a rarely needed feature.
