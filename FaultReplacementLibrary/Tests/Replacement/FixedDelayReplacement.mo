within FaultReplacementLibrary.Tests.Replacement;
model FixedDelayReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableFixedDelaySystem(
    redeclare FaultReplacementLibrary.Blocks.Nonlinear.FaultableFixedDelay device(delayTime=0.1,faultMode=FaultReplacementLibrary.Blocks.Nonlinear.FaultableFixedDelay.FaultMode.Dropout,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then
    assert(abs(device.y)<1e-8,"FixedDelay dropout replacement output is not zero");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FixedDelayReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FixedDelayReplacement;
