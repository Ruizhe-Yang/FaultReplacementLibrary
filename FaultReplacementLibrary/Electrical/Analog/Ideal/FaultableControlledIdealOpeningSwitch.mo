within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableControlledIdealOpeningSwitch "ControlledIdealOpeningSwitch independent fault model"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter Modelica.Units.SI.Resistance Ron(final min=0)=1e-5;
  parameter Modelica.Units.SI.Conductance Goff(final min=0)=1e-5;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(final T=293.15);
  parameter Modelica.Units.SI.Voltage level=0.5 "Switch level";
  Modelica.Electrical.Analog.Interfaces.Pin control "Control pin" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}},rotation=90)));
  type FaultMode=enumeration(Normal "正常", StuckOpen "卡在开路", StuckClosed "卡在闭合", ContactResistanceIncrease "接触电阻增加", LeakageIncrease "关断泄漏增加");
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
  Boolean off;
  Boolean naturalOff;
  Real s(final unit="1");
  constant Modelica.Units.SI.Voltage unitVoltage=1;
  constant Modelica.Units.SI.Current unitCurrent=1;
  Modelica.Units.SI.Resistance Ron_effective;
  Modelica.Units.SI.Conductance Goff_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  control.i=0;
  naturalOff=control.v > level;
  off=if faultMode==FaultMode.StuckOpen and faultActivation>0.5 then true elseif faultMode==FaultMode.StuckClosed and faultActivation>0.5 then false else naturalOff;
  Ron_effective=if faultMode==FaultMode.ContactResistanceIncrease then Ron+faultActivation*(RonFault-Ron) else Ron;
  Goff_effective=if faultMode==FaultMode.LeakageIncrease then Goff+faultActivation*(GoffFault-Goff) else Goff;
  v=(s*unitCurrent)*(if off then 1 else Ron_effective);
  i=(s*unitVoltage)*(if off then Goff_effective else 1);
  LossPower=v*i;
  annotation (defaultComponentName="switch",
    Documentation(info="<html><p>用法：将 FaultableControlledIdealOpeningSwitch 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The switching behaviour of the controlled  ideal opening switch is controlled by the control pin: off = control.v &gt; level<br>
For further details, see partial model <a href=\"modelica://Modelica.Electrical.Analog.Interfaces.IdealSwitch\">IdealSwitch</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li><em>February 7, 2016   </em>
       by Anton Haumer<br> extending from partial IdealSwitch<br>
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
        Line(points={{40,20},{40,0}}, color={0,0,255}),
        Line(
          visible=useHeatPort,
          points={{0,-100},{0,25}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(points={{-37,2},{40,40}},color={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableControlledIdealOpeningSwitch;

