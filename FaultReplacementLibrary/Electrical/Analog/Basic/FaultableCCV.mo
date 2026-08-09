within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableCCV "Linear current-controlled voltage source"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;

  parameter SI.Resistance transResistance(start=1) "Transresistance";

  type FaultMode = enumeration(Normal "正常", TransresistanceDrift "跨阻漂移", OutputLoss "输出损失", StuckGain "跨阻卡死");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter SI.Resistance transResistanceFault=0.5*transResistance;
  SI.Resistance transResistance_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  transResistance_effective = if faultMode == FaultMode.TransresistanceDrift or faultMode == FaultMode.StuckGain then transResistance + faultActivation*(transResistanceFault - transResistance)
    elseif faultMode == FaultMode.OutputLoss then transResistance*(1 - faultActivation) else transResistance;
  v2 = i1*transResistance_effective;
  v1 = 0;
  annotation (defaultComponentName="ccv",
    Documentation(info="<html><p>用法：将 FaultableCCV 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear current-controlled voltage source is a TwoPort. The right port voltage v2 is controlled by the left port current i1 via</p>
<blockquote><pre>
v2 = i1 * transResistance.
</pre></blockquote>
<p>The left port voltage is zero. Any transResistance can be chosen.</p>
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
        Line(points={{90,100},{40,100},{40,-100},{90,-100}},
                                                           color={0,0,255}),
        Ellipse(extent={{20,20},{60,-20}}, lineColor={0,0,255}),
        Line(points={{-20,60},{20,60}}, color={0,0,255}),
        Polygon(
          points={{20,60},{10,63},{10,57},{20,60}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{-90,100},{-40,100},{-40,-100},{-90,-100}},
                                                             color={0,0,255}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableCCV;
