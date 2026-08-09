within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ResistorBaseline "官方电阻与 FaultableResistor Normal 等价性"
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=10, f=5) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sourceFaultable(V=10, f=5) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor original(R=7.5) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Electrical.Analog.Basic.FaultableResistor faultable(
    R=7.5,
    faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableResistor.FaultMode.Normal) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{17,30},{37,50}})));
  Modelica.Electrical.Analog.Basic.Ground groundFaultable annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
equation
  connect(sourceOriginal.p, original.p)
    annotation(Line(points={{-90,40},{-37,40}}, color={0,0,255}));
  connect(original.n, sourceOriginal.n)
    annotation(Line(points={{-17,40},{-70,40}}, color={0,0,255}));
  connect(sourceOriginal.n, groundOriginal.p)
    annotation(Line(points={{-70,40},{-22,40},{-22,50},{27,50}}, color={0,0,255}));
  connect(sourceFaultable.p, faultable.p)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,255}));
  connect(faultable.n, sourceFaultable.n)
    annotation(Line(points={{90,-40},{-70,-40}}, color={0,0,255}));
  connect(sourceFaultable.n, groundFaultable.p)
    annotation(Line(points={{-70,-40},{-22,-40},{-22,-30},{27,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i - faultable.i) < 1e-10),
    "FaultableResistor Normal 与 MSL Resistor 不等价");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ResistorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1, Tolerance=1e-9));
end ResistorBaseline;
