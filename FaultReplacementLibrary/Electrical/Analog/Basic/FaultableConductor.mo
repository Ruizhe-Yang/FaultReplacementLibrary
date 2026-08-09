within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableConductor "Ideal linear electrical conductor"
  import SI = Modelica.Units.SI;
  parameter SI.Conductance G(start=1)
    "Conductance at temperature T_ref";
  parameter SI.Temperature T_ref=300.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of conductance (G_actual = G_ref/(1 + alpha*(T_heatPort - T_ref))";
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=T_ref);
  SI.Conductance G_actual
    "Actual conductance = G_ref/(1 + alpha*(T_heatPort - T_ref))";

  type FaultMode = enumeration(Normal "正常", ConductanceDrift "电导漂移", ConductanceStep "电导阶跃", OpenCircuit "低电导开路", ShortCircuit "高电导短路", TemperatureCoefficientDrift "温度系数漂移");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter SI.Conductance G_fault=2*G "电导漂移目标值";
  parameter SI.Conductance G_open=1e-10 "开路有限小电导";
  parameter SI.Conductance G_short=1e6 "短路有限大电导";
  parameter SI.LinearTemperatureCoefficient alpha_fault=2*alpha "故障温度系数";
  SI.Conductance G_effective "故障后的参考电导";
  SI.LinearTemperatureCoefficient alpha_effective "故障后的温度系数";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  G_effective = if faultMode == FaultMode.ConductanceDrift or faultMode == FaultMode.ConductanceStep then G + faultActivation*(G_fault - G)
    elseif faultMode == FaultMode.OpenCircuit then G + faultActivation*(G_open - G)
    elseif faultMode == FaultMode.ShortCircuit then G + faultActivation*(G_short - G) else G;
  alpha_effective = if faultMode == FaultMode.TemperatureCoefficientDrift then alpha + faultActivation*(alpha_fault - alpha) else alpha;
  assert((1 + alpha_effective*(T_heatPort - T_ref)) >= Modelica.Constants.eps,
    "Temperature outside scope of model!");
  G_actual = G_effective/(1 + alpha_effective*(T_heatPort - T_ref));
  i = G_actual*v;
  LossPower = v*i;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableConductor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear conductor connects the branch voltage <em>v</em> with the branch current <em>i</em> by <em>i = v*G</em>. The Conductance <em>G</em> is allowed to be positive, zero, or negative.</p>
</html>",
        revisions="<html>
<ul>
<li><em> August 07, 2009   </em>
       by Anton Haumer<br> temperature dependency of conductance added<br>
       </li>
<li><em> March 11, 2009   </em>
       by Christoph Clauss<br> conditional heat port added<br>
       </li>
<li><em> 1998   </em>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-70,30},{70,-30}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,0,0}),
        Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
        Line(points={{-90,0},{-70,0}}, color={0,0,255}),
        Line(points={{70,0},{90,0}}, color={0,0,255}),
        Line(
          visible=useHeatPort,
          points={{0,-100},{0,-30}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Text(
          extent={{-150,-40},{150,-80}},
          textString="G=%G"),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableConductor;
