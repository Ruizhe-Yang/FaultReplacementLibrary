within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalSpringBaseline "Executable Normal/severity=0 numerical equivalence test"
  Modelica.Blocks.Sources.Sine command(amplitude=0.1,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Mechanics.Rotational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Mechanics.Rotational.Sources.Position driveFaultable(exact=true) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixedOriginal annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixedFaultable annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Mechanics.Rotational.Components.Spring original(c=100) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableSpring faultable(c=100,severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(command.y,driveOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,127})); connect(command.y,driveFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127}));
  connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-40,40},{-25,40},{-25,-40},{-10,-40}}, color={0,0,0})); connect(original.flange_b,fixedOriginal.flange)
    annotation(Line(points={{10,-40},{25,-40},{25,40},{40,40}}, color={0,0,0}));
  connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-40,-40},{15,-40},{15,40},{70,40}}, color={0,0,0})); connect(faultable.flange_b,fixedFaultable.flange)
    annotation(Line(points={{90,40},{65,40},{65,-40},{40,-40}}, color={0,0,0}));
  assert(noEvent(abs(original.tau-faultable.tau)<1e-8),"Rotational Spring Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalSpringBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalSpringBaseline;
