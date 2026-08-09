within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalForceSensorBaseline "Executable mechanical sensor Normal equivalence test"
  Modelica.Blocks.Sources.Sine command(amplitude=0.02,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Mechanics.Translational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-58,30},{-38,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-58,-50},{-38,-30}})));
  Modelica.Mechanics.Translational.Components.Spring loadOriginal(c=100) annotation(Placement(transformation(extent={{6,30},{26,50}}))),loadFaultable(c=100) annotation(Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Mechanics.Translational.Components.Fixed fixedOriginal annotation(Placement(transformation(extent={{38,30},{58,50}}))),fixedFaultable annotation(Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Mechanics.Translational.Sensors.ForceSensor original annotation(Placement(transformation(extent={{-26,-50},{-6,-30}})));
  FaultReplacementLibrary.Mechanics.Translational.Sensors.FaultableForceSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(command.y,driveOriginal.s_ref)
    annotation(Line(points={{-70,40},{-48,40}}, color={0,0,127})); connect(command.y,driveFaultable.s_ref)
    annotation(Line(points={{-70,40},{-59,40},{-59,-40},{-48,-40}}, color={0,0,127}));
  connect(driveOriginal.flange,original.flange_a)
    annotation(Line(points={{-48,40},{-37,40},{-37,-40},{-26,-40}}, color={0,127,0})); connect(original.flange_b,loadOriginal.flange_a)
    annotation(Line(points={{-6,-40},{0,-40},{0,40},{6,40}}, color={0,127,0})); connect(loadOriginal.flange_b,fixedOriginal.flange)
    annotation(Line(points={{26,40},{48,40}}, color={0,127,0}));
  connect(driveFaultable.flange,faultable.flange_a)
    annotation(Line(points={{-48,-40},{11,-40},{11,40},{70,40}}, color={0,127,0})); connect(faultable.flange_b,loadFaultable.flange_a)
    annotation(Line(points={{90,40},{48,40},{48,-40},{6,-40}}, color={0,127,0})); connect(loadFaultable.flange_b,fixedFaultable.flange)
    annotation(Line(points={{26,-40},{48,-40}}, color={0,127,0}));
  assert(noEvent(abs(original.f-faultable.f)<1e-7),"TranslationalForceSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalForceSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalForceSensorBaseline;
