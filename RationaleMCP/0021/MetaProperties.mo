within ;
package MetaProperties
  "Library containing all models of the paper 'Constructs for Meta Properties Modeling in Modelica'"
  package Section_2_1_ComponentIterators
    model StandardIterator
      extends Modelica.Icons.Example;

      Real v[:] = {i*i for i in 1:10};
    equation

      annotation (experiment(StopTime=1.1));
    end StandardIterator;

    record Observation
      constant String name;
      parameter Real m;
      parameter Real v2[3];
      Real r2;
    end Observation;

    model Component
      parameter Real p=2;
      parameter Real v[3] = {-1,2.5,6};
      Real r;
      Real w[3];
      Boolean b;
      Integer i;
    equation
      r=time;
      w=ones(3);
      b = r > 0.5;
      i = 10;
    end Component;

    model Submodel
      Component c1(p=3, v={1,-4,8});
      Component c2;
    end Submodel;

    model Model
      extends Modelica.Icons.Example;
      Submodel s1;
      Submodel s2;

      Integer i2[:] = {c.i+3 for c in Component};
      Observation obs[:] = {Observation(m=c.p, v2=c.v, r2=c.r,
                                        name=c.getInstanceName())
                            for c in Component};

      annotation (experiment(StopTime=1.1));
    end Model;

    model ModelExpanded
      extends Modelica.Icons.Example;
      Submodel s1;
      Submodel s2;

      Integer i2[:] = {s1.c1.i+3, s1.c2.i+3, s2.c1.i+3, s2.c2.i+3};
      Observation obs[:] = {Observation(m=s1.c1.p, v2=s1.c1.v, r2=s1.c1.r,
                                        name="ModelExpanded.s1.c1"),
                            Observation(m=s1.c2.p, v2=s1.c2.v, r2=s1.c2.r,
                                        name="ModelExpanded.s1.c2"),
                            Observation(m=s2.c1.p, v2=s2.c1.v, r2=s2.c1.r,
                                        name="ModelExpanded.s2.c1"),
                            Observation(m=s2.c2.p, v2=s2.c2.v, r2=s2.c2.r,
                                        name="ModelExpanded.s2.c2")};
      annotation (experiment(StopTime=1.1));
    end ModelExpanded;

    model ModelWithGuard
      Submodel s1;
      Submodel s2;

      Integer i2[:] = {c.i+3 for c in Component};
    end ModelWithGuard;
  end Section_2_1_ComponentIterators;

  package Section_2_2_ModelInstancesAsArgumentsToFunctions

    model Submodel
      Real r1;
      Real r2;
      Integer i1;
      Integer i2;
    equation
      r1=1;
      r2=2;
      i1=1;
      i2=2;
    end Submodel;

    record Record
      Real r1;
      Integer i2;
    end Record;

    function get
      input Record rec;
      output Real result;
    algorithm
      result :=rec.r1 + rec.i2;
    end get;

    model Model
      extends Modelica.Icons.Example;
      Submodel s1;
      Real r=get(s1);
      annotation (experiment(StopTime=1.1));
    end Model;

    model ModelExpanded
      extends Modelica.Icons.Example;
      Submodel s1;
      Real r=get(Record(r1=s1.r1,i2=s1.i2));
      annotation (experiment(StopTime=1.1));
    end ModelExpanded;
  end Section_2_2_ModelInstancesAsArgumentsToFunctions;

  package Section_3_1_TotalMass "Models to compute the total mass"

    model TotalMass "Compute total mass of system"
       import Modelica.Mechanics.MultiBody.Parts;
       import SI = Modelica.SIunits;
       final parameter SI.Mass m_total = sum({b.m for b in Parts.Body})
        "Total mass";
    end TotalMass;

    model TotalMassWithLog "Compute total mass of system and print a log"
      import Modelica.Utilities.Streams.print;
      import Modelica.Mechanics.MultiBody.Parts;
      import SI = Modelica.SIunits;
      final parameter SI.Mass m_total = sum(mObs[:].m) "Total mass";
    protected
      record MassObservation
        String  name "Name of body";
        SI.Mass m "Mass of body";
      end MassObservation;
      parameter MassObservation mObs[:] = {MassObservation(name=b.getInstanceName(), m=b.m)
                                           for b in Parts.Body};
    equation
      when initial() then
        print("... Body masses:");
        for i in 1:size(mObs,1) loop
          print("  " + Utilities.removeFirstName(mObs[i].name) + ": "
                     + String(mObs[i].m) + " kg");
        end for;
        print("  Total mass: " + String(m_total) + " kg");
      end when;
    end TotalMassWithLog;

    model TotalMassOfRobot "Compute total mass of r3 robot"
      extends TotalMass;
      extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;
      annotation (experiment(StopTime=1.1));
    end TotalMassOfRobot;

    model TotalMassOfRobotWithLog "Compute total mass of r3 robot"
      extends TotalMassWithLog;
      extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;
      annotation (experiment(StopTime=1.1));
    end TotalMassOfRobotWithLog;
  end Section_3_1_TotalMass;

  package Section_3_2_TotalCenterOfMass
    "Models to compute the total center of mass"

    model TotalCenterOfMass "Compute total center of mass of system"
       import Modelica.Mechanics.MultiBody.Frames;
       import Modelica.Mechanics.MultiBody.Parts;
       import SI = Modelica.SIunits;

       SI.Mass m_total = sum(obs[:].m) "Total mass";
       SI.Position rCM_total[3] = {sum(m_rCM[:,j])/m_total for j in 1:3}
        "Total center of Mass";
    protected
       record FrameObservation
         SI.Position r_0[3];
         Frames.Orientation R;
       end FrameObservation;

       record BodyObservation "Variables to extract from Bodies"
         SI.Mass m "Mass of body";
         SI.Position r_CM[3] "Vector frame_a to center of mass";
         FrameObservation frame_a;
       end BodyObservation;

       function getObservations
         input BodyObservation obs;
         output BodyObservation result=obs;
       algorithm

         annotation(Inline=true);
       end getObservations;

       BodyObservation obs[:] = {getObservations(b) for b in Parts.Body};
       // Real m_rCM[size(obs,1),3] = {o.m*(o.frame_a.r_0 + Frames.resolve1(o.frame_a.R, o.r_CM)) for o in obs};
       Real m_rCM[size(obs,1),3];
    equation
       for i in 1:size(obs,1) loop
          m_rCM[i,:] = obs[i].m*(obs[i].frame_a.r_0 +
                                 Frames.resolve1(obs[i].frame_a.R, obs[i].r_CM));
       end for;
    end TotalCenterOfMass;

    model TotalCenterOfMassError
      "Dymola claims that dimensions do not match for m_rCM [8,3] against [8]"
       import Modelica.Mechanics.MultiBody.Frames;
       import Modelica.Mechanics.MultiBody.Parts;
       import SI = Modelica.SIunits;

       SI.Mass m_total = sum(obs[:].m) "Total mass";
       SI.Position rCM_total[3] = {sum(m_rCM[:,j])/m_total for j in 1:3}
        "Total center of Mass";
    protected
       record FrameObservation
         SI.Position r_0[3];
         Frames.Orientation R;
       end FrameObservation;

       record BodyObservation "Variables to extract from Bodies"
         SI.Mass m "Mass of body";
         SI.Position r_CM[3] "Vector frame_a to center of mass";
         FrameObservation frame_a;
       end BodyObservation;

       function getObservations
         input BodyObservation obs;
         output BodyObservation result=obs;
       algorithm

         annotation(Inline=true);
       end getObservations;

       BodyObservation obs[:] = {getObservations(b) for b in Parts.Body};
       Real m_rCM[size(obs,1),3] = {o.m*(o.frame_a.r_0 + Frames.resolve1(o.frame_a.R, o.r_CM)) for o in obs};

    end TotalCenterOfMassError;

    model TotalCenterOfMassOfRobot "Compute total center of mass of r3 robot"
      extends TotalCenterOfMass;
      // extends TotalCenterOfMassError;
      extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;
      annotation (experiment(StopTime=1.8));
    end TotalCenterOfMassOfRobot;

    model TotalCenterOfMassOfRobot2
      "Compute total center of mass of r3 robot (Dymola claims that dimensions do not match for m_rCM [8,3] against [8])"
      // extends TotalCenterOfMass;
      extends TotalCenterOfMassError;
      extends Modelica.Mechanics.MultiBody.Examples.Systems.RobotR3.fullRobot;
      extends MetaProperties.Icons.ExampleDoesNotTranslateInDymola;
      annotation (experiment(StopTime=1.8));
    end TotalCenterOfMassOfRobot2;
  end Section_3_2_TotalCenterOfMass;

  package Section_4_2_InstanceBinding
    "Models to bind one instance to a requirement model"
    record PumpObservation "Observation signals needed for one pump"
      extends Modelica.Icons.Record;
      constant String name "Name of pump" annotation(Dialog);
      Boolean inOperation "= true, if in operation"  annotation(Dialog);
      Boolean cavitate "= true, if pump cavitates"  annotation(Dialog);
    end PumpObservation;

    model PumpRequirements "Requirements on several pumps"
      import Modelica.Utilities.Streams.print;
      input PumpObservation obs[:] annotation (Dialog);
    equation
       for i in 1:size(obs,1) loop
         when obs[i].inOperation and obs[i].cavitate then
            print("... warning: pump " + obs[i].name + " is cavitating during operation");
         end when;
       end for;
    end PumpRequirements;

    function fromPrescribedPump
      input PrescribedPumpObservation obs;
      input String name;
      input Modelica.SIunits.Pressure p_cavitate=0.99e5;
      output PumpObservation result(
        name=name,
        inOperation=obs.N_in > 0.1,
        cavitate=obs.port_a.p <= p_cavitate or obs.port_b.p <= p_cavitate);
    protected
      record PortObservation
        Modelica.SIunits.Pressure p;
      end PortObservation;

      record PrescribedPumpObservation
        Real N_in(unit="1/min");
        PortObservation port_a;
        PortObservation port_b;
      end PrescribedPumpObservation;
    algorithm

       annotation(GenerateEvents=true);
    end fromPrescribedPump;

    model CheckPumpsOfBatchPlant
      import Modelica.Fluid.Examples.AST_BatchPlant;
      extends AST_BatchPlant.BatchPlant_StandardWater;

      PumpRequirements req(obs={fromPrescribedPump(P1,"P1"),
                                fromPrescribedPump(P2,"P2")});

      annotation(experiment(StopTime=3600));
    end CheckPumpsOfBatchPlant;

    block SinglePumpRequirements "Requirements for one pump"
      import NonSI = Modelica.SIunits.Conversions.NonSIunits;
      extends Modelica_Requirements.Interfaces.PartialRequirements(final observationName=obs.name);

      parameter Real max_rpm(unit="1/min") = 1000 "Maximum pump speed";
      parameter Modelica.SIunits.Pressure p_min = 0.99e5 "Cavitation pressure";

      input MetaProperties.Section_4_2_InstanceBinding.PumpObservation obs
        "Observation variables record from a pump" annotation (Dialog(group="Observation variables"),
          Placement(transformation(extent={{-100,80},{-80,100}})));

      Modelica_Requirements.ChecksInFixedWindow.During during1(check=not obs.cavitate)
        annotation (Placement(transformation(extent={{-44,40},{-4,60}})));
      Modelica_Requirements.Sources.BooleanExpression inOperation(y=obs.inOperation)
        annotation (Placement(transformation(extent={{-100,40},{-60,60}})));
      Modelica_Requirements.Verify.Requirement R1(text=
            "When in operation, pump must not cavitate")
        annotation (Placement(transformation(extent={{14,40},{74,60}})));
    equation
      connect(inOperation.y, during1.condition) annotation (Line(points={{-59,
              50},{-46,50},{-46,50.1}}, color={255,0,255}));
      connect(during1.y, R1.property)
        annotation (Line(points={{-3,50},{4,50},{12,50}}, color={255,0,128}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})),           Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
              Bitmap(extent={{-18,-52},{90,50}}, fileName="modelica://Modelica_Requirements/Resources/Images/Examples/PumpingSystem/pump.png")}));
    end SinglePumpRequirements;

    model MultiPumpRequirements "Requirements on several pumps"
      import Modelica.Utilities.Streams.print;
      input PumpObservation obs[:] annotation (Dialog);
      SinglePumpRequirements req[size(obs, 1)](obs=obs);
      annotation (Icon(graphics={           Text(
              extent={{-250,150},{250,110}},
              textString="%name",
              lineColor={175,175,175}),
                                    Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),   Line(
              points={{-86,-14},{-62,-48},{-28,40}},
              color={0,127,0},
              smooth=Smooth.None,
              thickness=0.5),
              Bitmap(extent={{-18,-4},{90,98}},  fileName="modelica://Modelica_Requirements/Resources/Images/Examples/PumpingSystem/pump.png"),
              Bitmap(extent={{-18,-98},{90,4}},  fileName="modelica://Modelica_Requirements/Resources/Images/Examples/PumpingSystem/pump.png")}));
    end MultiPumpRequirements;

    model CheckPumpsOfBatchPlant2
      import Modelica.Fluid.Examples.AST_BatchPlant;
      extends AST_BatchPlant.BatchPlant_StandardWater;

      MultiPumpRequirements prescribedPumpReq(obs={fromPrescribedPump(P1, "P1"),
                                                   fromPrescribedPump(P2, "P2")})
          annotation (Placement(transformation(extent={{-100,260},{-60,300}})));

      inner Modelica_Requirements.Verify.PrintViolations printViolations
        annotation (Placement(transformation(extent={{-180,260},{-140,300}})));

      annotation (experiment(StopTime=3600),
                  Diagram(coordinateSystem(extent={{-200,-280},{200,300}})));
    end CheckPumpsOfBatchPlant2;
  end Section_4_2_InstanceBinding;

  package Section_4_3_ClassBinding
    "Models to bind all instances of one class to a requirement model"

    model CheckPumpsOfBatchPlantWithForLoop
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;

      PumpRequirements req(obs={fromPrescribedPump(p,p.getInstanceName())
                                for p in Modelica.Fluid.Machines.PrescribedPump});

      annotation(experiment(StopTime=3600));
    end CheckPumpsOfBatchPlantWithForLoop;

    model CheckPumpsOfBatchPlantWithForLoop2
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;

      MultiPumpRequirements prescribedPumpReq(
                obs={ fromPrescribedPump(p,p.getInstanceName())
                      for p in Modelica.Fluid.Machines.PrescribedPump})
          annotation (Placement(transformation(extent={{-100,260},{-60,300}})));

      inner Modelica_Requirements.Verify.PrintViolations printViolations
        annotation (Placement(transformation(extent={{-180,260},{-140,300}})));

      annotation (experiment(StopTime=3600),
                  Diagram(coordinateSystem(extent={{-200,-280},{200,300}})));
    end CheckPumpsOfBatchPlantWithForLoop2;

    model CheckPumpsOfBatchPlantWithForLoop3
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;

      parameter Modelica.SIunits.Pressure p_cavitate = 0.99e5
        "Cavitation pressure";
      MultiPumpRequirements prescribedPumpReq(
                obs={PumpObservation(name=  p.getInstanceName(),
                                     inOperation=  p.N_in > 0.1,
                                     cavitate=  p.port_a.p <= p_cavitate or p.port_b.p <= p_cavitate)
                     for p in Modelica.Fluid.Machines.PrescribedPump})
          annotation (Placement(transformation(extent={{-100,260},{-60,300}})));

      inner Modelica_Requirements.Verify.PrintViolations printViolations
        annotation (Placement(transformation(extent={{-180,260},{-140,300}})));

      annotation (experiment(StopTime=3600),
                  Diagram(coordinateSystem(extent={{-200,-280},{200,300}})));
    end CheckPumpsOfBatchPlantWithForLoop3;

    model MultiPumpRequirements4 "Requirements on several pumps"
      import MetaProperties.Section_4_2_InstanceBinding.*;

      parameter Modelica.SIunits.Pressure p_cavitate = 0.99e5
        "Cavitation pressure";
      SinglePumpRequirements req(
                obs={PumpObservation(name=p.getInstanceName(),
                                     inOperation=p.N_in > 0.1,
                                     cavitate=p.port_a.p <= p_cavitate or p.port_b.p <= p_cavitate)
                     for p in Modelica.Fluid.Machines.PrescribedPump})
                       annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

      annotation (Icon(graphics={           Text(
              extent={{-250,150},{250,110}},
              textString="%name",
              lineColor={175,175,175}),
                                    Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),   Line(
              points={{-86,-14},{-62,-48},{-28,40}},
              color={0,127,0},
              smooth=Smooth.None,
              thickness=0.5),
              Bitmap(extent={{-18,-4},{90,98}},  fileName="modelica://Modelica_Requirements/Resources/Images/Examples/PumpingSystem/pump.png"),
              Bitmap(extent={{-18,-98},{90,4}},  fileName="modelica://Modelica_Requirements/Resources/Images/Examples/PumpingSystem/pump.png")}));

    end MultiPumpRequirements4;

    model CheckPumpsOfBatchPlantWithForLoop4
      "Dymola claimes: type error in record binding"
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;
      extends MetaProperties.Icons.ExampleDoesNotTranslateInDymola;

      inner Modelica_Requirements.Verify.PrintViolations printViolations
        annotation (Placement(transformation(extent={{-180,260},{-140,300}})));

      MultiPumpRequirements4 pumpRequirements
        annotation (Placement(transformation(extent={{-120,260},{-80,300}})));
      annotation (experiment(StopTime=3600),
                  Diagram(coordinateSystem(extent={{-200,-280},{200,320}})));
    end CheckPumpsOfBatchPlantWithForLoop4;

  record MediumObservation "Observation signals needed for one medium"
    import SI = Modelica.SIunits;
    SI.Pressure p "Medium pressure" annotation(Dialog);
    SI.Temperature T "Medium temperature" annotation(Dialog);
  end MediumObservation;

  record PipeObservation "Observation signals needed for one pipe"
    import SI = Modelica.SIunits;
    constant String name "Name of pipe";
    MediumObservation mediums[:] "Pipe medium nodes";
  end PipeObservation;

    model PipeRequirements "Requirements on several pipes"
      import Modelica.Utilities.Streams.print;
      parameter Modelica.SIunits.Pressure p_min = 100;
      input PipeObservation obs[:] annotation (Dialog);
    equation
       for i in 1:size(obs,1) loop
          for j in 1:size(obs[i].mediums,1) loop
             when obs[i].mediums[j].p <= p_min then
               print("... warning: pipe " + obs[i].name + " in mediums["
                     + String(j) + "] has too low pressure");
             end when;
          end for;
       end for;
    end PipeRequirements;

    function fromDynamicPipe
      input DynamicPipeObservation obs;
      input String name;
      output PipeObservation result(name=name, mediums=obs.mediums);
    protected
      record DynamicPipeObservation
         MediumObservation mediums[:];
      end DynamicPipeObservation;
    algorithm

      annotation(Inline=true);
    end fromDynamicPipe;

    model CheckPumpsAndPipesOfBatchPlant
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;
      extends MetaProperties.Icons.ExampleDoesNotTranslateInDymola;
      PumpRequirements pumpReq(obs={fromPrescribedPump(p,p.getInstanceName())
                                    for p in Modelica.Fluid.Machines.PrescribedPump});
      PipeRequirements pipeReq(obs={fromDynamicPipe(p,p.getInstanceName())
                                    for p in Modelica.Fluid.Pipes.DynamicPipe});

      annotation(experiment(StopTime=3600));
    end CheckPumpsAndPipesOfBatchPlant;

    model CheckPumpsAndPipesOfBatchPlant2
      "Same as CheckPumpsAndPipesOfBatchPlant but without for loop"
      import Modelica.Fluid.Examples.AST_BatchPlant;
      import MetaProperties.Section_4_2_InstanceBinding.*;
      extends AST_BatchPlant.BatchPlant_StandardWater;
      PumpRequirements pumpReq(obs={fromPrescribedPump(p,p.getInstanceName())
                                    for p in Modelica.Fluid.Machines.PrescribedPump});
      PipeRequirements pipeReq(obs={fromDynamicPipe(pipeB1B2,"pipeB1B2"),
                                    fromDynamicPipe(pipePump1B1,"pipePump1B1"),
                                    fromDynamicPipe(pipePump2B2,"pipePump2B2")});

      annotation(experiment(StopTime=3600));
    end CheckPumpsAndPipesOfBatchPlant2;
  end Section_4_3_ClassBinding;

  package Section_4_4_ClassBindingWithTwoClasses
    "Models to bind all instances of two classes to a requirement model"

    model CentrifugalPump "Dummy model of a centrifugal pump"
      output Real p;
    equation
      p = time;
    end CentrifugalPump;

    model ElectricMotor "Dummy model of an electric motor driving a pump"
      output Real V;
    equation
      V = 2*time;
    end ElectricMotor;

    model Subsystem "Dummy subsystem containing 3 pumps"
      CentrifugalPump P1;
      ElectricMotor   M1;
      CentrifugalPump P2;
      ElectricMotor   M2;
      CentrifugalPump P3;
      ElectricMotor   M3;
    end Subsystem;

    model CoolingSystem "Dummy system with 2 subsystems that have 3 pumps each"
      extends Modelica.Icons.Example;
      Subsystem subsystem1;
      Subsystem subsystem2;
    end CoolingSystem;

    record PumpObservation_cavitate
      Boolean cavitate;
    end PumpObservation_cavitate;

    record PumpObservation_inOperation
      Boolean inOperation;
    end PumpObservation_inOperation;

    function fromCPump
      input CentrifugalPumpObservation  obs;
      output PumpObservation_cavitate result(cavitate=obs.p < 0.5);
    protected
      record CentrifugalPumpObservation
         Real p;
      end CentrifugalPumpObservation;
    algorithm
      annotation(GenerateEvents=true);
    end fromCPump;

    function fromEMotor
      input ElectricMotorObservation  obs;
      output PumpObservation_inOperation result(inOperation=obs.V > 1.5);
    protected
      record ElectricMotorObservation
         Real V;
      end ElectricMotorObservation;
    algorithm

       annotation(GenerateEvents=true);
    end fromEMotor;

    function fromCPumpAndEMotor
       import MetaProperties.Section_4_2_InstanceBinding.PumpObservation;
       input PumpObservation_cavitate pObs[:];
       input PumpObservation_inOperation mObs[:];
       input Integer motorIndices[size(pObs,1)];
       output PumpObservation obs[size(pObs,1)];
    algorithm
       for i in 1:size(pObs,1) loop
          obs[i].cavitate :=pObs[i].cavitate;
          obs[i].inOperation :=mObs[motorIndices[i]].inOperation;
       end for;
       annotation(Inline=true);
    end fromCPumpAndEMotor;

    function associateCPumpsAndEMotorsByNames
      "Return EMotor j that belongs to CPump i"
       import Modelica.Utilities.Strings.replace;
       import Modelica.Utilities.Strings.isEqual;
       import Modelica.Utilities.Streams.print;

       input String pumpNames[:] "Full path names of pumps";
       input String motorNames[:] "Full path names of motor";
       input String pumpMotorAssociations[:,3] "[path, pumpName, motorName]";
       input String rootName;
       output Integer motorIndices[size(pumpNames,1)];
    protected
       String rName = rootName + ".";
       String mName;
       String name;
    algorithm
       // Find associations
       for i in 1:size(pumpNames,1) loop
          for j in 1:size(pumpMotorAssociations,1) loop
             // Find index of pump name in pumpMotorAssociation
             name :=rName + pumpMotorAssociations[j, 1] + "." + pumpMotorAssociations[j, 2];
             if isEqual(pumpNames[i], name) then
                mName :=rName + pumpMotorAssociations[j, 1] + "." + pumpMotorAssociations[j, 3];
                break;
             elseif j == size(pumpMotorAssociations,1) then
                assert(false, "No association found for pump " + pumpNames[i]);
             end if;
          end for;

          // Find index of motor in motorNames
          for j in 1:size(motorNames,1) loop
             if isEqual(motorNames[j], mName) then
                motorIndices[i] :=j;

                // Print association
                print("   pumpNames[" + String(i) + "] = " + pumpNames[i] +
                      ",  motorNames[" + String(j) + "] = " + motorNames[j]);
                break;
             elseif j == size(motorNames,1) then
                assert(false, "Motor " + mName + " not found for "+
                              "pump " + pumpNames[i]);
             end if;
          end for;
       end for;
    end associateCPumpsAndEMotorsByNames;

    model CheckCoolingSystem
      import MetaProperties.Section_4_2_InstanceBinding.PumpRequirements;
      extends CoolingSystem;

      constant String pumpMotorAssociations[:,3]=
         ["subsystem1", "P1", "M1";
          "subsystem1", "P2", "M2";
          "subsystem1", "P3", "M3";
          "subsystem2", "P1", "M1";
          "subsystem2", "P2", "M2";
          "subsystem2", "P3", "M3"];

      constant Integer motorIndices[:]=
         associateCPumpsAndEMotorsByNames(
            {p.getInstanceName() for p in CentrifugalPump},
            {m.getInstanceName() for m in ElectricMotor},
            pumpMotorAssociations, getInstanceName());

      PumpRequirements req(obs=
            fromCPumpAndEMotor( {fromCPump(p) for p in CentrifugalPump},
                                {fromEMotor(m) for m in ElectricMotor},
                                motorIndices));
    end CheckCoolingSystem;
  end Section_4_4_ClassBindingWithTwoClasses;

  package Section_4_4_ClassBindingWithTwoClassesAndID
    "Models to bind all instances of two classes to a requirement model using a component id"

    model CentrifugalPumpWithID "Dummy model of a centrifugal pump"
      constant Integer id;
      output Real p;
    equation
      p = time;
    end CentrifugalPumpWithID;

    model ElectricMotorWithID "Dummy model of an electric motor driving a pump"
      constant Integer id;
      output Real V;
    equation
      V = 2*time;
    end ElectricMotorWithID;

    model SubsystemWithID "Dummy subsystem containing 3 pumps"
      CentrifugalPumpWithID P1(id=1);
      ElectricMotorWithID   M1(id=1);
      CentrifugalPumpWithID P2(id=2);
      ElectricMotorWithID   M2(id=2);
      CentrifugalPumpWithID P3(id=3);
      ElectricMotorWithID   M3(id=3);
    end SubsystemWithID;

    model CoolingSystemWithID
      "Dummy system with 2 subsystems that have 3 pumps each"
      extends Modelica.Icons.Example;
      SubsystemWithID subsystem1;
      SubsystemWithID subsystem2(P1(id=4),M1(id=4),
                                 P2(id=5),M2(id=5),
                                 P3(id=6),M3(id=6));
    end CoolingSystemWithID;

    record PumpObservation_cavitate
      Boolean cavitate;
    end PumpObservation_cavitate;

    record PumpObservation_inOperation
      Boolean inOperation;
    end PumpObservation_inOperation;

    function fromCPump
      input CentrifugalPumpObservation  obs;
      output PumpObservation_cavitate result(cavitate=obs.p < 0.5);
    protected
      record CentrifugalPumpObservation
         Real p;
      end CentrifugalPumpObservation;
    algorithm
      annotation(GenerateEvents=true);
    end fromCPump;

    function fromEMotor
      input ElectricMotorObservation  obs;
      output PumpObservation_inOperation result(inOperation=obs.V > 1.5);
    protected
      record ElectricMotorObservation
         Real V;
      end ElectricMotorObservation;
    algorithm

       annotation(GenerateEvents=true);
    end fromEMotor;

    function fromCPumpAndEMotor
       import MetaProperties.Section_4_2_InstanceBinding.PumpObservation;
       input PumpObservation_cavitate pObs[:];
       input PumpObservation_inOperation mObs[:];
       input Integer motorIndices[size(pObs,1)];
       output PumpObservation obs[size(pObs,1)];
    algorithm
       for i in 1:size(pObs,1) loop
          obs[i].cavitate :=pObs[i].cavitate;
          obs[i].inOperation :=mObs[motorIndices[i]].inOperation;
       end for;
       annotation(Inline=true);
    end fromCPumpAndEMotor;

    function associateCPumpsAndEMotorsByID
      "Return EMotor j that belongs to CPump i"
       input Integer pumpIds[:];
       input Integer motorIds[:];
       output Integer motorIndices[size(pumpIds,1)];
    algorithm
       for i in 1:size(pumpIds,1) loop
          for j in 1:size(motorIds,1) loop
             if motorIds[j] == pumpIds[i] then
                motorIndices[i] :=j;
                break;
             elseif j == size(motorIds,1) then
                assert(false, "id's are wrong");
             end if;
          end for;
       end for;
    end associateCPumpsAndEMotorsByID;

    model CheckCoolingSystemWithID
      import MetaProperties.Section_4_2_InstanceBinding.PumpRequirements;
      extends CoolingSystemWithID;

      constant Integer motorIndices[:]=
           associateCPumpsAndEMotorsByID({p.id for p in CentrifugalPumpWithID},
                                         {m.id for m in ElectricMotorWithID});

      PumpRequirements req(obs=
            fromCPumpAndEMotor( {fromCPump(p) for p in CentrifugalPumpWithID},
                                {fromEMotor(m) for m in ElectricMotorWithID},
                                motorIndices));
    end CheckCoolingSystemWithID;
  end Section_4_4_ClassBindingWithTwoClassesAndID;

  package InstanceBindingWithTwoInstances
     model CentrifugalPump "Dummy model of a centrifugal pump"
      output Real p;
     equation
      p = time;
     end CentrifugalPump;

    model ElectricMotor "Dummy model of an electric motor driving a pump"
      output Real V;
    equation
      V = 2*time;
    end ElectricMotor;


    model CoolingSystem "Dummy cooling system with 3 pumps"
      extends Modelica.Icons.Example;
      CentrifugalPump P1;
      ElectricMotor   M1;
      CentrifugalPump P2;
      ElectricMotor   M2;
      CentrifugalPump P3;
      ElectricMotor   M3;
    end CoolingSystem;

  record PumpObservation "Observation signals needed for one pump"
    extends Modelica.Icons.Record;
    constant String name "Name of pump" annotation(Dialog);
    Boolean inOperation "= true, if in operation"  annotation(Dialog);
    Boolean cavitate "= true, if pump cavitates"  annotation(Dialog);
  end PumpObservation;

  model PumpRequirement "Requirement on one pump"
    import Modelica.Utilities.Streams.print;
    input PumpObservation obs annotation (Dialog);
  equation
    when obs.inOperation and obs.cavitate then
       print("... warning: pump " + obs.name + " is cavitating during operation");
    end when;
  end PumpRequirement;

  function fromCPumpAndEMotor
     input String  name;
     input CPumpObservation   cPump;
     input EMotorObservation  eMotor;
     output PumpObservation   obs(name=name, cavitate = cPump.p < 0.1, inOperation = eMotor.V > 1.5);
    protected
    record CPumpObservation
      Real p;
    end CPumpObservation;

    record EMotorObservation
      Real V;
    end EMotorObservation;
  algorithm

   annotation(Inline=true, GenerateEvents=true);
  end fromCPumpAndEMotor;

  model CheckCoolingSystem
    extends CoolingSystem;

    PumpRequirement R1(obs=fromCPumpAndEMotor("P1+M1", P1, M1));
    PumpRequirement R2(obs=fromCPumpAndEMotor("P2+M2", P2, M2));
    PumpRequirement R3(obs=fromCPumpAndEMotor("P3+M3", P3, M3));
  end CheckCoolingSystem;
  end InstanceBindingWithTwoInstances;

  package Icons

    partial model ExampleDoesNotTranslateInDymola
      "Icon for runnable example that does not translate in Dymola prototype for meta properties modeling"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Ellipse(lineColor={255,0,0},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor={255,0,0},
                    fillColor={255,0,0},
                    pattern=LinePattern.None,
                    fillPattern=FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end ExampleDoesNotTranslateInDymola;
  end Icons;

  package Utilities "Utility functions"
    extends Modelica.Icons.UtilitiesPackage;
    function getFirstName "Return first path of path name"
       import Modelica.Utilities.Strings;
       input String pathName "Path name";
       output String firstName
        "First part of name upto and not including the first dot";
    protected
       Integer iEnd;
    algorithm
       iEnd :=Strings.find(pathName, ".");
       firstName :=if iEnd == 0 then pathName else Strings.substring(pathName,1,iEnd-1);
    end getFirstName;

    function removeFirstName "Remove first part of name"
       import Modelica.Utilities.Strings;
       input String pathName "Path name";
       output String tail "Path name where first path has been removed";
    protected
       Integer iEnd;
       Integer iLen;
    algorithm
       iEnd :=Strings.find(pathName, ".");
       iLen :=Strings.length(pathName);
       tail :=if iEnd == 0 or iEnd >= iLen then pathName else Strings.substring(pathName,iEnd+1,iLen);
    end removeFirstName;
  end Utilities;

  annotation (uses(Modelica(version="3.2.1"), Modelica_Requirements(version=
            "0.10")),Documentation(info="<html>
<p>
This package requires a Dymola prototype and the flag:
</p>

<pre>
Hidden.AllowAutomaticInstanceOf=true;
</pre>

<p>
Issues in MetaProperties.Section_4_3_ClassBinding:
</p>

<ul>
<li> CheckPumpsOfBatchPlantWithForLoop (doesnot use Modelica_Requirements library; has a for-loop over a check)<br>
Simulates correctly in Dymola </li>

<li> CheckPumpsOfBatchPlantWithForLoop2 (defines requirements for one pump graphically in a model and uses the new
component iterator to iterate over all instances).<br>
Simulates in Dymola, but the result is wrong (all observation values prescribedPumpReq.obs[:] are zero)</li>

<li> CheckPumpsOfBatchPlantWithForLoop3 (same as CheckPumpsOfBatchPlantWithForLoop2, but mapping not performed
with function but explicitely with record constructor).<br>
Simulates in Dymola, but the result is wrong (all observation values prescribedPumpReq.obs[:] are zero).<br>
This means the reason is NOT the function that maps from a model to a record.</li>

<li> CheckPumpsOfBatchPlantWithForLoop4 (same as CheckPumpsOfBatchPlantWithForLoop3, but for-loop
is in a model that is dragged to the top model).<br>
Translation errors in Dymola</li>
</ul>

</html>"));
end MetaProperties;
