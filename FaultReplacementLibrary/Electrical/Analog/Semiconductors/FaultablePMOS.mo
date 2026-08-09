within FaultReplacementLibrary.Electrical.Analog.Semiconductors;
model FaultablePMOS "Fault-enhanced MSL 4.0.0 PMOS"
  import SI = Modelica.Units.SI;
  Modelica.Electrical.Analog.Interfaces.Pin D "Drain"
    annotation (Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Electrical.Analog.Interfaces.Pin G "Gate"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-70}}), iconTransformation(extent={{-90,-50},{-110,-70}})));
  Modelica.Electrical.Analog.Interfaces.Pin S "Source"
    annotation (Placement(transformation(extent={{90,-50},{110,-70}}), iconTransformation(extent={{90,-50},{110,-70}})));
  Modelica.Electrical.Analog.Interfaces.Pin B "Bulk"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  parameter SI.Length W=20e-6;
  parameter SI.Length L=6e-6;
  parameter SI.Transconductance Beta=0.0105e-3;
  parameter SI.Voltage Vt=-1.0;
  parameter Real K2=0.41;
  parameter Real K5=0.839;
  parameter SI.Length dW=-2.5e-6;
  parameter SI.Length dL=-2.1e-6;
  parameter SI.Resistance RDS=1e7;
  parameter Boolean useTemperatureDependency=false annotation(Evaluate=true,HideResult=true,choices(checkBox=true));
  parameter SI.Temperature Tnom=300.15 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real kvt=-2.9e-3 annotation(Dialog(enable=useTemperatureDependency));
  parameter Real kk2=6.2e-4 annotation(Dialog(enable=useTemperatureDependency));
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(useHeatPort=useTemperatureDependency);

  type FaultMode=enumeration(
    Normal "Nominal MSL behavior",
    ThresholdVoltageDrift "Progressive threshold-voltage shift",
    TransconductanceLoss "Progressive channel transconductance loss",
    DrainSourceLeakage "Off-state drain-source leakage increase",
    OnResistanceIncrease "On-state channel conduction degradation",
    OpenCircuit "Channel interruption with finite residual leakage",
    ShortCircuit "Finite drain-source short circuit",
    StuckOn "Gate-independent forced channel conduction",
    StuckOff "Gate/channel conduction suppressed with nominal leakage retained");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter SI.Time faultStartTime=0;
  parameter SI.Time faultEndTime=Modelica.Constants.inf;
  parameter SI.Time transitionTime(min=0)=0;
  parameter SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter SI.Voltage VtFault=Vt-0.5;
  parameter SI.Transconductance BetaFault=0.5*Beta;
  parameter SI.Resistance RDSLeakFault=1e4;
  parameter SI.Resistance ROpen=1e12;
  parameter SI.Resistance RShort=1e-3;
  parameter Real onResistanceFactor(min=1)=5;
  parameter SI.Voltage stuckOnOverdrive=-5;
  Real faultActivation(min=0,max=1),driftActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),driftProgress(min=0,max=1);
  SI.Transconductance Beta_effective;
  SI.Voltage Vt_effective;
  SI.Resistance RDS_effective;
protected
  Real v,uds,ubs,ugst,ugst_nominal,ud,us,id,id_channel,gds,beta_t,vt_t,k2_t;
  Real channelFactor(min=0,max=1);
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  driftProgress=if time<=faultStartTime then 0 else min(1,max(0,(min(time,faultEndTime)-faultStartTime)/driftTime));
  driftActivation=severity*driftProgress*endActivation;
  Beta_effective=if faultMode==FaultMode.TransconductanceLoss then Beta+driftActivation*(BetaFault-Beta) else Beta;
  Vt_effective=if faultMode==FaultMode.ThresholdVoltageDrift then Vt+driftActivation*(VtFault-Vt) else Vt;
  RDS_effective=if faultMode==FaultMode.DrainSourceLeakage then RDS+faultActivation*(RDSLeakFault-RDS)
    elseif faultMode==FaultMode.OpenCircuit then RDS+faultActivation*(ROpen-RDS)
    elseif faultMode==FaultMode.ShortCircuit then RDS+faultActivation*(RShort-RDS) else RDS;
  channelFactor=if faultMode==FaultMode.OpenCircuit or faultMode==FaultMode.StuckOff then
      1-faultActivation
    elseif faultMode==FaultMode.OnResistanceIncrease then
      1/(1+faultActivation*(onResistanceFactor-1)) else 1;
  assert(L+dL>0,"PMOS: effective length must be positive");
  assert(W+dW>0,"PMOS: effective width must be positive");
  assert(T_heatPort>0,"PMOS: temperature must be positive");
  gds=if (RDS_effective<1e-20 and RDS_effective>-1e-20) then 1e20 else 1/RDS_effective;
  v=beta_t*(W+dW)/(L+dL);
  ud=smooth(0,if D.v>S.v then S.v else D.v);
  us=smooth(0,if D.v>S.v then D.v else S.v);
  uds=ud-us;
  ubs=smooth(0,if B.v<us then 0 else B.v-us);
  ugst_nominal=(G.v-us-vt_t+k2_t*ubs)*K5;
  ugst=if faultMode==FaultMode.StuckOn then
    ugst_nominal+faultActivation*(stuckOnOverdrive-ugst_nominal) else ugst_nominal;
  id_channel=smooth(0,if ugst>=0 then 0 elseif ugst<uds then -v*uds*(ugst-uds/2) else -v*ugst*ugst/2);
  id=channelFactor*id_channel+uds*gds;
  beta_t=if useTemperatureDependency then Beta_effective*(T_heatPort/Tnom)^(-1.5) else Beta_effective;
  vt_t=if useTemperatureDependency then Vt_effective*(1+(T_heatPort-Tnom)*kvt) else Vt_effective;
  k2_t=if useTemperatureDependency then K2*(1+(T_heatPort-Tnom)*kk2) else K2;
  G.i=0;
  D.i=smooth(0,if D.v>S.v then -id else id);
  S.i=smooth(0,if D.v>S.v then id else -id);
  B.i=0;
  LossPower=D.i*(D.v-S.v);
  annotation(defaultComponentName="pMOS",
    Documentation(info="<html><p>用法：将 FaultablePMOS 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>Independent MSL 4.0.0 PMOS equation copy with
threshold, transconductance and leakage effective parameters. On-state resistance
growth attenuates channel conduction rather than misusing the off-state parallel
<code>RDS</code>; StuckOn/StuckOff act on effective gate/channel conduction.
Normal or zero severity is nominal. Evidence and limitations match FaultableNMOS; threshold
direction is intentionally parameterized because radiation response depends on
polarity and process.</p></html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={
      Line(points={{-90,-60},{-10,-60}},color={0,0,255}),Line(points={{-10,-60},{-10,60}},color={255,0,0}),
      Line(points={{10,80},{10,39}},color={255,0,0}),Line(points={{10,20},{10,-21}},color={255,0,0}),Line(points={{10,-40},{10,-81}},color={255,0,0}),
      Line(points={{10,60},{91,60}},color={0,0,255}),Line(points={{10,0},{90,0}},color={0,0,255}),Line(points={{10,-60},{90,-60}},color={0,0,255}),
      Polygon(points={{60,0},{40,5},{40,-5},{60,0}},fillColor={255,0,0},fillPattern=FillPattern.Solid,lineColor={255,0,0}),
      Text(extent={{-150,130},{150,90}},textString="%name",textColor={0,0,255}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultablePMOS;
