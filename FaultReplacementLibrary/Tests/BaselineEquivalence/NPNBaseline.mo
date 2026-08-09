within FaultReplacementLibrary.Tests.BaselineEquivalence;
model NPNBaseline
  "Difference amplifier with FaultableNPN at zero severity"
  extends FaultReplacementLibrary.Examples.Benchmarks.Electrical.DifferenceAmplifier.NPNGainLoss(
    scenarioSeverity=0);
  annotation(Documentation(info="<html><p>用法：直接仿真 NPNBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"));
end NPNBaseline;
