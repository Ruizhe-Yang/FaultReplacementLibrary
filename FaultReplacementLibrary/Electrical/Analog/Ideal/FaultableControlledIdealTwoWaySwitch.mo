within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableControlledIdealTwoWaySwitch "Controlled ideal two-way switch"
  parameter Modelica.Units.SI.Voltage level=0.5 "Switch level";
  parameter Modelica.Units.SI.Resistance Ron(final min=0) = 1e-5 "Closed switch resistance";
  parameter Modelica.Units.SI.Conductance Goff(final min=0) = 1e-5
    "Opened switch conductance";
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(final T=
        293.15);
  Modelica.Electrical.Analog.Interfaces.PositivePin p annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n2 annotation (Placement(transformation(extent={{90,
            -10},{110,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n1 annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Electrical.Analog.Interfaces.Pin control
    "Control pin: if control.v > level p--n2 connected, otherwise p--n1 connected"
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  type FaultMode=enumeration(Normal "正常", StuckPosition1 "卡在位置一", StuckPosition2 "卡在位置二", ContactResistanceIncrease "接触电阻增加", LeakageIncrease "关断泄漏增加");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Resistance RonFault=1;
  parameter Modelica.Units.SI.Conductance GoffFault=1e-2;
  Boolean control_effective;
  Boolean control_command;
  Modelica.Units.SI.Resistance Ron_effective;
  Modelica.Units.SI.Conductance Goff_effective;
protected
  Real s1(final unit="1");
  Real s2(final unit="1") "Auxiliary variables";
  constant Modelica.Units.SI.Voltage unitVoltage=1 annotation (HideResult=true);
  constant Modelica.Units.SI.Current unitCurrent=1 annotation (HideResult=true);
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  control_command=control.v > level;
  control.i=0;
  control_effective=if faultMode==FaultMode.StuckPosition1 and faultActivation>0.5 then false elseif faultMode==FaultMode.StuckPosition2 and faultActivation>0.5 then true else control_command;
  Ron_effective=if faultMode==FaultMode.ContactResistanceIncrease then Ron+faultActivation*(RonFault-Ron) else Ron;
  Goff_effective=if faultMode==FaultMode.LeakageIncrease then Goff+faultActivation*(GoffFault-Goff) else Goff;

  0 = p.i + n2.i + n1.i;

  p.v - n1.v = (s1*unitCurrent)*(if (control_effective) then 1 else Ron_effective);
  n1.i = -(s1*unitVoltage)*(if (control_effective) then Goff_effective else 1);
  p.v - n2.v = (s2*unitCurrent)*(if (control_effective) then Ron_effective else 1);
  n2.i = -(s2*unitVoltage)*(if (control_effective) then 1 else Goff_effective);
  LossPower = p.i*p.v + n1.i*n1.v + n2.i*n2.v;
  annotation (defaultComponentName="switch",
    Documentation(info="<html><p>用法：将 FaultableControlledIdealTwoWaySwitch 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The two-way switch has a positive pin p and two negative pins n1 and n2.
The switching behaviour is controlled
by the control pin. If its voltage exceeds the value of the parameter level,
the pin p is connected with the negative pin n2. Otherwise, the pin p is
connected the negative pin n1.
</p>
<p>
In order to prevent singularities during switching, the opened
switch has a (very low) conductance Goff_effective
and the closed switch has a (very low) resistance Ron_effective.
The limiting case is also allowed, i.e., the resistance Ron_effective of the
closed switch could be exactly zero and the conductance Goff_effective of the
open switch could be also exactly zero. Note, there are circuits,
where a description with zero Ron_effective or zero Goff_effective is not possible.
<br><br>
<strong>Please note:</strong>
In case of useHeatPort=true the temperature dependence of the electrical
behavior is <strong>not</strong> modelled. The parameters are not temperature dependent.
</p>
</html>",
        revisions="<html>
<ul>
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
        Ellipse(extent={{-44,4},{-36,-4}}, lineColor={0,0,255}),
        Line(points={{-90,0},{-44,0}}, color={0,0,255}),
        Line(points={{-37,2},{40,40}}, color={0,0,255}),
        Line(points={{40,40},{90,40}}, color={0,0,255}),
        Line(points={{40,0},{90,0}}, color={0,0,255}),
        Line(
          visible=useHeatPort,
          points={{0,-99},{0,25}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableControlledIdealTwoWaySwitch;
