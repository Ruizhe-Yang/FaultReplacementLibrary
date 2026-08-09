within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableTranslationalSpringSystem "MSL nominal component declared replaceable"
  Modelica.Blocks.Sources.Constant command(k=0.01) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Mechanics.Translational.Sources.Position drive(exact=true) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Mechanics.Translational.Components.Fixed fixed annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  replaceable Modelica.Mechanics.Translational.Components.Spring device(c=100) constrainedby Modelica.Mechanics.Translational.Interfaces.PartialCompliant annotation(choicesAllMatching=true, Placement(transformation(extent={{17,30},{37,50}})));
equation
  connect(command.y,drive.s_ref)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127})); connect(drive.flange,device.flange_a)
    annotation(Line(points={{-27,-40},{-5,-40},{-5,40},{17,40}}, color={0,127,0})); connect(device.flange_b,fixed.flange)
    annotation(Line(points={{37,40},{58,40},{58,-40},{80,-40}}, color={0,127,0}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableTranslationalSpringSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableTranslationalSpringSystem;
