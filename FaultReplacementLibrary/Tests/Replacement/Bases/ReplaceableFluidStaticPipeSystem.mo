within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableFluidStaticPipeSystem "Replaceable Modelica.Fluid StaticPipe system"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  inner Modelica.Fluid.System system;
  Modelica.Fluid.Sources.Boundary_pT inlet(redeclare package Medium=Medium,nPorts=1,p=3e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),outlet(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{70,30},{90,50}})));
  replaceable Modelica.Fluid.Pipes.StaticPipe device(redeclare package Medium=Medium,length=1,diameter=0.02)
    constrainedby Modelica.Fluid.Interfaces.PartialTwoPort(redeclare package Medium=Medium)
    annotation(choicesAllMatching=true, Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(inlet.ports[1],device.port_a)
    annotation(Line(points={{-80,40},{-45,40},{-45,-40},{-10,-40}}, color={0,127,255})); connect(device.port_b,outlet.ports[1])
    annotation(Line(points={{10,-40},{45,-40},{45,40},{80,40}}, color={0,127,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableFluidStaticPipeSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableFluidStaticPipeSystem;
