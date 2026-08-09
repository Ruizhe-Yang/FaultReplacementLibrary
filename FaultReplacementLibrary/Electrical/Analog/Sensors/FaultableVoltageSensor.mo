within FaultReplacementLibrary.Electrical.Analog.Sensors;
model FaultableVoltageSensor
  "Non-invasive voltage sensor with evidence-mapped signal faults"
  import SI = Modelica.Units.SI;
  extends Modelica.Icons.RoundSensor;

  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive pin"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative pin"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput v(unit="V")
    "Fault-affected measured voltage"
    annotation (Placement(transformation(origin={0,-110}, extent={{10,-10},{-10,10}}, rotation=90)));

  type FaultMode = enumeration(
    Normal "Nominal MSL behavior",
    Bias "Constant offset",
    Drift "Time-growing offset after fault onset",
    GainError "Multiplicative calibration error",
    NoiseIncrease "Deterministic reproducible noise increase",
    Stuck "Hold the value captured at fault onset",
    Dropout "Measurement loss toward zero",
    Saturation "Symmetric output clipping");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Voltage biasFault=1 "Offset at severity one";
  parameter Real gainFault=0.8 "Gain factor at severity one";
  parameter Real driftRate(unit="V/s")=0.1
    "Voltage drift rate at severity one";
  parameter SI.Voltage noiseAmplitude=0.01 "Added deterministic noise amplitude";
  parameter SI.Frequency noiseFrequency=37 "Base noise frequency";
  parameter Boolean useFixedStuckValue=false
    "Use stuckValue instead of the value captured at onset";
  parameter SI.Voltage stuckValue=0 "Optional fixed stuck value";
  parameter SI.Voltage saturationLimit(min=Modelica.Constants.small)=1e6
    "Symmetric output limit";

  SI.Voltage v_actual "True non-invasive voltage measurement";
  SI.Voltage stuckTarget;
  SI.Time activeElapsedTime;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  discrete SI.Voltage stuckMemory(start=0,fixed=true)
    "True measurement captured at fault onset";

equation
  startActivation = if time < faultStartTime then 0 else
    if transitionTime <= Modelica.Constants.eps then 1 else
    min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else
    if transitionTime <= Modelica.Constants.eps then 0 else
    max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  activeElapsedTime = if time <= faultStartTime then 0 else
    max(0,min(time,faultEndTime)-faultStartTime);

  p.i = 0;
  n.i = 0;
  v_actual = p.v - n.v;
  stuckTarget = if useFixedStuckValue then stuckValue else stuckMemory;

  when initial() then
    stuckMemory = v_actual;
  elsewhen time >= faultStartTime then
    stuckMemory = v_actual;
  end when;

  v = if faultMode == FaultMode.Bias then
      v_actual + faultActivation*biasFault
    elseif faultMode == FaultMode.Drift then
      v_actual + severity*endActivation*driftRate*activeElapsedTime
    elseif faultMode == FaultMode.GainError then
      v_actual*(1 + faultActivation*(gainFault - 1))
    elseif faultMode == FaultMode.NoiseIncrease then
      v_actual + faultActivation*noiseAmplitude*(
        0.65*sin(2*Modelica.Constants.pi*noiseFrequency*time) +
        0.35*sin(2*Modelica.Constants.pi*1.618*noiseFrequency*time))
    elseif faultMode == FaultMode.Stuck then
      v_actual + faultActivation*(stuckTarget-v_actual)
    elseif faultMode == FaultMode.Dropout then
      v_actual*(1-faultActivation)
    elseif faultMode == FaultMode.Saturation then
      v_actual + faultActivation*(min(saturationLimit,max(-saturationLimit,v_actual))-v_actual)
    else v_actual;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableVoltageSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The electrical pins remain exactly non-invasive (<code>p.i=n.i=0</code>).
Only the Real output is faulted. Normal mode and zero severity reproduce
<code>Modelica.Electrical.Analog.Sensors.VoltageSensor</code>.</p>
<p>Bias, drift and gain use distinct signal laws. Stuck mode captures the true
measurement at fault onset instead of silently defaulting to zero. Noise is a
deterministic two-tone approximation so regression tests remain reproducible.</p>
<p><b>Evidence:</b> current/voltage sensors are commonly represented with offset
and gain faults (Energies 8 (2015) 6509, doi:10.3390/en8076509); bias, drift,
stuck, spike and clipping taxonomies are documented in Electronics 14 (2025)
4532. Evidence level B; deterministic noise and dropout are level C.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-70,0},{-90,0}}, color={0,0,255}),
        Line(points={{70,0},{90,0}}, color={0,0,255}),
        Line(points={{0,-100},{0,-70}}, color={0,0,127}),
        Text(extent={{-150,80},{150,120}}, textString="%name", textColor={0,0,255}),
        Text(extent={{-30,-10},{30,-70}}, textString="V", textColor={64,64,64}),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableVoltageSensor;
