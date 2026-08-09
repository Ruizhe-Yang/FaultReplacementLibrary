within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableIdealDiode "Ideal diode with independent fault physics"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter Modelica.Units.SI.Resistance Ron(final min=0)=1e-5 "Forward state-on differential resistance";
  parameter Modelica.Units.SI.Conductance Goff(final min=0)=1e-5 "Backward state-off conductance";
  parameter Modelica.Units.SI.Voltage Vknee(final min=0)=0 "Forward threshold voltage";
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  type FaultMode=enumeration(Normal "正常", OpenCircuit "强制开路", ShortCircuit "强制短路", ForwardVoltageDrift "正向压降漂移", LeakageIncrease "反向泄漏增加");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Resistance R_short=1e-6;
  parameter Modelica.Units.SI.Conductance G_open=1e-10;
  parameter Modelica.Units.SI.Conductance G_leakFault=1e-2;
  parameter Modelica.Units.SI.Voltage VkneeFault=1;
  Boolean off(start=true);
  Boolean naturalOff;
  Real s(start=0,final unit="1");
  constant Modelica.Units.SI.Voltage unitVoltage=1;
  constant Modelica.Units.SI.Current unitCurrent=1;
  Modelica.Units.SI.Resistance Ron_effective;
  Modelica.Units.SI.Conductance Goff_effective;
  Modelica.Units.SI.Voltage Vknee_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  naturalOff = s < 0;
  off = if faultMode==FaultMode.OpenCircuit and faultActivation>0.5 then true
    elseif faultMode==FaultMode.ShortCircuit and faultActivation>0.5 then false else naturalOff;
  Ron_effective = if faultMode==FaultMode.ShortCircuit then Ron+faultActivation*(R_short-Ron) else Ron;
  Goff_effective = if faultMode==FaultMode.OpenCircuit then Goff+faultActivation*(G_open-Goff)
    elseif faultMode==FaultMode.LeakageIncrease then Goff+faultActivation*(G_leakFault-Goff) else Goff;
  Vknee_effective = if faultMode==FaultMode.ForwardVoltageDrift then Vknee+faultActivation*(VkneeFault-Vknee) else Vknee;
  v=(s*unitCurrent)*(if off then 1 else Ron_effective)+Vknee_effective;
  i=(s*unitVoltage)*(if off then Goff_effective else 1)+Goff_effective*Vknee_effective;
  LossPower=v*i;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableIdealDiode 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
    Polygon(points={{30,0},{-30,40},{-30,-40},{30,0}},lineColor={255,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{40,0}},color={0,0,255}),Line(points={{40,0},{90,0}},color={0,0,255}),
    Line(points={{30,40},{30,-40}},color={255,0,0}),Line(visible=useHeatPort,points={{0,-100},{0,-20}},color={127,0,0},pattern=LinePattern.Dot),
    Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255}),
    Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealDiode;

