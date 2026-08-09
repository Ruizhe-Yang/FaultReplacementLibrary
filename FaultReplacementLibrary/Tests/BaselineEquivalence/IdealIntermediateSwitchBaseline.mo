within FaultReplacementLibrary.Tests.BaselineEquivalence;
model IdealIntermediateSwitchBaseline "MSL IdealIntermediateSwitch and faultable annotation(Placement(transformation(extent={{-44,30},{-24,50}}))) Normal equivalence"
  Modelica.Electrical.Analog.Ideal.IdealIntermediateSwitch original annotation(Placement(transformation(extent={{-67,-50},{-47,-30}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealIntermediateSwitch faultable(severity=0);
  Modelica.Blocks.Sources.BooleanStep command(startTime=0.4,startValue=false) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage source1Original(V=5) annotation(Placement(transformation(extent={{-21,30},{-1,50}}))),source2Original(V=3) annotation(Placement(transformation(extent={{1,30},{21,50}}))),source1Faultable(V=5) annotation(Placement(transformation(extent={{-21,-50},{-1,-30}}))),source2Faultable(V=3) annotation(Placement(transformation(extent={{1,-50},{21,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor load1Original(R=10) annotation(Placement(transformation(extent={{47,30},{67,50}}))),load2Original(R=20) annotation(Placement(transformation(extent={{70,30},{90,50}}))),load1Faultable(R=10) annotation(Placement(transformation(extent={{47,-50},{67,-30}}))),load2Faultable(R=20) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{24,30},{44,50}}))),groundFaultable annotation(Placement(transformation(extent={{24,-50},{44,-30}})));
equation
  connect(command.y,original.control)
    annotation(Line(points={{-70,40},{-68,40},{-68,-40},{-67,-40}}, color={0,0,127})); connect(command.y,faultable.control)
    annotation(Line(points={{-70,40},{-44,40}}, color={0,0,127}));
  connect(source1Original.p,original.p1)
    annotation(Line(points={{-21,40},{-44,40},{-44,-40},{-67,-40}}, color={0,0,255})); connect(source2Original.p,original.p2)
    annotation(Line(points={{1,40},{-33,40},{-33,-40},{-67,-40}}, color={0,0,255})); connect(source1Original.n,groundOriginal.p)
    annotation(Line(points={{-1,40},{16,40},{16,50},{34,50}}, color={0,0,255})); connect(source2Original.n,groundOriginal.p)
    annotation(Line(points={{21,40},{28,40},{28,50},{34,50}}, color={0,0,255})); connect(original.n1,load1Original.p)
    annotation(Line(points={{-47,-40},{0,-40},{0,40},{47,40}}, color={0,0,255})); connect(original.n2,load2Original.p)
    annotation(Line(points={{-47,-40},{12,-40},{12,40},{70,40}}, color={0,0,255})); connect(load1Original.n,groundOriginal.p)
    annotation(Line(points={{67,40},{50,40},{50,50},{34,50}}, color={0,0,255})); connect(load2Original.n,groundOriginal.p)
    annotation(Line(points={{90,40},{62,40},{62,50},{34,50}}, color={0,0,255}));
  connect(source1Faultable.p,faultable.p1)
    annotation(Line(points={{-21,-40},{-32,-40},{-32,40},{-44,40}}, color={0,0,255})); connect(source2Faultable.p,faultable.p2)
    annotation(Line(points={{1,-40},{-22,-40},{-22,40},{-44,40}}, color={0,0,255})); connect(source1Faultable.n,groundFaultable.p)
    annotation(Line(points={{-1,-40},{16,-40},{16,-30},{34,-30}}, color={0,0,255})); connect(source2Faultable.n,groundFaultable.p)
    annotation(Line(points={{21,-40},{28,-40},{28,-30},{34,-30}}, color={0,0,255})); connect(faultable.n1,load1Faultable.p)
    annotation(Line(points={{-24,40},{12,40},{12,-40},{47,-40}}, color={0,0,255})); connect(faultable.n2,load2Faultable.p)
    annotation(Line(points={{-24,40},{23,40},{23,-40},{70,-40}}, color={0,0,255})); connect(load1Faultable.n,groundFaultable.p)
    annotation(Line(points={{67,-40},{50,-40},{50,-30},{34,-30}}, color={0,0,255})); connect(load2Faultable.n,groundFaultable.p)
    annotation(Line(points={{90,-40},{62,-40},{62,-30},{34,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.p1.i-faultable.p1.i)<1e-8 and abs(original.p2.i-faultable.p2.i)<1e-8),"IdealIntermediateSwitch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 IdealIntermediateSwitchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end IdealIntermediateSwitchBaseline;
