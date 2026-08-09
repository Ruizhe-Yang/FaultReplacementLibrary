within FaultReplacementLibrary.Magnetic.FluxTubes.Sensors;
model FaultableMagneticFluxSensor "Fault-enhanced MSL 4.0.0 MagneticFluxSensor"
  extends Modelica.Magnetic.FluxTubes.Interfaces.TwoPortElementary;
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput Phi(final quantity="MagneticFlux",final unit="Wb") annotation(Placement(transformation(origin={0,-110},extent={{10,-10},{-10,10}},rotation=90)));
  type FaultMode=enumeration(Normal, Bias, GainError, NoiseIncrease, Stuck, Dropout, Saturation);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.MagneticFlux biasFault=1e-6;
  parameter Real gainFault=0.5;
  parameter Modelica.Units.SI.MagneticFlux stuckValue=0;
  parameter Modelica.Units.SI.MagneticFlux saturationLimit=1;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1);
  Modelica.Units.SI.MagneticFlux Phi_raw,Phi_faulted;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  port_p.V_m=port_n.V_m;
  Phi_raw=port_p.Phi;
  0=port_p.Phi+port_n.Phi;
  Phi_faulted=if faultMode==FaultMode.Bias then Phi_raw+faultActivation*biasFault elseif faultMode==FaultMode.GainError then Phi_raw*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then Phi_raw+faultActivation*biasFault*sin(997*time) elseif faultMode==FaultMode.Stuck then Phi_raw+faultActivation*(stuckValue-Phi_raw) elseif faultMode==FaultMode.Dropout then (1-faultActivation)*Phi_raw elseif faultMode==FaultMode.Saturation then min(saturationLimit,max(-saturationLimit,Phi_raw)) else Phi_raw;
  Phi=Phi_faulted;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableMagneticFluxSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="magFluxSensor",Icon(graphics={Line(points={{-60,0},{60,0}},color={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableMagneticFluxSensor;
