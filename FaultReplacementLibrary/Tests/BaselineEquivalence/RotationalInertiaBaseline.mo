within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalInertiaBaseline "MSL Inertia and faultable annotation(Placement(transformation(extent={{70,30},{90,50}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.Inertia original(J=2) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableInertia faultable(J=2,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-37,30},{-17,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Blocks.Sources.Sine angle(amplitude=0.2,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(angle.y,driveOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-27,40}}, color={0,0,127})); connect(angle.y,driveFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127})); connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-27,40},{-5,40},{-5,-40},{17,-40}}, color={0,0,0})); connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-27,-40},{22,-40},{22,40},{70,40}}, color={0,0,0}));
  assert(noEvent(abs(original.flange_a.tau-faultable.flange_a.tau)<1e-5 and abs(original.w-faultable.w)<1e-7),"Rotational Inertia Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalInertiaBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalInertiaBaseline;
