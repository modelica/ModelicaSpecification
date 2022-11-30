# Source locations

To fully serve as a format for intermediate representation of translation of full Modelica, the Flat Modelica code can be decorated with source location information pointing back to the original full Modelica model (or other source of the Flat Modelica code).


## Design goals

Some design goals to keep in mind when comparing the design alternatives:
- The detailed format of a source location needs to be flexible to serve the needs of different tools.
- A tool should be able to ignore source locations originating from other tools.
- Source locations may be needed on many levels of the Flat Modelica code, including component declarations, equations, modifications, and expressions.
- Reduced Flat Modelica soruce code human readability is a concern when soruce locations are added.
- Simple compression of the source locations could be handy.


## Design alternatives

Some design alternatives are given below, along with their advantages and disadvantages.


### External source location table

The Flat Modelica code is accompanied by a separate table with source location details.
The table can be stored in an annotation or be provided as a separate file.

When stored in an annotation, it has the form
```
record SourceLocations
  String format "String used to identify the formal of each table row";
  String table "One source location per line, with lines numbered from zero";
end SourceLocations;
```

The `format` must not contain any newline, and all tool vendors must use a string starting with a vendor-annotation prefix.
For example:
```
SourceLocations(format = "__Wolfram file:row:col", table = "...")
```
(In the future, there could be standardized formats that all Flat Modelica tools are expected to recognize.)

Note that it is possible to store source locations compactly in various ways, such as only specifying that differs from the row before:
```
A/package.mo:1:0
::4
::10
:2:0
::7
A/B/package.mo:5:7
::9
A/package.mo:3:5
```

When provided as a separate file, the file shall have the following header right before the rows of table data:
```
//! flat source
//! format: FORMAT
```

In the Flat Modelica code, a source location is attached to an expression or constuct using the `@` operator:
```
package 'MyModel'
  model 'MyModel'
    parameter Real 'p' = 42 @21;  // Attach 21 to binding expression "42"
    Real 'x'(min = 0 @22);        // Attach 22 to modification "0"
    Real 'y' = @23 'x';           // Attach 23 to component declaration
  equation
    der('x') = @24 1;             // Attach 24 to equation
  end 'MyModel';
end 'MyModel';
```

The precedence of `@` is lower than the expression operators, so that no parentheses are needed when attaching a source locaiton to a modification or binding.


## Conclusions

None yet.
