within FaultReplacementLibrary.Tests.BaselineEquivalence;
model MagneticConstantPermeanceBaseline "Executable magnetic Normal equivalence test"
  Modelica.Magnetic.FluxTubes.Sources.ConstantMagneticPotentialDifference sourceOriginal(V_m=100) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V_m=100) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.ConstantPermeance original(G_m=1e-5) annotation(Placement(transformation(extent={{17,30},{37,50}})));
  FaultReplacementLibrary.Magnetic.FluxTubes.Basic.FaultableConstantPermeance faultable(G_m=1e-5,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-37,30},{-17,50}}))),groundFaultable annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
equation
  connect(sourceOriginal.port_n,groundOriginal.port)
    annotation(Line(points={{-80,40},{-54,40},{-54,50},{-27,50}}, color={255,127,0})); connect(sourceFaultable.port_n,groundFaultable.port)
    annotation(Line(points={{-80,-40},{-54,-40},{-54,-30},{-27,-30}}, color={255,127,0}));
  connect(sourceOriginal.port_p,original.port_p)
    annotation(Line(points={{-80,40},{27,40}}, color={255,127,0})); connect(original.port_n,sourceOriginal.port_n)
    annotation(Line(points={{27,40},{-80,40}}, color={255,127,0}));
  connect(sourceFaultable.port_p,faultable.port_p)
    annotation(Line(points={{-80,-40},{80,-40}}, color={255,127,0})); connect(faultable.port_n,sourceFaultable.port_n)
    annotation(Line(points={{80,-40},{-80,-40}}, color={255,127,0}));
  assert(noEvent(abs(sourceOriginal.Phi-sourceFaultable.Phi)<1e-10),"Magnetic ConstantPermeance Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 MagneticConstantPermeanceBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end MagneticConstantPermeanceBaseline;
