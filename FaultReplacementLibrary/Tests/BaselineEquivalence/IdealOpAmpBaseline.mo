within FaultReplacementLibrary.Tests.BaselineEquivalence;
model IdealOpAmpBaseline "MSL IdealOpAmp voltage follower Normal equivalence"
  Modelica.Electrical.Analog.Ideal.IdealOpAmp original annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealOpAmp faultable(severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=1,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V=1,f=1) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{30,30},{50,50}}))),loadFaultable(R=10) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),groundFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(sourceOriginal.p,original.p1)
    annotation(Line(points={{-90,40},{-50,40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-35,40},{-35,50},{0,50}}, color={0,0,255})); connect(original.n1,original.p2)
    annotation(Line(points={{-30,40},{-50,40}}, color={0,0,255})); connect(original.p2,loadOriginal.p)
    annotation(Line(points={{-50,40},{30,40}}, color={0,0,255})); connect(original.n2,groundOriginal.p)
    annotation(Line(points={{-30,40},{-15,40},{-15,50},{0,50}}, color={0,0,255})); connect(loadOriginal.n,groundOriginal.p)
    annotation(Line(points={{50,40},{25,40},{25,50},{0,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p1)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{-70,-40},{-35,-40},{-35,-30},{0,-30}}, color={0,0,255})); connect(faultable.n1,faultable.p2)
    annotation(Line(points={{90,-40},{70,-40}}, color={0,0,255})); connect(faultable.p2,loadFaultable.p)
    annotation(Line(points={{70,-40},{30,-40}}, color={0,0,255})); connect(faultable.n2,groundFaultable.p)
    annotation(Line(points={{90,-40},{45,-40},{45,-30},{0,-30}}, color={0,0,255})); connect(loadFaultable.n,groundFaultable.p)
    annotation(Line(points={{50,-40},{25,-40},{25,-30},{0,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.v2-faultable.v2)<1e-8 and abs(original.i2-faultable.i2)<1e-8),"IdealOpAmp Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 IdealOpAmpBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end IdealOpAmpBaseline;
