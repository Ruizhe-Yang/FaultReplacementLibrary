within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableRollingResistance "Resistance of a rolling wheel"
  extends Modelica.Mechanics.Translational.Interfaces.PartialForce;
  import Modelica.Constants.pi;
  parameter Modelica.Units.SI.Force fWeight(start=0) "Wheel load due to gravity";
  parameter Boolean useCrInput=false "Enable signal input for Cr";
  parameter Real CrConstant=0.01 "Constant rolling resistance coefficient"
    annotation(Dialog(enable=not useCrInput));
  parameter Boolean useInclinationInput=false "Enable signal input for inclination";
  parameter Real inclinationConstant=0 "Constant inclination = tan(angle)"
    annotation(Dialog(enable=not useInclinationInput));
  parameter Modelica.Blocks.Types.Regularization reg=Modelica.Blocks.Types.Regularization.Exp
    "Type of regularization" annotation(Evaluate=true);
  parameter Modelica.Units.SI.Velocity v0(final min=Modelica.Constants.eps)=0.1
    "Regularization below v0";
  Modelica.Units.SI.Velocity v
    "Velocity of flange with respect to support (= der(s))";
  Modelica.Units.SI.Force f_nominal "Nominal rolling resistance without regularization";
  Modelica.Blocks.Interfaces.RealInput inclination = inclination_internal if useInclinationInput
    "Inclination=tan(angle)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        origin={-120,60})));
  Modelica.Blocks.Interfaces.RealInput cr = Cr_internal if useCrInput
    "Rolling resistance coefficient"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        origin={-120,-60})));
  type FaultMode=enumeration(Normal "正常", ResistanceLoss "滚阻下降", ResistanceIncrease "滚阻增加", TireDamage "轮胎损伤周期力", LockedWheel "车轮锁死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real resistanceScaleFault(min=0)=2;
  parameter Modelica.Units.SI.Force damageForce=10;
  parameter Modelica.Units.SI.Frequency damageFrequency=10;
  Real resistanceScale;
protected
  Real Cr_internal "Rolling resistance coefficient";
  Real inclination_internal "Inclination";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  if not useCrInput then
    Cr_internal = CrConstant;
  end if;
  if not useInclinationInput then
    inclination_internal = inclinationConstant;
  end if;
  v = der(s);
  resistanceScale=if faultMode==FaultMode.ResistanceLoss then 1-faultActivation elseif faultMode==FaultMode.ResistanceIncrease then 1+faultActivation*(resistanceScaleFault-1) elseif faultMode==FaultMode.LockedWheel then 1+faultActivation*1000 else 1;
  f_nominal=-resistanceScale*Cr_internal*fWeight*cos(atan(inclination_internal)) + (if faultMode==FaultMode.TireDamage then faultActivation*damageForce*sin(2*Modelica.Constants.pi*damageFrequency*time) else 0);
  if reg==Modelica.Blocks.Types.Regularization.Exp then
    f = -f_nominal*(2/(1 + Modelica.Math.exp(-v/(0.01*v0)))-1);
  elseif reg==Modelica.Blocks.Types.Regularization.Sine then
    f = -f_nominal*smooth(1, (if abs(v)>=v0 then sign(v) else Modelica.Math.sin(pi/2*v/v0)));
  elseif reg==Modelica.Blocks.Types.Regularization.Linear then
    f = -f_nominal*(if abs(v)>=v0 then sign(v) else (v/v0));
  else//if reg==Modelica.Blocks.Types.Regularization.CoSine
    f = -f_nominal*(if abs(v)>=v0 then sign(v) else sign(v)*(1 - Modelica.Math.cos(pi/2*v/v0)));
  end if;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-60,60},{60,-60}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Sphere),
        Ellipse(extent={{-40,40},{40,-40}},
          lineColor={0,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,70},{-60,50}},
          textColor={64,64,64},
          textString="inc."),
        Text(
          extent={{-110,-50},{-70,-70}},
          textColor={64,64,64},
          textString="cr"),
        Rectangle(
          extent={{-2,40},{2,-40}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,40},{2,-40}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid,
          rotation=90),
        Rectangle(
          extent={{-2,40},{2,-40}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid,
          rotation=135),
        Rectangle(
          extent={{-2,40},{2,-40}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid,
          rotation=45),
        Ellipse(extent={{-10,10},{10,-10}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultableRollingResistance 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
Simplified model of the resistance of a&nbsp;rolling wheel,
dependent on vertical wheel load (due to gravity, i.e. static only),
inclination and rolling resistance coefficient:
</p>
<blockquote>
<pre>
flange.f = Cr * fWeight * cos(alpha)
</pre>
</blockquote>

<p>
The rolling resistance coefficient&nbsp;<var>C<sub>r</sub></var> is either constant
(given by the parameter <code>CrConstant</code>)
or prescribed by the input <code>cr</code>.
</p>
<p>
The inclination is either constant (parameter <code>inclinationConstant</code>)
or prescribed by the input <code>inclination</code>.
This corresponds to the road rise over running distance of 100&nbsp;m which,
in general, is written as a&nbsp;percentage and is equal to tan(<var>&alpha;</var>).
For example for a&nbsp;road rising by 10&nbsp;m over 100&nbsp;m the
grade&nbsp;=&nbsp;10&nbsp;% and, thus, the inclination is 0.1.
Positive inclination means driving uphill, negative inclination means
driving downhill, in case of positive vehicle velocity.
</p>

<h4>Note</h4>
<p>
The rolling resistance is independent of velocity here,
but changes its direction with the direction of velocity.
To avoid numerical problems around zero velocity, the rolling
resistance is regularized accordingly within <code>[-v0,&nbsp;v0]</code>.
Therefore static friction at vehicle&apos;s standstill
is not taken into account.
</p>
</html>"));
end FaultableRollingResistance;
