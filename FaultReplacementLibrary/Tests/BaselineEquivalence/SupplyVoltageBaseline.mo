within FaultReplacementLibrary.Tests.BaselineEquivalence;
model SupplyVoltageBaseline "Executable SupplyVoltage Normal/severity=0 equivalence test"
  Modelica.Electrical.Analog.Sources.SupplyVoltage original(Vps=15,Vns=-15) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  FaultReplacementLibrary.Electrical.Analog.Sources.FaultableSupplyVoltage faultable(Vps=15,Vns=-15,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Electrical.Analog.Basic.Resistor loadPOriginal(R=10) annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),loadNOriginal(R=10) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),loadPFaultable(R=10) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}}))),loadNFaultable(R=10) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{30,30},{50,50}}))),groundFaultable annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(original.pin_p,loadPOriginal.p)
    annotation(Line(points={{-80,40},{-50,40}}, color={0,0,255})); connect(loadPOriginal.n,original.ground)
    annotation(Line(points={{-30,40},{-80,40}}, color={0,0,255}));
  connect(original.pin_n,loadNOriginal.p)
    annotation(Line(points={{-80,40},{-10,40}}, color={0,0,255})); connect(loadNOriginal.n,original.ground)
    annotation(Line(points={{10,40},{-80,40}}, color={0,0,255})); connect(original.ground,groundOriginal.p)
    annotation(Line(points={{-80,40},{-20,40},{-20,50},{40,50}}, color={0,0,255}));
  connect(faultable.pin_p,loadPFaultable.p)
    annotation(Line(points={{80,-40},{-50,-40}}, color={0,0,255})); connect(loadPFaultable.n,faultable.ground)
    annotation(Line(points={{-30,-40},{80,-40}}, color={0,0,255}));
  connect(faultable.pin_n,loadNFaultable.p)
    annotation(Line(points={{80,-40},{-10,-40}}, color={0,0,255})); connect(loadNFaultable.n,faultable.ground)
    annotation(Line(points={{10,-40},{80,-40}}, color={0,0,255})); connect(faultable.ground,groundFaultable.p)
    annotation(Line(points={{80,-40},{60,-40},{60,-30},{40,-30}}, color={0,0,255}));
  assert(noEvent(abs(loadPOriginal.i-loadPFaultable.i)<1e-8 and abs(loadNOriginal.i-loadNFaultable.i)<1e-8),"SupplyVoltage Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 SupplyVoltageBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end SupplyVoltageBaseline;
