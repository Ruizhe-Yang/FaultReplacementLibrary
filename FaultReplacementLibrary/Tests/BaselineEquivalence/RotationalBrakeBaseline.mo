within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalBrakeBaseline "MSL Brake and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.Brake original(fn_max=10) annotation(Placement(transformation(extent={{30,30},{50,50}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableBrake faultable(fn_max=10,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Sources.Ramp angle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Blocks.Sources.Constant command(k=0.5) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(angle.y,driveOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,127})); connect(angle.y,driveFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(command.y,original.f_normalized)
    annotation(Line(points={{10,-40},{25,-40},{25,40},{40,40}}, color={0,0,127})); connect(command.y,faultable.f_normalized)
    annotation(Line(points={{10,-40},{80,-40}}, color={0,0,127}));
  connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-40,40},{30,40}}, color={0,0,0})); connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-40,-40},{70,-40}}, color={0,0,0}));
  assert(noEvent(abs(original.tau-faultable.tau)<1e-6),"Rotational Brake Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalBrakeBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalBrakeBaseline;
