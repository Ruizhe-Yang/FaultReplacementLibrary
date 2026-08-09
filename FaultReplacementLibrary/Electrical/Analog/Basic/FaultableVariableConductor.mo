within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableVariableConductor
  "Ideal linear electrical conductor with variable conductance"
  import SI = Modelica.Units.SI;
  parameter SI.Temperature T_ref=300.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of conductance (G_actual = G/(1 + alpha*(T_heatPort - T_ref))";
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=T_ref);
  SI.Conductance G_actual
    "Actual conductance = G/(1 + alpha*(T_heatPort - T_ref))";
  Modelica.Blocks.Interfaces.RealInput G(unit="S") annotation (Placement(
        transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  type FaultMode = enumeration(Normal "正常", ConductanceScaleError "输入电导比例误差", ConductanceBias "输入电导偏置", OpenCircuit "低电导开路", ShortCircuit "高电导短路");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real scaleFault=0.5 "比例故障目标";
  parameter SI.Conductance biasFault=1 "偏置故障目标";
  parameter SI.Conductance G_open=1e-10 "开路有限小电导";
  parameter SI.Conductance G_short=1e6 "短路有限大电导";
  SI.Conductance G_effective "故障后的命令电导";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps,
    "Temperature outside scope of model!");
  G_effective = if faultMode == FaultMode.ConductanceScaleError then G*(1 + faultActivation*(scaleFault - 1))
    elseif faultMode == FaultMode.ConductanceBias then G + faultActivation*biasFault
    elseif faultMode == FaultMode.OpenCircuit then G + faultActivation*(G_open - G)
    elseif faultMode == FaultMode.ShortCircuit then G + faultActivation*(G_short - G) else G;
  G_actual = G_effective/(1 + alpha*(T_heatPort - T_ref));
  i = G_actual*v;
  LossPower = v*i;
  annotation (defaultComponentName="conductor",
    Documentation(info="<html><p>用法：将 FaultableVariableConductor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear conductor connects the branch voltage <em>v</em> with the branch current <em>i</em> by
<br><em><strong>i = G*v</strong></em>
<br>The Conductance <em>G</em> is given as input signal.
<br><br><strong>Attention!!!</strong>
<br>It is recommended that the G signal should not cross the zero value. Otherwise depending on the surrounding circuit the probability of singularities is high.</p>
</html>",
        revisions="<html>
<ul>
<li><em> August 07, 2009   </em>
       by Anton Haumer<br> temperature dependency of conductance added<br>
       </li>
<li><em> March 11, 2009   </em>
       by Christoph Clauss<br> conditional heat port added<br>
       </li>
<li><em>June 7, 2004   </em>
       by Christoph Clauss<br> implemented<br>
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
end FaultableVariableConductor;
