within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableGainSystem "MSL nominal component declared replaceable"
  Modelica.Blocks.Sources.Constant inputSignal(k=3) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  replaceable Modelica.Blocks.Math.Gain device(k=2) constrainedby Modelica.Blocks.Interfaces.SISO annotation(choicesAllMatching=true, Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(inputSignal.y,device.u)
    annotation(Line(points={{-70,40},{0,40},{0,-40},{70,-40}}, color={0,0,127}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableGainSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableGainSystem;
