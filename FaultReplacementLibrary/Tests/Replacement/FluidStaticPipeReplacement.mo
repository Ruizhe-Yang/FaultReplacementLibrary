within FaultReplacementLibrary.Tests.Replacement;
model FluidStaticPipeReplacement "Modelica.Fluid pipe redeclare and complete-blockage scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableFluidStaticPipeSystem(
    redeclare FaultReplacementLibrary.Fluid.Pipes.FaultableStaticPipe device(
      redeclare package Medium=Medium,length=1,diameter=0.02,
      faultMode=FaultReplacementLibrary.Fluid.Pipes.FaultableStaticPipe.FaultMode.CompleteBlockage,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(device.port_a.m_flow)<1e-4,"Blocked StaticPipe still carries excessive flow"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidStaticPipeReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidStaticPipeReplacement;
