within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableThermalConductorSystem "MSL nominal component declared replaceable"
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hot(T=320) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T=280) annotation(Placement(transformation(extent={{70,30},{90,50}})));
  replaceable Modelica.Thermal.HeatTransfer.Components.ThermalConductor device(G=5) constrainedby Modelica.Thermal.HeatTransfer.Interfaces.Element1D annotation(choicesAllMatching=true, Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(hot.port,device.port_a)
    annotation(Line(points={{-80,40},{-45,40},{-45,-40},{-10,-40}}, color={191,0,0})); connect(device.port_b,cold.port)
    annotation(Line(points={{10,-40},{45,-40},{45,40},{80,40}}, color={191,0,0}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableThermalConductorSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableThermalConductorSystem;
