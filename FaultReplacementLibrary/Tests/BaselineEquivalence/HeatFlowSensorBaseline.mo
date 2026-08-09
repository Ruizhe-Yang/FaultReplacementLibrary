within FaultReplacementLibrary.Tests.BaselineEquivalence;
model HeatFlowSensorBaseline "Executable HeatTransfer Normal equivalence test"
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hotOriginal(T=320) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),hotFaultable(T=320) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),coldOriginal(T=280) annotation(Placement(transformation(extent={{30,30},{50,50}}))),coldFaultable(T=280) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor original annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Sensors.FaultableHeatFlowSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loadOriginal(G=5) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),loadFaultable(G=5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(hotOriginal.port,original.port_a)
    annotation(Line(points={{-80,40},{-50,40}}, color={0,0,255})); connect(original.port_b,loadOriginal.port_a)
    annotation(Line(points={{-30,40},{-10,40}}, color={0,0,255})); connect(loadOriginal.port_b,coldOriginal.port)
    annotation(Line(points={{10,40},{40,40}}, color={0,0,255}));
  connect(hotFaultable.port,faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={0,0,255})); connect(faultable.port_b,loadFaultable.port_a)
    annotation(Line(points={{90,-40},{-10,-40}}, color={0,0,255})); connect(loadFaultable.port_b,coldFaultable.port)
    annotation(Line(points={{10,-40},{40,-40}}, color={0,0,255}));
  assert(noEvent(abs(original.Q_flow-faultable.Q_flow)<1e-9),"HeatFlowSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 HeatFlowSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end HeatFlowSensorBaseline;
