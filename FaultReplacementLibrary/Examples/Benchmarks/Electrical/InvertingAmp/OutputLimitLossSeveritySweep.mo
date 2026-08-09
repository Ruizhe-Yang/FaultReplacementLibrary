within FaultReplacementLibrary.Examples.Benchmarks.Electrical.InvertingAmp;
model OutputLimitLossSeveritySweep
  "Five-level severity sweep for OutputLimitLoss"
  extends Modelica.Icons.Example;
  OutputLimitLoss level0(scenarioSeverity=0) annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  OutputLimitLoss level1(scenarioSeverity=0.25) annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  OutputLimitLoss level2(scenarioSeverity=0.5) annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  OutputLimitLoss level3(scenarioSeverity=0.75) annotation(Placement(transformation(extent={{30,-10},{50,10}})));
  OutputLimitLoss level4(scenarioSeverity=1) annotation(Placement(transformation(extent={{70,-10},{90,10}})));
  annotation(
    Documentation(info="<html><p>用法：仿真 OutputLimitLossSeveritySweep 可并行比较多个 severity 实例。绘制各实例的推荐外部观测量，用于检查故障响应随严重度变化的趋势。</p></html>"),
    experiment(StopTime=1, Interval=0.002));
end OutputLimitLossSeveritySweep;
