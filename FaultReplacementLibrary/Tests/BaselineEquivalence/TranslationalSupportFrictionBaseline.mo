within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalSupportFrictionBaseline "MSL SupportFriction and faultable annotation(Placement(transformation(extent={{70,30},{90,50}}))) Normal equivalence"
  Modelica.Mechanics.Translational.Components.SupportFriction original(f_pos=[0,10;1,10]) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  FaultReplacementLibrary.Mechanics.Translational.Components.FaultableSupportFriction faultable(f_pos=[0,10;1,10],severity=0);
  Modelica.Mechanics.Translational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-37,30},{-17,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Blocks.Sources.Ramp position(height=0.2,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(position.y,driveOriginal.s_ref)
    annotation(Line(points={{-70,40},{-27,40}}, color={0,0,127})); connect(position.y,driveFaultable.s_ref)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127})); connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-27,40},{-5,40},{-5,-40},{17,-40}}, color={0,127,0})); connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-27,-40},{22,-40},{22,40},{70,40}}, color={0,127,0}));
  assert(noEvent(abs(original.f-faultable.f)<1e-6),"Translational SupportFriction Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalSupportFrictionBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalSupportFrictionBaseline;
