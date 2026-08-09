within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableIdealPlanetary "Ideal planetary gear box"
  parameter Real ratio(start=100/50)
    "Number of ring_teeth/sun_teeth (e.g., ratio=100/50)";

  // kinematic relationship
  Modelica.Mechanics.Rotational.Interfaces.Flange_a sun "Flange of sun shaft" annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a carrier "Flange of carrier shaft" annotation (
      Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b ring "Flange of ring shaft" annotation (Placement(
        transformation(extent={{90,-10},{110,10}})));

  type FaultMode=enumeration(Normal "正常", GearRatioError "齿数比误差", ToothDamage "齿损伤", LockedGear "行星机构锁死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real ratioFault=0.9*ratio;
  parameter Modelica.Units.SI.Torque toothTorque=1;
  Real ratio_effective;
  Modelica.Units.SI.Torque faultTorque;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  ratio_effective=if faultMode==FaultMode.GearRatioError then ratio+faultActivation*(ratioFault-ratio) else ratio;
  faultTorque=if faultMode==FaultMode.ToothDamage then faultActivation*toothTorque*sin(40*Modelica.Constants.pi*time)
    elseif faultMode==FaultMode.LockedGear then faultActivation*1e8*der(carrier.phi) else 0;
  (1+ratio_effective)*carrier.phi=sun.phi+ratio_effective*ring.phi;
  ring.tau=ratio_effective*sun.tau+faultTorque;
  carrier.tau=-(1+ratio_effective)*sun.tau-faultTorque;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableIdealPlanetary 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The IdealPlanetary gear box is an ideal gear without inertia,
elasticity, damping or backlash consisting
of an inner <strong>sun</strong> wheel, an outer <strong>ring</strong> wheel and a
<strong>planet</strong> wheel located between sun and ring wheel. The bearing
of the planet wheel shaft is fixed in the planet <strong>carrier</strong>.
The component can be connected to other elements at the
sun, ring and/or carrier flanges. It is not possible to connect
to the planet wheel. If inertia shall not be neglected,
the sun, ring and carrier inertias can be easily added by attaching
inertias (= model Inertia) to the corresponding connectors.
The inertias of the planet wheels are always neglected.
</p>
<p>
The icon of the planetary gear signals that the sun and carrier
flanges are on the left side and the ring flange is on the right side
of the gear box. However, this component is generic and is valid
independently how the flanges are actually placed (e.g., sun wheel
may be placed on the right side instead on the left side in reality).
</p>
<p>
The ideal planetary gearbox is uniquely defined by the ratio
of the number of ring teeth zr with respect to the number of
sun teeth zs. For example, if there are 100 ring teeth and
50 sun teeth then ratio = zr/zs = 2. The number of planet teeth
zp has to fulfill the following relationship:
</p>
<blockquote><pre>
<strong>zp := (zr - zs) / 2</strong>
</pre></blockquote>
<p>
Therefore, in the above example zp = 25 is required.
</p>
<p>
According to the overall convention, the positive direction of all
vectors, especially the absolute angular velocities and cut-torques
in the flanges, are along the axis vector displayed in the icon.
</p>

</html>"),
    Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Rectangle(lineColor={160,160,164},
      fillColor={160,160,164},
      fillPattern=FillPattern.Solid,
      extent={{-50.0,100.0},{50.0,105.0}}),
    Rectangle(lineColor={160,160,164},
      fillColor={160,160,164},
      fillPattern=FillPattern.Solid,
      extent={{-50.0,-105.0},{50.0,-100.0}}),
    Line(points={{-90.0,40.0},{-70.0,40.0}}),
    Line(points={{-80.0,50.0},{-60.0,50.0}}),
    Line(points={{-70.0,50.0},{-70.0,40.0}}),
    Line(points={{-80.0,80.0},{-59.0,80.0}}),
    Line(points={{-70.0,100.0},{-70.0,80.0}}),
    Text(textColor={0,0,255},
      extent={{-150.0,110.0},{150.0,150.0}},
      textString="%name"),
    Text(extent={{-150.0,-150.0},{150.0,-110.0}},
      textString="ratio=%ratio"),
    Rectangle(lineColor={64,64,64},
      fillColor={255,255,255},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{10.0,-100.0},{50.0,100.0}}),
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-100.0,-10.0},{-50.0,10.0}}),
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{50.0,-10.0},{100.0,10.0}}),
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-80.0,60.0},{-50.0,70.0}}),
    Rectangle(origin={-30.0,65.0},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-20.0,-19.0},{20.0,19.0}}),
    Rectangle(origin={-30.0,48.0},
      fillColor={153,153,153},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-2.0},{20.0,2.0}}),
    Rectangle(origin={-30.0,82.0},
      fillColor={204,204,204},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-2.0},{20.0,2.0}}),
    Rectangle(origin={-30.0,59.0},
      fillColor={204,204,204},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-4.0},{20.0,4.0}}),
    Rectangle(origin={-30.0,73.0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-3.0},{20.0,3.0}}),
    Rectangle(origin={-30.0,-1.0},
      fillColor={255,255,255},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-20.0,-35.0},{20.0,35.0}}),
    Rectangle(origin={-30.0,32.0},
      fillColor={153,153,153},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-2.0},{20.0,2.0}}),
    Rectangle(origin={-30.0,23.0},
      fillColor={204,204,204},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-3.0},{20.0,3.0}}),
    Rectangle(origin={-30.0,-10.0},
      fillColor={204,204,204},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-4.0},{20.0,4.0}}),
    Rectangle(origin={-30.0,-34.0},
      fillColor={102,102,102},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-2.0},{20.0,2.0}}),
    Rectangle(origin={-30.0,-25.0},
      fillColor={153,153,153},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-3.0},{20.0,3.0}}),
    Rectangle(origin={-30.0,8.0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      extent={{-20.0,-4.0},{20.0,4.0}}),
    Rectangle(origin = {-30,65},
      fillColor = {192,192,192},
      extent = {{-20,-19},{20,19}}),
    Rectangle(origin = {-30,-1},
      fillColor = {255,255,255},
      extent = {{-20,-35},{20,35}}),
    Rectangle(lineColor = {64,64,64},
      fillColor = {255,255,255},
      extent = {{10,-100},{50,100}}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
  Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100,-100},{100,100}}), graphics={
    Polygon(lineColor = {128,128,128},
      fillColor = {128,128,128},
      fillPattern = FillPattern.Solid,
      points = {{58,130},{28,140},{28,120},{58,130}}),
    Line(points = {{-52,130},{28,130}})}));
end FaultableIdealPlanetary;
