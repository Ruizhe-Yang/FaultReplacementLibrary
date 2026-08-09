within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableEddyCurrent "Fault-enhanced MSL 4.0.0 EddyCurrent"
  extends Modelica.Magnetic.FluxTubes.Interfaces.TwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=293.15);
  type FaultMode=enumeration(Normal, ConductanceDrift, LossIncrease, LossDecrease, EddyPathOpen, EddyPathShort);
  parameter Boolean useConductance=false annotation(Evaluate=true,HideResult=true,choices(checkBox=true));
  parameter Modelica.Units.SI.Conductance G(min=0)=1/0.098e-6;
  parameter Modelica.Units.SI.Resistivity rho=0.098e-6;
  parameter Modelica.Units.SI.Length l=1;
  parameter Modelica.Units.SI.Area A=1;
  final parameter Modelica.Units.SI.Resistance R=rho*l/A;
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real conductanceFaultFactor(min=Modelica.Constants.eps)=2;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1);
  Modelica.Units.SI.Conductance G_effective;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  G_effective=(if useConductance then G else 1/R)*(if faultMode==FaultMode.ConductanceDrift or faultMode==FaultMode.LossIncrease or faultMode==FaultMode.EddyPathShort then 1+faultActivation*(conductanceFaultFactor-1) elseif faultMode==FaultMode.LossDecrease or faultMode==FaultMode.EddyPathOpen then 1-faultActivation*(1-1/conductanceFaultFactor) else 1);
  LossPower=V_m*der(Phi);
  V_m=G_effective*der(Phi);
  annotation(
    Documentation(info="<html><p>用法：将 FaultableEddyCurrent 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="eddyCurrent",Icon(graphics={Rectangle(extent={{-70,40},{70,-40}},lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableEddyCurrent;
