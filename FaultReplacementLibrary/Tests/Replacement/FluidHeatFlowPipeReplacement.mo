within FaultReplacementLibrary.Tests.Replacement;
model FluidHeatFlowPipeReplacement "FluidHeatFlow pipe redeclare and blockage scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableFluidHeatFlowPipeSystem(
    redeclare FaultReplacementLibrary.Thermal.FluidHeatFlow.Components.FaultablePipe device(
      medium=medium,m=0,T0=293.15,h_g=0,V_flowLaminar=0.01,dpLaminar=10,V_flowNominal=0.1,dpNominal=100,
      faultMode=FaultReplacementLibrary.Thermal.FluidHeatFlow.Components.FaultablePipe.FaultMode.Blockage,faultStartTime=0.4,transitionTime=0.05,severity=1));
equation
  when terminal() then assert(abs(device.dp)>1e5,"Blocked FluidHeatFlow pipe did not raise pressure drop"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidHeatFlowPipeReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidHeatFlowPipeReplacement;
