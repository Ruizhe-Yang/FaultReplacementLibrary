within FaultReplacementLibrary.Electrical.Analog.Semiconductors;
model FaultableNPN "Fault-enhanced MSL 4.0.0 Ebers-Moll NPN transistor"
  import SI = Modelica.Units.SI;
  parameter Real Bf=50 "Forward beta";
  parameter Real Br=0.1 "Reverse beta";
  parameter SI.Current Is=1e-16 "Transport saturation current";
  parameter SI.InversePotential Vak=0.02 "Early voltage (inverse)";
  parameter SI.Time Tauf=0.12e-9 "Ideal forward transit time";
  parameter SI.Time Taur=5e-9 "Ideal reverse transit time";
  parameter SI.Capacitance Ccs=1e-12 "Collector-substrate capacitance";
  parameter SI.Capacitance Cje=0.4e-12 "Base-emitter depletion capacitance";
  parameter SI.Capacitance Cjc=0.5e-12 "Base-collector depletion capacitance";
  parameter SI.Voltage Phie=0.8 "Base-emitter diffusion voltage";
  parameter Real Me=0.4 "Base-emitter gradation exponent";
  parameter SI.Voltage Phic=0.8 "Base-collector diffusion voltage";
  parameter Real Mc=0.333 "Base-collector gradation exponent";
  parameter SI.Conductance Gbc=1e-15 "Base-collector conductance";
  parameter SI.Conductance Gbe=1e-15 "Base-emitter conductance";
  parameter Real EMin=-100;
  parameter Real EMax=40;
  parameter Boolean useTemperatureDependency=false
    annotation(Evaluate=true,HideResult=true,choices(checkBox=true));
  parameter SI.Voltage Vt=0.02585 annotation(Dialog(enable=not useTemperatureDependency));
  parameter SI.Temperature Tnom=300.15 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real XTI=3 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real XTB=0 annotation(Dialog(enable=useTemperatureDependency));
  parameter SI.Voltage EG=1.11 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real NF=1.0;
  parameter Real NR=1.0;
  parameter SI.Voltage IC=0 annotation(Dialog(enable=UIC));
  parameter Boolean UIC=false;
  parameter Boolean useSubstrate=false;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(
    useHeatPort=useTemperatureDependency);

  Modelica.Electrical.Analog.Interfaces.Pin C "Collector"
    annotation (Placement(transformation(extent={{90,50},{110,70}}),iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Electrical.Analog.Interfaces.Pin B "Base"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}})));
  Modelica.Electrical.Analog.Interfaces.Pin E "Emitter"
    annotation (Placement(transformation(extent={{90,-50},{110,-70}}),iconTransformation(extent={{90,-50},{110,-70}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin S(final i=iS,final v=vS) if useSubstrate "Substrate"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  type FaultMode=enumeration(
    Normal "Nominal MSL behavior",
    CurrentGainLoss "Compatibility mode reducing forward and reverse current gain",
    ForwardGainLoss "Progressive forward current-gain reduction",
    ReverseGainLoss "Progressive reverse current-gain reduction",
    SaturationCurrentDrift "Progressive transport saturation-current drift",
    JunctionLeakageIncrease "Base-emitter and base-collector leakage growth",
    JunctionDegradation "Depletion-capacitance degradation",
    CollectorEmitterOpen "System-level interruption of collector transport",
    CollectorEmitterShort "Finite collector-emitter shunt");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter Real BfFault(min=Modelica.Constants.small)=0.2*Bf;
  parameter Real BrFault(min=Modelica.Constants.small)=0.2*Br;
  parameter SI.Current IsFault=10*Is;
  parameter SI.Conductance GbcFault=1e3*Gbc;
  parameter SI.Conductance GbeFault=1e3*Gbe;
  parameter SI.Capacitance CjeFault=0.5*Cje;
  parameter SI.Capacitance CjcFault=0.5*Cjc;
  parameter SI.Resistance RCEShort=1e-3;

  SI.Voltage vbc "Base-collector voltage";
  SI.Voltage vbe "Base-emitter voltage";
  SI.Voltage vcs "Collector-substrate voltage";
  Real qbk;
  SI.Current ibc;
  SI.Current ibe;
  SI.Capacitance cbc;
  SI.Capacitance cbe;
  SI.Capacitance Capcje;
  SI.Capacitance Capcjc;
  SI.Current is_t;
  Real br_t;
  Real bf_t;
  SI.Voltage vt_t;
  Real hexp;
  Real htempexp;
  SI.Voltage vS;
  SI.Current iS;
  SI.Current iCEShort "Added fixed-topology collector-emitter shunt current";
  Real faultActivation(min=0,max=1);
  Real driftActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real driftProgress(min=0,max=1);
  Real Bf_effective;
  Real Br_effective;
  SI.Current Is_effective;
  SI.Conductance Gbc_effective;
  SI.Conductance Gbe_effective;
  SI.Capacitance Cje_effective;
  SI.Capacitance Cjc_effective;
  Real collectorTransportFactor(min=0,max=1);

protected
  function powlinLocal "MSL semiconductor depletion-capacitance continuation"
    input Real x;
    input Real y;
    output Real z;
  algorithm
    z:=if x>0 then 1+y*x else (1-x)^(-y);
  end powlinLocal;

  function exlinLocal "Exponentially evaluate and linearly continue above Maxexp"
    input Real x;
    input Real Maxexp;
    output Real z;
  algorithm
    z:=if x>Maxexp then exp(Maxexp)*(1+x-Maxexp) else exp(x);
  end exlinLocal;

  function exlin2Local "Linearly continue the exponential at both bounds"
    input Real x;
    input Real Minexp;
    input Real Maxexp;
    output Real z;
  algorithm
    z:=if x<Minexp then exp(Minexp)*(1+x-Minexp) else exlinLocal(x,Maxexp);
  end exlin2Local;

initial equation
  if UIC then
    vcs=IC;
  end if;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  driftProgress=if time<=faultStartTime then 0 else min(1,max(0,(min(time,faultEndTime)-faultStartTime)/driftTime));
  driftActivation=severity*driftProgress*endActivation;
  Bf_effective=if faultMode==FaultMode.CurrentGainLoss or faultMode==FaultMode.ForwardGainLoss then
    Bf+driftActivation*(BfFault-Bf) else Bf;
  Br_effective=if faultMode==FaultMode.CurrentGainLoss or faultMode==FaultMode.ReverseGainLoss then
    Br+driftActivation*(BrFault-Br) else Br;
  Is_effective=if faultMode==FaultMode.SaturationCurrentDrift then Is+driftActivation*(IsFault-Is) else Is;
  Gbc_effective=if faultMode==FaultMode.JunctionLeakageIncrease then Gbc+faultActivation*(GbcFault-Gbc) else Gbc;
  Gbe_effective=if faultMode==FaultMode.JunctionLeakageIncrease then Gbe+faultActivation*(GbeFault-Gbe) else Gbe;
  Cje_effective=if faultMode==FaultMode.JunctionDegradation then Cje+faultActivation*(CjeFault-Cje) else Cje;
  Cjc_effective=if faultMode==FaultMode.JunctionDegradation then Cjc+faultActivation*(CjcFault-Cjc) else Cjc;
  collectorTransportFactor=if faultMode==FaultMode.CollectorEmitterOpen then 1-faultActivation else 1;
  iCEShort=if faultMode==FaultMode.CollectorEmitterShort then faultActivation*(C.v-E.v)/RCEShort else 0;

  assert(T_heatPort>0,"NPN: temperature must be positive");
  vbc=B.v-C.v;
  vbe=B.v-E.v;
  vcs=C.v-vS;
  qbk=1-vbc*Vak;
  hexp=(T_heatPort/Tnom-1)*EG/vt_t;
  htempexp=smooth(1,exlin2Local(hexp,EMin,EMax));
  is_t=if useTemperatureDependency then Is_effective*(T_heatPort/Tnom)^XTI*htempexp else Is_effective;
  br_t=if useTemperatureDependency then Br_effective*(T_heatPort/Tnom)^XTB else Br_effective;
  bf_t=if useTemperatureDependency then Bf_effective*(T_heatPort/Tnom)^XTB else Bf_effective;
  vt_t=if useTemperatureDependency then (Modelica.Constants.k/Modelica.Constants.q)*T_heatPort else Vt;
  ibc=smooth(1,is_t*(exlin2Local(vbc/(NR*vt_t),EMin,EMax)-1)+vbc*Gbc_effective);
  ibe=smooth(1,is_t*(exlin2Local(vbe/(NF*vt_t),EMin,EMax)-1)+vbe*Gbe_effective);
  Capcjc=smooth(1,Cjc_effective*powlinLocal(vbc/Phic,Mc));
  Capcje=smooth(1,Cje_effective*powlinLocal(vbe/Phie,Me));
  cbc=smooth(1,Taur*is_t/(NR*vt_t)*exlin2Local(vbc/(NR*vt_t),EMin,EMax)+Capcjc);
  cbe=smooth(1,Tauf*is_t/(NF*vt_t)*exlin2Local(vbe/(NF*vt_t),EMin,EMax)+Capcje);
  C.i=collectorTransportFactor*((ibe-ibc)*qbk-ibc/br_t-cbc*der(vbc))-iS+iCEShort;
  B.i=ibe/bf_t+ibc/br_t+cbc*der(vbc)+cbe*der(vbe);
  E.i=-B.i-C.i-iS;
  iS=-Ccs*der(vcs);
  if not useSubstrate then
    vS=0;
  end if;
  LossPower=collectorTransportFactor*(vbc*ibc/br_t+(ibe-ibc)*qbk*(C.v-E.v))+
    vbe*ibe/bf_t+iCEShort*(C.v-E.v);

  annotation(defaultComponentName="npn",
    Documentation(info="<html><p>用法：将 FaultableNPN 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>Independent fault-enhanced copy of the MSL 4.0.0
Ebers-Moll NPN model. Forward and reverse gain loss independently act on
<code>Bf</code>/<code>Br</code>; the legacy combined mode remains for compatibility.
Leakage acts on <code>Gbe/Gbc</code>, saturation-current drift on <code>Is</code>,
and junction degradation on <code>Cje/Cjc</code>. C-E open scales collector
transport while C-E short uses a finite shunt. Normal and zero severity reproduce MSL.</p>
<p><b>Evidence:</b> NASA NTRS 19700022435 reports reduced bipolar current gain and
increased junction leakage after irradiation; NTRS 20210018053 summarizes BJT
gain degradation. Evidence level A for directions, B/C for this lumped mapping.</p></html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
      Line(points={{-20,40},{-20,-40}},color={255,0,0}),Line(points={{-20,0},{-100,0}},color={0,0,255}),
      Line(points={{91,60},{30,60}},color={0,0,255}),Line(points={{30,60},{-20,10}},color={255,0,0}),
      Line(points={{-20,-10},{30,-60}},color={255,0,0}),Line(points={{30,-60},{91,-60}},color={0,0,255}),
      Polygon(points={{30,-60},{24,-46},{16,-54},{30,-60}},fillColor={255,0,0},fillPattern=FillPattern.Solid,lineColor={255,0,0}),
      Text(extent={{-150,130},{150,90}},textString="%name",textColor={0,0,255}),
      Line(points={{0,0},{90,0}},color={0,0,255},pattern=LinePattern.Dash,visible=useSubstrate),
      Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableNPN;
