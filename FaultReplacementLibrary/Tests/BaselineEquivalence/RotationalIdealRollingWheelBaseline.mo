within FaultReplacementLibrary.Tests.BaselineEquivalence;
model RotationalIdealRollingWheelBaseline "MSL IdealRollingWheel and faultable annotation(Placement(transformation(extent={{70,30},{90,50}}))) Normal equivalence"
  Modelica.Mechanics.Rotational.Components.IdealRollingWheel original(radius=0.3) annotation(Placement(transformation(extent={{-26,-50},{-6,-30}})));
  FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableIdealRollingWheel faultable(radius=0.3,severity=0);
  Modelica.Mechanics.Rotational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-58,30},{-38,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-58,-50},{-38,-30}})));
  Modelica.Mechanics.Translational.Components.Damper loadOriginal(d=20) annotation(Placement(transformation(extent={{6,30},{26,50}}))),loadFaultable(d=20) annotation(Placement(transformation(extent={{6,-50},{26,-30}}))); Modelica.Mechanics.Translational.Components.Fixed fixedOriginal annotation(Placement(transformation(extent={{38,30},{58,50}}))),fixedFaultable annotation(Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Blocks.Sources.Ramp angle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(angle.y,driveOriginal.phi_ref)
    annotation(Line(points={{-70,40},{-48,40}}, color={0,0,127})); connect(angle.y,driveFaultable.phi_ref)
    annotation(Line(points={{-70,40},{-59,40},{-59,-40},{-48,-40}}, color={0,0,127})); connect(driveOriginal.flange,original.flangeR)
    annotation(Line(points={{-48,40},{-32,40},{-32,-40},{-16,-40}}, color={0,0,0})); connect(original.flangeT,loadOriginal.flange_a)
    annotation(Line(points={{-16,-40},{-5,-40},{-5,40},{6,40}}, color={0,0,0})); connect(loadOriginal.flange_b,fixedOriginal.flange)
    annotation(Line(points={{26,40},{48,40}}, color={0,0,0}));
  connect(driveFaultable.flange,faultable.flangeR)
    annotation(Line(points={{-48,-40},{16,-40},{16,40},{80,40}}, color={0,0,0})); connect(faultable.flangeT,loadFaultable.flange_a)
    annotation(Line(points={{80,40},{43,40},{43,-40},{6,-40}}, color={0,0,0})); connect(loadFaultable.flange_b,fixedFaultable.flange)
    annotation(Line(points={{26,-40},{48,-40}}, color={0,0,0}));
  assert(noEvent(abs(original.flangeT.s-faultable.flangeT.s)<1e-8 and abs(original.flangeR.tau-faultable.flangeR.tau)<1e-7),"Rotational IdealRollingWheel Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalIdealRollingWheelBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalIdealRollingWheelBaseline;
