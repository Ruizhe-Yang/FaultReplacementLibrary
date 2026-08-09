within FaultReplacementLibrary.Examples.Benchmarks.Electrical.CauerLowPassAnalog;
model CapacitanceLoss "Central shunt capacitor loses capacitance"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor C3(
      C=c3, v(start=0,fixed=true), faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor.FaultMode.CapacitanceLoss, severity=scenarioSeverity, faultStartTime=2, transitionTime=0.1, C_loss=0.1682));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 CapacitanceLoss，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end CapacitanceLoss;
