within FaultReplacementLibrary.Tests.BaselineEquivalence;
model TranslationalAccSensorBaseline "Executable mechanical sensor Normal equivalence test"
  Modelica.Blocks.Sources.Sine command(amplitude=0.02,f=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Mechanics.Translational.Sources.Position driveOriginal(exact=true) annotation(Placement(transformation(extent={{-37,30},{-17,50}}))),driveFaultable(exact=true) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Mechanics.Translational.Sensors.AccSensor original annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  FaultReplacementLibrary.Mechanics.Translational.Sensors.FaultableAccSensor faultable(severity=0) annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(command.y,driveOriginal.s_ref)
    annotation(Line(points={{-70,40},{-27,40}}, color={0,0,127})); connect(command.y,driveFaultable.s_ref)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127}));
  connect(driveOriginal.flange,original.flange)
    annotation(Line(points={{-27,40},{0,40},{0,-40},{27,-40}}, color={0,127,0})); connect(driveFaultable.flange,faultable.flange)
    annotation(Line(points={{-27,-40},{26,-40},{26,40},{80,40}}, color={0,127,0}));
  assert(noEvent(abs(original.a-faultable.a)<1e-7),"TranslationalAccSensor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalAccSensorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalAccSensorBaseline;
