within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableSpringDamper "Linear 1D rotational spring and damper in parallel"
  parameter Modelica.Units.SI.RotationalSpringConstant c(final min=0, start=1.0e5)
    "Spring constant";
  parameter Modelica.Units.SI.RotationalDampingConstant d(final min=0, start=0)
    "Damping constant";
  parameter Modelica.Units.SI.Angle phi_rel0=0 "Unstretched spring angle";
  extends
    Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates;
  extends
    Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;
  type FaultMode=enumeration(Normal "正常", StiffnessLoss "刚度下降", DampingLoss "阻尼下降", DampingIncrease "阻尼增加", Broken "断裂", Seizure "卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.RotationalSpringConstant cFault=0.5*c;
  parameter Modelica.Units.SI.RotationalDampingConstant dFault=0.5*d;
  parameter Modelica.Units.SI.RotationalDampingConstant dSeized=1e9;
  Modelica.Units.SI.RotationalSpringConstant c_effective;
  Modelica.Units.SI.RotationalDampingConstant d_effective;
protected
  Modelica.Units.SI.Torque tau_c "Spring torque";
  Modelica.Units.SI.Torque tau_d "Damping torque";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  c_effective=if faultMode==FaultMode.StiffnessLoss then c+faultActivation*(cFault-c)
    elseif faultMode==FaultMode.Broken then c*(1-faultActivation) else c;
  d_effective=if faultMode==FaultMode.DampingLoss or faultMode==FaultMode.DampingIncrease then d+faultActivation*(dFault-d)
    elseif faultMode==FaultMode.Broken then d*(1-faultActivation)
    elseif faultMode==FaultMode.Seizure then d+faultActivation*(dSeized-d) else d;
  tau_c=c_effective*(phi_rel-phi_rel0);
  tau_d=d_effective*w_rel;
  tau = tau_c + tau_d;
  lossPower = tau_d*w_rel;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableSpringDamper 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A <strong>spring</strong> and <strong>damper</strong> element <strong>connected in parallel</strong>.
The component can be
connected either between two inertias/gears to describe the shaft elasticity
and damping, or between an inertia/gear and the housing (component Fixed),
to describe a coupling of the element with the housing via a spring/damper.
</p>

<p>
See also the discussion
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.StateSelection\">State Selection</a>
in the User's Guide of the Rotational library.
</p>
</html>"),
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
        graphics={
    Line(points={{-80,40},{-60,40},{-45,10},{-15,70},{15,10},{45,70},{60,40},{80,40}}),
    Line(points={{-80,40},{-80,-40}}),
    Line(points={{-80,-40},{-50,-40}}),
    Rectangle(extent={{-50,-10},{40,-70}},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-50,-10},{70,-10}}),
    Line(points={{-50,-70},{70,-70}}),
    Line(points={{40,-40},{80,-40}}),
    Line(points={{80,40},{80,-40}}),
    Line(points={{-90,0},{-80,0}}),
    Line(points={{80,0},{90,0}}),
    Text(origin={0,-9},
      extent={{-150,-144},{150,-104}},
      textString="d=%d"),
    Text(extent={{-190,110},{190,70}},
      textColor={0,0,255},
      textString="%name"),
    Text(
      origin={0,-7},
      extent={{-150,-108},{150,-68}},
      textString="c=%c"),
    Line(visible=useHeatPort,
      points={{-100,-100},{-100,-55},{-5,-55}},
      color={191,0,0},
      pattern=LinePattern.Dot),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableSpringDamper;

