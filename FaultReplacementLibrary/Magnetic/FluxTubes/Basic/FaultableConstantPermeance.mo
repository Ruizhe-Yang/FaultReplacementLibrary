within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableConstantPermeance "Fault-enhanced MSL 4.0.0 ConstantPermeance"
  extends Modelica.Magnetic.FluxTubes.Interfaces.TwoPort;
  extends Modelica.Magnetic.FluxTubes.Icons.Reluctance;
  type FaultMode=enumeration(Normal, PermeanceDrift, PermeanceLoss, CoreCrack, MagneticOpen, MagneticShort);
  parameter Modelica.Units.SI.Permeance G_m=1 "Magnetic permeance";
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.Permeance G_mFault=0.5*G_m;
  parameter Modelica.Units.SI.Permeance G_mOpen=1e-12;
  parameter Modelica.Units.SI.Permeance G_mShort=1e12;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Modelica.Units.SI.Permeance G_m_effective;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  G_m_effective=if faultMode==FaultMode.PermeanceDrift or faultMode==FaultMode.PermeanceLoss or faultMode==FaultMode.CoreCrack then G_m+faultActivation*(G_mFault-G_m) elseif faultMode==FaultMode.MagneticOpen then G_m+faultActivation*(G_mOpen-G_m) elseif faultMode==FaultMode.MagneticShort then G_m+faultActivation*(G_mShort-G_m) else G_m;
  G_m_effective*V_m=Phi;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableConstantPermeance 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="permeance",Icon(graphics={Line(points={{-70,0},{70,0}},color={255,0,0},thickness=1),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableConstantPermeance;
