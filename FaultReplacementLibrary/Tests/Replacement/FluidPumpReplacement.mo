within FaultReplacementLibrary.Tests.Replacement;
model FluidPumpReplacement "Modelica.Fluid Pump redeclare and bearing-friction scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableFluidPumpSystem(
    redeclare FaultReplacementLibrary.Fluid.Machines.FaultablePump device(
      redeclare package Medium=Medium,N_nominal=1500,
      V_flow_nominal=V_flow_nominal,head_nominal=head_nominal,
      faultTorqueAmplitude=1,
      faultMode=FaultReplacementLibrary.Fluid.Machines.FaultablePump.FaultMode.BearingFrictionIncrease,
      faultStartTime=0.4,transitionTime=0.05,severity=1) annotation(Placement(transformation(extent={{70,-50},{90,-30}}))));
equation
  connect(drive.flange,device.shaft)
    annotation(Line(points={{-80,40},{0,40},{0,-40},{80,-40}}, color={0,127,255}));
  when terminal() then
    assert(abs(device.faultTorque)>0.9,"Pump bearing-friction torque was not activated");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidPumpReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidPumpReplacement;
