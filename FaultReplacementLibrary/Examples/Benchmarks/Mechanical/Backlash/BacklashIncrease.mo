within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.Backlash;
model BacklashIncrease "Gear backlash grows"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableElastoBacklash elastoBacklash(
      c=20e3, d=50, b=0.7853981633974483, phi_nominal=1, faultMode=FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableElastoBacklash.FaultMode.BacklashIncrease, severity=scenarioSeverity, faultStartTime=0.5, transitionTime=0.1, bFault=1.5));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 BacklashIncrease，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end BacklashIncrease;
