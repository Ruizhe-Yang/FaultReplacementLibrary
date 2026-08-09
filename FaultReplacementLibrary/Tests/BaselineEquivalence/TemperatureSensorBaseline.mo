within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TemperatureSensorBaseline "Executable Normal/severity=0 numerical equivalence test"
  Modelica.Blocks.Sources.Sine temperatureSignal(amplitude=10,f=0.5,offset=310) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature boundaryOriginal annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature boundaryFaultable annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor original annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Sensors.FaultableTemperatureSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(temperatureSignal.y,boundaryOriginal.T)
    annotation(Line(points={{-70,40},{-27,40}}, color={0,0,127})); connect(temperatureSignal.y,boundaryFaultable.T)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127}));
  connect(boundaryOriginal.port,original.port)
    annotation(Line(points={{-27,40},{0,40},{0,-40},{27,-40}}, color={0,0,255})); connect(boundaryFaultable.port,faultable.port)
    annotation(Line(points={{-27,-40},{26,-40},{26,40},{80,40}}, color={0,0,255}));
  assert(noEvent(abs(original.T-faultable.T)<1e-10),"TemperatureSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TemperatureSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TemperatureSensorBaseline;
