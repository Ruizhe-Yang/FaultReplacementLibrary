within FaultReplacementLibrary.Electrical.Analog.Sensors;
model FaultablePotentialSensor "Sensor to measure the potential"
  extends Modelica.Icons.RoundSensor;

  Modelica.Electrical.Analog.Interfaces.PositivePin p "Pin to be measured" annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="V")
    "Absolute voltage potential as output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  type FaultMode = enumeration(Normal "正常", Bias "偏置", GainError "增益误差", NoiseIncrease "噪声增加", Stuck "输出卡死", Dropout "输出丢失", Saturation "输出饱和");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real biasFault=1 "偏置故障目标";
  parameter Real gainFault=0.8 "增益故障目标";
  parameter Real noiseAmplitude=0.01 "确定性噪声幅值";
  parameter Modelica.Units.SI.Frequency noiseFrequency=37 "确定性噪声频率";
  parameter Real stuckValue=0 "卡死输出值";
  parameter Real saturationLimit(min=Modelica.Constants.small)=1e6 "对称饱和限值";
  Real phi_actual "未受信号故障影响的真实测量值";
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  p.i = 0;
  phi_actual = p.v;
  phi = if faultMode == FaultMode.Bias then phi_actual + faultActivation*biasFault
    elseif faultMode == FaultMode.GainError then phi_actual*(1 + faultActivation*(gainFault - 1))
    elseif faultMode == FaultMode.NoiseIncrease then phi_actual + faultActivation*noiseAmplitude*sin(2*Modelica.Constants.pi*noiseFrequency*time)
    elseif faultMode == FaultMode.Stuck then phi_actual + faultActivation*(stuckValue - phi_actual)
    elseif faultMode == FaultMode.Dropout then phi_actual*(1 - faultActivation)
    elseif faultMode == FaultMode.Saturation then phi_actual + faultActivation*(min(saturationLimit,max(-saturationLimit,phi_actual)) - phi_actual)
    else phi_actual;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-70,0},{-90,0}}, color={0,0,255}),
        Line(points={{100,0},{70,0}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-30,-10},{30,-70}},
          textString="V",
          textColor={64,64,64}),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}), Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}),
    Documentation(revisions="<html>
<ul>
<li><em> 1998   </em>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>",
        info="<html><p>用法：将 FaultablePotentialSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The potential sensor converts the voltage of a node (with respect to the ground node) into a real valued signal. It does not influence the current sum at the node which voltage is measured, therefore, the electrical behavior is not influenced by the sensor.</p>
</html>"));
end FaultablePotentialSensor;

