within FaultReplacementLibrary.Fluid.Valves;
model FaultableValveDiscrete "ValveDiscrete with inline Boolean actuator faults"
  replaceable package Medium=Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium "工作介质";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  parameter Modelica.Units.SI.AbsolutePressure dp_nominal=1e5;
  parameter Medium.MassFlowRate m_flow_nominal=1;
  parameter Real opening_min(min=0)=0;
  type FaultMode=enumeration(Normal "正常", StuckClosed "阀门卡闭", StuckOpen "阀门卡开", CommandInvert "指令反相", LeakageIncrease "泄漏增加");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Modelica.Blocks.Interfaces.BooleanInput open annotation(Placement(transformation(origin={0,80},extent={{-20,-20},{20,20}},rotation=270)));
  Boolean open_effective;
  Modelica.Fluid.Valves.ValveDiscrete nominal(redeclare package Medium=Medium,dp_nominal=dp_nominal,m_flow_nominal=m_flow_nominal,opening_min=opening_min);
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  open_effective=if faultMode==FaultMode.StuckClosed and faultActivation>0.5 then false elseif faultMode==FaultMode.StuckOpen and faultActivation>0.5 then true elseif faultMode==FaultMode.CommandInvert and faultActivation>0.5 then not open elseif faultMode==FaultMode.LeakageIncrease and faultActivation>0.5 then true else open;
  nominal.open=open_effective;
  connect(port_a,nominal.port_a);connect(port_b,nominal.port_b);
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Polygon(points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},lineColor={255,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),Documentation(info="<html><p>用法：将 FaultableValveDiscrete 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>本模型保留 Modelica.Fluid 的 replaceable Medium、FluidPort 和 stream 连接语义。名义 MSL 组件作为内部正常物理模型；故障支路、控制量变换及激活方程全部在本文件可见，Normal 或 severity=0 时透明。</p></html>"));
end FaultableValveDiscrete;
