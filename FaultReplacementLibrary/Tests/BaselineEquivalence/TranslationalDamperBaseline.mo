within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalDamperBaseline "MSL translational Damper and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Mechanics.Translational.Components.Damper original(d=20) annotation(Placement(transformation(extent={{38,30},{58,50}})));
  FaultReplacementLibrary.Mechanics.Translational.Components.FaultableDamper faultable(d=20,severity=0);
  Modelica.Mechanics.Translational.Sources.Position leftOriginal(exact=true) annotation(Placement(transformation(extent={{-58,30},{-38,50}}))),rightOriginal(exact=true) annotation(Placement(transformation(extent={{6,30},{26,50}}))),leftFaultable(exact=true) annotation(Placement(transformation(extent={{-58,-50},{-38,-30}}))),rightFaultable(exact=true) annotation(Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Blocks.Sources.Ramp leftPosition(height=0.2,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Blocks.Sources.Constant rightPosition(k=0) annotation(Placement(transformation(extent={{-26,-50},{-6,-30}})));
equation
  connect(leftPosition.y,leftOriginal.s_ref)
    annotation(Line(points={{-70,40},{-48,40}}, color={0,0,127})); connect(leftPosition.y,leftFaultable.s_ref)
    annotation(Line(points={{-70,40},{-59,40},{-59,-40},{-48,-40}}, color={0,0,127})); connect(rightPosition.y,rightOriginal.s_ref)
    annotation(Line(points={{-6,-40},{5,-40},{5,40},{16,40}}, color={0,0,127})); connect(rightPosition.y,rightFaultable.s_ref)
    annotation(Line(points={{-6,-40},{16,-40}}, color={0,0,127}));
  connect(leftOriginal.flange,original.flange_a)
    annotation(Line(points={{-48,40},{38,40}}, color={0,127,0})); connect(rightOriginal.flange,original.flange_b)
    annotation(Line(points={{16,40},{58,40}}, color={0,127,0})); connect(leftFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-48,-40},{70,-40}}, color={0,127,0})); connect(rightFaultable.flange,faultable.flange_b)
    annotation(Line(points={{16,-40},{90,-40}}, color={0,127,0}));
  assert(noEvent(abs(original.f-faultable.f)<1e-7),"Translational Damper Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalDamperBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalDamperBaseline;
