within FaultReplacementLibrary.Tests.Replacement.Bases;
model ReplaceableMagneticReluctanceSystem "Replaceable MSL magnetic reluctance system"
  Modelica.Magnetic.FluxTubes.Sources.ConstantMagneticPotentialDifference source(V_m=100) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Magnetic.FluxTubes.Basic.Ground ground annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  replaceable Modelica.Magnetic.FluxTubes.Basic.ConstantReluctance device(R_m=1e5)
    constrainedby Modelica.Magnetic.FluxTubes.Interfaces.TwoPort
    annotation(choicesAllMatching=true, Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(source.port_n,ground.port)
    annotation(Line(points={{-80,40},{-40,40},{-40,-30},{0,-30}}, color={255,127,0})); connect(source.port_p,device.port_p)
    annotation(Line(points={{-80,40},{80,40}}, color={255,127,0})); connect(device.port_n,source.port_n)
    annotation(Line(points={{80,40},{-80,40}}, color={255,127,0}));
  annotation(Documentation(info="<html><p>用法：将 ReplaceableMagneticReluctanceSystem 作为可替换系统基类，通过 extends 派生场景，并在修改项中使用 redeclare 替换 device。保持其余拓扑和连接不变后仿真，可比较名义元件与故障增强元件。</p></html>"));
end ReplaceableMagneticReluctanceSystem;
