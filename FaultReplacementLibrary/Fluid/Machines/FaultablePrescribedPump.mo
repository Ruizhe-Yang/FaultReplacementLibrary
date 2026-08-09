within FaultReplacementLibrary.Fluid.Machines;
model FaultablePrescribedPump "PrescribedPump with rotational-speed faults"
  replaceable package Medium=Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium "工作介质";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium)
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal=1500;
  parameter Boolean use_N_in=false;
  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_const=N_nominal;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal[3]={0,0.001,0.002};
  parameter Modelica.Units.SI.Position head_nominal[3]={20,10,0};
  Modelica.Blocks.Interfaces.RealInput N_in(unit="rev/min") if use_N_in annotation(Placement(transformation(extent={{-20,80},{20,120}})));
  type FaultMode=enumeration(Normal "正常", SpeedLoss "转速下降", SpeedDrift "转速漂移", StuckSpeed "转速卡死", PumpTrip "泵跳闸");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real speedScaleFault=0.5;
  parameter Modelica.Units.NonSI.AngularVelocity_rpm stuckSpeed=0;
  Real speedCommand;
  Real speedEffective;
  Modelica.Fluid.Machines.PrescribedPump nominal(
    redeclare package Medium=Medium,N_nominal=N_nominal,use_N_in=true,
    redeclare function flowCharacteristic=Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal=V_flow_nominal,head_nominal=head_nominal));
protected
  Modelica.Blocks.Interfaces.RealInput N_in_internal(unit="rev/min");
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  connect(N_in,N_in_internal);
  if not use_N_in then
    N_in_internal=N_const;
  end if;
  speedCommand=N_in_internal;
  speedEffective=if faultMode==FaultMode.SpeedLoss or faultMode==FaultMode.SpeedDrift then speedCommand*(1+faultActivation*(speedScaleFault-1)) elseif faultMode==FaultMode.StuckSpeed then speedCommand+faultActivation*(stuckSpeed-speedCommand) elseif faultMode==FaultMode.PumpTrip then speedCommand*(1-faultActivation) else speedCommand;
  nominal.N_in=max(speedEffective,1e-3);
  connect(port_a,nominal.port_a);connect(port_b,nominal.port_b);
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Ellipse(extent={{-70,70},{70,-70}},lineColor={255,0,0},fillColor={0,127,255},fillPattern=FillPattern.Solid),Text(extent={{-150,90},{150,50}},textString="%name",textColor={0,0,255}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),Documentation(info="<html><p>用法：将 FaultablePrescribedPump 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p><p>本模型保留 Modelica.Fluid 的 replaceable Medium、FluidPort 和 stream 连接语义。名义 MSL 组件作为内部正常物理模型；故障支路、控制量变换及激活方程全部在本文件可见，Normal 或 severity=0 时透明。</p></html>"));
end FaultablePrescribedPump;
