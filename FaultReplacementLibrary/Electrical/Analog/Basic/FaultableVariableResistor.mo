within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableVariableResistor
  "Ideal linear electrical resistor with variable resistance"
  import SI = Modelica.Units.SI;
  parameter SI.Temperature T_ref=300.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=T_ref);
  SI.Resistance R_actual
    "Actual resistance = R*(1 + alpha*(T_heatPort - T_ref))";
  Modelica.Blocks.Interfaces.RealInput R(unit="Ohm") annotation (Placement(
        transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  type FaultMode = enumeration(Normal "正常", ResistanceScaleError "输入电阻比例误差", ResistanceBias "输入电阻偏置", OpenCircuit "有限大阻值开路", ShortCircuit "有限小阻值短路");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real scaleFault=0.5 "比例故障目标";
  parameter SI.Resistance biasFault=1 "偏置故障目标";
  parameter SI.Resistance R_open=1e10 "开路有限大电阻";
  parameter SI.Resistance R_short=1e-6 "短路有限小电阻";
  SI.Resistance R_effective "故障后的命令电阻";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps,
    "Temperature outside scope of model!");
  R_effective = if faultMode == FaultMode.ResistanceScaleError then R*(1 + faultActivation*(scaleFault - 1))
    elseif faultMode == FaultMode.ResistanceBias then R + faultActivation*biasFault
    elseif faultMode == FaultMode.OpenCircuit then R + faultActivation*(R_open - R)
    elseif faultMode == FaultMode.ShortCircuit then R + faultActivation*(R_short - R) else R;
  R_actual = R_effective*(1 + alpha*(T_heatPort - T_ref));
  v = R_actual*i;
  LossPower = v*i;
  annotation (defaultComponentName="resistor",
    Documentation(info="<html><p>用法：将 FaultableVariableResistor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear resistor connects the branch voltage <em>v</em> with the branch current <em>i</em> by
<br><em><strong>i*R = v</strong></em>
<br>The Resistance <em>R</em> is given as input signal.
<br><br><strong>Attention!!!</strong><br>It is recommended that the R signal should not cross the zero value. Otherwise depending on the surrounding circuit the probability of singularities is high.</p>
</html>",
        revisions="<html>
<ul>
<li><em> August 07, 2009   </em>
       by Anton Haumer<br> temperature dependency of resistance added<br>
       </li>
<li><em> March 11, 2009   </em>
       by Christoph Clauss<br> conditional heat port added<br>
       </li>
<li><em>June 7, 2004   </em>
       by Christoph Clauss<br>changed, docu added<br>
       </li>
<li><em>April 30, 2004</em>
       by Anton Haumer<br>implemented.
       </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{-90,0},{-70,0}}, color={0,0,255}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{70,0},{90,0}}, color={0,0,255}),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableVariableResistor;
