within FaultReplacementLibrary.Tests.BaselineEquivalence;
model VariableInductorBaseline "Executable VariableInductor Normal/severity=0 equivalence test"
  Modelica.Blocks.Sources.Constant control(k=0.2) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=5,f=1) annotation(Placement(transformation(extent={{30,30},{50,50}}))),sourceFaultable(V=5,f=1) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.Analog.Basic.VariableInductor original(IC=0) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  FaultReplacementLibrary.Electrical.Analog.Basic.FaultableVariableInductor faultable(IC=0,severity=0) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{70,30},{90,50}}))),groundFaultable annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(control.y,original.L)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(control.y,faultable.L)
    annotation(Line(points={{-70,40},{0,40}}, color={0,0,127}));
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{30,40},{-10,40},{-10,-40},{-50,-40}}, color={0,0,255})); connect(original.n,sourceOriginal.n)
    annotation(Line(points={{-30,-40},{10,-40},{10,40},{50,40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{50,40},{65,40},{65,50},{80,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{30,-40},{10,-40},{10,40},{-10,40}}, color={0,0,255})); connect(faultable.n,sourceFaultable.n)
    annotation(Line(points={{10,40},{30,40},{30,-40},{50,-40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{50,-40},{65,-40},{65,-30},{80,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i-faultable.i)<1e-7),"VariableInductor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 VariableInductorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end VariableInductorBaseline;
