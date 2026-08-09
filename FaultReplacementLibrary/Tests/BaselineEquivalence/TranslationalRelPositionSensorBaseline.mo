within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalRelPositionSensorBaseline "Executable mechanical sensor Normal equivalence test"
  Modelica.Blocks.Sources.Sine command(amplitude=0.02,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Mechanics.Translational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Mechanics.Translational.Components.Fixed fixedOriginal annotation(Placement(transformation(extent={{-10,30},{10,50}}))),fixedFaultable annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Mechanics.Translational.Sensors.RelPositionSensor original annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  FaultReplacementLibrary.Mechanics.Translational.Sensors.FaultableRelPositionSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(command.y,driveOriginal.s_ref)
    annotation(Line(points={{-70,40},{-40,40}}, color={0,0,127})); connect(command.y,driveFaultable.s_ref)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127}));
  connect(fixedOriginal.flange,original.flange_a)
    annotation(Line(points={{0,40},{15,40},{15,-40},{30,-40}}, color={0,127,0})); connect(driveOriginal.flange,original.flange_b)
    annotation(Line(points={{-40,40},{5,40},{5,-40},{50,-40}}, color={0,127,0}));
  connect(fixedFaultable.flange,faultable.flange_a)
    annotation(Line(points={{0,-40},{35,-40},{35,40},{70,40}}, color={0,127,0})); connect(driveFaultable.flange,faultable.flange_b)
    annotation(Line(points={{-40,-40},{25,-40},{25,40},{90,40}}, color={0,127,0}));
  assert(noEvent(abs(original.s_rel-faultable.s_rel)<1e-7),"TranslationalRelPositionSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalRelPositionSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalRelPositionSensorBaseline;
