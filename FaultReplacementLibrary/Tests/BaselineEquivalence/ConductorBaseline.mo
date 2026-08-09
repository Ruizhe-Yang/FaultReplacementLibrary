within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ConductorBaseline "Executable Conductor Normal/severity=0 equivalence test"
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=5,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V=5,f=1) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Basic.Conductor original(G=0.2) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Electrical.Analog.Basic.FaultableConductor faultable(G=0.2,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{17,30},{37,50}}))),groundFaultable annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
equation
  connect(sourceOriginal.p,original.p)
    annotation(Line(points={{-90,40},{-37,40}}, color={0,0,255})); connect(original.n,sourceOriginal.n)
    annotation(Line(points={{-17,40},{-70,40}}, color={0,0,255})); connect(sourceOriginal.n,groundOriginal.p)
    annotation(Line(points={{-70,40},{-22,40},{-22,50},{27,50}}, color={0,0,255}));
  connect(sourceFaultable.p,faultable.p)
    annotation(Line(points={{-90,-40},{70,-40}}, color={0,0,255})); connect(faultable.n,sourceFaultable.n)
    annotation(Line(points={{90,-40},{-70,-40}}, color={0,0,255})); connect(sourceFaultable.n,groundFaultable.p)
    annotation(Line(points={{-70,-40},{-22,-40},{-22,-30},{27,-30}}, color={0,0,255}));
  assert(noEvent(abs(original.i-faultable.i)<1e-7),"Conductor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ConductorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ConductorBaseline;
