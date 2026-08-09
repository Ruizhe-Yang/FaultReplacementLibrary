within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.CoupledClutches;
model ClutchSticking "First clutch develops excessive static capacity"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableClutch clutch1(
      peak=1.1, fn_max=20, faultMode=FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableClutch.FaultMode.Sticking, severity=scenarioSeverity, faultStartTime=0.3, transitionTime=0.05, stickingStaticScale=100));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 ClutchSticking，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end ClutchSticking;
