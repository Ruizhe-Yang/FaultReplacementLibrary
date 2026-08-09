within FaultReplacementLibrary.Thermal.FluidHeatFlow.Components;
model FaultableOneWayValve "Simple one-way valve"
  extends Modelica.Thermal.FluidHeatFlow.BaseClasses.TwoPort(m(start=0), final tapT=1);

  parameter Modelica.Units.SI.VolumeFlowRate V_flowNominal(start=1) "Nominal volume flow rate (forward)";
  parameter Modelica.Units.SI.Pressure dpForward(displayUnit="bar")=1e-6 "Pressure drop at nominal flow (forward)";
  parameter Modelica.Units.SI.Pressure dpNominal(displayUnit="bar", start=1e5) "Nominal pressure (backward)";
  parameter Modelica.Units.SI.VolumeFlowRate V_flowBackward(start=1E-6) "Leakage volume flow rate (backward)";
  parameter Real frictionLoss(min=0, max=1, start=0)
    "Part of friction losses fed to medium";
  Boolean backward(start=true) "State forward=false / backward=true";
protected
  Real s(start=0, final unit="1")
    "Auxiliary variable for actual position on the valve characteristic";
  /* s < 0: backward, leakage flow
         s > 0: forward, small pressure drop */
  constant Modelica.Units.SI.VolumeFlowRate unitVolumeFlowRate = 1;
public
  constant Modelica.Units.SI.Pressure unitPressureDrop = 1;  type FaultMode=enumeration(Normal "正常", StuckClosed "单向阀卡闭", StuckOpen "单向阀卡开", ForwardResistanceIncrease "正向阻力增加", ReverseLeakageIncrease "反向泄漏增加");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Pressure dpForwardFault=10*dpForward;
  parameter Modelica.Units.SI.VolumeFlowRate reverseLeakFault=100*V_flowBackward;
  Modelica.Units.SI.Pressure dpForward_effective;
  Modelica.Units.SI.VolumeFlowRate V_flowBackward_effective;
  Boolean backward_effective;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  backward_effective=if faultMode==FaultMode.StuckClosed and faultActivation>0.5 then true elseif faultMode==FaultMode.StuckOpen and faultActivation>0.5 then false else s<0;
  backward=backward_effective;
  dpForward_effective=if faultMode==FaultMode.ForwardResistanceIncrease or faultMode==FaultMode.StuckClosed then dpForward+faultActivation*(dpForwardFault-dpForward) else dpForward;
  V_flowBackward_effective=if faultMode==FaultMode.ReverseLeakageIncrease or faultMode==FaultMode.StuckOpen then V_flowBackward+faultActivation*(reverseLeakFault-V_flowBackward) else V_flowBackward;
  dp=(s*unitVolumeFlowRate)*(if backward_effective then 1 else dpForward_effective/V_flowNominal);
  V_flow=(s*unitPressureDrop)*(if backward_effective then V_flowBackward_effective/dpNominal else 1);
  Q_flow = frictionLoss*V_flow*dp;
annotation (Documentation(info="<html><p>用法：将 FaultableOneWayValve 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Simple one-way valve, comparable to the electrical <a href=\"modelica://Modelica.Electrical.Analog.Ideal.IdealDiode\">ideal diode</a> model.</p>
<ul>
<li>from flowPort_a to flowPort_b: small pressure drop, linearly dependent on volumeFlow</li>
<li>from flowPort_b to flowPort_a: small leakage flow, linearly dependent on pressure drop</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-90,10},{-60,10},{-60,60},{0,0},{60,60},{60,10},{90,10},{90,-10},
              {60,-10},{60,-60},{0,0},{-60,-60},{-60,-10},{-90,-10},{-90,10}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(extent={{-150,-70},{150,-110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-60,60},{60,-60},{50,-40},{40,-50},{60,-60}},
          thickness=0.5),
        Polygon(
          points={{50,-40},{60,-60},{40,-50},{50,-40}},
          fillPattern=FillPattern.Solid),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableOneWayValve;
