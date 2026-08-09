within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableDamper "Linear 1D translational damper"
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliantWithRelativeStates;
  parameter Modelica.Units.SI.TranslationalDampingConstant d(final min=0, start=0)
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
  parameter Modelica.Units.SI.TranslationalDampingConstant dFault=0.5*d;
  parameter Modelica.Units.SI.TranslationalDampingConstant dSeized=1e12;
  Modelica.Units.SI.TranslationalDampingConstant d_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  d_effective=if faultMode==FaultMode.DampingLoss or faultMode==FaultMode.DampingIncrease or faultMode==FaultMode.Leakage then d+faultActivation*(dFault-d) elseif faultMode==FaultMode.Seizure then d+faultActivation*(dSeized-d) else d;
  f=d_effective*v_rel;
  lossPower = f*v_rel;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableDamper 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
<em>Linear, velocity dependent damper</em> element. It can be either connected
between a sliding mass and the housing (model Fixed), or
between two sliding masses.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-90,0},{100,0}}, color={0,127,0}),
          Line(points={{-60,-30},{-60,30}}),                    Rectangle(
              extent={{-60,30},{30,-30}},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid,
          lineColor={0,127,0}),                                           Polygon(
          points={{50,-90},{20,-80},{20,-100},{50,-90}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid),    Line(points={{-60,-90},{20,-90}}, color={95,127,95}),
                                                                               Text(
              extent={{-150,90},{150,50}},
              textString="%name",
              textColor={0,0,255}),Text(
              extent={{-150,-45},{150,-75}},
              textString="d=%d"),Line(
              visible=useHeatPort,
              points={{-100,-100},{-100,-20},{-14,-20}},
              color={191,0,0},
              pattern=LinePattern.Dot),
                                Line(points={{60,-30},{-60,-30},{-60,30},{60,30}}, color={0,127,0}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableDamper;

