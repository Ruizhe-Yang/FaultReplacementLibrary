within FaultReplacementLibrary.Tests.BaselineEquivalence;
model CosineCurrentBaseline "Executable source Normal/severity=0 equivalence test"
  Modelica.Electrical.Analog.Sources.CosineCurrent original(I=2,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  FaultReplacementLibrary.Electrical.Analog.Sources.FaultableCosineCurrent faultable(I=2,f=1,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  Modelica.Electrical.Analog.Basic.Resistor loadFaultable(R=10) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{17,30},{37,50}})));
  Modelica.Electrical.Analog.Basic.Ground groundFaultable annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
equation
  connect(original.p,loadOriginal.p)
    annotation(Line(points={{-90,40},{-37,40}}, color={0,0,255})); connect(loadOriginal.n,original.n)
    annotation(Line(points={{-17,40},{-70,40}}, color={0,0,255})); connect(original.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-22,40},{-22,50},{27,50}}, color={0,0,255}));
  connect(faultable.p,loadFaultable.p)
    annotation(Line(points={{70,-40},{-37,-40}}, color={0,0,255})); connect(loadFaultable.n,faultable.n)
    annotation(Line(points={{-17,-40},{90,-40}}, color={0,0,255})); connect(faultable.n,groundFaultable.p)
    annotation(Line(points={{90,-40},{58,-40},{58,-30},{27,-30}}, color={0,0,255}));
  assert(noEvent(abs(loadOriginal.i-loadFaultable.i)<1e-8),"CosineCurrent Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 CosineCurrentBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end CosineCurrentBaseline;
