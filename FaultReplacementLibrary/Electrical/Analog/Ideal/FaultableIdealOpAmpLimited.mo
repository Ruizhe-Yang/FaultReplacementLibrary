within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableIdealOpAmpLimited
  "Fault-enhanced MSL 4.0.0 ideal operational amplifier with limits"
  import SI = Modelica.Units.SI;
  Modelica.Electrical.Analog.Interfaces.PositivePin in_p "Positive input"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin in_n "Negative input"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin out "Output"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin VMax "Positive output limit"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin VMin "Negative output limit"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),iconTransformation(extent={{-10,-110},{10,-90}})));

  type FaultMode=enumeration(
    Normal "Nominal MSL behavior",
    InputOffsetDrift "Progressive equivalent input-offset drift",
    GainLoss "Finite differential gain",
    OutputLimitLoss "Reduced available output swing",
    OutputStuck "Drive output toward a calibrated fixed failure value");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter SI.Voltage inputOffsetFault=0.01;
  parameter Real gainFault(min=Modelica.Constants.small)=10
    "Finite V/V gain at severity one";
  parameter Real outputSwingFactor(min=0,max=1)=0.5
    "Remaining fraction of the rail-to-rail output span";
  parameter SI.Voltage outputStuckValue=0
    "Fixed output used by the system-level OutputStuck abstraction";

  SI.Voltage vin "Physical differential input";
  SI.Voltage vin_effective "Differential input including offset fault";
  SI.Voltage VMax_effective;
  SI.Voltage VMin_effective;
  SI.Voltage out_internal;
  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  Real inverseGain(min=0);
  Real outputSpanFactor(min=0,max=1);
protected
  Real s(start=0,final unit="1");
  constant SI.Voltage unitVoltage=1 annotation(HideResult=true);
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  driftProgress=if time<=faultStartTime then 0 else min(1,max(0,(min(time,faultEndTime)-faultStartTime)/driftTime));
  driftActivation=severity*driftProgress*endActivation;

  in_p.i=0;
  in_n.i=0;
  VMax.i=0;
  VMin.i=0;
  vin=in_p.v-in_n.v;
  vin_effective=vin+(if faultMode==FaultMode.InputOffsetDrift then driftActivation*inputOffsetFault else 0);
  inverseGain=if faultMode==FaultMode.GainLoss then faultActivation/gainFault else 0;
  outputSpanFactor=if faultMode==FaultMode.OutputLimitLoss then 1-faultActivation*(1-outputSwingFactor) else 1;
  VMax_effective=(VMax.v+VMin.v)/2+outputSpanFactor*(VMax.v-VMin.v)/2;
  VMin_effective=(VMax.v+VMin.v)/2-outputSpanFactor*(VMax.v-VMin.v)/2;

  vin_effective=unitVoltage*smooth(0,if s<-1 then s+1 elseif s>1 then s-1 else 0)+unitVoltage*inverseGain*s;
  out_internal=smooth(0,if s<-1 then VMin_effective elseif s>1 then VMax_effective else
    (VMax_effective-VMin_effective)*s/2+(VMax_effective+VMin_effective)/2);
  out.v=if faultMode==FaultMode.OutputStuck then
    out_internal+faultActivation*(outputStuckValue-out_internal) else out_internal;

  annotation(defaultComponentName="opAmp",
    Documentation(info="<html><p>用法：将 FaultableIdealOpAmpLimited 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>The Normal equations are the MSL 4.0.0
<code>IdealOpAmpLimited</code> equations. Input-offset drift shifts the differential
input; gain loss introduces a continuously activated inverse finite gain;
output-limit loss shrinks the available rail span; stuck mode drives the output
toward the calibrated parameter <code>outputStuckValue</code>. Zero severity removes
every added term exactly.</p>
<p><b>Evidence:</b> OP484 total-ionizing-dose tests monitor input offset, output
voltage, supply current and gain (NASA NTRS 20210018713). Input offset is level A,
finite-gain mapping level B, and stuck/output-stage abstractions level C.</p></html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
      Line(points={{60,0},{90,0}},color={0,0,255}),
      Polygon(points={{70,0},{-70,80},{-70,-80},{70,0}},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineColor={255,0,0}),
      Line(points={{-100,60},{-70,60}},color={0,0,255}),Line(points={{-100,-60},{-70,-60}},color={0,0,255}),
      Line(points={{-60,50},{-40,50}},color={255,0,0}),Line(points={{-50,-40},{-50,-60}},color={255,0,0}),Line(points={{-60,-50},{-40,-50}},color={255,0,0}),
      Line(points={{70,0},{100,0}},color={0,0,255}),Line(points={{-45,-10},{-10,-10},{-10,10},{20,10}},color={255,0,0}),
      Text(extent={{-150,150},{150,110}},textString="%name",textColor={0,0,255}),
      Line(points={{0,40},{0,100}},color={0,0,255}),Line(points={{0,-100},{0,-40}},color={0,0,255}),
      Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealOpAmpLimited;
