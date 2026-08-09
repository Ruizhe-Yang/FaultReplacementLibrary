within FaultReplacementLibrary.Magnetic.FluxTubes.Sensors;
model FaultableMagneticPotentialDifferenceSensor "Fault-enhanced MSL 4.0.0 MagneticPotentialDifferenceSensor"
  extends Modelica.Icons.RoundSensor;
  extends Modelica.Magnetic.FluxTubes.Interfaces.TwoPortElementary;
  Modelica.Blocks.Interfaces.RealOutput V_m(final quantity="MagneticPotentialDifference",final unit="A") annotation(Placement(transformation(origin={0,-110},extent={{10,-10},{-10,10}},rotation=90)));
  type FaultMode=enumeration(Normal, Bias, GainError, NoiseIncrease, Stuck, Dropout, Saturation);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.MagneticPotentialDifference biasFault=1;
  parameter Real gainFault=0.5;
  parameter Modelica.Units.SI.MagneticPotentialDifference stuckValue=0;
  parameter Modelica.Units.SI.MagneticPotentialDifference saturationLimit=1e6;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1);
  Modelica.Units.SI.MagneticPotentialDifference V_m_raw,V_m_faulted;
  Modelica.Units.SI.MagneticFlux Phi "Magnetic flux from port_p to port_n";
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  V_m_raw=port_p.V_m-port_n.V_m;
  Phi=port_p.Phi;
  Phi=0;
  0=port_p.Phi+port_n.Phi;
  V_m_faulted=if faultMode==FaultMode.Bias then V_m_raw+faultActivation*biasFault elseif faultMode==FaultMode.GainError then V_m_raw*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then V_m_raw+faultActivation*biasFault*sin(997*time) elseif faultMode==FaultMode.Stuck then V_m_raw+faultActivation*(stuckValue-V_m_raw) elseif faultMode==FaultMode.Dropout then (1-faultActivation)*V_m_raw elseif faultMode==FaultMode.Saturation then min(saturationLimit,max(-saturationLimit,V_m_raw)) else V_m_raw;
  V_m=V_m_faulted;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableMagneticPotentialDifferenceSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="magVoltageSensor",Icon(graphics={Line(points={{-60,0},{60,0}},color={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableMagneticPotentialDifferenceSensor;
