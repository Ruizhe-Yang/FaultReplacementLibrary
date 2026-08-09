within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableIdealRollingWheel
  "Simple 1-dim. model of an ideal rolling wheel without inertia"

  extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational;
  parameter Modelica.Units.SI.Distance radius(start=0.3) "Wheel radius";

  type FaultMode=enumeration(Normal "正常", RadiusError "半径误差", Slip "滚动打滑", LockedWheel "车轮锁死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Distance radiusFault=0.9*radius;
  parameter Real slipRatioFault(min=0,max=1)=0.2;
  Modelica.Units.SI.Distance radius_effective;
  Real rollingScale;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  radius_effective=if faultMode==FaultMode.RadiusError then radius+faultActivation*(radiusFault-radius) else radius;
  rollingScale=if faultMode==FaultMode.Slip then 1-faultActivation*slipRatioFault elseif faultMode==FaultMode.LockedWheel then 1-faultActivation else 1;
  (flangeR.phi-internalSupportR.phi)*radius_effective*rollingScale=flangeT.s-internalSupportT.s;
  0=radius_effective*flangeT.f+flangeR.tau;
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
      Rectangle(  lineColor={64,64,64},
        fillColor={192,192,192},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100.0,-10.0},{-46.0,10.0}}),
      Ellipse(  lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-50.0,-80.0},{10.0,80.0}}),
      Rectangle(  lineColor={64,64,64},
        fillColor={255,255,255},
        pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-20.0,-80.0},{12.0,80.0}}),
      Ellipse(  lineColor={64,64,64},
        fillColor={128,128,128},
        fillPattern=FillPattern.Solid,
        extent={{-16.0,-80.0},{44.0,80.0}}),
      Ellipse(  lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        extent={{-2.0,-52.0},{34.0,52.0}}),
      Ellipse(  lineColor={64,64,64},
        fillColor={192,192,192},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{12.0,-10.0},{20.0,10.0}}),
      Rectangle(  lineColor={64,64,64},
        fillColor={192,192,192},
        pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{16.0,-10.0},{60.0,10.0}}),
      Ellipse(  fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        extent={{56.0,-10.0},{64.0,10.0}}),
      Text(  textColor={0,0,255},
        extent={{-150.0,90.0},{150.0,130.0}},
        textString="%name"),
      Polygon(  lineColor={0,127,0},
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid,
        points={{80.0,10.0},{80.0,26.0},{60.0,26.0},{60.0,20.0},{70.0,20.0},{70.0,-20.0},{60.0,-20.0},{60.0,-26.0},{80.0,-26.0},{80.0,-10.0},{90.0,-10.0},{90.0,10.0},{80.0,10.0}}),
      Line(  points={{-100.0,-20.0},{-60.0,-20.0}}),
      Line(  points={{-100.0,-20.0},{-100.0,-100.0}}),
      Line(  points={{-100.0,20.0},{-60.0,20.0}}),
      Line(  points={{100.0,-90.0},{-40.0,-90.0}},
        color={0,127,0}),
      Line(  points={{70.0,-26.0},{70.0,-50.0},{100.0,-50.0},{100.0,-100.0}},
        color={0,127,0}),
      Line(  origin={-2.5,80.0},
        points={{-17.5,0.0},{17.5,0.0}},
        color={64,64,64}),
      Line(  origin={-2.5,-80.0},
        points={{-17.5,0.0},{17.5,0.0}},
        color={64,64,64}),
      Line(  origin={38.0,10.0},
        points={{-22.0,0.0},{22.0,0.0}},
        color={64,64,64}),
      Line(  origin={38.0,-10.0},
        points={{-22.0,0.0},{22.0,0.0}},
        color={64,64,64}),
      Text(  extent={{-150,-120},{150,-150}},
          textString="radius=%radius"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
                             Documentation(info="<html><p>用法：将 FaultableIdealRollingWheel 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A simple kinematic model of a rolling wheel which has no inertia and
no rolling resistance. This component defines the kinematic constraint:
</p>

<blockquote><pre>
(flangeR.phi - internalSupportR.phi) * radius = (flangeT.s - internalSupportT.s);
</pre></blockquote>
</html>"));
end FaultableIdealRollingWheel;

