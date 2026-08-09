within FaultReplacementLibrary.Tests.Replacement;
model RotationalSpringReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableRotationalSpringSystem(
    redeclare FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableSpring device(c=100,faultMode=FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableSpring.FaultMode.Broken,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then
    assert(abs(device.tau)<1e-6,"Broken rotational spring still transmits torque");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalSpringReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalSpringReplacement;
