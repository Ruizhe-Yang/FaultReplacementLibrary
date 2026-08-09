within FaultReplacementLibrary.Tests.Replacement;
model MagneticReluctanceReplacement "Magnetic reluctance redeclare and open-path scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableMagneticReluctanceSystem(
    redeclare FaultReplacementLibrary.Magnetic.FluxTubes.Basic.FaultableConstantReluctance device(
      R_m=1e5,R_mOpen=1e12,faultMode=FaultReplacementLibrary.Magnetic.FluxTubes.Basic.FaultableConstantReluctance.FaultMode.MagneticOpen,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(source.Phi)<1e-8,"Magnetic-open replacement still carries flux"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 MagneticReluctanceReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end MagneticReluctanceReplacement;
