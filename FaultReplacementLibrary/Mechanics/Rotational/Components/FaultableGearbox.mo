within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableGearbox "Realistic model of a gearbox (based on LossyGear)"
  extends Modelica.Mechanics.Rotational.Icons.Gearbox;
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlangesAndSupport;

  parameter Real ratio(start=1)
    "Transmission ratio (flange_a.phi/flange_b.phi)";
  parameter Real lossTable[:, 5]=[0, 1, 1, 0, 0]
    "Array for mesh efficiencies and bearing friction depending on speed (see docu of LossyGear)";
  parameter Modelica.Units.SI.RotationalSpringConstant c(final min=Modelica.Constants.small,
      start=1.0e5) "Gear elasticity (spring constant)";
  parameter Modelica.Units.SI.RotationalDampingConstant d(final min=0, start=0)
    "Gear damping (relative damping)";
  parameter Modelica.Units.SI.Angle b(final min=0) = 0 "Total backlash";
  parameter StateSelect stateSelect=StateSelect.prefer
    "Priority to use phi_rel and w_rel as states"
    annotation (HideResult=true, Dialog(tab="Advanced"));
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialConditionalHeatPort(
      final T=293.15);
  Modelica.Units.SI.Angle phi_rel(
    start=0,
    stateSelect=stateSelect,
    nominal=1e-4) = flange_b.phi - lossyGear.flange_b.phi
    "Relative rotation angle over gear elasticity (= flange_b.phi - lossyGear.flange_b.phi)";
  Modelica.Units.SI.AngularVelocity w_rel(
    start=0,
    stateSelect=stateSelect) = der(phi_rel)
    "Relative angular velocity over gear elasticity (= der(phi_rel))";
  Modelica.Units.SI.AngularAcceleration a_rel(start=0) = der(w_rel)
    "Relative angular acceleration over gear elasticity (= der(w_rel))";

  Modelica.Mechanics.Rotational.Components.LossyGear lossyGear(
    final ratio=ratio,
    final lossTable=lossTable,
    final useSupport=true,
    final useHeatPort=true) annotation (Placement(transformation(extent={{-60,
            -20},{-20,20}})));
  Modelica.Mechanics.Rotational.Components.ElastoBacklash elastoBacklash(
    final b=b,
    final c=c,
    final phi_rel0=0,
    final d=d,
    final useHeatPort=true) annotation (Placement(transformation(extent={{
            20,-20},{60,20}})));
  type FaultMode=enumeration(Normal "正常", ToothDamage "齿损伤周期扰动", EfficiencyLoss "附加损耗", LockedGear "锁死阻尼");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Torque faultTorqueAmplitude=1;
  parameter Modelica.Units.SI.Frequency toothFrequency=20;
  parameter Modelica.Units.SI.RotationalDampingConstant lockDamping=1e9;
  Modelica.Mechanics.Rotational.Sources.Torque faultTorqueSource(useSupport=true);
  Modelica.Blocks.Sources.RealExpression faultTorqueCommand(y=if faultMode==FaultMode.ToothDamage then faultActivation*faultTorqueAmplitude*sin(2*Modelica.Constants.pi*toothFrequency*time) elseif faultMode==FaultMode.EfficiencyLoss then -faultActivation*faultTorqueAmplitude*sign(der(flange_a.phi)) elseif faultMode==FaultMode.LockedGear then -faultActivation*lockDamping*der(flange_a.phi) else 0);
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  connect(faultTorqueCommand.y,faultTorqueSource.tau);
  connect(faultTorqueSource.flange,flange_a);
  connect(faultTorqueSource.support,internalSupport);

  connect(flange_a, lossyGear.flange_a) annotation (Line(points={{-100,0},{
          -90,0},{-90,0},{-80,0},{-80,0},{-60,0}}));
  connect(lossyGear.flange_b, elastoBacklash.flange_a) annotation (Line(
        points={{-20,0},{-10,0},{0,0},{20,0}}));
  connect(elastoBacklash.flange_b, flange_b) annotation (Line(points={{60,0},
          {70,0},{70,0},{80,0},{80,0},{100,0}}));
  connect(elastoBacklash.heatPort, internalHeatPort) annotation (Line(
      points={{20,-20},{20,-60},{-100,-60},{-100,-80}}, color={191,0,0}));
  connect(lossyGear.heatPort, internalHeatPort) annotation (Line(
      points={{-60,-20},{-60,-60},{-100,-60},{-100,-80}}, color={191,0,0}));
  connect(lossyGear.support, internalSupport) annotation (Line(
      points={{-40,-20},{-40,-40},{0,-40},{0,-80}}));
  annotation (
    Documentation(info="<html><p>用法：将 FaultableGearbox 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>This component models the essential effects of a gearbox, in
particular</p>
<ul>
  <li>in component <strong>lossyGear</strong>
    <ul>
      <li>gear <strong>efficiency</strong> due to friction between the teeth</li>
      <li><strong>bearing friction</strong></li>
    </ul></li>
  <li>in component <strong>elastoBacklash</strong>
    <ul>
      <li>gear <strong>elasticity</strong></li>
      <li><strong>damping</strong></li>
      <li><strong>backlash</strong></li>
    </ul></li>
</ul>
<p>The inertia of the gear wheels is not modeled. If necessary,
inertia has to be taken into account by connecting components of
model Inertia to the left and/or the right flange of component
Gearbox.
</p>

</html>"),
       Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),graphics={Text(
              extent={{-150,150},{150,110}},
              textColor={0,0,255},
              textString="%name"),Text(
              extent={{-150,70},{150,100}},
              textString="ratio=%ratio, c=%c"),Line(
              visible=useHeatPort,
              points={{-100,-100},{-100,-30},{0,-30}},
              color={191,0,0},
              pattern=LinePattern.Dot),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableGearbox;
