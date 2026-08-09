within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableFluidHeatFlowPipeSystem "Replaceable MSL FluidHeatFlow pipe system"
  parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient inlet(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),outlet(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow pump(medium=medium,m=0,T0=293.15,constantVolumeFlow=0.1) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  replaceable Modelica.Thermal.FluidHeatFlow.Components.Pipe device(
    medium=medium,m=0,T0=293.15,h_g=0,V_flowLaminar=0.01,dpLaminar=10,V_flowNominal=0.1,dpNominal=100)
    constrainedby Modelica.Thermal.FluidHeatFlow.BaseClasses.TwoPort(medium=medium)
    annotation(choicesAllMatching=true, Placement(transformation(extent={{17,30},{37,50}})));
equation
  connect(inlet.flowPort,pump.flowPort_a)
    annotation(Line(points={{-80,40},{-54,40},{-54,-40},{-27,-40}}, color={0,127,255})); connect(pump.flowPort_b,device.flowPort_a)
    annotation(Line(points={{-27,-40},{0,-40},{0,40},{27,40}}, color={0,127,255})); connect(device.flowPort_b,outlet.flowPort)
    annotation(Line(points={{27,40},{54,40},{54,-40},{80,-40}}, color={0,127,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableFluidHeatFlowPipeSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableFluidHeatFlowPipeSystem;
