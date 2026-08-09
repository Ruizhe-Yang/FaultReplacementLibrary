within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableVCV "Linear voltage-controlled voltage source"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
  parameter Real gain(start=1) "Voltage gain";

  type FaultMode = enumeration(Normal "正常", GainDrift "增益漂移", OutputLoss "输出损失", StuckGain "增益卡死");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real gainFault=0.5*gain;
  Real gain_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  gain_effective = if faultMode == FaultMode.GainDrift or faultMode == FaultMode.StuckGain then gain + faultActivation*(gainFault - gain)
    elseif faultMode == FaultMode.OutputLoss then gain*(1 - faultActivation) else gain;
  v2 = v1*gain_effective;
  i1 = 0;
  annotation (defaultComponentName="vcv",
    Documentation(info="<html><p>用法：将 FaultableVCV 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear voltage-controlled voltage source is a TwoPort. The right port voltage v2 is controlled by the left port voltage v1 via</p>
<blockquote><pre>
v2 = v1 * gain.
</pre></blockquote>
<p>The left port current is zero. Any voltage gain can be chosen.</p>
</html>",
        revisions="<html>
<ul>
<li><em> 1998   </em>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,0,0}),
        Line(points={{90,100},{40,100},{40,-100},{100,-100}},
                                                           color={0,0,255}),
        Ellipse(extent={{20,20},{60,-20}}, lineColor={0,0,255}),
        Line(points={{-20,60},{20,60}}, color={0,0,255}),
        Polygon(
          points={{20,60},{10,63},{10,57},{20,60}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Text(
          extent={{-150,151},{150,111}},
          textString="%name",
          textColor={0,0,255}),
        Line(points={{-90,100},{-40,100},{-40,62}}, color={0,0,255}),
        Line(points={{-90,-100},{-40,-100},{-40,-60}}, color={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableVCV;
