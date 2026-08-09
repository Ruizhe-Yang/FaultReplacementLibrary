within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableMass "Sliding mass with inertia"
  parameter Modelica.Units.SI.Mass m(min=0, start=1) "Mass of the sliding mass";
  parameter StateSelect stateSelect=StateSelect.default
    "Priority to use s and v as states" annotation (Dialog(tab="Advanced"));
  extends Modelica.Mechanics.Translational.Interfaces.PartialRigid(L=0,s(start=0, stateSelect=
          stateSelect));
  Modelica.Units.SI.Velocity v(start=0, stateSelect=stateSelect)
    "Absolute velocity of component";
  Modelica.Units.SI.Acceleration a(start=0) "Absolute acceleration of component";

  type FaultMode=enumeration(Normal "正常", MassDrift "质量漂移", MassLoss "质量下降", LockedMass "质量块卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Mass mFault=0.5*m;
  parameter Modelica.Units.SI.TranslationalDampingConstant lockDamping=1e12;
  Modelica.Units.SI.Mass m_effective;
  Modelica.Units.SI.Force lockForce;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  v = der(s);
  a = der(v);
  m_effective=if faultMode==FaultMode.MassDrift or faultMode==FaultMode.MassLoss then m+faultActivation*(mFault-m) else m;
  lockForce=if faultMode==FaultMode.LockedMass then faultActivation*lockDamping*v else 0;
  m_effective*a+lockForce=flange_a.f+flange_b.f;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableMass 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
Sliding mass with <em>inertia, without friction</em> and two rigidly connected flanges.
</p>
<p>
The sliding mass has the length L, the position coordinate s is in the middle.
Sign convention: A positive force at flange flange_a moves the sliding mass in the positive direction.
A negative force at flange flange_a moves the sliding mass to the negative direction.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{-100,0},{100,0}}, color={0,127,0}),
        Rectangle(
          extent={{-55,-30},{56,30}},
          fillPattern=FillPattern.Sphere,
          fillColor={160,215,160},
          lineColor={0,127,0}),
        Polygon(
          points={{50,-90},{20,-80},{20,-100},{50,-90}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,-90},{20,-90}}, color={95,127,95}),
        Text(
          extent={{-150,85},{150,45}},
          textString="%name",
          textColor={0,0,255},
          fillColor={110,210,110},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-45},{150,-75}},
          textString="m=%m",
          fillColor={110,221,110},
          fillPattern=FillPattern.Solid,
          fontSize=0),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableMass;

