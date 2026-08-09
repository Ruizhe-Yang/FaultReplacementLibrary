within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalIdealPlanetaryBaseline "MSL IdealPlanetary and faultable annotation(Placement(transformation(extent={{70,30},{90,50}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.IdealPlanetary original(ratio=2) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableIdealPlanetary faultable(ratio=2,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position sunOriginal(exact=true) annotation(Placement(transformation(extent={{-63,30},{-43,50}}))),sunFaultable(exact=true) annotation(Placement(transformation(extent={{-63,-50},{-43,-30}})));
  Modelica.Mechanics.Rotational.Components.Fixed ringOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),ringFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}}))),fixedOriginal annotation(Placement(transformation(extent={{43,30},{63,50}}))),fixedFaultable annotation(Placement(transformation(extent={{43,-50},{63,-30}})));
  Modelica.Mechanics.Rotational.Components.Damper loadOriginal(d=2) annotation(Placement(transformation(extent={{17,30},{37,50}}))),loadFaultable(d=2) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Blocks.Sources.Ramp angle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(angle.y,sunOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-53,40}}, color={0,0,127})); connect(angle.y,sunFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-62,40},{-62,-40},{-53,-40}}, color={0,0,127})); connect(sunOriginal.flange,original.sun)
    annotation(Line(points={{-53,40},{-40,40},{-40,-40},{-27,-40}}, color={0,0,0})); connect(original.ring,ringOriginal.flange)
    annotation(Line(points={{-27,-40},{-14,-40},{-14,40},{0,40}}, color={0,0,0})); connect(original.carrier,loadOriginal.flange_a)
    annotation(Line(points={{-27,-40},{-5,-40},{-5,40},{17,40}}, color={0,0,0})); connect(loadOriginal.flange_b,fixedOriginal.flange)
    annotation(Line(points={{37,40},{53,40}}, color={0,0,0}));
  connect(sunFaultable.flange,faultable.sun)
    annotation(Line(points={{-53,-40},{14,-40},{14,40},{80,40}}, color={0,0,0})); connect(faultable.ring,ringFaultable.flange)
    annotation(Line(points={{80,40},{40,40},{40,-40},{0,-40}}, color={0,0,0})); connect(faultable.carrier,loadFaultable.flange_a)
    annotation(Line(points={{80,40},{48,40},{48,-40},{17,-40}}, color={0,0,0})); connect(loadFaultable.flange_b,fixedFaultable.flange)
    annotation(Line(points={{37,-40},{53,-40}}, color={0,0,0}));
  assert(noEvent(abs(original.carrier.phi-faultable.carrier.phi)<1e-8 and abs(original.sun.tau-faultable.sun.tau)<1e-7),"Rotational IdealPlanetary Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalIdealPlanetaryBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalIdealPlanetaryBaseline;
