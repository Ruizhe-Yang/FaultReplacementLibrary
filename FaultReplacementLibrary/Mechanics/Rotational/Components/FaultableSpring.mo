within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableSpring "Linear 1D rotational spring"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialCompliant;
  parameter Modelica.Units.SI.RotationalSpringConstant c(final min=0, start=1.0e5)
    "Spring constant";
  parameter Modelica.Units.SI.Angle phi_rel0=0 "Unstretched spring angle";

  type FaultMode=enumeration(Normal "正常", StiffnessDegradation "刚度下降", StiffnessIncrease "刚度增加", Broken "断裂", PreloadShift "预紧位置漂移", Sticking "卡滞");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.RotationalSpringConstant cDegraded=0.5*c;
  parameter Modelica.Units.SI.RotationalSpringConstant cIncreased=2*c;
  parameter Modelica.Units.SI.Angle phiRel0Fault=phi_rel0+0.1;
  parameter Modelica.Units.SI.RotationalSpringConstant cStick=1e9;
  Modelica.Units.SI.RotationalSpringConstant c_effective;
  Modelica.Units.SI.Angle phi_rel0_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  c_effective=if faultMode==FaultMode.StiffnessDegradation then c+faultActivation*(cDegraded-c)
    elseif faultMode==FaultMode.StiffnessIncrease then c+faultActivation*(cIncreased-c)
    elseif faultMode==FaultMode.Broken then c*(1-faultActivation)
    elseif faultMode==FaultMode.Sticking then c+faultActivation*(cStick-c) else c;
  phi_rel0_effective=if faultMode==FaultMode.PreloadShift then phi_rel0+faultActivation*(phiRel0Fault-phi_rel0) else phi_rel0;
  tau=c_effective*(phi_rel-phi_rel0_effective);
  annotation (
    Documentation(info="<html><p>用法：将 FaultableSpring 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A <strong>linear 1D rotational spring</strong>. The component can be connected either
between two inertias/gears to describe the shaft elasticity, or between
a inertia/gear and the housing (component Fixed), to describe
a coupling of the element with the housing via a spring.
</p>

</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
    Text(extent={{-150,80},{150,40}},
      textString="%name",
      textColor={0,0,255}),
    Text(extent={{-150,-40},{150,-80}},
      textString="c=%c"),
    Line(points={{-100,0},{-58,0},{-43,-30},{-13,30},{17,-30},{47,30},{62,0},{100,0}}, color={255,0,0}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableSpring;
