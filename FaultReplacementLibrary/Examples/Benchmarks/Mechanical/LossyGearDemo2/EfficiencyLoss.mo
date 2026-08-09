within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.LossyGearDemo2;
model EfficiencyLoss "Gear mesh efficiency degrades"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableLossyGear gear(
      ratio=2, lossTable=[0,0.5,0.5,0,0], useSupport=true, faultMode=FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableLossyGear.FaultMode.EfficiencyLoss, severity=scenarioSeverity, faultStartTime=0.1, transitionTime=0.02, lossTorqueFault=5));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 EfficiencyLoss，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end EfficiencyLoss;
