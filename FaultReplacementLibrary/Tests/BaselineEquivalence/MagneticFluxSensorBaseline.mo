within FaultReplacementLibrary.Tests.BaselineEquivalence;
model MagneticFluxSensorBaseline "Executable MagneticFluxSensor Normal equivalence test"
  Modelica.Magnetic.FluxTubes.Sources.ConstantMagneticPotentialDifference sourceOriginal(V_m=100) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V_m=100) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.ConstantReluctance loadOriginal(R_m=1e5) annotation(Placement(transformation(extent={{30,30},{50,50}}))),loadFaultable(R_m=1e5) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Magnetic.FluxTubes.Sensors.MagneticFluxSensor original annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  FaultReplacementLibrary.Magnetic.FluxTubes.Sensors.FaultableMagneticFluxSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),groundFaultable annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(sourceOriginal.port_n,groundOriginal.port)
    annotation(Line(points={{-80,40},{-60,40},{-60,50},{-40,50}}, color={255,127,0})); connect(sourceFaultable.port_n,groundFaultable.port)
    annotation(Line(points={{-80,-40},{-60,-40},{-60,-30},{-40,-30}}, color={255,127,0}));
  connect(sourceOriginal.port_p,original.port_p)
    annotation(Line(points={{-80,40},{0,40}}, color={255,127,0})); connect(original.port_n,loadOriginal.port_p)
    annotation(Line(points={{0,40},{40,40}}, color={255,127,0})); connect(loadOriginal.port_n,sourceOriginal.port_n)
    annotation(Line(points={{40,40},{-80,40}}, color={255,127,0}));
  connect(sourceFaultable.port_p,faultable.port_p)
    annotation(Line(points={{-80,-40},{80,-40}}, color={255,127,0})); connect(faultable.port_n,loadFaultable.port_p)
    annotation(Line(points={{80,-40},{40,-40}}, color={255,127,0})); connect(loadFaultable.port_n,sourceFaultable.port_n)
    annotation(Line(points={{40,-40},{-80,-40}}, color={255,127,0}));
  assert(noEvent(abs(original.Phi-faultable.Phi)<1e-10),"MagneticFluxSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 MagneticFluxSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end MagneticFluxSensorBaseline;
