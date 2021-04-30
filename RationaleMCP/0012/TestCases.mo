within ;
package TestCases
  model Level1
    import Modelica.Blocks.MathBoolean.*;
   import Modelica.Blocks.Sources.*;
   BooleanPulse BooleanPulse_1(width=30, period=0.1);
   BooleanPulse BooleanPulse_2(width=50, period=0.4);
   Boolean u1 = BooleanPulse_1.y;
   Boolean u2 = BooleanPulse_2.y;
   OnDelay OnDelay_1(delayTime=0.3);
   OnDelay OnDelay_2(delayTime=0.1);
   OnDelay OnDelay_3(delayTime=0.05);

   Boolean y1 = (u1 and u2) or OnDelay_1.y;
   Boolean y2 = OnDelay_3.y;
  equation
   OnDelay_1.u = u1;
   OnDelay_2.u = u2;
   OnDelay_3.u = OnDelay_2.y;
  end Level1;

  model Level2Rewrite
    Modelica.Blocks.Math.Asin asin1
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    block ElseBranch
      Modelica.Blocks.Interfaces.RealOutput y=0.5
        annotation (Placement(transformation(extent={{98,-2},{118,18}})));
    end ElseBranch;

    Modelica.Blocks.Sources.Constant
               const(k=0.5)
      annotation (Placement(transformation(extent={{-20,-38},{0,-18}})));
    block IfInput
      Modelica.Blocks.Interfaces.RealOutput y=time
        annotation (Placement(transformation(extent={{98,-2},{118,18}})));
    end IfInput;

    Modelica.Blocks.Interfaces.RealOutput yTemp
      annotation (Placement(transformation(extent={{98,-2},{118,18}})));
    Real y=yTemp;



    Modelica.Blocks.Sources.ContinuousClock continuousClock
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  equation
    initialState(asin1) annotation (Line(
        points={{-8,42},{-8,68}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier,
        arrow={Arrow.Filled,Arrow.None}));
    connect(asin1.y, yTemp) annotation (Line(points={{1,30},{94,30},{94,8},{108,
            8}}, color={0,0,127}));
    connect(const.y, yTemp) annotation (Line(points={{1,-28},{94,-28},{94,8},{
            108,8}}, color={0,0,127}));
    transition(
        asin1,
        const,
        time > 0.5,
        reset=false,
        priority=1,
        immediate=true,
        synchronize=false) annotation (Line(
        points={{-10,18},{-10,-16}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    connect(continuousClock.y, asin1.u)
      annotation (Line(points={{-79,30},{-22,30}}, color={0,0,127}));
    transition(
        const,
        asin1,
        time <= 0.5,
        reset=false) annotation (Line(
        points={{2,-22},{1,19}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,-4},{4,-10}},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(__Dymola_Algorithm="Dassl"));
  end Level2Rewrite;
  annotation (uses(Modelica(version="4.0.0")));
end TestCases;
