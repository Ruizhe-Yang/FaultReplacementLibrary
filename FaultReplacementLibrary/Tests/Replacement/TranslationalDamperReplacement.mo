within FaultReplacementLibrary.Tests.Replacement;
model TranslationalDamperReplacement "Translational damper redeclare and damping-loss scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableTranslationalDamperSystem(
    redeclare FaultReplacementLibrary.Mechanics.Translational.Components.FaultableDamper device(
      d=100,dFault=0,faultMode=FaultReplacementLibrary.Mechanics.Translational.Components.FaultableDamper.FaultMode.DampingLoss,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(device.f)<1e-6,"Damping-loss replacement still transmits force"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 TranslationalDamperReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end TranslationalDamperReplacement;
