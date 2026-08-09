within FaultReplacementLibrary.Mechanics.Translational.Sensors;
model FaultableRelPositionSensor "Independent fault-enhanced MSL 4.0.0 RelPositionSensor"
  extends Modelica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
  Modelica.Blocks.Interfaces.RealOutput s_rel(unit="m") annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={0,-110})));
  type FaultMode=enumeration(Normal, Bias, GainError, NoiseIncrease, Stuck, Dropout, Saturation);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real biasFault=1;
  parameter Real gainFault=0.5;
  parameter Real stuckValue=0;
  parameter Real saturationLimit=1e9;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),s_rel_raw;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  s_rel_raw=flange_b.s-flange_a.s;
  0=flange_a.f;
  s_rel=if faultMode==FaultMode.Bias then s_rel_raw+faultActivation*biasFault elseif faultMode==FaultMode.GainError then s_rel_raw*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then s_rel_raw+faultActivation*biasFault*sin(997*time) elseif faultMode==FaultMode.Stuck then s_rel_raw+faultActivation*(stuckValue-s_rel_raw) elseif faultMode==FaultMode.Dropout then (1-faultActivation)*s_rel_raw elseif faultMode==FaultMode.Saturation then min(saturationLimit,max(-saturationLimit,s_rel_raw)) else s_rel_raw;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableRelPositionSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="relPositionSensor",Icon(graphics={Ellipse(extent={{-70,70},{70,-70}},lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableRelPositionSensor;
