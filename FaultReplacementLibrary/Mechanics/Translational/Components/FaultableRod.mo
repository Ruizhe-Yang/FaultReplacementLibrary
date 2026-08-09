within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableRod "Rod without inertia"
  extends Modelica.Mechanics.Translational.Interfaces.PartialRigid;
  type FaultMode=enumeration(Normal "正常", AxialForceDisturbance "轴向力扰动", RodDamage "杆损伤周期力", RodLock "杆卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Force forceFault=1;
  parameter Modelica.Units.SI.Frequency damageFrequency=20;
  Modelica.Units.SI.Force faultForceValue "故障引入的等效轴向外力";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  faultForceValue=if faultMode==FaultMode.AxialForceDisturbance then faultActivation*forceFault elseif faultMode==FaultMode.RodDamage then faultActivation*forceFault*sin(2*Modelica.Constants.pi*damageFrequency*time) elseif faultMode==FaultMode.RodLock then -faultActivation*1e10*der(flange_a.s) else 0;
  0=flange_a.f+flange_b.f+faultForceValue;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableRod 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
A translational rod <strong>without inertia</strong> and two rigidly connected flanges.
</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Line(points={{-100,0},{100,0}}, color={0,127,0}),
                                                        Polygon(
          points={{50,-90},{20,-80},{20,-100},{50,-90}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid),    Line(points={{-60,-90},{20,-90}}, color={95,127,95}),
                                                                               Rectangle(
          extent={{-60,10},{60,-10}},
          lineColor={0,127,0},
          fillColor={160,215,160},
          fillPattern=FillPattern.Solid),    Text(
              extent={{-150,80},{150,40}},
              textString="%name",
              textColor={0,0,255}),Text(
              extent={{-150,-30},{150,-60}},
              textString="L=%L"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableRod;
