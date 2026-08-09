within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultablePotentiometer "Adjustable resistor"
  import SI = Modelica.Units.SI;
  parameter SI.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter SI.Temperature T_ref=293.15 "Reference temperature";
  parameter SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=T_ref);
  parameter Boolean useRinput=false "Use input for 0<r<1 (else constant)"
    annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="potentiometer"));
  parameter Real rConstant(
    final min=0,
    final max=1) = 0.5 "Contact between n (r=0) and p (r=1)"
    annotation (Dialog(group="potentiometer", enable=not useRinput));
  SI.Resistance Rp
    "Actual resistance between pin_p and contact";
  SI.Resistance Rn
    "Actual resistance between contact and pin_n";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin contact annotation (
      Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput r if useRinput annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-120})));
  type FaultMode = enumeration(Normal "正常", TotalResistanceDrift "总阻值漂移", WiperBias "滑片偏置", WiperStuck "滑片卡死", ContactOpen "滑片接触开路");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter SI.Resistance R_fault=2*R "总阻值故障目标";
  parameter Real wiperBias=0.1 "滑片偏置";
  parameter Real wiperStuckValue(min=0,max=1)=0.5 "滑片卡死位置";
  parameter SI.Resistance R_contactOpen=1e10 "接触开路有限大电阻";
  SI.Resistance R_effective "故障后的总电阻";
  Real r_effective "故障后的滑片位置";
  SI.Resistance R_contact "故障后的滑片接触电阻";
protected
  Modelica.Blocks.Sources.Constant rConst(final k=rConstant) if not useRinput
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,-50})));
  Modelica.Blocks.Interfaces.RealInput rInt
    annotation (Placement(transformation(extent={{-84,-84},{-76,-76}})));
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  pin_p.i + pin_n.i + contact.i = 0;
  R_effective = if faultMode == FaultMode.TotalResistanceDrift then R + faultActivation*(R_fault - R) else R;
  r_effective = if faultMode == FaultMode.WiperBias then min(1, max(0, rInt + faultActivation*wiperBias))
    elseif faultMode == FaultMode.WiperStuck then rInt + faultActivation*(wiperStuckValue - rInt) else min(1, max(0, rInt));
  R_contact = if faultMode == FaultMode.ContactOpen then faultActivation*R_contactOpen else 0;
  Rp = R_effective*(1 + alpha*(T_heatPort - T_ref))*(1 - r_effective);
  Rn = R_effective*(1 + alpha*(T_heatPort - T_ref))*r_effective;
  pin_p.v - contact.v = (Rp + R_contact)*pin_p.i;
  pin_n.v - contact.v = (Rn + R_contact)*pin_n.i;
  LossPower = (pin_p.v - contact.v)*pin_p.i + (pin_n.v - contact.v)*pin_n.i;
  connect(rInt, r) annotation (Line(
      points={{-80,-80},{-100,-80},{-100,-120}}, color={0,0,127}));
  connect(rInt, rConst.y) annotation (Line(
      points={{-80,-80},{-90,-80},{-90,-61}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{-70,0}},
          color={0,0,255}),
        Line(
          points={{70,0},{90,0}},
          color={0,0,255}),
        Line(
          visible=useHeatPort,
          points={{0,-100},{0,-30}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{0,40},{0,-40},{100,-80},{100,-90}},
          color={0,0,255}),
        Line(
          visible=useRinput,
          points={{-100,-90},{-100,-80},{0,-40}},
          color={0,0,255},
          pattern=LinePattern.Dot),
        Line(
          visible=useHeatPort,
          points={{0,-90},{0,-40}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Polygon(
          points={{0,-30},{-4,-40},{4,-40},{0,-30}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultablePotentiometer 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
                       <p>This models a potentiometer where the sliding contact is placed between pin_n (r = 0) and pin_p (r = 1), dependent on either the parameter rConstant or the signal input r.</p>
                       <p>The total resistance R is temperature dependent.</p>
                       </html>"));
end FaultablePotentiometer;
