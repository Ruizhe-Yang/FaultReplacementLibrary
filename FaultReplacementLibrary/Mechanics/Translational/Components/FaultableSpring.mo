within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableSpring "Linear 1D translational spring"
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliant;
  parameter Modelica.Units.SI.TranslationalSpringConstant c(final min=0, start=1)
    "Spring constant";
  parameter Modelica.Units.SI.Distance s_rel0=0 "Unstretched spring length";

  type FaultMode=enumeration(Normal "正常", StiffnessLoss "刚度下降", StiffnessIncrease "刚度增加", Broken "断裂", PreloadShift "自由长度漂移", Sticking "卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.TranslationalSpringConstant cFault=0.5*c;
  parameter Modelica.Units.SI.Position sRel0Fault=s_rel0+0.01;
  parameter Modelica.Units.SI.TranslationalSpringConstant cStuck=1e12;
  Modelica.Units.SI.TranslationalSpringConstant c_effective;
  Modelica.Units.SI.Position s_rel0_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  c_effective=if faultMode==FaultMode.StiffnessLoss or faultMode==FaultMode.StiffnessIncrease then c+faultActivation*(cFault-c) elseif faultMode==FaultMode.Broken then c*(1-faultActivation) elseif faultMode==FaultMode.Sticking then c+faultActivation*(cStuck-c) else c;
  s_rel0_effective=if faultMode==FaultMode.PreloadShift then s_rel0+faultActivation*(sRel0Fault-s_rel0) else s_rel0;
  f=c_effective*(s_rel-s_rel0_effective);
  annotation (
    Documentation(info="<html><p>用法：将 FaultableSpring 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A <em>linear 1D translational spring</em>. The component can be connected either
between two sliding masses, or between
a sliding mass and the housing (model Fixed), to describe
a coupling of the sliding mass with the housing via a spring.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{-60,-90},{20,-90}}, color={95,127,95}),
        Polygon(
          points={{50,-90},{20,-80},{20,-100},{50,-90}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Line(points={{-98,0},{-60,0},{-44,-30},{-16,30},{14,-30},{44,30},{
              60,0},{100,0}}, color={0,127,0}),
        Text(
          extent={{-150,-45},{150,-75}},
          textString="c=%c"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableSpring;

