within FaultReplacementLibrary.Tests.BaselineEquivalence;
model CurrentSensorBaseline "Executable electrical sensor Normal equivalence test"
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=5,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V=5,f=1) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor original annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Electrical.Analog.Sensors.FaultableCurrentSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),loadFaultable(R=10) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{30,30},{50,50}}))),groundFaultable annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{-90,40},{-50,40}}, color={0,0,255})); connect(original.n,loadOriginal.p)
    annotation(Line(points={{-30,40},{-10,40}}, color={0,0,255})); connect(loadOriginal.n,sourceOriginal.n)
    annotation(Line(points={{10,40},{-70,40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-15,40},{-15,50},{40,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,255})); connect(faultable.n,loadFaultable.p)
    annotation(Line(points={{90,-40},{-10,-40}}, color={0,0,255})); connect(loadFaultable.n,sourceFaultable.n)
    annotation(Line(points={{10,-40},{-70,-40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{-70,-40},{-15,-40},{-15,-30},{40,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i-faultable.i)<1e-9),"CurrentSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 CurrentSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end CurrentSensorBaseline;
