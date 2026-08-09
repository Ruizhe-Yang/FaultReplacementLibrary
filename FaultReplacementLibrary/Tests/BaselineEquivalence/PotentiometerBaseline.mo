within FaultReplacementLibrary.Tests.BaselineEquivalence;
model PotentiometerBaseline "MSL Potentiometer and FaultablePotentiometer Normal equivalence"
  Modelica.Electrical.Analog.Basic.Potentiometer original(R=100,rConstant=0.3) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Electrical.Analog.Basic.FaultablePotentiometer faultable(R=100,rConstant=0.3,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sourceOriginal(V=10) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V=10) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=1000) annotation(Placement(transformation(extent={{30,30},{50,50}}))),loadFaultable(R=1000) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),groundFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(sourceOriginal.p,original.pin_p)
    annotation(Line(points={{-90,40},{-40,40}}, color={0,0,255})); connect(sourceOriginal.n,original.pin_n)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,255})); connect(original.pin_n,groundOriginal.p)
    annotation(Line(points={{-40,40},{-20,40},{-20,50},{0,50}}, color={0,0,255}));
  connect(original.contact,loadOriginal.p)
    annotation(Line(points={{-40,40},{30,40}}, color={0,0,255})); connect(loadOriginal.n,groundOriginal.p)
    annotation(Line(points={{50,40},{25,40},{25,50},{0,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.pin_p)
    annotation(Line(points={{-90,-40},{80,-40}}, color={0,0,255})); connect(sourceFaultable.n,faultable.pin_n)
    annotation(Line(points={{-70,-40},{80,-40}}, color={0,0,255})); connect(faultable.pin_n,groundFaultable.p)
    annotation(Line(points={{80,-40},{40,-40},{40,-30},{0,-30}}, color={0,0,255}));
  connect(faultable.contact,loadFaultable.p)
    annotation(Line(points={{80,-40},{30,-40}}, color={0,0,255})); connect(loadFaultable.n,groundFaultable.p)
    annotation(Line(points={{50,-40},{25,-40},{25,-30},{0,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.contact.v-faultable.contact.v)<1e-8 and abs(original.pin_p.i-faultable.pin_p.i)<1e-8),"Potentiometer Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 PotentiometerBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end PotentiometerBaseline;
