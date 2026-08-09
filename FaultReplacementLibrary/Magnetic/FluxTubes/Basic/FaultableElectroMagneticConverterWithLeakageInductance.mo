within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableElectroMagneticConverterWithLeakageInductance "Fault-enhanced converter with leakage inductance"
  Modelica.Magnetic.FluxTubes.Interfaces.PositiveMagneticPort port_p "Positive magnetic port" annotation(Placement(transformation(extent={{90,90},{110,110}}),iconTransformation(extent={{90,90},{110,110}})));
  Modelica.Magnetic.FluxTubes.Interfaces.NegativeMagneticPort port_n "Negative magnetic port" annotation(Placement(transformation(extent={{110,-110},{90,-90}}),iconTransformation(extent={{110,-110},{90,-90}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive electrical pin" annotation(Placement(transformation(extent={{-90,90},{-110,110}}),iconTransformation(extent={{-90,90},{-110,110}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative electrical pin" annotation(Placement(transformation(extent={{-110,-108},{-90,-88}}),iconTransformation(extent={{-110,-108},{-90,-88}})));
  Modelica.Units.SI.Voltage v;
  Modelica.Units.SI.Current i(start=0,stateSelect=StateSelect.prefer);
  Modelica.Units.SI.MagneticPotentialDifference V_m;
  Modelica.Units.SI.MagneticFlux Phi(stateSelect=StateSelect.never);
  Modelica.Units.SI.MagneticFlux Phi_ind(stateSelect=StateSelect.never);
  Modelica.Units.SI.MagneticFlux Phi_leak(stateSelect=StateSelect.never);
  parameter Real N(start=1,min=Modelica.Constants.eps)=1 "Number of turns";
  parameter Modelica.Units.SI.Length L=10e-3;
  parameter Modelica.Units.SI.Area A=10e-6;
  parameter Modelica.Units.SI.RelativePermeability mu_rel(min=Modelica.Constants.eps)=1;
  final parameter Modelica.Units.SI.Permeance G_m=Modelica.Constants.mu_0*mu_rel*A/L;
  Modelica.Units.SI.MagneticFlux Psi;
  Modelica.Units.SI.Inductance L_stat;
  type FaultMode=enumeration(Normal, TurnLoss, WindingOpen, ShortedTurns, LeakageIncrease, LeakageDecrease);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real NFault(min=Modelica.Constants.eps)=0.5*N;
  parameter Real leakageFaultFactor(min=Modelica.Constants.eps)=2;
  parameter Modelica.Units.SI.Resistance ROpen=1e9;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),N_effective(min=Modelica.Constants.eps);
  Modelica.Units.SI.Permeance G_m_effective;
  Modelica.Units.SI.Resistance R_series_effective;
protected
  constant Real eps=100*Modelica.Constants.eps;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  N_effective=if faultMode==FaultMode.TurnLoss or faultMode==FaultMode.ShortedTurns then N+faultActivation*(NFault-N) else N;
  G_m_effective=G_m*(if faultMode==FaultMode.LeakageIncrease then 1+faultActivation*(leakageFaultFactor-1) elseif faultMode==FaultMode.LeakageDecrease then 1-faultActivation*(1-1/leakageFaultFactor) else 1);
  R_series_effective=if faultMode==FaultMode.WindingOpen then faultActivation*ROpen else 0;
  v=p.v-n.v;
  0=p.i+n.i;
  i=p.i;
  V_m=port_p.V_m-port_n.V_m;
  0=port_p.Phi+port_n.Phi;
  Phi=port_p.Phi;
  V_m=i*N_effective;
  N_effective*der(Phi_ind)=-(v-i*R_series_effective);
  Phi_leak=G_m_effective*V_m;
  Phi=Phi_ind+Phi_leak;
  Psi=N_effective*Phi_ind;
  L_stat=noEvent(if abs(i)>eps then abs(Psi/i) else abs(Psi/eps));
  annotation(
    Documentation(info="<html><p>用法：将 FaultableElectroMagneticConverterWithLeakageInductance 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="converter",Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-70,80},{70,-80}},lineColor={255,0,0}),Line(points={{-70,60},{70,60}},color={255,0,0}),Line(points={{-70,-60},{70,-60}},color={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0}),Text(extent={{-150,150},{150,110}},textString="%name",textColor={0,0,255})}));
end FaultableElectroMagneticConverterWithLeakageInductance;
