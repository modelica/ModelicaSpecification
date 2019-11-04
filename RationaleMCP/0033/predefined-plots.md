# Structure of annotations
The purpose of this document is to facilitate discussion around the actual structure and scope of standardized annotations for predefined plots.

## Figures in the class Documentation
A class' `Documentation` annotation might look like this:

```
annotation(
  Documentation(
    figures = {
      Figure(title = "Battery Voltage", identifier = "voltage", preferred = true, plots = {Plot(curves = {Curve(x = time, y = battery.p.v, legend = "Battery voltage")}, y=Axis(label = "Voltage"))}),
      Figure(title = "Battery Limit Controller", identifier = "limit", caption = "...", plots = {Plot(title = "Battery Limits", curves = {Curve(x = time, y = battery.LimitController.threshold, legend = "Threshold for terminating simulation"), Curve(x = time, y = battery.LimitController.u, legend = "Limit  controller input signal"), Curve(x = time, y = battery.LimitController.y, legend = "Limit controller output signal")})}),
      Figure(title = "Load Current", identifier = "load", plots = {Plot(curves = {Curve(x = time, y = load.i, legend = "Load current")})})
    }
  )
)
```

Since the use of HTML is not supported in the predefined plots, introduction of `figure` in `Documentation` means that the suport for the `<HTML>...</HTML>` construct needs to be restricted to `info` and `revisions`.

## A figure
As seen in the example above, the pseudo code type of `figures` is `Figure[:]`.  Inserting some line breaks into one of the `Figure` objects, it looks like this:
```
Figure(
  title = "Battery Limit Controller",
  caption = "Overshoot when using a PI-controller with anti-windup."
  identifier = "limit",
  plots = {
    Plot(
      title = "Battery Limits",
      identifier = "battery",
      curves = {
        Curve(x = time, y = battery.LimitController.threshold, legend = "Threshold for terminating simulation"),
        Curve(x = time, y = battery.LimitController.u, legend = "Limit controller input signal"),
        Curve(x = time, y = battery.LimitController.y, legend = "Limit controller output signal")
      }
    )
  }
)
```

Pseudo code definition of `Figure`:
```
record Figure
  String title "Title meant for display";
  String identifier "Identifier meant for programmatic access";
  String group = "" "Name of plot group";
  Boolean preferred = false "Automatically display figure after simulation";
  Plot[:] plots "Plots";
  String caption "Figure caption";
end Figure;
```

Pseudo code definition of `Plot`:
```
record Plot
  String title "Title meant for display";
  String identifier "Identifier meant for programmatic access";
  Curve[:] curves "Plot curves";
  Axis x "X axis properties";
  Axis y "Y axis properties";
end Plot;
```

The `title` of a `Figure` shall be non-empty and is mandatory, as every figure needs a title for presentation in contexts such as a list of figures, and as it is generally hard for tools to automatically generate a meaningful title.  On the other hand, when the `title` of a `Plot` isn't provided, the tool produces a default, but the default is allowed to be empty.  Providing the empty string as `title` of a `Plot` means that no title should be shown.  The plot title is not to be confused with the plot _label_ which is never empty, see below.

The `identifier` in `Figure` and `Plot` is optional, and is intended for programmatic access.  An `identifier` must be unique within the class containing the `figures` annotation, without considering whether it belongs to `Figure` or `Plot`.  As an example for `Figure`, a small extension to the Modelica URI scheme would make it possible to reference the plot from the class documentation.  For `Plot`, this makes it possible to reference the plot in the figure caption, which becomes useful when the `Figure` contains more than one `Plot`.

Every `Plot` has an automatically generated _label_ which is required to be shown as soon as at least one `Plot` in the `Figure` has an `identifier`.  A tool is free to choose both labeling scheme (such as _a_, _b_, …, or _i_, _ii_, …) placement in the plot, and styling in the plot itself as well as in other contexts.

When a `Figure` defines a non-empty `group`, it is used to organize figures similar to how `group` is used in the `Dialog` annotation.  However, leaving `group` at the default of an empty string does not mean that a group will be created automatically, but that the figure resides outside of any group.  The `group` is both the key used for grouping, and the name of the group for diaplay purposes.

## Plot curves
The actual data to plot is specified in the `curves` of a `Plot`:
```
record Curve
  expression x = time "X coordinate values";
  expression y "Y coordinate values";
  String legend "Legend";
end Curve;
```

The mandatory `x` and `y` expressions are currently restricted to be component references refering to a scalar variable or `time`.

When `legend` isn't provided, the tool produces a default based on `x` and/or `y`.  Providing the empty string as `legend` means that the curve shall be omitted from the plot legend.

## Axis properties
Properties may be defined for each `Plot` axis:
```
record Axis
  Real min "Axis lower bound";
  Real max "Axis upper bound";
  String unit "Unit of min and max";
  String label "Axis label";
end Axis;
```

When an axis bound isn't provided, the tool computes one automatically.

The Modelica tool is responsible for showing the unit used for values at the axis tick marks, so the axis `label` shall not be used to convey this information.

When an axis label isn't provided, the tool produces a default label.  Providing the empty string as axis label means that no label should be shown.

## Variable replacements
In most places where text is displayed (`title`, `caption`, `legend`, `label`), the final value of a result variable can be embedded by refering to the variable as `%{inertia1.w}`.  This is similar to the `Text` graphical in 18.6.5.5 _Text_,.

Note that expansion to the final value means that expansion is not restricted to parameters and constants, so that values to be shown in a caption can be determined during simulation.

The percent character is encoded `%%`.  Neither `%class` nor `%name` is supported in this context, as this information is expected to already be easily accessible (when applicable) in tool-specific ways.  (Titles making use of `%class` or `%name` would then only lead to ugly duplication of this information.)

## Text markup in captions
In addition to variable replacements, a very restricted form of text markup is used for the `caption`.

### Links
Links take the form `%[<text>](<link>)`, where the `[<text>]` part is optional.  The `<link>` can be in either of the following forms:
- A URI, such as `https://github.com/modelica/ModelicaSpecification` or `modelica:///Modelica.Blocks`.
- A `variable:<id>`, where `<id>` is a component reference such as `inertia1.w`.
- A `plot:<id>`, where `<id>` is the identifier of a `Plot` in the current `Figure`.

When `[<text>]` is omitted, a Modelica tool is free to derive a default based on the `<link>`.

The styling of the link text and the link action is left for each Modelica tool to decide.

For example, `%(inertia1.w)` could be displayed as the text `inertia1.w` formatted with upright monospaced font, and have a pop-up menu attached with menu items for plotting the variable, setting its start value, or investigating the equation system from which it is solved.  On the other hand, `%[angular velocity](inertia1.w)` could be formatted in the same style as the surrounding text, except some non-intrusive visual clue about it being linked.

### Paragraph break
A sequence of one or more newlines (encoded either literally or using the `\n` escape sequence) means a paragraph break.  (A line break within a paragraph is not supported.)
