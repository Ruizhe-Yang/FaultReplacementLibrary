within FaultReplacementLibrary.Magnetic.FluxTubes.Basic;
model FaultableLeakageWithCoefficient "Fault-enhanced MSL 4.0.0 LeakageWithCoefficient"
  extends Modelica.Magnetic.FluxTubes.BaseClasses.Leakage;
  parameter Modelica.Units.SI.CouplingCoefficient c_usefulFlux(final min=Modelica.Constants.eps,final max=1-Modelica.Constants.eps,start=0.7);
  Modelica.Blocks.Interfaces.RealInput R_mUsefulTot(quantity="Reluctance",unit="H-1") annotation(Placement(transformation(extent={{-20,-20},{20,20}},rotation=270,origin={0,120})));
  type FaultMode=enumeration(Normal, CouplingDrift, LeakageIncrease, LeakageDecrease, LeakagePathOpen);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.CouplingCoefficient cFault(min=Modelica.Constants.eps,max=1-Modelica.Constants.eps)=0.4;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1);
  Modelica.Units.SI.CouplingCoefficient c_effective;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  c_effective=if faultMode==FaultMode.CouplingDrift or faultMode==FaultMode.LeakageIncrease then c_usefulFlux+faultActivation*(cFault-c_usefulFlux) elseif faultMode==FaultMode.LeakageDecrease or faultMode==FaultMode.LeakagePathOpen then c_usefulFlux+faultActivation*((1-Modelica.Constants.eps)-c_usefulFlux) else c_usefulFlux;
  (1-c_effective)*R_m=c_effective*R_mUsefulTot;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableLeakageWithCoefficient 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="leakage",Icon(graphics={Line(points={{-60,60},{60,-60}},color={255,0,0},thickness=1),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableLeakageWithCoefficient;
