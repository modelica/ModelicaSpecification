# Source locations

To fully serve as a format for intermediate representation of translation of full Modelica, the Flat Modelica code can be decorated with source location information pointing back to the original full Modelica model (or other source of the Flat Modelica code).

Each _source location decoration_ (or simply _decoration_ in this context) attaches some kind of source location information to a specific construct in the Flat Modelica code.

Design decisions include:
- Details of what a source location consists of: standardized or open for tool-specific choices?
- Syntax of information included directly in a decoration.
- Syntax for how a decoration is attached to a Flat Modelica construct.
- How to handle need for (optional) big tables of verbose source location data.


## Design goals

Some design goals to keep in mind when comparing the design alternatives:
- The detailed format of a source location needs to be flexible to serve the needs of different tools.
- A tool should be able to ignore source locations originating from other tools.
- Source locations may be needed on many levels of the Flat Modelica code, including component declarations, equations, modifications, and expressions.
- Reduced Flat Modelica soruce code human readability is a concern when soruce locations are added.
- Simple compression of the source locations could be handy.



## Tool-specific table of source location details

The Flat Modelica package level annotation may have a `SourceLocations`-annotation.
There is no standardized content for this annotation, so it is currently only possible to use with vendor-specific annotations inside.
For example:
```
package 'MyModel'
model 'MyModel'
…
end 'MyModel';
annotation(SourceLocations(__Wolfram(sourceLocationsFile = "MyModel.loc")));
end 'MyModel';
```

As an alternative to pointing to a vendor-specific external file, it is also possible to include information directly in the annotation:
```
annotation(SourceLocations(__OpenModelica(
  table = {
    SourceLocation(file = "MoModel.mo", start = {1, 2}, end = {1, 7}),
    SourceLocation(…),
    …
  }));
```

In the future, there could be standardized contents for the `SourceLocations` that all Flat Modelica tools are expected to recognize.


## Syntax of information present in a source location decoration

### Design alternatives

Alternatives include:
- Just an integer to be used with a separate table of details provided by `SourceLocations`-annotation.
- Predefined record to avoid need for tool-specific table. (Details to be designed).
- Use `annotation(SourceLocation(…))` to avoid need for attachment operator.

The alternatives above could also be combined in different ways:
- Number of supported formats:
  - Standardize on just one of the alternatives.
  - Allow more than one of the alternatives.
- Number of informations included in a single source location decoration
  - Just a single piece of information.
  - Multiple pieces of information (possibly in different formats).

### Conclusion

For now, only allow a single integer.  It would be easy to extend this in future versions of Flat Modelica.


## Syntax for source location decoration attachment

Given a decision on what information that should be present in a decoration, the next question is which syntax to use for attaching it to a Flat Modelica construct.

### Design alternatives

#### Low precedence infix `@` operator

Use infix `@` as decoration attachment operator:
```
package 'MyModel'
model 'MyModel'
  parameter Real 'p' = 42 @21;  // Attach 21 to binding expression "42"
  Real 'x'(min = 0 @22);        // Attach 22 to modification "0"
  Real 'y' = @23 'x';           // Attach 23 to component declaration
equation
  der('x') = @24 1;             // Attach 24 to equation
  der('y') = 1 @25;             // Attach 25 to "1"
end 'MyModel';
annotation(SourceLocations(…));
end 'MyModel';
```

The precedence of `@` is lower than the expression operators, so that no parentheses are needed when attaching a source locaiton to a modification or binding.

#### Low precedence infix `!` operator

Similar to the `@` operator above, but using `!` instead.

#### Allow use of annotations in new places

Instead of using an operator, one could use annotations if allowing them in new places:
```
package 'MyModel'
model 'MyModel'
  parameter Real 'p' = (42 annotation(SourceLocation = 21));  // Attach 21 to binding expression "42"
  Real 'x'(min = 0 annotation(SourceLocation = 22));          // Attach 22 to modification "0"
  Real 'y' = 'x' annotation(SourceLocation = 23));            // Attach 23 to component declaration
equation
  der('x') = 1 annotation(SourceLocation = 24);               // Attach 24 to equation
  der('y') = (1 annotation(SourceLocation = 25));             // Attach 25 to "1"
end 'MyModel';
annotation(SourceLocations(…));
end 'MyModel';
```


### Conclusions

None yet.
