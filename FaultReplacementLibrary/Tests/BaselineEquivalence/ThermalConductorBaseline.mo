within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ThermalConductorBaseline "Executable Normal/severity=0 numerical equivalence test"
  Modelica.Blocks.Sources.Sine temperatureSignal(amplitude=10,f=0.5,offset=310) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hotOriginal annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hotFaultable annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature coldOriginal(T=290) annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature coldFaultable(T=290) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor original(G=5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableThermalConductor faultable(G=5,severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(temperatureSignal.y,hotOriginal.T)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,127})); connect(temperatureSignal.y,hotFaultable.T)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127}));
  connect(hotOriginal.port,original.port_a)
    annotation(Line(points={{-40,40},{-25,40},{-25,-40},{-10,-40}}, color={191,0,0})); connect(original.port_b,coldOriginal.port)
    annotation(Line(points={{10,-40},{25,-40},{25,40},{40,40}}, color={191,0,0}));
  connect(hotFaultable.port,faultable.port_a)
    annotation(Line(points={{-40,-40},{15,-40},{15,40},{70,40}}, color={191,0,0})); connect(faultable.port_b,coldFaultable.port)
    annotation(Line(points={{90,40},{65,40},{65,-40},{40,-40}}, color={191,0,0}));
  assert(noEvent(abs(original.Q_flow-faultable.Q_flow)<1e-8),"ThermalConductor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ThermalConductorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ThermalConductorBaseline;
