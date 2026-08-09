within FaultReplacementLibrary.Examples.Benchmarks.Electrical.OvervoltageProtection;
model ZenerLeakage "Protection Zener leakage increases"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableZDiode zDiode1(
      v(start=0), faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableZDiode.FaultMode.ReverseLeakageIncrease, severity=scenarioSeverity, faultStartTime=0.1, transitionTime=0.01, RLeakFault=1e3));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 ZenerLeakage，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end ZenerLeakage;
