within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableCapacitor
  "Fault-enhanced MSL 4.0.0 capacitor with ESR and leakage branches"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.OnePort(v(start=0));
  parameter SI.Capacitance C(start=1) "Capacitance";

  type FaultMode = enumeration(
    Normal "Nominal MSL behavior",
    CapacitanceDrift "Progressive bidirectional capacitance drift",
    CapacitanceLoss "Abrupt or ramped capacitance loss",
    LeakageIncrease "Parallel leakage conductance increase",
    ESRIncrease "Series equivalent resistance increase",
    OpenCircuit "Finite series-resistance open circuit",
    ShortCircuit "Finite parallel-conductance short circuit");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1
    "Time from drift onset to its calibrated target";
  parameter SI.Capacitance C_drift=1.2*C "Capacitance at completed drift";
  parameter SI.Capacitance C_loss=0.5*C "Capacitance after capacity loss";
  parameter SI.Conductance G_leakFault=1e-3 "Leakage target conductance";
  parameter SI.Conductance G_short=1e6 "Finite short-circuit conductance";
  parameter SI.Resistance R_seriesNominal=1e-9
    "Finite transparent resistance used by series-fault modes at zero severity";
  parameter SI.Resistance R_ESR=1 "Target series ESR";
  parameter SI.Resistance R_open=1e10 "Finite open-circuit series resistance";

  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  SI.Capacitance C_effective "Fault-adjusted capacitance";
  SI.Conductance G_parallel "Always-present parallel leakage/short branch";
  SI.Resistance R_series "Always-present series ESR/open branch";
  SI.Voltage v_cap(start=0) "Voltage across capacitance and leakage branch";

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

  C_effective = if faultMode == FaultMode.CapacitanceDrift then
      C + driftActivation*(C_drift-C)
    elseif faultMode == FaultMode.CapacitanceLoss then
      C + faultActivation*(C_loss-C) else C;
  G_parallel = if faultMode == FaultMode.LeakageIncrease then
      faultActivation*G_leakFault
    elseif faultMode == FaultMode.ShortCircuit then
      faultActivation*G_short else 0;
  R_series = if faultMode == FaultMode.ESRIncrease then
      R_seriesNominal + faultActivation*(R_ESR-R_seriesNominal)
    elseif faultMode == FaultMode.OpenCircuit then
      R_seriesNominal + faultActivation*(R_open-R_seriesNominal) else 0;

  if faultMode == FaultMode.ESRIncrease or faultMode == FaultMode.OpenCircuit then
    v = v_cap + R_series*i;
    i = C_effective*der(v_cap) + G_parallel*v_cap;
  else
    v_cap = v;
    i = C_effective*der(v) + G_parallel*v;
  end if;

  annotation (
    Documentation(info="<html><p>用法：将 FaultableCapacitor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Normal mode and <code>severity=0</code> reduce algebraically to the MSL 4.0.0
equation <code>i=C*der(v)</code>. The series and parallel branches are always in
the equation set, with exactly zero resistance/conductance when inactive.</p>
<p>Capacity loss, ESR increase and leakage increase are separately observable and
must not share one effective-parameter law. Progressive drift additionally uses
<code>driftTime</code>.</p>
<p><b>Evidence:</b> NASA accelerated-aging studies report capacitance loss
(NTRS 20120013444), ESR degradation (NTRS 20170003492), and leakage-current
growth associated with dielectric defects/oxygen-vacancy migration
(NTRS 20110015253, 20160001192). Evidence level A for directions, B/C for this
lumped fixed-topology mapping.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-6,28},{-6,-28}}, color={255,0,0}),
        Line(points={{6,28},{6,-28}}, color={255,0,0}),
        Line(points={{-90,0},{-6,0}}, color={0,0,255}),
        Line(points={{6,0},{90,0}}, color={0,0,255}),
        Text(extent={{-150,-40},{150,-80}}, textString="C=%C"),
        Text(extent={{-150,90},{150,50}}, textString="%name", textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableCapacitor;
