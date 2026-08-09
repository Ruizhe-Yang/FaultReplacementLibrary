within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidHeatFlowRelTemperatureSensorBaseline "MSL FluidHeatFlow RelTemperatureSensor and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient hotOriginal(medium=medium,constantAmbientTemperature=310) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),coldOriginal(medium=medium,constantAmbientTemperature=290) annotation(Placement(transformation(extent={{17,30},{37,50}}))),hotFaultable(medium=medium,constantAmbientTemperature=310) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),coldFaultable(medium=medium,constantAmbientTemperature=290) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Thermal.FluidHeatFlow.Sensors.RelTemperatureSensor original(medium=medium) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Thermal.FluidHeatFlow.Sensors.FaultableRelTemperatureSensor faultable(medium=medium,severity=0);
equation
  connect(hotOriginal.flowPort,original.flowPort_a)
    annotation(Line(points={{-80,40},{-27,40}}, color={0,127,255})); connect(coldOriginal.flowPort,original.flowPort_b)
    annotation(Line(points={{27,40},{-27,40}}, color={0,127,255})); connect(hotFaultable.flowPort,faultable.flowPort_a)
    annotation(Line(points={{-80,-40},{80,-40}}, color={0,127,255})); connect(coldFaultable.flowPort,faultable.flowPort_b)
    annotation(Line(points={{27,-40},{80,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.y-faultable.y)<1e-8),"FluidHeatFlow RelTemperatureSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidHeatFlowRelTemperatureSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FluidHeatFlowRelTemperatureSensorBaseline;
