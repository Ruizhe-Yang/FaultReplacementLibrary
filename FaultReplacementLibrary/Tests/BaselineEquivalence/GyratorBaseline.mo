within FaultReplacementLibrary.Tests.BaselineEquivalence;
model GyratorBaseline "MSL Gyrator and FaultableGyrator Normal equivalence"
  Modelica.Electrical.Analog.Basic.Gyrator original(G1=0.2,G2=0.3) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Electrical.Analog.Basic.FaultableGyrator faultable(G1=0.2,G2=0.3,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage v1Original(V=2) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),v2Original(V=3) annotation(Placement(transformation(extent={{30,30},{50,50}}))),v1Faultable(V=2) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),v2Faultable(V=3) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),groundFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(v1Original.p,original.p1)
    annotation(Line(points={{-90,40},{-50,40}}, color={0,0,255})); connect(v1Original.n,original.n1)
    annotation(Line(points={{-70,40},{-30,40}}, color={0,0,255})); connect(original.n1,groundOriginal.p)
    annotation(Line(points={{-30,40},{-15,40},{-15,50},{0,50}}, color={0,0,255}));
  connect(v2Original.p,original.p2)
    annotation(Line(points={{30,40},{-50,40}}, color={0,0,255})); connect(v2Original.n,original.n2)
    annotation(Line(points={{50,40},{-30,40}}, color={0,0,255})); connect(original.n2,groundOriginal.p)
    annotation(Line(points={{-30,40},{-15,40},{-15,50},{0,50}}, color={0,0,255}));
  connect(v1Faultable.p,faultable.p1)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,255})); connect(v1Faultable.n,faultable.n1)
    annotation(Line(points={{-70,-40},{90,-40}}, color={0,0,255})); connect(faultable.n1,groundFaultable.p)
    annotation(Line(points={{90,-40},{45,-40},{45,-30},{0,-30}}, color={0,0,255}));
  connect(v2Faultable.p,faultable.p2)
    annotation(Line(points={{30,-40},{70,-40}}, color={0,0,255})); connect(v2Faultable.n,faultable.n2)
    annotation(Line(points={{50,-40},{90,-40}}, color={0,0,255})); connect(faultable.n2,groundFaultable.p)
    annotation(Line(points={{90,-40},{45,-40},{45,-30},{0,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i1-faultable.i1)<1e-9 and abs(original.i2-faultable.i2)<1e-9),"Gyrator Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 GyratorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end GyratorBaseline;
