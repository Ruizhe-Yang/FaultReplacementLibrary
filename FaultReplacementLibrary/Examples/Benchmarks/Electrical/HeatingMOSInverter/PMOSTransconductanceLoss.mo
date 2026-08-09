within FaultReplacementLibrary.Examples.Benchmarks.Electrical.HeatingMOSInverter;
model PMOSTransconductanceLoss "PMOS transconductance degrades"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultablePMOS H_PMOS(
      useTemperatureDependency=true, faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultablePMOS.FaultMode.TransconductanceLoss, severity=scenarioSeverity, faultStartTime=1, transitionTime=0.1, driftTime=0.5, BetaFault=1.05e-6));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 PMOSTransconductanceLoss，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end PMOSTransconductanceLoss;
