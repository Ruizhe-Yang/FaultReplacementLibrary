within FaultReplacementLibrary.Thermal.HeatTransfer.Components;
model FaultableGeneralHeatFlowToTemperatureAdaptor
  "Signal adaptor for a HeatTransfer port with temperature and derivative of temperature as outputs and heat flow as input (especially useful for FMUs)"
  extends Modelica.Blocks.Interfaces.Adaptors.FlowToPotentialAdaptor(
    final Name_p="T",
    final Name_pder="dT",
    final Name_pder2="d2T",
    final Name_f="Q",
    final Name_fder="der(Q)",
    final Name_fder2="der2(Q)",
    final use_pder2=false,
    final use_fder=false,
    final use_fder2=false,
    p(unit="K", displayUnit="degC"),
    final pder(unit="K/s"),
    final pder2(unit="K/s2"),
    final f(unit="W"),
    final fder(unit="W/s"),
    final fder2(unit="W/s2"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  type FaultMode=enumeration(Normal "正常", TemperatureBias "温度偏置", TemperatureGainError "温度增益误差", TemperatureStuck "温度卡死", TemperatureDropout "温度丢失");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.TemperatureDifference biasFault=1;
  parameter Real gainFault=0.9;
  parameter Modelica.Units.SI.Temperature stuckTemperature=293.15;
  Modelica.Units.SI.Temperature temperatureActual;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  temperatureActual=heatPort.T;
  y=if faultMode==FaultMode.TemperatureBias then temperatureActual+faultActivation*biasFault elseif faultMode==FaultMode.TemperatureGainError then temperatureActual*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.TemperatureStuck then temperatureActual+faultActivation*(stuckTemperature-temperatureActual) elseif faultMode==FaultMode.TemperatureDropout then temperatureActual*(1-faultActivation) else temperatureActual;
  u = heatPort.Q_flow "input = flow = heat flow";
  annotation (defaultComponentName="heatFlowToTemperatureAdaptor",
    Documentation(info="<html><p>用法：将 FaultableGeneralHeatFlowToTemperatureAdaptor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
Adaptor between a heatport connector and a signal representation of the flange.
This component is used to provide a pure signal interface around a HeatTransfer model
and export this model in form of an input/output block,
especially as FMU (<a href=\"https://fmi-standard.org\">Functional Mock-up Unit</a>).
Examples of the usage of this adaptor are provided in
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Examples.GenerationOfFMUs\">HeatTransfer.Examples.GenerationOfFMUs</a>.
This adaptor has heatflow as input and temperature and derivative of temperature as output signals.
</p>
</html>"),
    Icon(graphics={
            Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={191,0,0},
          radius=10,
          lineThickness=0.5),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableGeneralHeatFlowToTemperatureAdaptor;
