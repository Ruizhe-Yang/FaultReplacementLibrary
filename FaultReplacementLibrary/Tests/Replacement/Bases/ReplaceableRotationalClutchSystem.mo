within FaultReplacementLibrary.Tests.Replacement.Bases;
partial model ReplaceableRotationalClutchSystem
  "Replaceable rotational clutch topology using an official MSL constraint"
  Modelica.Mechanics.Rotational.Sources.Position leftDrive(exact=true) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}}))),rightDrive(exact=true) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Blocks.Sources.Ramp leftAngle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.Constant rightAngle(k=0) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Modelica.Mechanics.Rotational.Components.Clutch device(fn_max=10)
    constrainedby Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates
    annotation(choicesAllMatching=true, Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(leftAngle.y,leftDrive.phi_ref)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127}));
  connect(rightAngle.y,rightDrive.phi_ref)
    annotation(Line(points={{10,40},{25,40},{25,-40},{40,-40}}, color={0,0,127}));
  connect(leftDrive.flange,device.flange_a)
    annotation(Line(points={{-40,-40},{15,-40},{15,40},{70,40}}, color={0,0,0}));
  connect(rightDrive.flange,device.flange_b)
    annotation(Line(points={{40,-40},{65,-40},{65,40},{90,40}}, color={0,0,0}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableRotationalClutchSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableRotationalClutchSystem;
