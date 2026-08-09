within FaultReplacementLibrary.Electrical.Analog.Sources;
model FaultableSupplyVoltage "Supply voltage (positive and negative) with independent faults"
  type FaultMode=enumeration(Normal "正常", PositiveRailLoss "正电源轨丢失", NegativeRailLoss "负电源轨丢失", RailAmplitudeDrift "电源轨幅值漂移", GroundShift "地电位偏移");
  parameter Modelica.Units.SI.Voltage Vps=+15 "Positive supply";
  parameter Modelica.Units.SI.Voltage Vns=-15 "Negative supply";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin ground annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real railScaleFault=0.5;
  parameter Modelica.Units.SI.Voltage groundShiftFault=1;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Modelica.Units.SI.Voltage Vps_effective;
  Modelica.Units.SI.Voltage Vns_effective;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  Vps_effective = if faultMode==FaultMode.PositiveRailLoss then Vps*(1-faultActivation)
    elseif faultMode==FaultMode.RailAmplitudeDrift then Vps*(1+faultActivation*(railScaleFault-1)) else Vps;
  Vns_effective = if faultMode==FaultMode.NegativeRailLoss then Vns*(1-faultActivation)
    elseif faultMode==FaultMode.RailAmplitudeDrift then Vns*(1+faultActivation*(railScaleFault-1)) else Vns;
  pin_p.v-ground.v = Vps_effective + (if faultMode==FaultMode.GroundShift then faultActivation*groundShiftFault else 0);
  pin_n.v-ground.v = Vns_effective + (if faultMode==FaultMode.GroundShift then faultActivation*groundShiftFault else 0);
  pin_p.i + pin_n.i + ground.i = 0;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(
          points={{-60,40},{-60,-40}},
          color={0,0,255}),
        Line(
          points={{40,40},{40,-40}},
          color={0,0,255}),
        Line(
          points={{-40,20},{-40,-20}},
          color={0,0,255}),
        Line(
          points={{60,20},{60,-20}},
          color={0,0,255}),
        Line(
          points={{-90,0},{-60,0}},
          color={0,0,255}),
        Line(
          points={{60,0},{90,0}},
          color={0,0,255}),
        Text(
          extent={{-150,110},{150,70}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-40,0},{-10,0}},
          color={0,0,255}),
        Line(
          points={{10,0},{40,0}},
          color={0,0,255}),
        Text(
          extent={{-100,40},{-80,20}},
          textColor={0,0,255},
          textString="+"),
        Text(
          extent={{80,40},{100,20}},
          textColor={0,0,255},
          textString="-"),
        Text(
          extent={{-10,40},{10,20}},
          textColor={0,0,255},
          textString="0"),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultableSupplyVoltage 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
                       <p>This is a simple model of a constant supply voltage with positive and negative supply, the potential between positive and negative supply is accessible.</p>
                       </html>"));
end FaultableSupplyVoltage;

