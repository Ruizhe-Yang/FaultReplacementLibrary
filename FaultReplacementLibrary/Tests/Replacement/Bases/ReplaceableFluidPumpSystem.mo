within FaultReplacementLibrary.Tests.Replacement.Bases;
partial model ReplaceableFluidPumpSystem
  "Replaceable shaft-driven Modelica.Fluid pump topology"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal[3]={0,0.001,0.002};
  parameter Modelica.Units.SI.Position head_nominal[3]={20,10,0};
  inner Modelica.Fluid.System system(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
  Modelica.Fluid.Sources.Boundary_pT inlet(
    redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Fluid.Sources.Boundary_pT outlet(
    redeclare package Medium=Medium,nPorts=1,p=1.2e5,T=300) annotation(Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed drive(
    w_fixed=1500*2*Modelica.Constants.pi/60);
  replaceable Modelica.Fluid.Machines.Pump device(
    redeclare package Medium=Medium,N_nominal=1500,
    redeclare function flowCharacteristic=Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(
      V_flow_nominal=V_flow_nominal,head_nominal=head_nominal))
    constrainedby Modelica.Fluid.Interfaces.PartialTwoPort(redeclare package Medium=Medium)
    annotation(choicesAllMatching=true, Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(inlet.ports[1],device.port_a)
    annotation(Line(points={{-80,40},{-45,40},{-45,-40},{-10,-40}}, color={0,127,255}));
  connect(device.port_b,outlet.ports[1])
    annotation(Line(points={{10,-40},{45,-40},{45,40},{80,40}}, color={0,127,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableFluidPumpSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableFluidPumpSystem;
