within FaultReplacementLibrary.Electrical.Analog.Semiconductors;
model FaultableDiode "Fault-enhanced MSL 4.0.0 PN diode"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter SI.Current Ids=1e-6 "Saturation current";
  parameter Boolean useTemperatureDependency=false
    annotation(Evaluate=true,HideResult=true,choices(checkBox=true));
  parameter SI.Voltage Vt(min=Modelica.Constants.small)=0.04
    annotation(Dialog(enable=not useTemperatureDependency));
  parameter Real Maxexp(final min=Modelica.Constants.small)=15;
  parameter SI.Resistance R=1e8 "Parallel ohmic resistance";
  parameter Real EG=1.11 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real N=1 annotation(Dialog(enable=useTemperatureDependency));
  parameter SI.Temperature TNOM=300.15 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real XTI=3 annotation(Dialog(enable=useTemperatureDependency));
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(
    useHeatPort=useTemperatureDependency);

  type FaultMode=enumeration(
    Normal "Nominal MSL behavior",
    SaturationCurrentDrift "Progressive transport saturation-current drift",
    ForwardVoltageDrift "Progressive forward I-V voltage-scale drift",
    ReverseLeakageIncrease "Parallel reverse-leakage increase",
    OpenCircuit "Suppress junction conduction and retain a finite high resistance",
    ShortCircuit "Finite low-resistance shunt");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter SI.Current IdsFault=10*Ids "Saturation current at completed drift";
  parameter SI.Voltage VtFault=1.5*Vt "Voltage scale at completed drift";
  parameter SI.Resistance RLeakFault=R/100 "Parallel resistance after leakage growth";
  parameter SI.Resistance ROpen=1e12 "Finite open resistance";
  parameter SI.Resistance RShort=1e-6 "Finite short resistance";

  SI.Voltage vt_t;
  SI.Voltage junctionVoltageScale;
  SI.Current id;
  SI.Current Ids_effective;
  SI.Voltage Vt_effective;
  SI.Resistance R_effective;
  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  Real diodeConductionFactor(min=0,max=1);
protected
  SI.Temperature htemp;
  Real aux;
  Real auxp;
  function exlinLocal
    input Real x;
    input Real Maxexp;
    output Real y;
  algorithm
    y:=if x>Maxexp then exp(Maxexp)*(1+x-Maxexp) else exp(x);
  end exlinLocal;
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
  R_effective=if faultMode==FaultMode.ReverseLeakageIncrease then
      R+faultActivation*(RLeakFault-R)
    elseif faultMode==FaultMode.OpenCircuit then R+faultActivation*(ROpen-R)
    elseif faultMode==FaultMode.ShortCircuit then R+faultActivation*(RShort-R)
    else R;
  diodeConductionFactor=if faultMode==FaultMode.OpenCircuit then
    1-faultActivation else 1;

  assert(T_heatPort>0,"Diode: temperature must be positive");
  htemp=T_heatPort;
  vt_t=Modelica.Constants.k*htemp/Modelica.Constants.q;
  junctionVoltageScale=if useTemperatureDependency then
    N*vt_t*(Vt_effective/Vt) else Vt_effective;
  id=Ids_effective*(exlinLocal(v/junctionVoltageScale,Maxexp)-1);
  if useTemperatureDependency then
    i=diodeConductionFactor*id*(htemp/TNOM)^(XTI/N)*auxp+v/R_effective;
  else
    i=smooth(1,diodeConductionFactor*id+v/R_effective);
  end if;
  aux=(htemp/TNOM-1)*EG/(N*vt_t);
  auxp=exp(aux);
  LossPower=i*v;

  annotation(defaultComponentName="diode",
    Documentation(info="<html><p>用法：将 FaultableDiode 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Copies the MSL 4.0.0 diode constitutive equation and exposes separate effective
parameters for saturation-current drift, forward voltage-scale drift and reverse
leakage. Open and short circuits use finite conductances without changing topology.
Normal mode and zero severity reproduce the original equations.</p>
<p><b>Evidence:</b> NASA radiation reports observe increased diode forward voltage
and reverse leakage (NTRS 19720010112, 19700022435, 20210018053). Evidence level A
for parameter direction and B/C for this lumped equation mapping.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
      Polygon(points={{30,0},{-30,40},{-30,-40},{30,0}},lineColor={255,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),
      Line(points={{-90,0},{40,0}},color={255,0,0}),
      Line(points={{40,0},{90,0}},color={255,0,0}),
      Line(points={{30,40},{30,-40}},color={255,0,0}),
      Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0}),
      Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255})}));
end FaultableDiode;
