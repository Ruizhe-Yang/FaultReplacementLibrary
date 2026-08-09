within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableVariablePermeance "Fault-enhanced MSL 4.0.0 VariablePermeance"
  extends Modelica.Magnetic.FluxTubes.Interfaces.TwoPort;
  extends Modelica.Magnetic.FluxTubes.Icons.Reluctance;
  Modelica.Blocks.Interfaces.RealInput G_m(quantity="Permeance",unit="H") "Magnetic permeance" annotation(Placement(transformation(extent={{-20,-20},{20,20}},rotation=270,origin={0,100})));
  type FaultMode=enumeration(Normal, InputDrift, GainError, Stuck, MagneticOpen, MagneticShort);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.Permeance G_mStuck=1;
  parameter Modelica.Units.SI.Permeance G_mOpen=1e-12;
  parameter Modelica.Units.SI.Permeance G_mShort=1e12;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1);
  Modelica.Units.SI.Permeance G_m_effective;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  G_m_effective=if faultMode==FaultMode.InputDrift then G_m*(1+faultActivation) elseif faultMode==FaultMode.GainError then G_m*(1-faultActivation) elseif faultMode==FaultMode.Stuck then G_m+faultActivation*(G_mStuck-G_m) elseif faultMode==FaultMode.MagneticOpen then G_m+faultActivation*(G_mOpen-G_m) elseif faultMode==FaultMode.MagneticShort then G_m+faultActivation*(G_mShort-G_m) else G_m;
  G_m_effective*V_m=Phi;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableVariablePermeance 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="permeance",Icon(graphics={Line(points={{-70,0},{70,0}},color={255,0,0},thickness=1),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableVariablePermeance;
