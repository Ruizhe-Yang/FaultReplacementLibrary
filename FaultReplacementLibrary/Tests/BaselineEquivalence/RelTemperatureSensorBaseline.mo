within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RelTemperatureSensorBaseline "Executable HeatTransfer Normal equivalence test"
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hotOriginal(T=320) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),hotFaultable(T=320) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),coldOriginal(T=280) annotation(Placement(transformation(extent={{17,30},{37,50}}))),coldFaultable(T=280) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.RelTemperatureSensor original annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Sensors.FaultableRelTemperatureSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(hotOriginal.port,original.port_a)
    annotation(Line(points={{-80,40},{-37,40}}, color={0,0,255})); connect(coldOriginal.port,original.port_b)
    annotation(Line(points={{27,40},{-17,40}}, color={0,0,255}));
  connect(hotFaultable.port,faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={0,0,255})); connect(coldFaultable.port,faultable.port_b)
    annotation(Line(points={{27,-40},{90,-40}}, color={0,0,255}));
  assert(noEvent(abs(original.T_rel-faultable.T_rel)<1e-9),"RelTemperatureSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RelTemperatureSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RelTemperatureSensorBaseline;
