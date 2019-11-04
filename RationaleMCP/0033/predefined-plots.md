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
  String group "Name of plot group";
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

The `identifier` in `Figure` and `Plot` is optional, and is intended for programmatic access.  As an example for `Figure`, a small extension to the Modelica URI scheme would make it possible to reference the plot from the class documentation.  For `Plot`, this makes it possible to reference the plot in the figure caption, which becomes useful when the `Figure` contains more than one `Plot`.

When a `Figure` defines a non-empty `group`, it is used to organize figures similar to how `group` is used in the `Dialog` annotation.  The `group` is both the key used for grouping, and the name of the group for diaplay purposes.

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
