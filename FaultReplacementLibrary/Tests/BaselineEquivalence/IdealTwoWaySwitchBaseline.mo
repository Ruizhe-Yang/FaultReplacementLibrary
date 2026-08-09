within FaultReplacementLibrary.Tests.BaselineEquivalence;
model IdealTwoWaySwitchBaseline "MSL IdealTwoWaySwitch and faultable annotation(Placement(transformation(extent={{-37,30},{-17,50}}))) Normal equivalence"
  Modelica.Electrical.Analog.Ideal.IdealTwoWaySwitch original annotation(Placement(transformation(extent={{-63,-50},{-43,-30}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealTwoWaySwitch faultable(severity=0);
  Modelica.Blocks.Sources.BooleanStep command(startTime=0.4,startValue=false) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceOriginal(V=5) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),sourceFaultable(V=5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor load1Original(R=10) annotation(Placement(transformation(extent={{43,30},{63,50}}))),load2Original(R=20) annotation(Placement(transformation(extent={{70,30},{90,50}}))),load1Faultable(R=10) annotation(Placement(transformation(extent={{43,-50},{63,-30}}))),load2Faultable(R=20) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{17,30},{37,50}}))),groundFaultable annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
equation
  connect(command.y,original.control)
    annotation(Line(points={{-70,40},{-66,40},{-66,-40},{-63,-40}}, color={0,0,127})); connect(command.y,faultable.control)
    annotation(Line(points={{-70,40},{-37,40}}, color={0,0,127}));
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{-10,40},{-36,40},{-36,-40},{-63,-40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{10,40},{18,40},{18,50},{27,50}}, color={0,0,255})); connect(original.n1,load1Original.p)
    annotation(Line(points={{-43,-40},{0,-40},{0,40},{43,40}}, color={0,0,255})); connect(original.n2,load2Original.p)
    annotation(Line(points={{-43,-40},{14,-40},{14,40},{70,40}}, color={0,0,255})); connect(load1Original.n,groundOriginal.p)
    annotation(Line(points={{63,40},{45,40},{45,50},{27,50}}, color={0,0,255})); connect(load2Original.n,groundOriginal.p)
    annotation(Line(points={{90,40},{58,40},{58,50},{27,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{-10,-40},{-24,-40},{-24,40},{-37,40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{10,-40},{18,-40},{18,-30},{27,-30}}, color={0,0,255})); connect(faultable.n1,load1Faultable.p)
    annotation(Line(points={{-17,40},{13,40},{13,-40},{43,-40}}, color={0,0,255})); connect(faultable.n2,load2Faultable.p)
    annotation(Line(points={{-17,40},{26,40},{26,-40},{70,-40}}, color={0,0,255})); connect(load1Faultable.n,groundFaultable.p)
    annotation(Line(points={{63,-40},{45,-40},{45,-30},{27,-30}}, color={0,0,255})); connect(load2Faultable.n,groundFaultable.p)
    annotation(Line(points={{90,-40},{58,-40},{58,-30},{27,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.p.i-faultable.p.i)<1e-8),"IdealTwoWaySwitch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 IdealTwoWaySwitchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end IdealTwoWaySwitchBaseline;
