within FaultReplacementLibrary.Tests.BaselineEquivalence;
model MagneticElectroMagneticConverterBaseline "MSL electromagnetic converter and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Magnetic.FluxTubes.Basic.ElectroMagneticConverter original(N=100) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Magnetic.FluxTubes.Basic.FaultableElectroMagneticConverter faultable(N=100,severity=0);
  Modelica.Magnetic.FluxTubes.Basic.ConstantReluctance reluctanceOriginal(R_m=1e6) annotation(Placement(transformation(extent={{17,30},{37,50}}))),reluctanceFaultable(R_m=1e6) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Magnetic.FluxTubes.Basic.Ground magneticGroundOriginal annotation(Placement(transformation(extent={{43,30},{63,50}}))),magneticGroundFaultable annotation(Placement(transformation(extent={{43,-50},{63,-30}})));
  Modelica.Electrical.Analog.Sources.SineVoltage sourceOriginal(V=1,f=2) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(V=1,f=2) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor resistorOriginal(R=10) annotation(Placement(transformation(extent={{-63,30},{-43,50}}))),resistorFaultable(R=10) annotation(Placement(transformation(extent={{-63,-50},{-43,-30}}))); Modelica.Electrical.Analog.Basic.Ground electricalGroundOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),electricalGroundFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(sourceOriginal.p,resistorOriginal.p)
    annotation(Line(points={{-90,40},{-63,40}}, color={255,127,0})); connect(resistorOriginal.n,original.p)
    annotation(Line(points={{-43,40},{-37,40}}, color={255,127,0})); connect(original.n,electricalGroundOriginal.p)
    annotation(Line(points={{-17,40},{-8,40},{-8,50},{0,50}}, color={255,127,0})); connect(sourceOriginal.n,electricalGroundOriginal.p)
    annotation(Line(points={{-70,40},{-35,40},{-35,50},{0,50}}, color={255,127,0})); connect(original.port_p,reluctanceOriginal.port_p)
    annotation(Line(points={{-27,40},{27,40}}, color={255,127,0})); connect(reluctanceOriginal.port_n,magneticGroundOriginal.port)
    annotation(Line(points={{27,40},{40,40},{40,50},{53,50}}, color={255,127,0})); connect(original.port_n,magneticGroundOriginal.port)
    annotation(Line(points={{-27,40},{13,40},{13,50},{53,50}}, color={255,127,0}));
  connect(sourceFaultable.p,resistorFaultable.p)
    annotation(Line(points={{-90,-40},{-63,-40}}, color={255,127,0})); connect(resistorFaultable.n,faultable.p)
    annotation(Line(points={{-43,-40},{70,-40}}, color={255,127,0})); connect(faultable.n,electricalGroundFaultable.p)
    annotation(Line(points={{90,-40},{45,-40},{45,-30},{0,-30}}, color={255,127,0})); connect(sourceFaultable.n,electricalGroundFaultable.p)
    annotation(Line(points={{-70,-40},{-35,-40},{-35,-30},{0,-30}}, color={255,127,0})); connect(faultable.port_p,reluctanceFaultable.port_p)
    annotation(Line(points={{80,-40},{27,-40}}, color={255,127,0})); connect(reluctanceFaultable.port_n,magneticGroundFaultable.port)
    annotation(Line(points={{27,-40},{40,-40},{40,-30},{53,-30}}, color={255,127,0})); connect(faultable.port_n,magneticGroundFaultable.port)
    annotation(Line(points={{80,-40},{66,-40},{66,-30},{53,-30}}, color={255,127,0}));
  assert(noEvent(abs(original.i-faultable.i)<1e-6 and abs(original.Phi-faultable.Phi)<1e-8),"ElectroMagneticConverter Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 MagneticElectroMagneticConverterBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end MagneticElectroMagneticConverterBaseline;
