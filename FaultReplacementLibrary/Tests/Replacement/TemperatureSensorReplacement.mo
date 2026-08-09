within FaultReplacementLibrary.Tests.Replacement;
model TemperatureSensorReplacement "TemperatureSensor redeclare and bias scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableTemperatureSensorSystem(
    redeclare FaultReplacementLibrary.Thermal.HeatTransfer.Sensors.FaultableTemperatureSensor device(
      biasFault=10,faultMode=FaultReplacementLibrary.Thermal.HeatTransfer.Sensors.FaultableTemperatureSensor.FaultMode.Bias,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(device.T-310)<1e-6,"Biased temperature sensor output mismatch"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TemperatureSensorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TemperatureSensorReplacement;
