within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidHeatFlowTemperatureSensorBaseline "MSL FluidHeatFlow TemperatureSensor and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambientOriginal(medium=medium,constantAmbientTemperature=310) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),ambientFaultable(medium=medium,constantAmbientTemperature=310) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Thermal.FluidHeatFlow.Sensors.TemperatureSensor original(medium=medium) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  FaultReplacementLibrary.Thermal.FluidHeatFlow.Sensors.FaultableTemperatureSensor faultable(medium=medium,severity=0);
equation
  connect(ambientOriginal.flowPort,original.flowPort)
    annotation(Line(points={{-80,40},{0,40}}, color={0,127,255})); connect(ambientFaultable.flowPort,faultable.flowPort)
    annotation(Line(points={{-80,-40},{80,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.y-faultable.y)<1e-8),"FluidHeatFlow TemperatureSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidHeatFlowTemperatureSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FluidHeatFlowTemperatureSensorBaseline;
