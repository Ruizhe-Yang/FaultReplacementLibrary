within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableGyrator "Gyrator"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
  parameter SI.Conductance G1(start=1) "Primary gyration conductance";
  parameter SI.Conductance G2(start=1) "Secondary gyration conductance";
  type FaultMode = enumeration(Normal "正常", PrimaryGainDrift "原边回转电导漂移", SecondaryGainDrift "副边回转电导漂移", CouplingLoss "耦合损失");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter SI.Conductance G1_fault=0.5*G1;
  parameter SI.Conductance G2_fault=0.5*G2;
  SI.Conductance G1_effective;
  SI.Conductance G2_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  G1_effective = if faultMode == FaultMode.PrimaryGainDrift or faultMode == FaultMode.CouplingLoss then G1 + faultActivation*(G1_fault - G1) else G1;
  G2_effective = if faultMode == FaultMode.SecondaryGainDrift or faultMode == FaultMode.CouplingLoss then G2 + faultActivation*(G2_fault - G2) else G2;
  i1 = G2_effective*v2;
  i2 = -G1_effective*v1;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableGyrator 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>A gyrator is a two-port element defined by the following equations:</p>
<blockquote><pre>
i1 =  G2 * v2
i2 = -G1 * v1
</pre></blockquote>
<p>where the constants <em>G1</em>, <em>G2</em> are called the gyration conductance.</p>
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
        Line(points={{-40,30},{40,30}}, color={0,0,255}),
        Line(points={{-20,-30},{20,-30}}, color={0,0,255}),
        Polygon(
          points={{30,34},{40,30},{30,26},{30,34}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{-5,10},{-10,-10}}),
        Line(points={{9,10},{4,-9}}),
        Line(points={{-12,10},{16,10}}),
        Text(
          extent={{-29,69},{30,40}},
          textString="G1"),
        Text(
          extent={{-29,-39},{29,-68}},
          textString="G2"),
        Text(
          extent={{-150,151},{150,111}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{-10,-26},{-20,-30},{-10,-34},{-10,-26}},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{-100,100},{-40,100},{-40,60}}, color={0,0,255}),
        Line(
          points={{20,25},{-40,25},{-40,-15}},
          color={0,0,255},
          origin={80,75},
          rotation=360),
        Line(
          points={{-35,-20},{25,-20},{25,20}},
          color={0,0,255},
          origin={-65,-80},
          rotation=360),
        Line(
          points={{20,-25},{-40,-25},{-40,15}},
          color={0,0,255},
          origin={80,-75},
          rotation=360),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableGyrator;
