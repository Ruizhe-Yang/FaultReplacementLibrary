within FaultReplacementLibrary.Thermal.HeatTransfer.Sensors;
model FaultableTemperatureSensor "Absolute temperature sensor in Kelvin"

  Modelica.Blocks.Interfaces.RealOutput T(unit="K")
    "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}})));
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
  Real T_actual;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;

  T_actual=port.T;
  T=if faultMode==FaultMode.Bias then T_actual+faultActivation*biasFault elseif faultMode==FaultMode.GainError then T_actual*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then T_actual+faultActivation*noiseAmplitude*sin(2*Modelica.Constants.pi*noiseFrequency*time) elseif faultMode==FaultMode.Stuck then T_actual+faultActivation*(stuckValue-T_actual) elseif faultMode==FaultMode.Dropout then T_actual*(1-faultActivation) elseif faultMode==FaultMode.Saturation then T_actual+faultActivation*(min(saturationLimit,max(-saturationLimit,T_actual))-T_actual) else T_actual;
  port.Q_flow = 0;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{100,0}},color={0,0,127}),
        Line(points={{-90,0},{-12,0}}, color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},
              {12,80},{12,40},{-12,40}},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}),
        Line(points={{-40,20},{-12,20}}),
        Line(points={{-40,60},{-12,60}}),
        Text(
          extent={{-150,140},{150,100}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{20,60},{80,0}},
          textColor={64,64,64},
          textString="K"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultableTemperatureSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
This is an ideal absolute temperature sensor which returns
the temperature of the connected port in Kelvin as an output
signal.  The sensor itself has no thermal interaction with
whatever it is connected to.  Furthermore, no
thermocouple-like lags are associated with this
sensor model.
</p>
</html>"));
end FaultableTemperatureSensor;
