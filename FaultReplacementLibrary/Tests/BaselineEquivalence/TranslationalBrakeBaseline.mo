within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalBrakeBaseline "MSL Brake and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Mechanics.Translational.Components.Brake original(fn_max=100) annotation(Placement(transformation(extent={{30,30},{50,50}})));
  FaultReplacementLibrary.Mechanics.Translational.Components.FaultableBrake faultable(fn_max=100,severity=0);
  Modelica.Mechanics.Translational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Sources.Ramp position(height=0.2,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Blocks.Sources.Constant command(k=0.5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(position.y,driveOriginal.s_ref)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,127})); connect(position.y,driveFaultable.s_ref)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(command.y,original.f_normalized)
    annotation(Line(points={{10,-40},{25,-40},{25,40},{40,40}}, color={0,0,127})); connect(command.y,faultable.f_normalized)
    annotation(Line(points={{10,-40},{80,-40}}, color={0,0,127})); connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-40,40},{30,40}}, color={0,127,0})); connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-40,-40},{70,-40}}, color={0,127,0}));
  assert(noEvent(abs(original.f-faultable.f)<1e-6),"Translational Brake Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalBrakeBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalBrakeBaseline;
