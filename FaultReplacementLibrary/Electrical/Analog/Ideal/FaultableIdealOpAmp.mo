within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableIdealOpAmp "Ideal operational amplifier (norator-nullator pair)"
  Modelica.Units.SI.Voltage v1 "Voltage drop over the left port";
  Modelica.Units.SI.Voltage v2 "Voltage drop over the right port";
  Modelica.Units.SI.Current i1 "Current flowing from pos. to neg. pin of the left port";
  Modelica.Units.SI.Current i2 "Current flowing from pos. to neg. pin of the right port";
  Modelica.Electrical.Analog.Interfaces.PositivePin p1 "Positive pin of the left port" annotation (
      Placement(transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n1 "Negative pin of the left port" annotation (
      Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p2 "Positive pin of the right port" annotation (
      Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n2 "Negative pin of the right port" annotation (
      Placement(transformation(
        origin={0,-100},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  type FaultMode=enumeration(Normal "正常", InputOffset "输入失调", InputLeakage "输入泄漏", InputShort "输入短路");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Voltage inputOffsetFault=0.01;
  parameter Modelica.Units.SI.Conductance inputLeakageFault=1e-6;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  v1 = p1.v - n1.v;
  v2 = p2.v - n2.v;
  0 = p1.i + n1.i;
  0 = p2.i + n2.i;
  i1 = p1.i;
  i2 = p2.i;
  v1 = if faultMode==FaultMode.InputOffset then faultActivation*inputOffsetFault else 0;
  i1 = if faultMode==FaultMode.InputLeakage then faultActivation*inputLeakageFault*v1
    elseif faultMode==FaultMode.InputShort then faultActivation*1e6*v1 else 0;
  annotation (defaultComponentName="opAmp",
    Documentation(info="<html><p>用法：将 FaultableIdealOpAmp 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The ideal OpAmp is a two-port. The left port is fixed to <em>v1=0</em> and <em>i1=0</em>
(nullator). At the right port both any voltage <em>v2</em> and any current <em>i2</em>
are possible (norator).
</p>
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
        Line(points={{60,0},{90,0}}, color={0,0,255}),
        Text(
          extent={{-150,130},{150,90}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{70,0},{-70,80},{-70,-80},{70,0}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}),
        Line(points={{0,-40},{0,-100}}, color={0,0,255}),
        Line(points={{-100,60},{-70,60}}, color={0,0,255}),
        Line(points={{-100,-60},{-70,-60}}, color={0,0,255}),
        Line(points={{70,0},{100,0}}, color={0,0,255}),
        Line(points={{-60,50},{-40,50}}, color={0,0,255}),
        Line(points={{-60,-50},{-40,-50}}, color={0,0,255}),
        Line(points={{-50,-40},{-50,-60}}, color={0,0,255}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealOpAmp;

