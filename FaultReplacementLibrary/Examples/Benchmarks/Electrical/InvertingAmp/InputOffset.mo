within FaultReplacementLibrary.Examples.Benchmarks.Electrical.InvertingAmp;
model InputOffset "Operational-amplifier input offset drifts"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealOpAmpLimited opAmp(
      out(i(start=0,fixed=false)), faultMode=FaultReplacementLibrary.Electrical.Analog.Ideal.FaultableIdealOpAmpLimited.FaultMode.InputOffsetDrift, severity=scenarioSeverity, faultStartTime=0.1, transitionTime=0.01, driftTime=0.1, inputOffsetFault=0.5));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 InputOffset，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end InputOffset;
