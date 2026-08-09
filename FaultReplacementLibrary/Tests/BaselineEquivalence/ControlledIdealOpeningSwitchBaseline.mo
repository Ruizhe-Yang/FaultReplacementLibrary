within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ControlledIdealOpeningSwitchBaseline "MSL controlled opening switch and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Electrical.Analog.Ideal.ControlledIdealOpeningSwitch original(level=0.5) annotation(Placement(transformation(extent={{-58,30},{-38,50}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableControlledIdealOpeningSwitch faultable(level=0.5,severity=0);
  Modelica.Electrical.Analog.Sources.RampVoltage commandOriginal(V=1,duration=0.2,startTime=0.3) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),commandFaultable(V=1,duration=0.2,startTime=0.3) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceOriginal(V=5) annotation(Placement(transformation(extent={{6,30},{26,50}}))),sourceFaultable(V=5) annotation(Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{38,30},{58,50}}))),loadFaultable(R=10) annotation(Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-26,30},{-6,50}}))),groundFaultable annotation(Placement(transformation(extent={{-26,-50},{-6,-30}})));
equation
  connect(commandOriginal.p,original.control)
    annotation(Line(points={{-90,40},{-58,40}}, color={0,0,127})); connect(commandOriginal.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-43,40},{-43,50},{-16,50}}, color={0,0,255}));
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{6,40},{-58,40}}, color={0,0,255})); connect(original.n,loadOriginal.p)
    annotation(Line(points={{-38,40},{38,40}}, color={0,0,255})); connect(loadOriginal.n,groundOriginal.p)
    annotation(Line(points={{58,40},{21,40},{21,50},{-16,50}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{26,40},{5,40},{5,50},{-16,50}}, color={0,0,255}));
  connect(commandFaultable.p,faultable.control)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,127})); connect(commandFaultable.n,groundFaultable.p)
    annotation(Line(points={{-70,-40},{-43,-40},{-43,-30},{-16,-30}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{6,-40},{70,-40}}, color={0,0,255})); connect(faultable.n,loadFaultable.p)
    annotation(Line(points={{90,-40},{38,-40}}, color={0,0,255})); connect(loadFaultable.n,groundFaultable.p)
    annotation(Line(points={{58,-40},{21,-40},{21,-30},{-16,-30}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{26,-40},{5,-40},{5,-30},{-16,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i-faultable.i)<1e-8),"ControlledIdealOpeningSwitch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ControlledIdealOpeningSwitchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ControlledIdealOpeningSwitchBaseline;
