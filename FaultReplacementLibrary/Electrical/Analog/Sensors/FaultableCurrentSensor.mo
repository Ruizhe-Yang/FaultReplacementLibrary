within FaultReplacementLibrary.Electrical.Analog.Sensors;
model FaultableCurrentSensor
  "Ideal series current sensor with evidence-mapped signal faults"
  import SI = Modelica.Units.SI;
  extends Modelica.Icons.RoundSensor;

  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive pin"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative pin"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput i(unit="A")
    "Fault-affected measured current"
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
  parameter SI.Current biasFault=1;
  parameter Real gainFault=0.8;
  parameter Real driftRate(unit="A/s")=0.1;
  parameter SI.Current noiseAmplitude=0.01;
  parameter SI.Frequency noiseFrequency=37;
  parameter Boolean useFixedStuckValue=false;
  parameter SI.Current stuckValue=0;
  parameter SI.Current saturationLimit(min=Modelica.Constants.small)=1e6;

  SI.Current i_actual "True current through the ideal series sensor";
  SI.Current stuckTarget;
  SI.Time activeElapsedTime;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  discrete SI.Current stuckMemory(start=0,fixed=true);

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

  p.v = n.v;
  p.i = i_actual;
  n.i = -i_actual;
  stuckTarget = if useFixedStuckValue then stuckValue else stuckMemory;

  when initial() then
    stuckMemory = i_actual;
  elsewhen time >= faultStartTime then
    stuckMemory = i_actual;
  end when;

  i = if faultMode == FaultMode.Bias then
      i_actual + faultActivation*biasFault
    elseif faultMode == FaultMode.Drift then
      i_actual + severity*endActivation*driftRate*activeElapsedTime
    elseif faultMode == FaultMode.GainError then
      i_actual*(1 + faultActivation*(gainFault - 1))
    elseif faultMode == FaultMode.NoiseIncrease then
      i_actual + faultActivation*noiseAmplitude*(
        0.65*sin(2*Modelica.Constants.pi*noiseFrequency*time) +
        0.35*sin(2*Modelica.Constants.pi*1.618*noiseFrequency*time))
    elseif faultMode == FaultMode.Stuck then
      i_actual + faultActivation*(stuckTarget-i_actual)
    elseif faultMode == FaultMode.Dropout then
      i_actual*(1-faultActivation)
    elseif faultMode == FaultMode.Saturation then
      i_actual + faultActivation*(min(saturationLimit,max(-saturationLimit,i_actual))-i_actual)
    else i_actual;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableCurrentSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The electrical path remains an ideal zero-voltage series sensor. Faults affect
only its Real output. Normal mode and zero severity reproduce the MSL 4.0.0
CurrentSensor equations.</p>
<p>Bias, progressive drift, gain, reproducible noise, captured-value stuck,
dropout and saturation are separate signal mechanisms. Evidence level B for
bias/drift/gain/stuck and C for the deterministic noise/dropout abstraction; see
<code>Documentation/ElectricalFaultEvidence.md</code>.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(extent={{-150,80},{150,120}}, textString="%name", textColor={0,0,255}),
        Line(points={{0,-100},{0,-70}}, color={0,0,127}),
        Text(extent={{-30,-10},{30,-70}}, textString="A", textColor={64,64,64}),
        Line(points={{100,0},{-100,0}}, color={0,0,255}),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(extent={{-153,79},{147,119}}, textString="%name", textColor={0,0,255})}));
end FaultableCurrentSensor;
