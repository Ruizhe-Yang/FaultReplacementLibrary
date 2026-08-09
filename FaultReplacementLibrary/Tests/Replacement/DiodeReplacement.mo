within FaultReplacementLibrary.Tests.Replacement;
model DiodeReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableDiodeCircuit(
    redeclare FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableDiode device(faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableDiode.FaultMode.OpenCircuit,faultStartTime=0.4,transitionTime=0.05,severity=1,ROpen=1e9));
equation
  when terminal() then
    assert(abs(device.i)<1e-5,"Diode open-circuit replacement did not suppress current");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 DiodeReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end DiodeReplacement;
