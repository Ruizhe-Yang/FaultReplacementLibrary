within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableTransformer "Transformer with two ports"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.TwoPort(i1(start=0),i2(start=0));
  parameter SI.Inductance L1(start=1) "Primary inductance";
  parameter SI.Inductance L2(start=1) "Secondary inductance";
  parameter SI.Inductance M(start=1) "Coupling inductance";
  Real dv "Difference between voltage drop over primary inductor and voltage drop over secondary inductor";
  type FaultMode = enumeration(Normal "正常", PrimaryInductanceDrift "原边电感漂移", SecondaryInductanceDrift "副边电感漂移", CouplingLoss "耦合损失", PrimaryOpen "原边开路", SecondaryOpen "副边开路");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter SI.Inductance L1_fault=0.5*L1 "原边电感故障目标";
  parameter SI.Inductance L2_fault=0.5*L2 "副边电感故障目标";
  parameter SI.Inductance M_fault=0.1*M "耦合电感故障目标";
  parameter SI.Resistance R_open=1e10 "绕组开路有限大电阻";
  SI.Inductance L1_effective;
  SI.Inductance L2_effective;
  SI.Inductance M_effective;
  SI.Resistance R1_series;
  SI.Resistance R2_series;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  L1_effective = if faultMode == FaultMode.PrimaryInductanceDrift then L1 + faultActivation*(L1_fault - L1) else L1;
  L2_effective = if faultMode == FaultMode.SecondaryInductanceDrift then L2 + faultActivation*(L2_fault - L2) else L2;
  M_effective = if faultMode == FaultMode.CouplingLoss then M + faultActivation*(M_fault - M) else M;
  R1_series = if faultMode == FaultMode.PrimaryOpen then faultActivation*R_open else 0;
  R2_series = if faultMode == FaultMode.SecondaryOpen then faultActivation*R_open else 0;
  v1 = L1_effective*der(i1) + M_effective*der(i2) + R1_series*i1;
  v2 = M_effective*der(i1) + L2_effective*der(i2) + R2_series*i2;
  dv = v1 - v2;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableTransformer 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The transformer is a two port. The left port voltage <em>v1</em>, left port current <em>i1</em>, right port voltage <em>v2</em> and right port current <em>i2</em> are connected by the following relation:</p>
<blockquote><pre>
| v1 |         | L1   M  |  | i1&#39; |
|    |    =    |         |  |     |
| v2 |         | M    L2 |  | i2&#39; |
</pre></blockquote>
<p><em>L1</em>, <em>L2</em>, and <em>M</em> are the primary, secondary, and coupling inductances respectively.</p>
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
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-20,-60},{20,-100}},
          textString="M",
          textColor={0,0,255}),
        Line(points={{-40,60},{-40,100},{-90,100}}, color={0,0,255}),
        Line(points={{40,60},{40,100},{90,100}}, color={0,0,255}),
        Line(points={{-40,-60},{-40,-100},{-90,-100}}, color={0,0,255}),
        Line(points={{40,-60},{40,-100},{90,-100}}, color={0,0,255}),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,45},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,15},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,-15},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,-45},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,45},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,15},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,-15},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,-45},
          rotation=90),
        Text(
          extent={{-100,20},{-58,-20}},
          textString="L1",
          textColor={0,0,255}),
        Text(
          extent={{60,20},{100,-20}},
          textString="L2",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableTransformer;
