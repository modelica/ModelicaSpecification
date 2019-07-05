# Structure of annotations
The purpose of this document is to facilitate discussion around the actual structure and scope of standardized annotations for predefined plots.  The starting point was taken from an email previously send to MAP-Lib, which was based on Wolfram SystemModeler's current vendor-specific annotatios, but removing the `__Wolfram` part and just a tiny bit of cleanup.

## Simulation model top level annotation
A model's class annotation might look like this:

```
annotation(
  PlotSet(
    plots = {
      Plot(title = "Battery Voltage", identifier = "Voltage", preferred = true, subPlots = {SubPlot(curves = {Curve(x = time, y = battery.p.v, legend = "Battery voltage")}, labels = Labels(y = "Voltage [V]"))}),
      Plot(title = "Battery Limit Controller", identifier = "Limit", caption = "...", subPlots = {SubPlot(title = "Batter Limits", curves = {Curve(x = time, y = battery.LimitController.threshold, legend = "Threshold for terminating simulation"), Curve(x = time, y = battery.LimitController.u, legend = "Limit  controller input signal"), Curve(x = time, y = battery.LimitController.y, legend = "Limit controller output signal")})}),
      Plot(title = "Load Current", identifier = "Load", subPlots = {SubPlot(curves = {Curve(x = time, y = load.i, legend = "Load current")})})
    }
  )
)
```

One can argue whether the `plots` need to be named member of `PlotSet`, but it opens up for future additions at the `PlotSet` level.

## A plot
Inserting some line breaks into one of the `Plot` objects, it looks like this:
```
Plot(
  title = "Battery Limit Controller",
  caption = "<html>This illustrates the behavior of the <strong>controller</strong>,
               in particular the small overshoot when changing the input.
               The controller is implemented as a PI-controller with anti-windup, for details see...
             </html>"
  identifier = "Limit", 
  subPlots = {
    SubPlot(
	  title = "Batter Limits",
      curves = {
        Curve(x = time, y = battery.LimitController.threshold, legend = "Threshold for terminating simulation"),
        Curve(x = time, y = battery.LimitController.u, legend = "Limit controller input signal"),
        Curve(x = time, y = battery.LimitController.y, legend = "Limit controller output signal")
      }
    )
  }
)
```

The optional identifier is intended for programmatic access.
As is seen in the _Battery Voltage_ plot, this has the `preferred` flag set, meaning that it will be displayed automatically after the model has been simulated.

## Axis labels
As is also seen in the _Battery Voltage_ plot, one can define axis labels:
```
record Labels
  String x "x axis label";
  String y "y axis label";
end Labels;
```

When an axis label isn't provided, the tool produces a default label (SystemModeler currently uses the special expression `auto` to make this explicit, but it seems safe to assume that not providing a value will be easier to get through an MCP).

## Naming and grouping of plots
A Plot may also define a `group` which is a `String` similar to the `group` in the `Dialog` annotation.  It is used to organize plots in models with a large `PlotSet`.

SystemModeler has chosen to not make a distinction between the identifier of a `Plot` and its title.  This is something that could be reconsidered when writing an MCP.

## Axis ranges
A `SubPlot` may, in addition to the `curves` seen above, also define `range`:
```
record SubPlotRange
  Real xmin "Lower bound of the x axis, in the displayUnit of the first curve";
  Real xmax "Upper bound of the x axis, in the displayUnit of the first curve";
  Real ymin "Lower bound of the y axis, in the displayUnit of the first curve";
  Real ymax "Upper bound of the y axis, in the displayUnit of the first curve";
end SubPlotRange;
```

When an axis bound isn't provided, the tool computes one automatically.  Due to the connection to the _`displayUnit` of the first curve_, I guess one should consider the pros and cons of including this part in an MCP.


## Extensions without counterpart in Wolfram SystemModeler

In addition to the constructs shown above, it should also be possible to specify a HTML `caption` (similar to the documentation annotation), at least at the `Plot` level, but possibly also at the `SubPlot` level.  It can also be argued that it should be possible to provide a `title` also at the `SubPlot` level.
