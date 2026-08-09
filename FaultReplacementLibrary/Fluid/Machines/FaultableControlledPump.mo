within FaultReplacementLibrary.Fluid.Machines;
model FaultableControlledPump "ControlledPump with set-point and performance faults"
  replaceable package Medium=Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium "工作介质";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  parameter Medium.AbsolutePressure p_a_nominal=1e5;
  parameter Medium.AbsolutePressure p_b_nominal=2e5;
  parameter Medium.MassFlowRate m_flow_nominal=1;
  parameter Boolean control_m_flow=true;
  parameter Boolean use_m_flow_set=false;
  parameter Boolean use_p_set=false;
  Modelica.Blocks.Interfaces.RealInput m_flow_set(unit="kg/s") if use_m_flow_set annotation(Placement(transformation(extent={{-70,70},{-30,110}})));
  Modelica.Blocks.Interfaces.RealInput p_set(unit="Pa") if use_p_set annotation(Placement(transformation(extent={{30,70},{70,110}})));
  type FaultMode=enumeration(Normal "正常", OutputLoss "泵输出丢失", SetpointBias "设定值偏置", GainLoss "控制增益下降", StuckCommand "控制指令卡死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real gainFault=0.5;
  parameter Medium.MassFlowRate massFlowBias=0;
  parameter Modelica.Units.SI.PressureDifference pressureBias=0;
  parameter Real stuckMassFlow=0;
  parameter Modelica.Units.SI.Pressure stuckPressure=p_b_nominal;
  Real m_flow_command;
  Real p_command;
  Modelica.Fluid.Machines.ControlledPump nominal(redeclare package Medium=Medium,p_a_nominal=p_a_nominal,p_b_nominal=p_b_nominal,m_flow_nominal=m_flow_nominal,control_m_flow=control_m_flow,use_m_flow_set=true,use_p_set=true);
protected
  Modelica.Blocks.Interfaces.RealInput m_flow_set_internal(unit="kg/s");
  Modelica.Blocks.Interfaces.RealInput p_set_internal(unit="Pa");
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  connect(m_flow_set,m_flow_set_internal);
  connect(p_set,p_set_internal);
  if not use_m_flow_set then
    m_flow_set_internal=m_flow_nominal;
  end if;
  if not use_p_set then
    p_set_internal=p_b_nominal;
  end if;
  m_flow_command=m_flow_set_internal;
  p_command=p_set_internal;
  nominal.m_flow_set=if faultMode==FaultMode.OutputLoss then m_flow_command*(1-faultActivation) elseif faultMode==FaultMode.SetpointBias then m_flow_command+faultActivation*massFlowBias elseif faultMode==FaultMode.GainLoss then m_flow_command*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.StuckCommand then m_flow_command+faultActivation*(stuckMassFlow-m_flow_command) else m_flow_command;
  nominal.p_set=if faultMode==FaultMode.OutputLoss then port_a.p+(p_command-port_a.p)*(1-faultActivation) elseif faultMode==FaultMode.SetpointBias then p_command+faultActivation*pressureBias elseif faultMode==FaultMode.GainLoss then port_a.p+(p_command-port_a.p)*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.StuckCommand then p_command+faultActivation*(stuckPressure-p_command) else p_command;
  connect(port_a,nominal.port_a);connect(port_b,nominal.port_b);
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Ellipse(extent={{-70,70},{70,-70}},lineColor={255,0,0},fillColor={0,127,255},fillPattern=FillPattern.Solid),Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),Documentation(info="<html><p>用法：将 FaultableControlledPump 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>本模型保留 Modelica.Fluid 的 replaceable Medium、FluidPort 和 stream 连接语义。名义 MSL 组件作为内部正常物理模型；故障支路、控制量变换及激活方程全部在本文件可见，Normal 或 severity=0 时透明。</p></html>"));
end FaultableControlledPump;
