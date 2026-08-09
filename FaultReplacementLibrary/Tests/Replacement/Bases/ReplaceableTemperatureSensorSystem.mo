within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableTemperatureSensorSystem "Replaceable MSL HeatTransfer TemperatureSensor system"
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature source(T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  replaceable Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor device
    constrainedby Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    annotation(choicesAllMatching=true, Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(source.port,device.port)
    annotation(Line(points={{-80,40},{0,40},{0,-40},{80,-40}}, color={0,0,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableTemperatureSensorSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableTemperatureSensorSystem;
