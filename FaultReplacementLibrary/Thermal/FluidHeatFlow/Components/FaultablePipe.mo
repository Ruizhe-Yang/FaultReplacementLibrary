within FaultReplacementLibrary.Thermal.FluidHeatFlow.Components;
model FaultablePipe "Pipe with optional heat exchange"
  extends Modelica.Thermal.FluidHeatFlow.BaseClasses.TwoPort;
  extends Modelica.Thermal.FluidHeatFlow.BaseClasses.SimpleFriction;

  parameter Boolean useHeatPort = false "= true, if HeatPort is enabled"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.Units.SI.Length h_g(start=0)
    "Geodetic height (height difference from flowPort_a to flowPort_b)";
  parameter Modelica.Units.SI.Acceleration g(final min=0)=Modelica.Constants.g_n "Gravitation";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(T=T_q, Q_flow=Q_flowHeatPort) if useHeatPort
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  type FaultMode=enumeration(Normal "正常", PressureLossIncrease "压降增加", Blockage "堵塞", Leakage "泄漏", HeatTransferLoss "换热损失");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.Pressure pressureDropFault=1e5;
  parameter Real heatTransferScaleFault(min=0)=0.5;
  Modelica.Units.SI.Pressure addedPressureDrop;
  Real heatTransferScale;
protected
  Modelica.Units.SI.HeatFlowRate Q_flowHeatPort "Heat flow at conditional heatPort";
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  if not useHeatPort then
    Q_flowHeatPort=0;
  end if;
  // coupling with FrictionModel
  volumeFlow = V_flow;
  addedPressureDrop=if faultMode==FaultMode.PressureLossIncrease then faultActivation*pressureDropFault*sign(V_flow) elseif faultMode==FaultMode.Blockage then faultActivation*1e9*V_flow elseif faultMode==FaultMode.Leakage then -faultActivation*0.5*pressureDrop else 0;
  dp=pressureDrop+medium.rho*g*h_g+addedPressureDrop;
  // energy exchange with medium
  heatTransferScale=if faultMode==FaultMode.HeatTransferLoss then 1+faultActivation*(heatTransferScaleFault-1) else 1;
  Q_flow=heatTransferScale*Q_flowHeatPort+Q_friction;
annotation (Documentation(info="<html><p>用法：将 FaultablePipe 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Pipe with optional heat exchange.</p>
<p>
Thermodynamic equations are defined by BaseClasses.TwoPort.
Q_flow is defined by heatPort.Q_flow (useHeatPort=true) or zero (useHeatPort=false).</p>
<p>
<strong>Note:</strong> Setting parameter m (mass of medium within pipe) to zero
leads to neglect of temperature transient cv*m*der(T).
</p>
<p>
<strong>Note:</strong> Injecting heat into a pipe with zero mass flow causes
temperature rise defined by storing heat in medium's mass.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-90,20},{90,-20}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(visible=useHeatPort,
          points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,-90}},
          lineColor={255,0,0}),           Text(extent={{-150,80},{150,40}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultablePipe;

