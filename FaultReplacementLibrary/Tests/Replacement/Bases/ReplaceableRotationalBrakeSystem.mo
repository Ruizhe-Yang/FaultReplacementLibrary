within FaultReplacementLibrary.Tests.Replacement.Bases;
partial model ReplaceableRotationalBrakeSystem
  "Replaceable rotational brake topology using an official MSL constraint"
  Modelica.Mechanics.Rotational.Sources.Position drive(exact=true) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Ramp angle(height=1,duration=1) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  replaceable Modelica.Mechanics.Rotational.Components.Brake device(fn_max=10)
    constrainedby Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2
    annotation(choicesAllMatching=true, Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(angle.y,drive.phi_ref)
    annotation(Line(points={{-70,40},{-35,40},{-35,-40},{0,-40}}, color={0,0,127}));
  connect(drive.flange,device.flange_a)
    annotation(Line(points={{0,-40},{35,-40},{35,40},{70,40}}, color={0,0,0}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableRotationalBrakeSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableRotationalBrakeSystem;
