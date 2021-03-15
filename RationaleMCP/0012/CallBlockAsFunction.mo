within ;
package CallBlockAsFunction
  model Test1
    import Modelica.Blocks.MathBoolean.*;
    import Modelica.Blocks.Sources.*;
    /* Desired:
   Boolean u1 = BooleanPulse.y(width=30, period=0.1);
   Boolean u2 = BooleanPulse.y(width=50, period=0.4);
   Boolean y1 = (u1 and u2) or OnDelay.y(u=u1, delayTime=0.3);
   Boolean y2  = OnDelay.y(u=OnDelay.y(u=u2, delayTime=0.1), delayTime=0.05);
  */
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
  end Test1;

  package WithStateMachineMapping
    model Test1
      Modelica.Blocks.Math.Asin asin
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      Modelica.Blocks.Sources.Constant const(k=0.5)
        annotation (Placement(transformation(extent={{0,-20},{20,0}})));
      Modelica.Blocks.Sources.Clock clock
        annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
      Modelica.Blocks.Interfaces.RealOutput y1
        "Connector of Real output signal"
        annotation (Placement(transformation(extent={{50,-4},{70,16}})));
    equation
      connect(clock.y, asin.u) annotation (Line(
          points={{-29,30},{-2,30}},
          color={0,0,127},
          smooth=Smooth.None));
      transition(
            asin,
            const,
            time > 0.5,
            reset=false) annotation (Line(
          points={{8,18},{8,2}},
          color={175,175,175},
          thickness=0.25,
          smooth=Smooth.Bezier), Text(
          string="%condition",
          extent={{-4,4},{-4,10}},
          lineColor={95,95,95},
          fontSize=10,
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Right));
      connect(asin.y, y1) annotation (Line(
          points={{21,30},{30,30},{30,6},{60,6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(const.y, y1) annotation (Line(
          points={{21,-10},{30,-10},{30,6},{60,6}},
          color={0,0,127},
          smooth=Smooth.None));
      initialState(asin) annotation (Line(
          points={{14,42},{14,60}},
          color={175,175,175},
          thickness=0.25,
          smooth=Smooth.Bezier,
          arrow={Arrow.Filled,Arrow.None}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),      graphics));
    end Test1;

    model Test2
       Modelica.Blocks.Math.Asin Asin1;

       block ElseBranch
         Modelica.Blocks.Interfaces.RealOutput y = 0.5;
       end ElseBranch;
       ElseBranch elseBranch;

       block IfInput
         Modelica.Blocks.Interfaces.RealOutput y = time;
       end IfInput;
       IfInput ifInput;

       Modelica.Blocks.Interfaces.RealOutput yTemp;
       Real y = yTemp;
    equation
       initialState(Asin1);
       transition(Asin1, elseBranch, not time < 0.5, reset=false);
       connect(ifInput.y, Asin1.u);
       connect(Asin1.y, yTemp);
       connect(elseBranch.y, yTemp);
    end Test2;
  end WithStateMachineMapping;
  annotation (uses(Modelica(version="3.2.1")));
end CallBlockAsFunction;
