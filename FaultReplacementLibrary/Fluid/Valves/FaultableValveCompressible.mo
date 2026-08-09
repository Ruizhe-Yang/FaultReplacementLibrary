within FaultReplacementLibrary.Fluid.Valves;
model FaultableValveCompressible "ValveCompressible with inline opening faults"
  replaceable package Medium=Modelica.Media.Air.SimpleAir constrainedby Modelica.Media.Interfaces.PartialMedium "工作介质";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  parameter Modelica.Units.SI.Pressure dp_nominal=1e5 "Nominal pressure drop";
  parameter Medium.MassFlowRate m_flow_nominal=1 "Nominal mass flow rate";
  parameter Real opening_nominal(min=0,max=1)=1 "Nominal opening";
  parameter Real opening_min(min=0,max=1)=0 "Remaining opening at closed command";
  parameter Real Fxt_full=0.5 "Nominal choked-flow factor";
  type FaultMode=enumeration(Normal "正常", StuckClosed "阀门卡闭", StuckOpen "阀门卡开", OpeningBias "开度偏置", ActuatorGainLoss "执行器增益下降", LeakageIncrease "泄漏增加");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real stuckOpening(min=0,max=1)=0;
  parameter Real openingBias=0.1;
  parameter Real actuatorGainFault(min=0,max=1)=0.5;
  Modelica.Blocks.Interfaces.RealInput opening annotation(Placement(transformation(origin={0,100},extent={{-20,-20},{20,20}},rotation=270)));
  Real opening_effective(min=0,max=1);
  Modelica.Fluid.Valves.ValveCompressible nominal(
    redeclare package Medium=Medium,
    dp_nominal=dp_nominal,m_flow_nominal=m_flow_nominal,opening_nominal=opening_nominal,Fxt_full=Fxt_full);
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  opening_effective=max(opening_min,min(1,if faultMode==FaultMode.StuckClosed then opening+faultActivation*(stuckOpening-opening)
    elseif faultMode==FaultMode.StuckOpen then opening+faultActivation*(1-opening)
    elseif faultMode==FaultMode.OpeningBias then opening+faultActivation*openingBias
    elseif faultMode==FaultMode.ActuatorGainLoss then opening*(1+faultActivation*(actuatorGainFault-1))
    elseif faultMode==FaultMode.LeakageIncrease then max(opening,faultActivation*0.2) else opening));
  nominal.opening=opening_effective;
  connect(port_a,nominal.port_a);
  connect(port_b,nominal.port_b);
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Polygon(points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},lineColor={255,0,0},fillColor={255,255,255},fillPattern=FillPattern.Solid),Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),Documentation(info="<html><p>用法：将 FaultableValveCompressible 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>本模型保留 Modelica.Fluid 的 replaceable Medium、FluidPort 和 stream 连接语义。名义 MSL 组件作为内部正常物理模型；故障支路、控制量变换及激活方程全部在本文件可见，Normal 或 severity=0 时透明。</p></html>"));
end FaultableValveCompressible;

