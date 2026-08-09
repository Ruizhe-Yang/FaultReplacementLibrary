within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.Vehicle;
model DragIncreaseSeveritySweep
  "Five-level severity sweep for DragIncrease"
  extends Modelica.Icons.Example;
  DragIncrease level0(scenarioSeverity=0) annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  DragIncrease level1(scenarioSeverity=0.25) annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  DragIncrease level2(scenarioSeverity=0.5) annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  DragIncrease level3(scenarioSeverity=0.75) annotation(Placement(transformation(extent={{30,-10},{50,10}})));
  DragIncrease level4(scenarioSeverity=1) annotation(Placement(transformation(extent={{70,-10},{90,10}})));
  annotation(
    Documentation(info="<html><p>用法：仿真 DragIncreaseSeveritySweep 可并行比较多个 severity 实例。绘制各实例的推荐外部观测量，用于检查故障响应随严重度变化的趋势。</p></html>"),
    experiment(StopTime=60, Interval=0.12));
end DragIncreaseSeveritySweep;
