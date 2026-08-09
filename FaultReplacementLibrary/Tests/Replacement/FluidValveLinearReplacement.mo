within FaultReplacementLibrary.Tests.Replacement;
model FluidValveLinearReplacement "Modelica.Fluid valve redeclare and stuck-closed scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableFluidValveLinearSystem(
    redeclare FaultReplacementLibrary.Fluid.Valves.FaultableValveLinear device(
      redeclare package Medium=Medium,dp_nominal=1e5,m_flow_nominal=1,
      faultMode=FaultReplacementLibrary.Fluid.Valves.FaultableValveLinear.FaultMode.StuckClosed,faultStartTime=0.4,transitionTime=0.05,severity=1) annotation(Placement(transformation(extent={{70,-50},{90,-30}}))));
  Modelica.Blocks.Sources.Constant command(k=0.8) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(command.y,device.opening)
    annotation(Line(points={{-70,40},{5,40},{5,-40},{80,-40}}, color={0,0,127}));
  when terminal() then assert(abs(device.port_a.m_flow)<0.01,"Stuck-closed ValveLinear still carries excessive flow"); end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidValveLinearReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidValveLinearReplacement;
