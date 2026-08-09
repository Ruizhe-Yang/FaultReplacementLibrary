within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableElectroMagneticConverter "Fault-enhanced MSL 4.0.0 ElectroMagneticConverter"
  Modelica.Magnetic.FluxTubes.Interfaces.PositiveMagneticPort port_p "Positive magnetic port" annotation(Placement(transformation(extent={{90,90},{110,110}}),iconTransformation(extent={{90,90},{110,110}})));
  Modelica.Magnetic.FluxTubes.Interfaces.NegativeMagneticPort port_n "Negative magnetic port" annotation(Placement(transformation(extent={{110,-110},{90,-90}}),iconTransformation(extent={{110,-110},{90,-90}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p "Positive electrical pin" annotation(Placement(transformation(extent={{-90,90},{-110,110}}),iconTransformation(extent={{-90,90},{-110,110}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative electrical pin" annotation(Placement(transformation(extent={{-110,-110},{-90,-90}}),iconTransformation(extent={{-110,-110},{-90,-90}})));
  Modelica.Units.SI.Voltage v;
  Modelica.Units.SI.Current i(start=0,stateSelect=StateSelect.prefer);
  Modelica.Units.SI.MagneticPotentialDifference V_m;
  Modelica.Units.SI.MagneticFlux Phi;
  parameter Real N=1 "Number of turns";
  Modelica.Units.SI.MagneticFlux Psi;
  Modelica.Units.SI.Inductance L_stat;
  type FaultMode=enumeration(Normal, TurnCountDrift, TurnLoss, WindingOpen, ShortedTurns, CouplingLoss);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real NFault(min=Modelica.Constants.eps)=0.5*N;
  parameter Modelica.Units.SI.Resistance ROpen=1e9;
  parameter Modelica.Units.SI.Resistance RShortedTurns=1e-6;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),N_effective(min=Modelica.Constants.eps);
  Modelica.Units.SI.Resistance R_series_effective;
protected
  constant Real eps=100*Modelica.Constants.eps;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  N_effective=if faultMode==FaultMode.TurnCountDrift or faultMode==FaultMode.TurnLoss or faultMode==FaultMode.ShortedTurns or faultMode==FaultMode.CouplingLoss then N+faultActivation*(NFault-N) else N;
  R_series_effective=if faultMode==FaultMode.WindingOpen then faultActivation*ROpen elseif faultMode==FaultMode.ShortedTurns then faultActivation*RShortedTurns else 0;
  v=p.v-n.v;
  0=p.i+n.i;
  i=p.i;
  V_m=port_p.V_m-port_n.V_m;
  0=port_p.Phi+port_n.Phi;
  Phi=port_p.Phi;
  V_m=i*N_effective;
  N_effective*der(Phi)=-(v-i*R_series_effective);
  Psi=N_effective*Phi;
  L_stat=noEvent(if abs(i)>eps then abs(Psi/i) else abs(Psi/eps));
  annotation(
    Documentation(info="<html><p>用法：将 FaultableElectroMagneticConverter 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="converter",Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-70,80},{70,-80}},lineColor={255,0,0}),Line(points={{-70,60},{70,60}},color={255,0,0}),Line(points={{-70,-60},{70,-60}},color={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0}),Text(extent={{-150,150},{150,110}},textString="%name",textColor={0,0,255})}));
end FaultableElectroMagneticConverter;
