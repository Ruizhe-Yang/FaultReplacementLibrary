within FaultReplacementLibrary.Thermal.FluidHeatFlow.Sensors;
model FaultableEnthalpyFlowSensor "Enthalpy flow sensor"

  extends Modelica.Thermal.FluidHeatFlow.Interfaces.FlowSensor(y(unit="W")
      "Enthalpy flow as output signal");
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
  parameter Real saturationLimit=1e12;
  Real y_actual;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;

  y_actual=flowPort_a.H_flow;
  y=if faultMode==FaultMode.Bias then y_actual+faultActivation*biasFault elseif faultMode==FaultMode.GainError then y_actual*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then y_actual+faultActivation*noiseAmplitude*sin(2*Modelica.Constants.pi*noiseFrequency*time) elseif faultMode==FaultMode.Stuck then y_actual+faultActivation*(stuckValue-y_actual) elseif faultMode==FaultMode.Dropout then y_actual*(1-faultActivation) elseif faultMode==FaultMode.Saturation then y_actual+faultActivation*(min(saturationLimit,max(-saturationLimit,y_actual))-y_actual) else y_actual;
  annotation (
    Documentation(info="<html><p>用法：将 FaultableEnthalpyFlowSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The EnthalpyFlowSensor measures the enthalpy flow rate.</p>
<p>Thermodynamic equations are defined by Interfaces.FlowSensor.</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-30,-10},{30,-70}},
          textColor={64,64,64},
          textString="W"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableEnthalpyFlowSensor;

