within FaultReplacementLibrary.Examples.Benchmarks.Electrical.HeatingMOSInverter;
model NMOSThresholdDrift "NMOS threshold voltage drifts"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNMOS H_NMOS(
      useTemperatureDependency=true, faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNMOS.FaultMode.ThresholdVoltageDrift, severity=scenarioSeverity, faultStartTime=1, transitionTime=0.1, driftTime=0.5, VtFault=2.5));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 NMOSThresholdDrift，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end NMOSThresholdDrift;
