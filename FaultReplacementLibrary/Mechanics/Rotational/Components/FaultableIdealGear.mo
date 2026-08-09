within FaultReplacementLibrary.Mechanics.Rotational.Components;
model FaultableIdealGear "Ideal gear without inertia"
  extends Modelica.Mechanics.Rotational.Icons.Gear;
  extends
    Modelica.Mechanics.Rotational.Interfaces.PartialElementaryTwoFlangesAndSupport2;
  parameter Real ratio(start=1)
    "Transmission ratio (flange_a.phi/flange_b.phi)";
  Modelica.Units.SI.Angle phi_a
    "Angle between left shaft flange and support";
  Modelica.Units.SI.Angle phi_b
    "Angle between right shaft flange and support";

  type FaultMode=enumeration(Normal "正常", GearRatioError "传动比误差", ToothDamage "齿损伤扰动", LockedGear "齿轮锁死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real ratioFault=0.9*ratio;
  parameter Modelica.Units.SI.RotationalDampingConstant lockDamping=1e9;
  parameter Modelica.Units.SI.Torque toothTorque=1;
  parameter Modelica.Units.SI.Frequency toothFrequency=20;
  Real ratio_effective;
  Modelica.Units.SI.Torque faultTorque;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;

  phi_a = flange_a.phi - phi_support;
  phi_b = flange_b.phi - phi_support;
  ratio_effective=if faultMode==FaultMode.GearRatioError then ratio+faultActivation*(ratioFault-ratio) else ratio;
  faultTorque=if faultMode==FaultMode.ToothDamage then faultActivation*toothTorque*sin(2*Modelica.Constants.pi*toothFrequency*time)
    elseif faultMode==FaultMode.LockedGear then faultActivation*lockDamping*der(phi_a-ratio_effective*phi_b) else 0;
  phi_a=ratio_effective*phi_b;
  0=ratio_effective*flange_a.tau+flange_b.tau+faultTorque;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableIdealGear 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
This element characterizes any type of gear box which is fixed in the
ground and which has one driving shaft and one driven shaft.
The gear is <strong>ideal</strong>, i.e., it does not have inertia, elasticity, damping
or backlash. If these effects have to be considered, the gear has to be
connected to other elements in an appropriate way.
</p>

</html>"),
       Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}),
    graphics={
      Text(extent={{-153,145},{147,105}},
        textColor={0,0,255},
        textString="%name"),
      Text(extent={{-146,-49},{154,-79}},
        textString="ratio=%ratio"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealGear;

