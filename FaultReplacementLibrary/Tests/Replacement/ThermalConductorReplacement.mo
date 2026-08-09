within FaultReplacementLibrary.Tests.Replacement;
model ThermalConductorReplacement "Executable extends + redeclare fault scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableThermalConductorSystem(
    redeclare FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableThermalConductor device(G=5,faultMode=FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableThermalConductor.FaultMode.ThermalOpen,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then
    assert(abs(device.Q_flow)<1e-5,"Thermal-open replacement still transmits heat");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ThermalConductorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ThermalConductorReplacement;
