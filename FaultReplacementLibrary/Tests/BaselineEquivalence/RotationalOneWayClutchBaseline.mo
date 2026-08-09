within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalOneWayClutchBaseline "MSL OneWayClutch and faultable annotation(Placement(transformation(extent={{70,30},{90,50}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.OneWayClutch original(fn_max=10) annotation(Placement(transformation(extent={{43,-50},{63,-30}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableOneWayClutch faultable(fn_max=10,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position leftOriginal(exact=true) annotation(Placement(transformation(extent={{-63,30},{-43,50}}))),rightOriginal(exact=true) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),leftFaultable(exact=true) annotation(Placement(transformation(extent={{-63,-50},{-43,-30}}))),rightFaultable(exact=true) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Ramp leftAngle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))); Modelica.Blocks.Sources.Constant rightAngle(k=0) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}}))),command(k=0.5) annotation(Placement(transformation(extent={{17,30},{37,50}})));
equation
  connect(leftAngle.y,leftOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-53,40}}, color={0,0,127})); connect(leftAngle.y,leftFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-62,40},{-62,-40},{-53,-40}}, color={0,0,127})); connect(rightAngle.y,rightOriginal.phi_ref)
    annotation(Line(points={{-17,-40},{-8,-40},{-8,40},{0,40}}, color={0,0,127})); connect(rightAngle.y,rightFaultable.phi_ref)
    annotation(Line(points={{-17,-40},{0,-40}}, color={0,0,127})); connect(command.y,original.f_normalized)
    annotation(Line(points={{37,40},{45,40},{45,-40},{53,-40}}, color={0,0,127})); connect(command.y,faultable.f_normalized)
    annotation(Line(points={{37,40},{80,40}}, color={0,0,127}));
  connect(leftOriginal.flange,original.flange_a)
    annotation(Line(points={{-53,40},{-5,40},{-5,-40},{43,-40}}, color={0,0,0})); connect(rightOriginal.flange,original.flange_b)
    annotation(Line(points={{0,40},{32,40},{32,-40},{63,-40}}, color={0,0,0})); connect(leftFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-53,-40},{8,-40},{8,40},{70,40}}, color={0,0,0})); connect(rightFaultable.flange,faultable.flange_b)
    annotation(Line(points={{0,-40},{45,-40},{45,40},{90,40}}, color={0,0,0}));
  assert(noEvent(abs(original.tau-faultable.tau)<1e-6),"Rotational OneWayClutch Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalOneWayClutchBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalOneWayClutchBaseline;
