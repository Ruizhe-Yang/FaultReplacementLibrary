within FaultReplacementLibrary.Examples.Benchmarks.Electrical.HeatingRectifier;
model DiodeForwardCharacteristicDegradation "Rectifier forward voltage scale progressively drifts"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableDiode HeatingDiode1(
      useTemperatureDependency=true, useHeatPort=true, faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableDiode.FaultMode.ForwardVoltageDrift, severity=scenarioSeverity, faultStartTime=1, transitionTime=0.1, driftTime=1, VtFault=0.1));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 DiodeForwardCharacteristicDegradation，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end DiodeForwardCharacteristicDegradation;
