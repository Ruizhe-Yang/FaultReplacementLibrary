within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ThermalResistorBaseline "Executable HeatTransfer Normal equivalence test"
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hotOriginal(T=320) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),hotFaultable(T=320) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),coldOriginal(T=280) annotation(Placement(transformation(extent={{17,30},{37,50}}))),coldFaultable(T=280) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor original(R=2) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableThermalResistor faultable(R=2,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(hotOriginal.port,original.port_a)
    annotation(Line(points={{-80,40},{-37,40}}, color={191,0,0})); connect(original.port_b,coldOriginal.port)
    annotation(Line(points={{-17,40},{27,40}}, color={191,0,0}));
  connect(hotFaultable.port,faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={191,0,0})); connect(faultable.port_b,coldFaultable.port)
    annotation(Line(points={{90,-40},{27,-40}}, color={191,0,0}));
  assert(noEvent(abs(original.Q_flow-faultable.Q_flow)<1e-9),"ThermalResistor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ThermalResistorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ThermalResistorBaseline;
