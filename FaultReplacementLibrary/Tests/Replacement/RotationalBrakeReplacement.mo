within FaultReplacementLibrary.Tests.Replacement;
model RotationalBrakeReplacement "Brake redeclare and friction-loss scenario"
  extends FaultReplacementLibrary.Tests.Replacement.Bases.ReplaceableRotationalBrakeSystem(
    redeclare FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableBrake device(
      fn_max=10,frictionScaleFault=0,
      faultMode=FaultReplacementLibrary.Mechanics.Rotational.Components.FaultableBrake.FaultMode.FrictionLoss,
      faultStartTime=0.4,transitionTime=0.05,severity=1) annotation(Placement(transformation(extent={{70,-50},{90,-30}}))));
  Modelica.Blocks.Sources.Constant command(k=0.5) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(command.y,device.f_normalized)
    annotation(Line(points={{-70,40},{5,40},{5,-40},{80,-40}}, color={0,0,127}));
  when terminal() then
    assert(abs(device.tau)<1e-6,"Friction-loss brake still transmits torque");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 RotationalBrakeReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end RotationalBrakeReplacement;
