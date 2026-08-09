within FaultReplacementLibrary.Examples.Benchmarks.Electrical.DifferenceAmplifier;
model NPNGainLoss "First NPN stage loses current gain"
  extends BaseReplaceable(
    redeclare NPNFaultStage Transistor1(
      ct(v(start=0,fixed=true)), faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNPN.FaultMode.CurrentGainLoss, scenarioSeverity=scenarioSeverity, faultStartTime=2e-9, transitionTime=1e-10, driftTime=2e-9, BfFault=5));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 NPNGainLoss，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end NPNGainLoss;
