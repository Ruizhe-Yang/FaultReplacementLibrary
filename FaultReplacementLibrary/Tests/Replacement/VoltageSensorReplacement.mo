within FaultReplacementLibrary.Tests.Replacement;
model VoltageSensorReplacement "VoltageSensor redeclare and bias scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableVoltageSensorSystem(
    redeclare FaultReplacementLibrary.Electrical.Analog.Sensors.FaultableVoltageSensor device(
      biasFault=2,faultMode=FaultReplacementLibrary.Electrical.Analog.Sensors.FaultableVoltageSensor.FaultMode.Bias,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(device.v-7)<1e-6,"Biased voltage sensor output mismatch"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 VoltageSensorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end VoltageSensorReplacement;
