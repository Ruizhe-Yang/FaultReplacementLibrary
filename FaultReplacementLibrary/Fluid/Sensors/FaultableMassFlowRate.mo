within FaultReplacementLibrary.Fluid.Sensors;
model FaultableMassFlowRate "MassFlowRate fluid flow sensor with local signal faults"
  replaceable package Medium=Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium) annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium) annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow(unit="kg/s") annotation(Placement(transformation(origin={0,110},extent={{10,-10},{-10,10}},rotation=270)));
  type FaultMode=enumeration(Normal "正常", Bias "偏置", GainError "增益误差", NoiseIncrease "噪声增加", Stuck "输出卡死", Dropout "输出丢失", Saturation "输出饱和");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real biasFault=1;
  parameter Real gainFault=0.9;
  parameter Real noiseAmplitude=0.01;
  parameter Modelica.Units.SI.Frequency noiseFrequency=37;
  parameter Real stuckValue=0;
  parameter Real saturationLimit=1e12;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real measuredActual;
  Modelica.Fluid.Sensors.MassFlowRate nominal(redeclare package Medium=Medium);
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  connect(port_a,nominal.port_a);
  connect(port_b,nominal.port_b);
  measuredActual=nominal.m_flow;
  m_flow=if faultMode==FaultMode.Bias then measuredActual+faultActivation*biasFault elseif faultMode==FaultMode.GainError then measuredActual*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then measuredActual+faultActivation*noiseAmplitude*sin(2*Modelica.Constants.pi*noiseFrequency*time) elseif faultMode==FaultMode.Stuck then measuredActual+faultActivation*(stuckValue-measuredActual) elseif faultMode==FaultMode.Dropout then measuredActual*(1-faultActivation) elseif faultMode==FaultMode.Saturation then measuredActual+faultActivation*(min(saturationLimit,max(-saturationLimit,measuredActual))-measuredActual) else measuredActual;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableMassFlowRate 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    Icon(graphics={Ellipse(extent={{-70,70},{70,-70}},lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableMassFlowRate;

