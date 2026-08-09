within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableInductor
  "Fault-enhanced MSL 4.0.0 inductor with winding and turn-short effects"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.OnePort(i(start=0));
  parameter SI.Inductance L(start=1) "Inductance";

  type FaultMode = enumeration(
    Normal "Nominal MSL behavior",
    InductanceDrift "Progressive inductance drift",
    InductanceLoss "Abrupt or ramped inductance loss",
    WindingResistanceIncrease "Series winding resistance increase",
    TurnShort "Reduced effective turns plus additional winding loss",
    OpenCircuit "Finite high-resistance winding open circuit");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter SI.Inductance L_drift=1.2*L "Inductance at completed drift";
  parameter SI.Inductance L_loss=0.5*L "Inductance after discrete loss";
  parameter SI.Resistance R_windingFault=10 "Added winding resistance target";
  parameter Real maxTurnShortRatio(min=0,max=0.95)=0.3
    "Shorted-turn fraction at severity one";
  parameter SI.Resistance R_turnShortLoss=1
    "Series-equivalent loss at maximum shorted-turn fraction";
  parameter SI.Resistance R_open=1e10 "Finite open-circuit resistance";

  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  Real turnShortRatio(min=0,max=0.95);
  SI.Inductance L_effective "Fault-adjusted inductance";
  SI.Resistance R_series "Fault-adjusted winding loss/open resistance";

equation
  startActivation = if time < faultStartTime then 0 else
    if transitionTime <= Modelica.Constants.eps then 1 else
    min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else
    if transitionTime <= Modelica.Constants.eps then 0 else
    max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  driftProgress = if time <= faultStartTime then 0 else
    min(1,max(0,(min(time,faultEndTime)-faultStartTime)/driftTime));
  driftActivation = severity*driftProgress*endActivation;
  turnShortRatio = if faultMode == FaultMode.TurnShort then
      faultActivation*maxTurnShortRatio else 0;

  L_effective = if faultMode == FaultMode.InductanceDrift then
      L + driftActivation*(L_drift-L)
    elseif faultMode == FaultMode.InductanceLoss then
      L + faultActivation*(L_loss-L)
    elseif faultMode == FaultMode.TurnShort then
      L*(1-turnShortRatio)^2 else L;
  R_series = if faultMode == FaultMode.WindingResistanceIncrease then
      faultActivation*R_windingFault
    elseif faultMode == FaultMode.TurnShort then
      faultActivation*R_turnShortLoss
    elseif faultMode == FaultMode.OpenCircuit then
      faultActivation*R_open else 0;

  v = L_effective*der(i) + R_series*i;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableInductor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Normal mode and <code>severity=0</code> reproduce the MSL equation
<code>v=L*der(i)</code>. Drift and discrete loss use distinct temporal laws.</p>
<p><code>TurnShort</code> represents a calibrated shorted-turn fraction: inductance
scales approximately with the square of effective turns and a finite
series-equivalent loss represents fault-loop heating. This is a system-level
lumped approximation, not a detailed coupled shorted-winding model.</p>
<p><b>Evidence:</b> transformer/winding inter-turn-short studies model shorted-turn
ratio, changed self/mutual inductances, fault resistance and circulating current
(Energies 18 (2025) 5453, doi:10.3390/en18205453). Evidence level B.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{60,0},{90,0}}, color={0,0,255}),
        Line(points={{-90,0},{-60,0}}, color={0,0,255}),
        Text(extent={{-150,-40},{150,-80}}, textString="L=%L"),
        Line(points={{-60,0},{-59,6},{-52,14},{-38,14},{-31,6},{-30,0}}, color={255,0,0}, smooth=Smooth.Bezier),
        Line(points={{-30,0},{-29,6},{-22,14},{-8,14},{-1,6},{0,0}}, color={255,0,0}, smooth=Smooth.Bezier),
        Line(points={{0,0},{1,6},{8,14},{22,14},{29,6},{30,0}}, color={255,0,0}, smooth=Smooth.Bezier),
        Line(points={{30,0},{31,6},{38,14},{52,14},{59,6},{60,0}}, color={255,0,0}, smooth=Smooth.Bezier),
        Text(extent={{-150,90},{150,50}}, textString="%name", textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableInductor;
