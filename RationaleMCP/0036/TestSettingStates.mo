within ;
package TestSettingStates
  model TrivialDemonstration
    model DiscretizedWithReinit
      input Real u;
      Real x=reinit(u);
      Real y=2*x;
    equation
      der(y)=u-y;
    end DiscretizedWithReinit;

    model Discretized
      input Real u;
      Real x(stateSelect=StateSelect.always);
      Real y=2*x;
    equation
      der(y)=u-y;
    end Discretized;
    Discretized discretized1(u=sample(time, Clock(Clock(1, 10), "ExplicitEuler")));
    DiscretizedWithReinit discretized2(u=sample(time, Clock(Clock(1, 10), "ExplicitEuler")));
    annotation (Documentation(info="<html>
<p>The result of this model will be similar to:</p>
<pre>
when sample(1e-1) then
 /* without state reset */ 
 discretized1.u=time;
 discretized1.x=discretized1.x+...; // Euler discretization
 discretized1.y=2*discretized1.x;
 discretized1.der_y=time-discretized1.y;
 discretized1.der_x=0.5*discretized1.der_y;
 
 /* with state reset */ 
 discretized2.u=time;
 discretized2.x=time; // Just using input!
 discretized2.y=2*discretized2.x;
 discretized2.der_y=time-discretized2.y;
 discretized2.der_x=0.5*discretized2.der_y;
end when;
</pre>
<p>In particular note that the relation between der_y and der_x is the same regardless of resetting states, i.e., it only influences the integration of x not the differentation before that.</p>
</html>"));
  end TrivialDemonstration;
  model TrialArrayDemonstration
    model DiscretizedWithReinit
      input Real u[:];
      Real x[size(u,1)]=reinit(u);
      Real y[:]=2*x;
    equation
      der(y)=u-y;
    end DiscretizedWithReinit;

    model Discretized
      input Real u[:];
      Real x[size(u,1)](each stateSelect=StateSelect.always);
      Real y[:]=2*x;
    equation
      der(y)=u-y;
    end Discretized;
    Discretized discretized1(u={sample(time, Clock(Clock(1, 10), "ExplicitEuler"))});
    DiscretizedWithReinit discretized2(u={sample(time, Clock(Clock(1, 10), "ExplicitEuler"))});
    annotation (Documentation(info="<html>
<p>The result of this model will be similar to:</p>
<pre>
when sample(1e-1) then
 /* without state reset */ 
 discretized1.u[1]=time;
 discretized1.x[1]=discretized1.x[1]+...; // Euler discretization
 discretized1.y[1]=2*discretized1.x[1];
 discretized1.der_y[1]=time-discretized1.y[1];
 discretized1.der_x[1]=0.5*discretized1.der_y[1];
 
 /* with state reset */ 
 discretized2.u[1]=time;
 discretized2.x[1]=time; // Just using input!
 discretized2.y[1]=2*discretized2.x[1];
 discretized2.der_y[1]=time-discretized2.y[1];
 discretized2.der_x[1]=0.5*discretized2.der_y[1];
end when;
</pre>
<p>In particular note that the relation between der_y and der_x is the same regardless of resetting states, i.e., it only influences the integration of x not the differentation before that.</p>
</html>"));
  end TrialArrayDemonstration;

  package System
    model FeedforwardControl
      extends Modelica.Clocked.Examples.Systems.ControlledMixingUnit(pro=1.1);
      annotation (Documentation(info="<html>
<p>An example from Modelica Standard Library, but changed to have some difference between plant and plant in controller for easier comparison.</p>
<p>This does not need the possibility for setting states due to using a different controller.</p>
</html>"));
    end FeedforwardControl;

    model FeedbackControl
      "Simple example of a mixing unit where a (discretized) nonlinear inverse plant model is used as feedback linearization controller"
       extends Modelica.Icons.Example;

      parameter Modelica.Units.SI.Frequency freq=1/300
        "Critical frequency of filter";
      parameter Real c0(unit="mol/l") = 0.848 "Nominal concentration";
      parameter Modelica.Units.SI.Temperature T0=308.5 "Nominal temperature";
      parameter Real a1_inv =  0.2674 "Process parameter of inverse plant model (see references in help)";
      parameter Real a21_inv = 1.815 "Process parameter of inverse plant model (see references in help)";
      parameter Real a22_inv = 0.4682 "Process parameter of inverse plant model (see references in help)";
      parameter Real b_inv =   1.5476 "Process parameter of inverse plant model (see references in help)";
      parameter Real k0_inv =  1.05e14 "Process parameter of inverse plant model (see references in help)";
      parameter Real eps = 34.2894 "Process parameter (see references in help)";
      parameter Real x10 = 0.42 "Relative offset between nominal concentration and initial concentration";
      parameter Real x20 = 0.01 "Relative offset between nominal temperature and initial temperature";
      parameter Real u0 = -0.0224 "Relative offset between initial cooling temperature and nominal temperature";
      final parameter Real c_start(unit="mol/l") = c0*(1-x10) "Initial concentration";
      final parameter Modelica.Units.SI.Temperature T_start=T0*(1 + x20)
        "Initial temperature";
      final parameter Real c_high_start(unit="mol/l") = c0*(1-0.72) "Reference concentration";
      final parameter Real T_c_start = T0*(1+u0) "Initial cooling temperature";
      parameter Real pro=1.1 "Deviations of plant to inverse plant parameters";
      final parameter Real a1=a1_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real a21=a21_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real a22=a22_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real b=b_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real k0=k0_inv*pro "Process parameter of plant model (see references in help)";


      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.MixingUnit invMixingUnit(
        c0=c0,
        T0=T0,
        a1=a1_inv,
        a21=a21_inv,
        a22=a22_inv,
        b=b_inv,
        k0=k0_inv,
        eps=eps,
        c(start=c_start, fixed=true),
        T(start=T_start,
          fixed=true),
        T_c(start=T_c_start))
        annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={2,26})));
      Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints
        annotation (Placement(transformation(extent={{-26,-16},{26,16}}, origin={0,28})));
      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.MixingUnit mixingUnit(
        c(start=c_start, fixed=true),
        T(start=T_start, fixed=true),
        c0=c0,
        T0=T0,
        a1=a1,
        a21=a21,
        a22=a22,
        b=b,
        k0=k0,
        eps=eps) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              origin={86,-16})));

      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.CriticalDamping
        filter(
        n=3,
        f=freq,
        x(start={0.49,0.49,0.49}, fixed={true,false,false}))
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-78,30})));
      Modelica.Clocked.RealSignals.Sampler.Hold hold1(y_start=300)
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={62,-16})));
      Modelica.Clocked.ClockSignals.Clocks.PeriodicRealClock periodicClock1(
        useSolver=true,
        period=1,
        solverMethod="Rosenbrock2")
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={-130,-22})));
      Modelica.Blocks.Sources.Step step(height=c_high_start - c_start, offset=
            c_start,
        startTime=0)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,30})));
      Modelica.Clocked.RealSignals.Sampler.SampleClocked sample2
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={-106,30})));
      Modelica.Clocked.RealSignals.Sampler.Sample sample_c
        annotation (Placement(transformation(extent={{6,-6},{-6,6}}, origin={78,68})));
      Modelica.Clocked.RealSignals.Sampler.SampleClocked sample_T
        annotation (Placement(transformation(extent={{6,-6},{-6,6}}, origin={70,-44})));
      Utilities.InputToState inputToState annotation (Placement(transformation(
              extent={{-10,-10},{10,10}}, origin={8,-4})));
      Utilities.InputToState inputToState1 annotation (Placement(transformation(
              extent={{-10,-10},{10,10}}, origin={-6,56})));
      Utilities.FeedbackController controller(
        freq=freq) annotation (Placement(transformation(rotation=0, extent={{-58,20},{-38,
                40}})));
    equation
      connect(inverseBlockConstraints.y2, invMixingUnit.T_c) annotation (Line(
          points={{22.1,28},{22.1,26},{14,26}},
          color={0,0,127}));
      connect(invMixingUnit.c, inverseBlockConstraints.u2) annotation (Line(
          points={{-10,32},{-20,32},{-20,28},{-20.8,28}},
          color={0,0,127}));
      connect(hold1.y, mixingUnit.T_c) annotation (Line(
          points={{68.6,-16},{70,-16},{70,-18},{72,-18},{72,-16},{74,-16}},
          color={0,0,127}));
      connect(sample2.u,step. y) annotation (Line(
          points={{-113.2,30},{-119,30}},
          color={0,0,127}));
      connect(filter.u, sample2.y) annotation (Line(
          points={{-90,30},{-99.4,30}},
          color={0,0,127}));
      connect(periodicClock1.y, sample2.clock) annotation (Line(
          points={{-123.4,-22},{-106,-22},{-106,22.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5));
      connect(hold1.u, inverseBlockConstraints.y1) annotation (Line(points={{54.8,-16},
              {36,-16},{36,28},{27.3,28}},               color={0,0,127}));
      connect(mixingUnit.c, sample_c.u) annotation (Line(points={{98,-10},{104,-10},
              {104,68},{85.2,68}},color={0,0,127}));
      connect(sample_T.u, mixingUnit.T) annotation (Line(points={{77.2,-44},{104,-44},
              {104,-22},{98,-22}},  color={0,0,127}));
      connect(sample_T.clock, periodicClock1.y) annotation (Line(
          points={{70,-51.2},{78,-51.2},{78,-72},{-126,-72},{-126,-22},{-123.4,-22}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5));

      connect(sample_T.y, inputToState.measurement) annotation (Line(points={{63.4,-44},
              {26,-44},{26,-4},{18,-4}},   color={0,0,127}));
      connect(inputToState.stateToSet, invMixingUnit.T) annotation (Line(points={{-2,-4},
              {-10,-4},{-10,20}},                   color={0,0,127}));
      connect(inputToState1.measurement, sample_c.y) annotation (Line(points={{4,56},{
              62,56},{62,68},{71.4,68}},  color={0,0,127}));
      connect(controller.y,       inverseBlockConstraints.u1) annotation (Line(
            points={{-38,28},{-28.6,28}},                             color={0,0,127}));
      connect(filter.y,controller.u1)
                                     annotation (Line(points={{-67,30},{-58,30}},
                             color={0,0,127}));
      connect(controller.u2,
                           sample_c.y)
        annotation (Line(points={{-56,40},{-56,72},{62,72},{62,68},{71.4,68}},
                                                               color={0,0,127}));
      connect(inputToState1.stateToSet, inverseBlockConstraints.u2) annotation (
          Line(points={{-16,56},{-28,56},{-28,28},{-20.8,28}},
                                                           color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
                -100},{120,100}}),      graphics={Rectangle(extent={{-96,70},{40,-18}},
                           lineColor={255,0,0}), Text(
            extent={{-84,-4},{-38,-12}},
            textColor={255,0,0},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
              textString="feedback linearization")}),
        experiment(StopTime=300),
        Documentation(info="<html>
<p>This demonstrates using feedback linearization to improve the control of the plant.</p>
</html>"));
    end FeedbackControl;

    model BothControl
      "Simple example of a mixing unit where a (discretized) nonlinear inverse plant model is used as feedback linearization controller and another inverse model as feedforward control"
       extends Modelica.Icons.Example;

      parameter Modelica.Units.SI.Frequency freq=1/300
        "Critical frequency of filter";
      parameter Real c0(unit="mol/l") = 0.848 "Nominal concentration";
      parameter Modelica.Units.SI.Temperature T0=308.5 "Nominal temperature";
      parameter Real a1_inv =  0.2674 "Process parameter of inverse plant model (see references in help)";
      parameter Real a21_inv = 1.815 "Process parameter of inverse plant model (see references in help)";
      parameter Real a22_inv = 0.4682 "Process parameter of inverse plant model (see references in help)";
      parameter Real b_inv =   1.5476 "Process parameter of inverse plant model (see references in help)";
      parameter Real k0_inv =  1.05e14 "Process parameter of inverse plant model (see references in help)";
      parameter Real eps = 34.2894 "Process parameter (see references in help)";
      parameter Real x10 = 0.42 "Relative offset between nominal concentration and initial concentration";
      parameter Real x20 = 0.01 "Relative offset between nominal temperature and initial temperature";
      parameter Real u0 = -0.0224 "Relative offset between initial cooling temperature and nominal temperature";
      final parameter Real c_start(unit="mol/l") = c0*(1-x10) "Initial concentration";
      final parameter Modelica.Units.SI.Temperature T_start=T0*(1 + x20)
        "Initial temperature";
      final parameter Real c_high_start(unit="mol/l") = c0*(1-0.72) "Reference concentration";
      final parameter Real T_c_start = T0*(1+u0) "Initial cooling temperature";
      parameter Real pro=1.1 "Deviations of plant to inverse plant parameters";
      final parameter Real a1=a1_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real a21=a21_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real a22=a22_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real b=b_inv*pro "Process parameter of plant model (see references in help)";
      final parameter Real k0=k0_inv*pro "Process parameter of plant model (see references in help)";

      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.MixingUnit invMixingUnit(
        c0=c0,
        T0=T0,
        a1=a1_inv,
        a21=a21_inv,
        a22=a22_inv,
        b=b_inv,
        k0=k0_inv,
        eps=eps,
        c(start=c_start, fixed=true),
        T(start=T_start,
          fixed=true),
        T_c(start=T_c_start))
        annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={2,26})));
      Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints
        annotation (Placement(transformation(extent={{-26,-16},{26,16}}, origin={0,28})));
      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.MixingUnit mixingUnit(
        c(start=c_start, fixed=true),
        T(start=T_start, fixed=true),
        c0=c0,
        T0=T0,
        a1=a1,
        a21=a21,
        a22=a22,
        b=b,
        k0=k0,
        eps=eps) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              origin={86,-16})));

      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.CriticalDamping
        filter(
        n=3,
        f=freq,
        x(start={0.49,0.49,0.49}, fixed={true,false,false}))
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-78,30})));
      Modelica.Clocked.RealSignals.Sampler.Hold hold1(y_start=300)
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={62,-16})));
      Modelica.Clocked.ClockSignals.Clocks.PeriodicRealClock periodicClock1(
        useSolver=true,
        period=1,
        solverMethod="Rosenbrock2")
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={-130,-22})));
      Modelica.Blocks.Sources.Step step(height=c_high_start - c_start, offset=
            c_start,
        startTime=0)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,30})));
      Modelica.Clocked.RealSignals.Sampler.SampleClocked sample2
        annotation (Placement(transformation(extent={{-6,-6},{6,6}}, origin={-106,30})));
      Modelica.Clocked.RealSignals.Sampler.Sample sample_c
        annotation (Placement(transformation(extent={{6,-6},{-6,6}}, origin={78,68})));
      Modelica.Clocked.RealSignals.Sampler.SampleClocked sample_T
        annotation (Placement(transformation(extent={{6,-6},{-6,6}}, origin={70,-44})));
      Utilities.InputToState inputToState annotation (Placement(transformation(
              extent={{-10,-10},{10,10}}, origin={8,-4})));
      Utilities.InputToState inputToState1 annotation (Placement(transformation(
              extent={{-10,-10},{10,10}}, origin={-6,56})));
      Utilities.FeedbackController controller(
        freq=freq) annotation (Placement(transformation(rotation=0, extent={{-58,20},{-38,
                40}})));
      Modelica.Clocked.Examples.Systems.Utilities.ComponentsMixingUnit.MixingUnit
                                                                         invMixingUnit1(
        c0=c0,
        T0=T0,
        a1=a1_inv,
        a21=a21_inv,
        a22=a22_inv,
        b=b_inv,
        k0=k0_inv,
        eps=eps,
        c(start=c_start, fixed=true),
        T(start=T_start,
          fixed=true,
          stateSelect=StateSelect.always),
        T_c(start=T_c_start))
        annotation (Placement(transformation(extent={{10,-48},{-10,-28}})));
      Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints1
        annotation (Placement(transformation(extent={{-32,-52},{20,-20}})));
      Modelica.Blocks.Math.Gain gain(k=20) annotation (Placement(transformation(
              extent={{28,-68},{48,-48}})));
      Modelica.Blocks.Math.Feedback feedback
        annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
      Modelica.Blocks.Math.Add add
        annotation (Placement(transformation(extent={{46,14},{66,34}})));
    equation
      connect(inverseBlockConstraints.y2, invMixingUnit.T_c) annotation (Line(
          points={{22.1,28},{22.1,26},{14,26}},
          color={0,0,127}));
      connect(invMixingUnit.c, inverseBlockConstraints.u2) annotation (Line(
          points={{-10,32},{-20,32},{-20,28},{-20.8,28}},
          color={0,0,127}));
      connect(hold1.y, mixingUnit.T_c) annotation (Line(
          points={{68.6,-16},{70,-16},{70,-18},{72,-18},{72,-16},{74,-16}},
          color={0,0,127}));
      connect(sample2.u,step. y) annotation (Line(
          points={{-113.2,30},{-119,30}},
          color={0,0,127}));
      connect(filter.u, sample2.y) annotation (Line(
          points={{-90,30},{-99.4,30}},
          color={0,0,127}));
      connect(periodicClock1.y, sample2.clock) annotation (Line(
          points={{-123.4,-22},{-106,-22},{-106,22.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5));
      connect(mixingUnit.c, sample_c.u) annotation (Line(points={{98,-10},{104,-10},
              {104,68},{85.2,68}},color={0,0,127}));
      connect(sample_T.u, mixingUnit.T) annotation (Line(points={{77.2,-44},{104,-44},
              {104,-22},{98,-22}},  color={0,0,127}));
      connect(sample_T.clock, periodicClock1.y) annotation (Line(
          points={{70,-51.2},{78,-51.2},{78,-72},{-126,-72},{-126,-22},{-123.4,-22}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5));

      connect(sample_T.y, inputToState.measurement) annotation (Line(points={{63.4,-44},
              {28,-44},{28,-4},{18,-4}},   color={0,0,127}));
      connect(inputToState.stateToSet, invMixingUnit.T) annotation (Line(points={{-2,-4},
              {-10,-4},{-10,20}},                   color={0,0,127}));
      connect(inputToState1.measurement, sample_c.y) annotation (Line(points={{4,56},{
              62,56},{62,68},{71.4,68}},  color={0,0,127}));
      connect(controller.y,       inverseBlockConstraints.u1) annotation (Line(
            points={{-38,28},{-28.6,28}},                             color={0,0,127}));
      connect(filter.y,controller.u1)
                                     annotation (Line(points={{-67,30},{-58,30}},
                             color={0,0,127}));
      connect(controller.u2,
                           sample_c.y)
        annotation (Line(points={{-56,40},{-56,72},{62,72},{62,68},{71.4,68}},
                                                               color={0,0,127}));
      connect(inputToState1.stateToSet, inverseBlockConstraints.u2) annotation (
          Line(points={{-16,56},{-28,56},{-28,28},{-20.8,28}},
                                                           color={0,0,127}));
      connect(invMixingUnit1.T, feedback.u1)
        annotation (Line(points={{-12,-44},{-12,-70},{-6,-70}}, color={0,0,127}));
      connect(feedback.y,gain. u) annotation (Line(points={{11,-70},{20,-70},{20,-58},
              {26,-58}},
            color={0,0,127}));
      connect(invMixingUnit1.c, inverseBlockConstraints1.u2) annotation (Line(
            points={{-12,-32},{-22,-32},{-22,-36},{-26.8,-36}}, color={0,0,127}));
      connect(filter.y, inverseBlockConstraints1.u1) annotation (Line(points={{-67,30},
              {-62,30},{-62,-36},{-34.6,-36}}, color={0,0,127}));
      connect(feedback.u2, inputToState.measurement) annotation (Line(points={{2,-78},
              {2,-90},{56,-90},{56,-44},{28,-44},{28,-4},{18,-4}}, color={0,0,127}));
      connect(inverseBlockConstraints1.y2, invMixingUnit1.T_c) annotation (Line(
            points={{16.1,-36},{14.05,-36},{14.05,-38},{12,-38}}, color={0,0,127}));
      connect(inverseBlockConstraints.y1, add.u1) annotation (Line(points={{27.3,28},
              {38,28},{38,30},{44,30}}, color={0,0,127}));
      connect(gain.y, add.u2) annotation (Line(points={{49,-58},{54,-58},{54,-26},{38,
              -26},{38,18},{44,18}}, color={0,0,127}));
      connect(add.y, hold1.u) annotation (Line(points={{67,24},{72,24},{72,-4},{48,-4},
              {48,-16},{54.8,-16}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
                -100},{120,100}}),      graphics={Rectangle(extent={{-96,70},{40,-18}},
                           lineColor={255,0,0}), Text(
            extent={{-82,-6},{-36,-14}},
            textColor={255,0,0},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
              textString="feedback linearization"),
                                                  Rectangle(extent={{-36,-18},{62,-94}},
                           lineColor={255,0,0}), Text(
            extent={{-40,-82},{6,-90}},
            textColor={255,0,0},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textString="controller")}),
        experiment(StopTime=300),
        Documentation(info="<html>
<p>This demonstrates using feedback linearization to improve the control of the plant.</p>
</html>"));
    end BothControl;

    package Utilities
      model FeedbackController
        Modelica.Blocks.Math.Feedback feedback annotation (Placement(
              transformation(extent={{-10,10},{10,-10}}, origin={-64,0})));
        Modelica.Blocks.Math.Gain gain1(k=K0) annotation (Placement(
              transformation(extent={{-10,-10},{10,10}}, origin={-30,0})));
        Modelica.Blocks.Math.Feedback feedback1 annotation (Placement(
              transformation(extent={{-10,10},{10,-10}}, origin={2,0})));
        Modelica.Blocks.Math.Gain gain(k=K1) annotation (Placement(
              transformation(extent={{10,-10},{-10,10}}, origin={26,30})));
        SimpleIntegrator simpleIntegrator1(initType=Modelica.Blocks.Types.Init.NoInit)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                origin={32,0})));
        SimpleIntegrator simpleIntegrator(initType=Modelica.Blocks.Types.Init.NoInit)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                origin={72,0})));
        final parameter Real K0 = (2*pi*freq)^2;
        final parameter Real K1 = 2*(2*pi*freq);
        parameter Modelica.Units.SI.Frequency freq=1/300
          "Critical frequency of filter";
        constant Real pi = Modelica.Constants.pi;
        Modelica.Blocks.Interfaces.RealInput u1 annotation (Placement(
              transformation(rotation=0, extent={{-100,-10},{-80,10}})));
        Modelica.Blocks.Interfaces.RealInput u2 annotation (Placement(
              transformation(rotation=0, extent={{-80,90},{-60,110}})));
        Modelica.Blocks.Interfaces.RealOutput y(start=simpleIntegrator.y_start)
          annotation (Placement(transformation(rotation=0, extent={{100,-30},{
                  120,-10}})));
      equation
        connect(simpleIntegrator1.y, simpleIntegrator.u) annotation (Line(points={{43,0},{
                60,0}},                                            color={0,0,127}));
        connect(feedback1.u2, gain.y)
          annotation (Line(points={{2,8},{2,30},{15,30}},       color={0,0,127}));
        connect(gain1.y, feedback1.u1) annotation (Line(points={{-19,0},{-6,0}},
                               color={0,0,127}));
        connect(feedback1.y, simpleIntegrator1.u) annotation (Line(points={{11,0},{
                20,0}},                                                    color={0,0,
                127}));
        connect(simpleIntegrator1.y, gain.u) annotation (Line(points={{43,0},{
                48,0},{48,30},{38,30}},
              color={0,0,127}));
        connect(feedback.y, gain1.u)
          annotation (Line(points={{-55,0},{-42,0}},   color={0,0,127}));
        connect(u1, feedback.u1)
          annotation (Line(points={{-90,0},{-72,0}}, color={0,0,127}));
        connect(u2, feedback.u2) annotation (Line(points={{-70,100},{-70,14},{
                -64,14},{-64,8}}, color={0,0,127}));
        connect(y, simpleIntegrator.y) annotation (Line(points={{110,-20},{88,
                -20},{88,0},{83,0}}, color={0,0,127}));
        annotation (Diagram(coordinateSystem(extent={{-90,-100},{110,100}})),
            Icon(coordinateSystem(extent={{-90,-100},{110,100}})));
      end FeedbackController;

      block SimpleIntegrator
        "Output the integral of the input signal with optional reset"
        import Modelica.Blocks.Types.Init;
        parameter Real k(unit="1")=1 "Integrator gain";
        /* InitialState is the default, because it was the default in Modelica 2.2
     and therefore this setting is backward compatible
  */
        parameter Init initType=Init.InitialState
          "Type of initialization (1: no init, 2: steady state, 3,4: initial output)" annotation(Evaluate=true,
            Dialog(group="Initialization"));
        parameter Real y_start=0 "Initial or guess value of output (= state)"
          annotation (Dialog(group="Initialization"));
        extends Modelica.Blocks.Interfaces.SISO(y(start=y_start));
      equation
        der(y) = k*u;
        annotation (
          Documentation(info="<html>
<p>
This blocks computes output <strong>y</strong> as
<em>integral</em> of the input <strong>u</strong> multiplied with
the gain <em>k</em>:
</p>
<blockquote><pre>
    k
y = - u
    s
</pre></blockquote>

<p>
It might be difficult to initialize the integrator in steady state.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

<p>
If the <em>reset</em> port is enabled, then the output <strong>y</strong> is reset to <em>set</em>
or to <em>y_start</em> (if the <em>set</em> port is not enabled), whenever the <em>reset</em>
port has a rising edge.
</p>
</html>"),     Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100.0,-100.0},{100.0,100.0}}),
              graphics={
                Line(
                  points={{-80.0,78.0},{-80.0,-90.0}},
                  color={192,192,192}),
                Polygon(
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid,
                  points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
                Line(
                  points={{-90.0,-80.0},{82.0,-80.0}},
                  color={192,192,192}),
                Polygon(
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid,
                  points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
                Text(
                  extent={{-150.0,-150.0},{150.0,-110.0}},
                  textString="k=%k"),
                Line(
                  points=DynamicSelect({{-80.0,-80.0},{80.0,80.0}}, if use_reset then {{-80.0,-80.0},{60.0,60.0},{60.0,-80.0},{80.0,-60.0}} else {{-80.0,-80.0},{80.0,80.0}}),
                  color={0,0,127}),
                Line(
                  visible=use_reset,
                  points={{60,-100},{60,-80}},
                  color={255,0,255},
                  pattern=LinePattern.Dot)}));
      end SimpleIntegrator;

      block InputToState
        Modelica.Blocks.Interfaces.RealInput measurement
          annotation (Placement(transformation(extent={{120,-20},{80,20}})));
        RealInputSetState                    stateToSet=reinit(measurement)
          annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
              coordinateSystem(preserveAspectRatio=false)));
      end InputToState;

      connector RealInputSetState =
                            input Real "'input Real' as connector" annotation (
        defaultComponentName="u",
        Icon(graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
          coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
            preserveAspectRatio=true,
            initialScale=0.2)),
        Diagram(
          coordinateSystem(preserveAspectRatio=true,
            initialScale=0.2,
            extent={{-100.0,-100.0},{100.0,100.0}}),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid,
            points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
          Text(
            textColor={0,0,127},
            extent={{-10.0,60.0},{-10.0,85.0}},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));
    end Utilities;
  end System;
  package ErrorExamples
    model DiscretizedIncorrect1 "Illegal since rhs must just be reinit, use reinit(-u) instead."
      input Real u;
      Real x=-reinit(u);
    equation
      when Clock(Clock(1,10), "ExplicitEuler") then
        der(x)=u-x;
      end when;
    end DiscretizedIncorrect1;
    model DiscretizedIncorrect2 "Illegal since reinit must be in a binding declaration"
      input Real u;
      Real x;
    equation
      when Clock(Clock(1,10), "ExplicitEuler") then
        der(x)=u-x;
        x=reinit(u);
      end when;
    end DiscretizedIncorrect2;
    model DiscretizedIncorrect3 "Illegal, since cannot have both x and y as states"
      input Real u;
      Real x=reinit(u);
      Real y(stateSelect=StateSelect.always)=2*x;
    equation
      when Clock(Clock(1,10), "ExplicitEuler") then
        der(y)=u-y;
      end when;
    end DiscretizedIncorrect3;
    model DiscretizedIncorrect4 "Using normal reinit is legal, but does not give the desired result for y"
      model DiscretizedWithReinitOther "Using normal reinit instead, different result for y"
        /*
        Specifically the normal reinit semantics imply that x will be updated at the end of the step.
        The clocked semantics normally only evaluate y once per step.
        Combined this means one step delay in y.
        There are also additional minor changes related to der(y) and using y during the calculation.
        
        (And normally reinit would be in a non-clocked when.)
        */
        input Real u;
        Real x(stateSelect=StateSelect.always);
        Real y=2*x;
      equation 
        der(y)=u-y;
        when Clock() then
          reinit(x,u);
        end when;
      end DiscretizedWithReinitOther;
      DiscretizedWithReinitOther discretized3(u=sample(time, Clock(Clock(1, 10), "ExplicitEuler")));

      extends TrivialDemonstration;
    end DiscretizedIncorrect4;
  end ErrorExamples;
  annotation (uses(Modelica(version="4.0.0")));
end TestSettingStates;
