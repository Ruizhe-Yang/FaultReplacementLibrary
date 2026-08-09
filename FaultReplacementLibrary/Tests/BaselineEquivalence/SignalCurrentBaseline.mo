within FaultReplacementLibrary.Tests.BaselineEquivalence;
model SignalCurrentBaseline "Executable source Normal/severity=0 equivalence test"
  Modelica.Blocks.Sources.Sine command(amplitude=2,f=1,offset=0.2) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent original annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  FaultReplacementLibrary.Electrical.Analog.Sources.FaultableSignalCurrent faultable(severity=0) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Electrical.Analog.Basic.Resistor loadOriginal(R=10) annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Electrical.Analog.Basic.Resistor loadFaultable(R=10) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.Analog.Basic.Ground groundOriginal annotation(Placement(transformation(extent={{70,30},{90,50}})));
  Modelica.Electrical.Analog.Basic.Ground groundFaultable annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(command.y,original.i)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(command.y,faultable.i)
    annotation(Line(points={{-70,40},{0,40}}, color={0,0,127}));
  connect(original.p,loadOriginal.p)
    annotation(Line(points={{-50,-40},{-10,-40},{-10,40},{30,40}}, color={0,0,255})); connect(loadOriginal.n,original.n)
    annotation(Line(points={{50,40},{10,40},{10,-40},{-30,-40}}, color={0,0,255})); connect(original.n,groundOriginal.p)
    annotation(Line(points={{-30,-40},{25,-40},{25,50},{80,50}}, color={0,0,255}));
  connect(faultable.p,loadFaultable.p)
    annotation(Line(points={{-10,40},{10,40},{10,-40},{30,-40}}, color={0,0,255})); connect(loadFaultable.n,faultable.n)
    annotation(Line(points={{50,-40},{30,-40},{30,40},{10,40}}, color={0,0,255})); connect(faultable.n,groundFaultable.p)
    annotation(Line(points={{10,40},{45,40},{45,-30},{80,-30}}, color={0,0,255}));
  assert(noEvent(abs(loadOriginal.i-loadFaultable.i)<1e-8),"SignalCurrent Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 SignalCurrentBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end SignalCurrentBaseline;
