within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableDamper "Linear 1D rotational damper"
  extends
    Modelica.Mechanics.Rotational.Interfaces.PartialCompliantWithRelativeStates;
  parameter Modelica.Units.SI.RotationalDampingConstant d(final min=0, start=0)
    "Damping constant";
  extends
    Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;
  type FaultMode=enumeration(Normal "正常", DampingLoss "阻尼下降", DampingIncrease "阻尼增加", Leakage "阻尼泄漏", Seizure "卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.RotationalDampingConstant dFault=0.5*d
    "Compatibility alias for earlier replacement scenarios";
  parameter Modelica.Units.SI.RotationalDampingConstant dLoss=dFault;
  parameter Modelica.Units.SI.RotationalDampingConstant dIncrease=2*d;
  parameter Modelica.Units.SI.RotationalDampingConstant dLeak=0.1*d;
  parameter Modelica.Units.SI.Time leakageTime(min=Modelica.Constants.small)=1;
  parameter Modelica.Units.SI.RotationalDampingConstant dSeized=1e9;
  Modelica.Units.SI.RotationalDampingConstant d_effective;
  Real leakageProgress(min=0,max=1);
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  leakageProgress=if time<=faultStartTime then 0 else min(1,max(0,(min(time,faultEndTime)-faultStartTime)/leakageTime));
  d_effective=if faultMode==FaultMode.DampingLoss then d+faultActivation*(dLoss-d)
    elseif faultMode==FaultMode.DampingIncrease then d+faultActivation*(dIncrease-d)
    elseif faultMode==FaultMode.Leakage then d+severity*endActivation*leakageProgress*(dLeak-d)
    elseif faultMode==FaultMode.Seizure then d+faultActivation*(dSeized-d) else d;
  tau=d_effective*w_rel;
  lossPower = tau*w_rel;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableDamper 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
<strong>Linear, velocity dependent damper</strong> element. It can be either connected
between an inertia or gear and the housing (component Fixed), or
between two inertia/gear elements.
</p>

<p>
See also the discussion
<a href=\"modelica://Modelica.Mechanics.Rotational.UsersGuide.StateSelection\">State Selection</a>
in the User's Guide of the Rotational library.
</p>
</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
    Line(points={{-90,0},{-60,0}}),
    Line(points={{-60,-30},{-60,30}}),
    Line(points={{-60,-30},{60,-30}}),
    Line(points={{-60,30},{60,30}}),
    Rectangle(extent={{-60,30},{30,-30}},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{30,0},{90,0}}),
    Text(extent={{-150,80},{150,40}},
      textString="%name",
      textColor={0,0,255}),
    Text(extent={{-150,-50},{150,-90}},
      textString="d=%d"),
    Line(visible=useHeatPort,
      points={{-100,-100},{-100,-40},{-20,-40},{-20,0}},
      color={191,0,0},
      pattern=LinePattern.Dot),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableDamper;
