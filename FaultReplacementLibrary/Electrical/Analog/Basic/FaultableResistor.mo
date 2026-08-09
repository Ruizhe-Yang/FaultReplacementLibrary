within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableResistor
  "Fault-enhanced MSL 4.0.0 resistor with distinct drift and step laws"
  import SI = Modelica.Units.SI;

  parameter SI.Resistance R(start=1) "Resistance at reference temperature";
  parameter SI.Temperature T_ref=300.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance";

  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=T_ref);

  type FaultMode = enumeration(
      Normal "Nominal MSL behavior",
      ResistanceDrift "Progressive resistance drift",
      ResistanceStep "Abrupt resistance change",
      OpenCircuit "Finite high-resistance open circuit",
      ShortCircuit "Finite low-resistance short circuit",
      TemperatureCoefficientDrift "Progressive temperature-coefficient drift");

  parameter FaultMode faultMode=FaultMode.Normal "Selected fault mode";
  parameter Real severity(min=0, max=1)=1 "Fault severity";
  parameter SI.Time faultStartTime=0 "Fault start time";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "Fault end time";
  parameter SI.Time transitionTime(min=0)=0 "Activation/deactivation ramp time";
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1
    "Time from drift onset to its calibrated target";
  parameter SI.Resistance R_drift=2*R "Resistance at completed drift";
  parameter SI.Resistance R_step=2*R "Resistance after an abrupt step";
  parameter SI.Resistance R_open(min=Modelica.Constants.small)=1e10
    "Finite resistance representing an open circuit";
  parameter SI.Resistance R_short(min=Modelica.Constants.small)=1e-6
    "Finite resistance representing a short circuit";
  parameter SI.LinearTemperatureCoefficient alpha_fault=2*alpha
    "Temperature coefficient at completed drift";

  SI.Resistance R_actual
    "Temperature-adjusted resistance used by the constitutive equation";
  SI.Resistance R_effective "Fault-adjusted reference resistance";
  SI.LinearTemperatureCoefficient alpha_effective
    "Fault-adjusted temperature coefficient";
  Real faultActivation(min=0, max=1) "Severity-scaled activation envelope";
  Real driftActivation(min=0, max=1) "Severity-scaled progressive drift";
  Real startActivation(min=0, max=1);
  Real endActivation(min=0, max=1);
  Real driftProgress(min=0, max=1);

equation
  startActivation = if time < faultStartTime then 0 else
    if transitionTime <= Modelica.Constants.eps then 1 else
    min(1, max(0, (time - faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else
    if transitionTime <= Modelica.Constants.eps then 0 else
    max(0, 1 - (time - faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  driftProgress = if time <= faultStartTime then 0 else
    min(1, max(0, (min(time, faultEndTime) - faultStartTime)/driftTime));
  driftActivation = severity*driftProgress*endActivation;

  R_effective = if faultMode == FaultMode.ResistanceDrift then
      R + driftActivation*(R_drift - R)
    elseif faultMode == FaultMode.ResistanceStep then
      R + faultActivation*(R_step - R)
    elseif faultMode == FaultMode.OpenCircuit then
      R + faultActivation*(R_open - R)
    elseif faultMode == FaultMode.ShortCircuit then
      R + faultActivation*(R_short - R)
    else R;
  alpha_effective = if faultMode == FaultMode.TemperatureCoefficientDrift then
      alpha + driftActivation*(alpha_fault - alpha) else alpha;

  assert((1 + alpha_effective*(T_heatPort - T_ref)) >= Modelica.Constants.eps,
    "Temperature outside the valid linear resistance model range");
  R_actual = R_effective*(1 + alpha_effective*(T_heatPort - T_ref));
  v = R_actual*i;
  LossPower = v*i;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableResistor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Independent fault-enhanced implementation of
<code>Modelica.Electrical.Analog.Basic.Resistor</code>. Normal mode and
<code>severity=0</code> reproduce the MSL 4.0.0 constitutive and heat-loss
equations exactly.</p>
<p><code>ResistanceDrift</code> uses the separate progressive clock
<code>driftTime</code>; <code>ResistanceStep</code>, open circuit and short circuit
use the activation envelope. Open and short faults remain finite and never change
the connection topology.</p>
<p><b>Evidence:</b> resistor corrosion and aging support parametric drift,
resistive shorts and opens (Amin et al., Microelectronics Reliability 52 (2012),
doi:10.1016/j.microrel.2012.02.020). The equation mapping is evidence level A/B;
target values require component-specific calibration.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-70,30},{70,-30}}, lineColor={255,0,0},
          fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{-70,0}}, color={0,0,255}),
        Line(points={{70,0},{90,0}}, color={0,0,255}),
        Text(extent={{-150,-40},{150,-80}}, textString="R=%R"),
        Line(visible=useHeatPort, points={{0,-100},{0,-30}},
          color={127,0,0}, pattern=LinePattern.Dot),
        Text(extent={{-150,90},{150,50}}, textString="%name", textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableResistor;
