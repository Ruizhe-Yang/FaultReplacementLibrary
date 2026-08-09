within FaultReplacementLibrary.Tests.BaselineEquivalence;
model IdealOpeningSwitchBaseline "MSL IdealOpeningSwitch and faultable annotation(Placement(transformation(extent={{-26,30},{-6,50}}))) Normal equivalence"
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch original annotation(Placement(transformation(extent={{-58,-50},{-38,-30}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealOpeningSwitch faultable(severity=0);
  Modelica.Blocks.Sources.BooleanStep command(startTime=0.4,startValue=false) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceOriginal(V=5) annotation(Placement(transformation(extent={{6,30},{26,50}}))),sourceFaultable(V=5) annotation(Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{38,30},{58,50}}))),loadFaultable(R=10) annotation(Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{70,30},{90,50}}))),groundFaultable annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(command.y,original.control)
    annotation(Line(points={{-70,40},{-64,40},{-64,-40},{-58,-40}}, color={0,0,127})); connect(command.y,faultable.control)
    annotation(Line(points={{-70,40},{-26,40}}, color={0,0,127}));
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{6,40},{-26,40},{-26,-40},{-58,-40}}, color={0,0,255})); connect(original.n,loadOriginal.p)
    annotation(Line(points={{-38,-40},{0,-40},{0,40},{38,40}}, color={0,0,255})); connect(loadOriginal.n,groundOriginal.p)
    annotation(Line(points={{58,40},{69,40},{69,50},{80,50}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{26,40},{53,40},{53,50},{80,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{6,-40},{-10,-40},{-10,40},{-26,40}}, color={0,0,255})); connect(faultable.n,loadFaultable.p)
    annotation(Line(points={{-6,40},{16,40},{16,-40},{38,-40}}, color={0,0,255})); connect(loadFaultable.n,groundFaultable.p)
    annotation(Line(points={{58,-40},{69,-40},{69,-30},{80,-30}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{26,-40},{53,-40},{53,-30},{80,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i-faultable.i)<1e-8),"IdealOpeningSwitch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 IdealOpeningSwitchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end IdealOpeningSwitchBaseline;
