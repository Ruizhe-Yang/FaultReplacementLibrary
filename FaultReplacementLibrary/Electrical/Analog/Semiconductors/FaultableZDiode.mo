within FaultReplacementLibrary.Electrical.Analog.Semiconductors;
model FaultableZDiode "Fault-enhanced MSL 4.0.0 Zener diode"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter SI.Current Ids=1e-6;
  parameter SI.Voltage Vt(min=Modelica.Constants.small)=0.04;
  parameter Real Maxexp(final min=Modelica.Constants.small)=30;
  parameter SI.Resistance R=1e8;
  parameter SI.Voltage Bv=5.1;
  parameter SI.Current Ibv=0.7;
  parameter Real Nbv=0.74;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=293.15);

  type FaultMode=enumeration(
    Normal "Nominal MSL behavior",
    SaturationCurrentDrift "Progressive transport-current drift",
    ForwardVoltageDrift "Progressive forward I-V scale drift",
    BreakdownVoltageDrift "Progressive Zener-voltage drift",
    ReverseLeakageIncrease "Parallel leakage increase",
    OpenCircuit "Finite high-resistance open circuit",
    ShortCircuit "Finite low-resistance shunt");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter SI.Current IdsFault=10*Ids;
  parameter SI.Voltage VtFault=1.5*Vt;
  parameter SI.Voltage BvFault=0.7*Bv;
  parameter SI.Resistance RLeakFault=R/100;
  parameter SI.Resistance ROpen=1e12;
  parameter SI.Resistance RShort=1e-6;

  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  Real diodeConductionFactor(min=0,max=1);
  SI.Current Ids_effective;
  SI.Voltage Vt_effective;
  SI.Voltage Bv_effective;
  SI.Resistance R_effective;
  SI.Current i_semiconductor;
equation
  startActivation=if time<faultStartTime then 0 elseif
    transitionTime<=Modelica.Constants.eps then 1 else
    min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif
    transitionTime<=Modelica.Constants.eps then 0 else
    max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  driftProgress=if time<=faultStartTime then 0 else
    min(1,max(0,(min(time,faultEndTime)-faultStartTime)/driftTime));
  driftActivation=severity*driftProgress*endActivation;

  Ids_effective=if faultMode==FaultMode.SaturationCurrentDrift then
    Ids+driftActivation*(IdsFault-Ids) else Ids;
  Vt_effective=if faultMode==FaultMode.ForwardVoltageDrift then
    Vt+driftActivation*(VtFault-Vt) else Vt;
  Bv_effective=if faultMode==FaultMode.BreakdownVoltageDrift then
    Bv+driftActivation*(BvFault-Bv) else Bv;
  R_effective=if faultMode==FaultMode.ReverseLeakageIncrease then
      R+faultActivation*(RLeakFault-R)
    elseif faultMode==FaultMode.OpenCircuit then R+faultActivation*(ROpen-R)
    elseif faultMode==FaultMode.ShortCircuit then R+faultActivation*(RShort-R)
    else R;
  diodeConductionFactor=if faultMode==FaultMode.OpenCircuit then
    1-faultActivation else 1;

  i_semiconductor=smooth(1,if v>Maxexp*Vt_effective then
      Ids_effective*(exp(Maxexp)*(1+v/Vt_effective-Maxexp)-1)
    elseif (v+Bv_effective)<-Maxexp*(Nbv*Vt_effective) then
      -Ids_effective-Ibv*exp(Maxexp)*(1-(v+Bv_effective)/(Nbv*Vt_effective)-Maxexp)
    else Ids_effective*(exp(v/Vt_effective)-1)-
      Ibv*exp(-(v+Bv_effective)/(Nbv*Vt_effective)));
  i=diodeConductionFactor*i_semiconductor+v/R_effective;
  LossPower=v*i;

  annotation(defaultComponentName="diode",
    Documentation(info="<html><p>用法：将 FaultableZDiode 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Fault modes act independently on the MSL Zener-diode I-V parameters:
transport current, forward scale, breakdown voltage and parallel leakage.
Normal mode and zero severity reproduce MSL 4.0.0.</p>
<p><b>Evidence:</b> NASA reports document radiation-induced forward-voltage and
leakage changes and finite changes of Zener voltage (NTRS 19720010112,
19700022435). Evidence level A for directions and B/C for the lumped mapping.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
      Polygon(points={{30,0},{-30,40},{-30,-40},{30,0}},lineColor={255,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),
      Line(points={{-90,0},{40,0}},color={255,0,0}),
      Line(points={{40,0},{90,0}},color={255,0,0}),
      Line(points={{30,40},{30,-40}},color={255,0,0}),
      Line(points={{30,-40},{20,-40}},color={255,0,0}),
      Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0}),
      Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255})}));
end FaultableZDiode;
