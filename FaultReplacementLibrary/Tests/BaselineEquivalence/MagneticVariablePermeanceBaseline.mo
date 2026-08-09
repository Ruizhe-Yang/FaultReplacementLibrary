within FaultReplacementLibrary.Tests.BaselineEquivalence;
model MagneticVariablePermeanceBaseline "Executable magnetic Normal equivalence test"
  Modelica.Blocks.Sources.Constant control(k=1e-5) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Magnetic.FluxTubes.Sources.ConstantMagneticPotentialDifference sourceOriginal(V_m=100) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V_m=100) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.VariablePermeance original annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  FaultReplacementLibrary.Magnetic.FluxTubes.Basic.FaultableVariablePermeance faultable(severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Magnetic.FluxTubes.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),groundFaultable annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(sourceOriginal.port_n,groundOriginal.port)
    annotation(Line(points={{-80,40},{-60,40},{-60,50},{-40,50}}, color={255,127,0})); connect(sourceFaultable.port_n,groundFaultable.port)
    annotation(Line(points={{-80,-40},{-60,-40},{-60,-30},{-40,-30}}, color={255,127,0}));
  connect(control.y,original.G_m)
    annotation(Line(points={{10,40},{25,40},{25,-40},{40,-40}}, color={0,0,127})); connect(control.y,faultable.G_m)
    annotation(Line(points={{10,40},{80,40}}, color={0,0,127}));
  connect(sourceOriginal.port_p,original.port_p)
    annotation(Line(points={{-80,40},{-20,40},{-20,-40},{40,-40}}, color={255,127,0})); connect(original.port_n,sourceOriginal.port_n)
    annotation(Line(points={{40,-40},{-20,-40},{-20,40},{-80,40}}, color={255,127,0}));
  connect(sourceFaultable.port_p,faultable.port_p)
    annotation(Line(points={{-80,-40},{0,-40},{0,40},{80,40}}, color={255,127,0})); connect(faultable.port_n,sourceFaultable.port_n)
    annotation(Line(points={{80,40},{0,40},{0,-40},{-80,-40}}, color={255,127,0}));
  assert(noEvent(abs(sourceOriginal.Phi-sourceFaultable.Phi)<1e-10),"Magnetic VariablePermeance Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 MagneticVariablePermeanceBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end MagneticVariablePermeanceBaseline;
