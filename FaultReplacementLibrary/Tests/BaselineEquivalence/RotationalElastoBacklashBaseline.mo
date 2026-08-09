within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalElastoBacklashBaseline "MSL ElastoBacklash and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.ElastoBacklash original(c=100,d=2,b=0.02) annotation(Placement(transformation(extent={{38,30},{58,50}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableElastoBacklash faultable(c=100,d=2,b=0.02,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position leftOriginal(exact=true) annotation(Placement(transformation(extent={{-58,30},{-38,50}}))),rightOriginal(exact=true) annotation(Placement(transformation(extent={{6,30},{26,50}}))),leftFaultable(exact=true) annotation(Placement(transformation(extent={{-58,-50},{-38,-30}}))),rightFaultable(exact=true) annotation(Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Blocks.Sources.Ramp leftAngle(height=0.2,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Blocks.Sources.Constant rightAngle(k=0) annotation(Placement(transformation(extent={{-26,-50},{-6,-30}})));
equation
  connect(leftAngle.y,leftOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-48,40}}, color={0,0,127})); connect(leftAngle.y,leftFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-59,40},{-59,-40},{-48,-40}}, color={0,0,127})); connect(rightAngle.y,rightOriginal.phi_ref)
    annotation(Line(points={{-6,-40},{5,-40},{5,40},{16,40}}, color={0,0,127})); connect(rightAngle.y,rightFaultable.phi_ref)
    annotation(Line(points={{-6,-40},{16,-40}}, color={0,0,127}));
  connect(leftOriginal.flange,original.flange_a)
    annotation(Line(points={{-48,40},{38,40}}, color={0,0,0})); connect(rightOriginal.flange,original.flange_b)
    annotation(Line(points={{16,40},{58,40}}, color={0,0,0})); connect(leftFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-48,-40},{70,-40}}, color={0,0,0})); connect(rightFaultable.flange,faultable.flange_b)
    annotation(Line(points={{16,-40},{90,-40}}, color={0,0,0}));
  assert(noEvent(abs(original.tau-faultable.tau)<1e-6),"Rotational ElastoBacklash Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalElastoBacklashBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalElastoBacklashBaseline;
