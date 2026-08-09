within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableInductorCircuit "MSL nominal component declared replaceable"
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V=5) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  replaceable Modelica.Electrical.Analog.Basic.Inductor device(L=0.2,i(start=0,fixed=true)) constrainedby Modelica.Electrical.Analog.Interfaces.OnePort annotation(choicesAllMatching=true, Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(source.p,device.p)
    annotation(Line(points={{-90,40},{-50,40},{-50,-40},{-10,-40}}, color={0,0,255})); connect(device.n,source.n)
    annotation(Line(points={{10,-40},{-30,-40},{-30,40},{-70,40}}, color={0,0,255})); connect(source.n,ground.p)
    annotation(Line(points={{-70,40},{5,40},{5,50},{80,50}}, color={0,0,255}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableInductorCircuit 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableInductorCircuit;
