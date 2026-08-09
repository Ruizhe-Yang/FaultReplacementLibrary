within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FirstOrderBaseline "Executable FirstOrder Normal equivalence test"
  Modelica.Blocks.Sources.Sine inputSignal(amplitude=2,f=1,offset=0.5) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Continuous.FirstOrder original(k=2,T=0.2,y_start=0,initType=Modelica.Blocks.Types.Init.InitialOutput) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  FaultReplacementLibrary.Blocks.Continuous.FaultableFirstOrder faultable(k=2,T=0.2,y_start=0,initType=Modelica.Blocks.Types.Init.InitialOutput,severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(inputSignal.y,original.u)
    annotation(Line(points={{-70,40},{-40,40},{-40,-40},{-10,-40}}, color={0,0,127})); connect(inputSignal.y,faultable.u)
    annotation(Line(points={{-70,40},{70,40}}, color={0,0,127}));
  assert(noEvent(abs(original.y-faultable.y)<1e-7),"FirstOrder Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FirstOrderBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FirstOrderBaseline;
