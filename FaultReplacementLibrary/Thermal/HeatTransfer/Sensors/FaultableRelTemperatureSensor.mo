within FaultReplacementLibrary.Thermal.HeatTransfer.Sensors;
model FaultableRelTemperatureSensor "Relative temperature sensor"
  extends Modelica.Icons.RectangularSensor;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation (Placement(transformation(extent={{
            90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_rel(unit="K", displayUnit="K")
    "Relative temperature as output signal"
    annotation (absoluteValue=false, Placement(transformation(
        origin={0,-110},
        extent={{10,-10},{-10,10}},
        rotation=90), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-110})));
  type FaultMode=enumeration(Normal "正常", Bias "偏置", GainError "增益误差", NoiseIncrease "噪声增加", Stuck "输出卡死", Dropout "输出丢失", Saturation "输出饱和");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real biasFault=1;
  parameter Real gainFault=0.9;
  parameter Real noiseAmplitude=0.01;
  parameter Modelica.Units.SI.Frequency noiseFrequency=37;
  parameter Real stuckValue=0;
  parameter Real saturationLimit=1e9;
  Real T_rel_actual;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;

  T_rel_actual=port_a.T-port_b.T;
  T_rel=if faultMode==FaultMode.Bias then T_rel_actual+faultActivation*biasFault elseif faultMode==FaultMode.GainError then T_rel_actual*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then T_rel_actual+faultActivation*noiseAmplitude*sin(2*Modelica.Constants.pi*noiseFrequency*time) elseif faultMode==FaultMode.Stuck then T_rel_actual+faultActivation*(stuckValue-T_rel_actual) elseif faultMode==FaultMode.Dropout then T_rel_actual*(1-faultActivation) elseif faultMode==FaultMode.Saturation then T_rel_actual+faultActivation*(min(saturationLimit,max(-saturationLimit,T_rel_actual))-T_rel_actual) else T_rel_actual;
  0 = port_a.Q_flow;
  0 = port_b.Q_flow;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(points={{-90,0},{-70,0},{-70,0}}, color={191,0,0}),
        Line(points={{-90,0},{-70,0},{-70,0}}, color={191,0,0}),
        Line(points={{70,0},{90,0},{90,0}}, color={191,0,0}),
        Line(points={{0,-38},{0,-100}},color={0,0,127}),
        Text(
          extent={{-150,80},{150,40}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-24,20},{66,-40}},
          textColor={64,64,64},
          textString="K"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultableRelTemperatureSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The relative temperature \"port_a.T - port_b.T\" is determined between
the two ports of this component and is provided as output signal in Kelvin.
</p>
</html>"));
end FaultableRelTemperatureSensor;
