within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ControlledIdealTwoWaySwitchBaseline "MSL controlled two-way switch and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Electrical.Analog.Ideal.ControlledIdealTwoWaySwitch original(level=0.5) annotation(Placement(transformation(extent={{-63,30},{-43,50}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableControlledIdealTwoWaySwitch faultable(level=0.5,severity=0);
  Modelica.Electrical.Analog.Sources.RampVoltage commandOriginal(V=1,duration=0.2,startTime=0.3) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),commandFaultable(V=1,duration=0.2,startTime=0.3) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceOriginal(V=5) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),sourceFaultable(V=5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor load1Original(R=10) annotation(Placement(transformation(extent={{17,30},{37,50}}))),load2Original(R=20) annotation(Placement(transformation(extent={{43,30},{63,50}}))),load1Faultable(R=10) annotation(Placement(transformation(extent={{17,-50},{37,-30}}))),load2Faultable(R=20) annotation(Placement(transformation(extent={{43,-50},{63,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-37,30},{-17,50}}))),groundFaultable annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
equation
  connect(commandOriginal.p,original.control)
    annotation(Line(points={{-90,40},{-63,40}}, color={0,0,127})); connect(commandOriginal.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-48,40},{-48,50},{-27,50}}, color={0,0,255})); connect(sourceOriginal.p,original.p)
    annotation(Line(points={{-10,40},{-63,40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{10,40},{-8,40},{-8,50},{-27,50}}, color={0,0,255})); connect(original.n1,load1Original.p)
    annotation(Line(points={{-43,40},{17,40}}, color={0,0,255})); connect(original.n2,load2Original.p)
    annotation(Line(points={{-43,40},{43,40}}, color={0,0,255})); connect(load1Original.n,groundOriginal.p)
    annotation(Line(points={{37,40},{5,40},{5,50},{-27,50}}, color={0,0,255})); connect(load2Original.n,groundOriginal.p)
    annotation(Line(points={{63,40},{18,40},{18,50},{-27,50}}, color={0,0,255}));
  connect(commandFaultable.p,faultable.control)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,127})); connect(commandFaultable.n,groundFaultable.p)
    annotation(Line(points={{-70,-40},{-48,-40},{-48,-30},{-27,-30}}, color={0,0,255})); connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{-10,-40},{70,-40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{10,-40},{-8,-40},{-8,-30},{-27,-30}}, color={0,0,255})); connect(faultable.n1,load1Faultable.p)
    annotation(Line(points={{90,-40},{17,-40}}, color={0,0,255})); connect(faultable.n2,load2Faultable.p)
    annotation(Line(points={{90,-40},{43,-40}}, color={0,0,255})); connect(load1Faultable.n,groundFaultable.p)
    annotation(Line(points={{37,-40},{5,-40},{5,-30},{-27,-30}}, color={0,0,255})); connect(load2Faultable.n,groundFaultable.p)
    annotation(Line(points={{63,-40},{18,-40},{18,-30},{-27,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.p.i-faultable.p.i)<1e-8),"ControlledIdealTwoWaySwitch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ControlledIdealTwoWaySwitchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ControlledIdealTwoWaySwitchBaseline;
