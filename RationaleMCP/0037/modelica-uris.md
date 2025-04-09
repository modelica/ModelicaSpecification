# Modelica URIs

The Modelica URI format is extended to give meaning to the forms described below.  (Examples and more details were included in the old email thread, and might be of interest to also include here.)

The design originates from the structure of a general URI.  Quoting [Wikipedia](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier):
```
URI = scheme:[//authority]path[?query][#fragment]
```

Users that are unsure about the details of the general URI syntax are recommended to try one of the many freely available online tools for URI parsing, such as: https://www.freeformatter.com/url-parser-query-string-splitter.html

## Basic structure

The Modelica URIs described in this proposal have a mandatory _query_ part.  This makes them easily distinguishable from the legacy Modelica URI format, where the _query_ part of the URI is never used.

The _path_ part of a Modelica URI is denoted the Modelice URI's _class reference_, and unlike the old Modelica URI format, qualified Modelica class names use the normal URI path segment separator `/` instead of `.`.

An empty _authority_ is allowed as an alternative to not specifying the _authority_ at all.
The use of a non-empty _authority_ is reserved for future use.  (It is also used in the legacy Modelica URI format.)

As usual, some characters need to be URL encoded when put in a URI.  For instance, the Modelica class `.Slashy.'Foo/Bar'.Baz` is referenced like so:
- _modelica:/Slashy/'Foo%2FBar'/Baz_

## Class reference

This section presents a couple of alternative designs, meant to be discussed in the language group before deciding which one to proceed with.

Before going into the alternative new designs, let us first mention the current form:
- _modelica://host/…_ (no _query_ part, and possibly a non-empty _authority_) — This is the form defined today, referred to as the _legacy form_ (of a Modelica URI) as of this MCP.
  * Example: _modelica://Modelica.Electrical.Analog/media/foo.png_

### Relative Modelica URIs and the class tree context

Among the proposed forms of class references below, there are some that are only meaningful relative to a context given by a position in the Modelica class tree.  These forms can only be used where a _class tree context_ is given.  It is an error if class reference relative to the class tree context doesn't resolve to a class within the same top level package as that of the context — references to resources in a different top level package must use the fully qualified form.  The class tree context can be given in one of two ways:
- A string literal (or a substring thereof) appearing in a Modelica class definition, and in a position where a Modelica URI is given special meaning.  This generally excludes Modelica string literals denoting normal Modelica `String` values — a Modelica tool does not need to keep track of the origin of all string values in the form of Modelica URIs in order to preserve the class tree context.  Instead, it is in the context of certain annotations that a string literal can be in a position where a Modelica URI is expected, as in the `href` of an `a` tag in the `Documentation` annotation.
- The [`resolveURI` operator](resolve-uri.md), also introduced by this MCP.

A [separate rationale](relative-class-references.md) is given for the inclusion of relative class references in this MCP.

### Base proposal: No authority, slash-separation, and Modelica lookup

These are the different ways of referencing a class, where the _host_, _fullclass_, and _relclass_ represent a slash-separated Modelica class reference (that is, Modelica identifiers, separated by the forward slash (`/`) charater):
- _modelica:/fullclass_ — Class given by its fully qualified name.  It is an error if _fullclass_ does not refer to an existing class.
  * Example: _modelica:/Modelica/Electrical/Analog_
  * Example: _modelica:///Modelica/Electrical/Analog_ (empty _authority_; the _fullclass_ form is the only possible form of class reference when _authority_ is present)
- _modelica:relclass_ — Class given by lookup of _relclass_ in the class tree.  Requires class tree context, and it is an error if _relclass_ doesn't resolve to an existing class.
  * Example: _modelica:Examples_
  * Example: _modelica:_ (empty _relclass_)
  * Example: _modelica:?figure=Disturbances&plot=Wind_ (empty _relclass_)
- _modelica:./relclass_ — Same as _modelica:relclass_, possibly useful to add clarity.
  * Example: _modelica:./Examples_
  * Example: _modelica:._ (empty _relclass_)
  * Wrong: _modelica:///._ (malformed absolute reference with _fullclass_ `/.`)
  * Wrong: _modelica:///./Examples_ (malformed absolute reference with _fullclass_ `/./Examples`)
- _modelica:~/relclass_ — Similar to the form above, but lookup of _relclass_ is made from the point of the nearest enclosing encapsulated class, or the current top level class in case there is no enclosing encapsulated class.  For the MSL, where class encapsultion is currently not used much at all, this provides a convenient way to access resources organized in a hierarchy which is separate from the package hierarchy.
  * Example: _modelica:~/Icons_
  * Example: _modelica:~?resource=images/logo.png_ (empty _relclass_)
  * Example: _modelica:~/Documentation?view=info#introduction_

The forms containing _relclass_ are referred to as the _lookup-based forms_ (of a Modelica URI).  The form with _fullclass_ is referred to as the _fully qualified form_ (of a Modelica URI).

### Lookup-free variation: Staying in the class tree

While powerful and tightly coupled with the rest of the Modelica language, the lookup-based forms also come with some disadvantages:
- Implementation and execution complexity: Performing lookup requires a significant amount of Modelica know-how to get it right, and performing the operation is not cheap.
- There is currently no Modelica URIs relying on resources associated with the class in the instance tree; all current resources are associated with the class in the class tree, but locating a class in the class tree could be much simpler than performing a normal Modelica lookup.

This leads to the alternative approach of making class references only through the class tree:
- _modelica:relclass_ — Class given by appending _relclass_ to the class tree context, and it is an error if _relclass_ doesn't resolve to an existing class.
- _modelica:~/relclass_ — Similar to the form above, but _relclass_ is appended to the nearest enclosing encapsulated class, or the current top level class in case there is no enclosing encapsulated class.  For the MSL, this would work just as fine as the lookup-based form.
- _modelica:{../}relclass_ (one or more leading '..' path segments) — Similar to the '.' form, but moving one level up the class tree with each '..' segment, and then appending _relclass_.  This is useful for locating sibling classes in a relative manner without depending on class encapsulation.
  * Example: _modelica:../Resistor_

### Class references with '.' separator

While not following the structure of a general URI, it would also be possible to define the new Modelica URIs with the class reference using `.` as separator rahter than `/`.  A [separate rationale](class-reference-separator.md) is given for the current proposal of not using `.`.

By sacrificing the ability to include a relative file path at the end of the URI path, one could also allow a mix of `/` and `.` separators.  The following would all be equivalent:
- _modelica:/Modelica/Electrical/Analog/Examples/ChuaCircuit_
- _modelica:.Modelica.Electrical.Analog.Examples.ChuaCircuit_
- _modelica:/Modelica.Electrical.Analog/Examples.ChuaCircuit_

Variations of the class reference can still be made by prepending the same special leading segments to the path, for example:
* _modelica:./Examples/media/foo.png_
* _modelica:~//media/foo.png_ (empty _relclass_)

### Further generalizations

As demonstrated by the forms above, these schemes can easily be extended with other ways of referring to a class by giving meaning to some new special content of the first path segments that cannot be mistaken for a (qualified) class name.  For instance, a reference relative to the current top level class could be indicated by a '~~' (two '~') in the first path segment.

## Class-relative resource

This section is divided into one subsection for each type of resource being referenced.  Here, _current class_ refers to the class referenced by the class part of the Modelica URI (not the class giving context to a relative class reference).

### External resource

An _external resource_ is a file stored in a structure reflecting the Modelica class hierarchy of the current class.  The resource is specified using the _resource_ query (the name is chosen to remind of the special directory name [_resources.d_](resource-directory.md)), for example:
- _modelica:/Modelica/Electrical/Analog?resource=media/foo.png_

For further details see, [resource-directory.md].

### Class view

Different views of a class can be specified by using the `view` query:
- _modelica:classref?view=diagram_ — Class diagram.
- _modelica:classref?view=icon_ — Class icon.
  * Example: `<img src="modelica:?view=icon" alt="class icon"/>` (icon of the current class)
- _modelica:classref?view=text_ — Textual class source code.
- _modelica:classref?view=info_ — Class documentation.  The fragment specifier can be used to reference an element by `id` or `name` (present in the `Documentation.info` of the current class).
  * Example: _modelica:/Modelica/Electrical/Analog?view=info#overview_

### Figure and plot

In the event that ([MCP-0033](https://github.com/modelica/ModelicaSpecification/pull/2482)) is accepted before this MCP, a `Figure` is referenced using its `identifier` in the `figure` query.
  * Example: _modelica:/Modelica/Electrical/Analog/Examples/Rectifier?figure=voltcurr_

In the context of a `Figure`, a `Plot` is uniquely identified by its `identifier`.  One way to reference a plot would therefore be to append a `plot` query:
  * Example: _modelica:/Modelica/Electrical/Analog/Examples/Rectifier?figure=voltcurr&plot=sumc1c2_

However, a more useful way to reference a plot is to make use of the fragmet specifier, which naturally applies to anything with an `identifier` inside the referenced figure:
  * Example: _modelica:/Modelica/Electrical/Analog/Examples/Rectifier?figure=voltcurr#sumc1c2_

 By using the fragment specifier instead of the `plot` query, it becomes possible to use a URI which is relative to the current figure.  This is useful when referencing a plot from the `caption` of a `Figure` (replacing the old way `caption = "%(plot:sumc1c2) Sum of two connectors."`, where `plot` isn't really a URI scheme, and the `Plot` identifier `sumc1c2` isn't URL encoded):
   * Example: `caption = "%(#sumc1c2) Sum of two connectors."` (thanks to URL encoding, this also works for nasty identifiers containing parentheses)

Note that inheritance of figures means that the `figure` identifier is not necessarily referring to a figure defined in the current class, but could come from one of its parent classes.

While the example above was using the _fullclass_ form of a Modelica URI, the most common place where a figure is references is probably in the documentation or other figures of the current class.  Then, using a lookup-based form makes the class more self-contained.
  * Example: _modelica:?figure=voltcurr#sumc1c2_ (appearing in the `Documentation.info` of the current class)
