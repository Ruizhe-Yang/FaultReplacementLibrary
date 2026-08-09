within FaultReplacementLibrary.Tests.Replacement;
model InductorReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableInductorCircuit(
    redeclare FaultReplacementLibrary.Electrical.Analog.Basic.FaultableInductor device(L=0.2,i(start=0,fixed=true),faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableInductor.FaultMode.OpenCircuit,faultStartTime=0.4,transitionTime=0.05,severity=1,R_open=1e6));
equation
  when terminal() then
    assert(abs(device.i)<1e-3,"Inductor open-circuit replacement did not suppress current");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 InductorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end InductorReplacement;
