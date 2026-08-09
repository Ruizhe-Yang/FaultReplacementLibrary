within FaultReplacementLibrary.Examples.Electrical;
model ReplaceableResistorExample
  "以官方 MSL 电阻为默认类的可替换基准系统"
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V=10)
    annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));
  replaceable Modelica.Electrical.Analog.Basic.Resistor load(R=10)
    constrainedby Modelica.Electrical.Analog.Interfaces.OnePort
    annotation(choicesAllMatching=true,
      Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation(Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation
  connect(source.p, load.p)
    annotation(Line(points={{-70,0},{0,0}}, color={0,0,255}));
  connect(load.n, source.n)
    annotation(Line(points={{20,0},{-50,0}}, color={0,0,255}));
  connect(source.n, ground.p)
    annotation(Line(points={{-50,0},{-40,0},{-40,-30},{-30,-30}}, color={0,0,255}));
  annotation(experiment(StopTime=2, Tolerance=1e-8),
    Documentation(info="<html><p>用法：在 OMEdit 中打开 ReplaceableResistorExample 查看连接图，设置公开参数后直接仿真。若模型声明了 replaceable 元件，可在派生模型中通过 redeclare 切换名义件或故障件。</p><p>正常系统只把官方 MSL 电阻声明为 replaceable；故障场景通过 extends + redeclare 替换该元件。</p></html>"));
end ReplaceableResistorExample;
