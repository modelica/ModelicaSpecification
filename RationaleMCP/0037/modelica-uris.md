# Modelica URIs

The Modelica URI format is extended to give meaning to the forms described below.  (Examples and more details were included in the old email thread, and might be of interest to also include here.)

A Modelica URI can be divided into two main parts: a reference to a Modelica class, followed by a resource specified relative to the class.  In terms of generic URI syntax, the class reference is given by the first part of the URI's _path_ — except for the current Modelica URIs, where the class reference is given by the _host_ part (occupying the entire _autority_).  A varying number of path segments are used to specify the class, but one can always immediately tell where the class reference part ends and where the class-relative resource part begins.

## Class reference

This section presents a couple of alternative designs, meant to be discussed in the language group before deciding which one to proceed with.

Below, "…" represent the class-relative resource part of the Modelica URI, [described below](class-relative-resource).

Before going into the alternative new designs, let us first mention the current form:
- _modelica://host/…_ (non-empty host) — This is the form defined today, becoming deprecated as of this MCP.  In this MCP, this is referred to as the _deprecated form_ (of a Modelica URI).
  * Example: _modelica://Modelica.Electrical.Analog/media/foo.png_

### Modelica URI class tree context

Among the proposed forms of class references below, there are some that are only meaningful relative to a context given by a position in the Modelica class tree.  These forms can only be used where a _class tree context_ is given.  It is an error if class reference relative to the class tree context doesn't resolve to a class within the same top level package as that of the context — references to resources in a different top level package must use the fully qualified form.  The class tree context can be given in one of two ways:
- A string literal (or a substring thereof) appearing in a Modelica class definition, and in a position where a Modelica URI is given special meaning.  This generally excludes Modelica string literals denoting normal Modelica `String` values — a Modelica tool does not need to keep track of the origin of all string values in the form of Modelica URIs in order to preserve the class tree context.  Instead, it is in the context of certain annotations that a string literal can be in a position where a Modelica URI is expected, as in the `href` of an `a` tag in the `Documentation` annotation.
- The [`resolveURI` operator](resolve-uri.md), also introduced by this MCP.


### Base proposal: Empty authority, dot-separation, and Modelica lookup

These are the different ways of referencing a class, where the _host_, _fullclass_, and _relclass_ represent a Modelica class reference (that is, Modelica identifiers, separated by the period ("dot") charater, and hence free of the path separator that would have to be percent-encoded if present inside a quoted identifier):
- _modelica:///fullclass…_ — Class given by its fully qualified name, without leading period.  It is an error if _fullclass_ does not refer to an existing class.
  * Example: _modelica:///Modelica.Electrical.Analog/media/foo.png_
- _modelica:///./relclass…_ — Class given by lookup of _relclass_ in the class tree — requires class tree context, and it is an error if _relclass_ doesn't resolve to an existing class.
  * Example: _modelica:///./Examples/media/foo.png_
  * Example: _modelica:///.//media/foo.png_ (empty _relclass_)
  * Example: _modelica:///.?figure=Disturbances&plot=Wind_ (empty _relclass_)
- _modelica:///~/relclass…_ — Similar to the form above, but lookup of _relclass_ is made from the point of the nearest enclosing encapsulated class, or the current top level class in case there is no enclosing encapsulated class.  For the MSL, where class encapsultion is currently not used much at all, this provides a convenient way to access resources organized in a hierarchy which is separate from the package hierarchy.
  * Example: _modelica:///~//media/foo.png_ (empty _relclass_)
  * Example: _modelica:///~/Documentation?view=info#introduction_

The forms containing _relclass_ are referred to as the _lookup-based forms_ (of a Modelica URI).  The form with _fullclass_ is referred to as the _fully qualified form_ (of a Modelica URI).

### Lookup-free variation: Staying in the class tree

While powerful and tightly coupled with the rest of the Modelica language, the lookup-based forms also come with some disadvantages:
- Implementation and execution complexity: Performing lookup requires a significant amount of Modelica know-how to get it right, and performing the operation is not cheap.
- There is currently no Modelica URIs relying on resources associated with the class in the instance tree; all current resources are associated with the class in the class tree, but locating a class in the class tree could be much simpler than performing a normal Modelica lookup.

This leads to the alternative approach of making class references only through the class tree:
- _modelica:///./relclass…_ — Class given by appending _relclass_ to the class tree context, and it is an error if _relclass_ doesn't resolve to an existing class.
- _modelica:///~/relclass…_ — Similar to the form above, but _relclass_ is appended to the nearest enclosing encapsulated class, or the current top level class in case there is no enclosing encapsulated class.  For the MSL, this would just as fine as the lookup-based form.
- _modelica:///{../}relclass…_ (one or more leading '..' path segments) — Similar to the '.' form, but moving one level up the class tree with each '..' segment, and then appending _relclass_.  This is useful for locating sibling classes in a relative manner without depending on class encapsulation.
  * Example: _modelica:///../Resistor_

### Class references with '/' separator

Here is another idea from the early discussions on how to form the new Modelica URIs.

The special meaning given to the path segments '.' and '..' is clearly inspired by file paths, but with the difference that the class references presented above use the standard '.' to separate identifiers in the qualified class name of the Modelica URI.  The analogy with file paths would be even better if the qualified class name in the Modelica URI used '/' as separator.

This then require a different way of giving a relative file path after the class reference, because there would be no easy way of telling where the class reference ends in an example like this:
  * Bad: _modelica:///Modelica/Electrical/Analog/media/foo.png_

It could be solved with some URI abuse, where a special character inside a segment marks the split (note that the split doesn't correspond to normal URI parsing):
  * URI abuse: _modelica:///Modelica/Electrical/Analog:media/foo.png_

Using a query becomes a bit more verbose, but seems pretty safe otherwise (using the name _resource_ in the query to connect with the special directory name [_resources.d_](resource-directory.md)):
  * Query solution: _modelica:///Modelica/Electrical/Analog?resource=media/foo.png_

### Modelica URIs without authority

In the (non-deprecated) Modelica URI forms above, the authority part of the URI was always empty, causing the cumbersome sequence `:///` separating the URI scheme from the class reference.  By omitting the authority instead of leaving it empty, the Modelica URIs become more readable.

Examples:
  * Fully qualified: _modelica:Modelica.Electrical.Analog/media/foo.png_
  * Lookup-based: _modelica:./Examples/media/foo.png_
  * Lookup-based: _modelica:.//media/foo.png_ (empty _relclass_)
  * Lookup-based: _modelica:.?figure=Disturbances&plot=Wind_ (empty _relclass_)
  * Lookup-based: _modelica:~//media/foo.png_ (empty _relclass_)
  * Lookup-based: _modelica:~/Documentation?view=info#introduction_

 While it double be tempting to require a leading '/' to indicate a fully qualified class reference and allow the leading `.` segment to be omitted,
  * Fully qualified: _modelica:/Modelica.Electrical.Analog/media/foo.png_
  * Lookup-based: _modelica:Examples/media/foo.png_
  * Lookup-based: _modelica:?figure=Disturbances&plot=Wind_ (empty _relclass_)

one would have to watch out for the pitfal of just leaving the _relclass_ empty when there are additional path segments:
  * Wrong: _modelica://media/foo.png_ (deprecated form where _media_ would be the class reference)
  * Wrong: _modelica:/media/foo.png_ (fully qualified form — not the intention)
  * Correct: _modelica:.//media/foo.png_ (empty _relclass_)

### Further generalizations

As demonstrated by the forms above, these schemes can easily be extended with other ways of referring to a class by giving meaning to some new special content of the first path segments that cannot be mistaken for a (qualified) class name.  For instance, a reference relative to the current top level class could be indicated by a '~~' (two '~') in the first path segment.

## Class-relative resource

This section is divided into one subsection for each type of resource being referenced.  Here, _current class_ refers to the class referenced by the class part of the Modelica URI (not the class giving context to a relative class reference).

### External resource

An _external resource_ is a file stored in a structure reflecting the Modelica class hierarchy of the current class.  The resource is specified using the rest of the URI path part, for example:
- _modelica:///Modelica.Electrical.Analog/media/foo.png_

This is currently the only form of (non-deprecated) Modelica URI with a path that continues after the class reference part, and this form is currently not combined with neither a query or a fragment specifier.  For further details see, [resoruce-directory.md].

### Class view

Different views of a class can be specified by using the `view` query:
- _modelica://classref?view=diagram_ — Class diagram.
- _modelica://classref?view=icon_ — Class icon.
  * Example: `<img src="modelica:///.?view=icon" alt="class icon"/>` (icon of the current class)
- _modelica://classref?view=text_ — Textual class source code.
- _modelica://classref?view=info_ — Class documentation.  The fragment specifier can be used to reference a link anchor (present in the `Documentation.info` of the current class).
  * Example: _modelica:///Modelica.Electrical.Analog?view=info#overview_

### Figure and plot

In the event that ([MCP-0033](https://github.com/modelica/ModelicaSpecification/pull/2482)) is accepted before this MCP, a figure is referenced using its `identifier` in the `figure` query.
  * Example: _modelica:///Modelica.Electrical.Analog.Examples.Rectifier?figure=voltcurr_

To reference a plot inside a figure, one can also use the `plot` query (note that the `plot` identifier is only meaningful within a given figure).
  * Example: _modelica:///Modelica.Electrical.Analog.Examples.Rectifier?figure=voltcurr&plot=sumc1c2_

Note that inheritance of figures means that the `figure` identifier is not necessarily referring to a figure defined in the current class, but could come from one of its parent classes.

While the example above was using the _fullclass_ form of a Modelica URI, the most common place where a figure is references is probably in the documentation or other figures of the current class.  Then, using a lookup-based form makes the class more self-contained.
  * Example: _modelica:///.?figure=voltcurr&plot=sumc1c2_ (appearing in the `Documentation.info` of the current class)

**It would be great if the path could be omitted when it's just a period.**
