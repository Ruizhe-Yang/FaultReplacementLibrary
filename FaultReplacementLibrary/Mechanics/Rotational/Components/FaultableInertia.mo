within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableInertia "1D-rotational component with inertia"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
  parameter Modelica.Units.SI.Inertia J(min=0, start=1) "Moment of inertia";
  parameter StateSelect stateSelect=StateSelect.default
    "Priority to use phi and w as states"
    annotation (HideResult=true, Dialog(tab="Advanced"));
  Modelica.Units.SI.Angle phi(stateSelect=stateSelect)
    "Absolute rotation angle of component"
    annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.AngularVelocity w(stateSelect=stateSelect)
    "Absolute angular velocity of component (= der(phi))"
    annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.AngularAcceleration a
    "Absolute angular acceleration of component (= der(w))"
    annotation (Dialog(group="Initialization", showStartAttribute=true));

  type FaultMode=enumeration(Normal "正常", InertiaDrift "转动惯量漂移", InertiaLoss "惯量下降", RotorLock "转子卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Inertia JFault=0.5*J;
  parameter Modelica.Units.SI.RotationalDampingConstant lockDamping=1e9;
  Modelica.Units.SI.Inertia J_effective;
  Modelica.Units.SI.Torque lockTorque;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  phi = flange_a.phi;
  phi = flange_b.phi;
  w = der(phi);
  a = der(w);
  J_effective=if faultMode==FaultMode.InertiaDrift or faultMode==FaultMode.InertiaLoss then J+faultActivation*(JFault-J) else J;
  lockTorque=if faultMode==FaultMode.RotorLock then faultActivation*lockDamping*w else 0;
  J_effective*a+lockTorque=flange_a.tau+flange_b.tau;
  annotation (Documentation(info="<html><p>用法：将 FaultableInertia 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
Rotational component with <strong>inertia</strong> and two rigidly connected flanges.
</p>
</html>"),
       Icon(
  coordinateSystem(preserveAspectRatio=true,
    extent={{-100.0,-100.0},{100.0,100.0}}),
  graphics={
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-100.0,-10.0},{-50.0,10.0}}),
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{50.0,-10.0},{100.0,10.0}}),
    Line(points={{-80.0,-25.0},{-60.0,-25.0}}),
    Line(points={{60.0,-25.0},{80.0,-25.0}}),
    Line(points={{-70.0,-25.0},{-70.0,-70.0}}),
    Line(points={{70.0,-25.0},{70.0,-70.0}}),
    Line(points={{-80.0,25.0},{-60.0,25.0}}),
    Line(points={{60.0,25.0},{80.0,25.0}}),
    Line(points={{-70.0,45.0},{-70.0,25.0}}),
    Line(points={{70.0,45.0},{70.0,25.0}}),
    Line(points={{-70.0,-70.0},{70.0,-70.0}}),
    Rectangle(lineColor={64,64,64},
      fillColor={255,255,255},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-50.0,-50.0},{50.0,50.0}},
      radius=10.0),
    Text(textColor={0,0,255},
      extent={{-150.0,60.0},{150.0,100.0}},
      textString="%name"),
    Text(extent={{-150.0,-120.0},{150.0,-80.0}},
      textString="J=%J"),
    Rectangle(
      lineColor = {64,64,64},
      fillColor = {255,255,255},
      extent = {{-50,-50},{50,50}},
      radius = 10),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableInertia;

