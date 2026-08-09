within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableVoltageSensorSystem "Replaceable MSL VoltageSensor system"
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V=5) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Electrical.Analog.Basic.Ground ground annotation(Placement(transformation(extent={{70,30},{90,50}})));
  replaceable Modelica.Electrical.Analog.Sensors.VoltageSensor device
    constrainedby Modelica.Electrical.Analog.Sensors.VoltageSensor
    annotation(choicesAllMatching=true, Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(source.p,device.p)
    annotation(Line(points={{-90,40},{-50,40},{-50,-40},{-10,-40}}, color={0,0,255})); connect(source.n,device.n)
    annotation(Line(points={{-70,40},{-30,40},{-30,-40},{10,-40}}, color={0,0,255})); connect(source.n,ground.p)
    annotation(Line(points={{-70,40},{5,40},{5,50},{80,50}}, color={0,0,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableVoltageSensorSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableVoltageSensorSystem;
