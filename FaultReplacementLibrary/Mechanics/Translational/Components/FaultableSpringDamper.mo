within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableSpringDamper "Linear 1D translational spring and damper in parallel"
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliantWithRelativeStates;
  parameter Modelica.Units.SI.TranslationalSpringConstant c(final min=0, start=1)
    "Spring constant";
  parameter Modelica.Units.SI.TranslationalDampingConstant d(final min=0, start=1)
    "Damping constant";
  parameter Modelica.Units.SI.Position s_rel0=0 "Unstretched spring length";
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPortWithoutT;
  type FaultMode=enumeration(Normal "正常", StiffnessLoss "刚度下降", DampingLoss "阻尼下降", DampingIncrease "阻尼增加", Broken "断裂", Seizure "卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.TranslationalSpringConstant cFault=0.5*c;
  parameter Modelica.Units.SI.TranslationalDampingConstant dFault=0.5*d;
  parameter Modelica.Units.SI.TranslationalDampingConstant dSeized=1e12;
  Modelica.Units.SI.TranslationalSpringConstant c_effective;
  Modelica.Units.SI.TranslationalDampingConstant d_effective;
protected
  Modelica.Units.SI.Force f_c "Spring force";
  Modelica.Units.SI.Force f_d "Damping force";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  c_effective=if faultMode==FaultMode.StiffnessLoss then c+faultActivation*(cFault-c) elseif faultMode==FaultMode.Broken then c*(1-faultActivation) else c;
  d_effective=if faultMode==FaultMode.DampingLoss or faultMode==FaultMode.DampingIncrease then d+faultActivation*(dFault-d) elseif faultMode==FaultMode.Broken then d*(1-faultActivation) elseif faultMode==FaultMode.Seizure then d+faultActivation*(dSeized-d) else d;
  f_c=c_effective*(s_rel-s_rel0);
  f_d=d_effective*v_rel;
  f = f_c + f_d;
  lossPower = f_d*v_rel;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableSpringDamper 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A <em>spring and damper element connected in parallel</em>.
The component can be
connected either between two sliding masses to describe the elasticity
and damping, or between a sliding mass and the housing (model Fixed),
to describe a coupling of the sliding mass with the housing via a spring/damper.
</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{-80,40},{-60,40},{-45,10},{-15,70},{15,10},{45,70},{
              60,40},{80,40}}, color={0,127,0}),
        Line(points={{-80,40},{-80,-70},{80,-70},{80,40}}, color={0,127,0}),
        Line(points={{-90,0},{-80,0}}, color={0,127,0}),
        Line(points={{80,0},{90,0}}, color={0,127,0}),
        Polygon(
          points={{53,-20},{23,-10},{23,-30},{53,-20}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-57,-20},{23,-20}}, color={95,127,95}),
        Text(
          extent={{-150,120},{150,80}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-150,-135},{150,-165}},
          textString="d=%d"),
        Text(
          extent={{-150,-100},{150,-130}},
          textString="c=%c"),
        Line(
          visible=useHeatPort,
          points={{-100,-100},{-100,-80},{-5,-80}},
          color={191,0,0},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{-50,-50},{40,-90}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          lineColor={0,127,0}), Line(points={{70,-90},{-50,-90},{-50,-50},{70,-50}}, color={0,127,0}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableSpringDamper;

