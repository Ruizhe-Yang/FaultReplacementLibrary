within FaultReplacementLibrary.Tests.Replacement;
model CapacitorReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableCapacitorCircuit(
    redeclare FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor device(C=1e-3,faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor.FaultMode.OpenCircuit,faultStartTime=0.4,transitionTime=0.05,severity=1,R_open=1e8));
equation
  when terminal() then
    assert(abs(device.i)<1e-4,"Capacitor open-circuit replacement did not suppress current");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 CapacitorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end CapacitorReplacement;
