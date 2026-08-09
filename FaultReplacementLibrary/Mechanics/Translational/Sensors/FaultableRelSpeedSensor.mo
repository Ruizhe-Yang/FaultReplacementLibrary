within FaultReplacementLibrary.Mechanics.Translational.Sensors;
model FaultableRelSpeedSensor "Independent fault-enhanced MSL 4.0.0 RelSpeedSensor"
  extends Modelica.Mechanics.Translational.Interfaces.PartialRelativeSensor;
  Modelica.Blocks.Interfaces.RealOutput v_rel(unit="m/s") annotation(Placement(transformation(extent={{-10,-10},{10,10}},rotation=270,origin={0,-110})));
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
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),v_rel_raw;
  Modelica.Units.SI.Position s_rel_internal;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  s_rel_internal=flange_b.s-flange_a.s;
  v_rel_raw=der(s_rel_internal);
  0=flange_a.f;
  v_rel=if faultMode==FaultMode.Bias then v_rel_raw+faultActivation*biasFault elseif faultMode==FaultMode.GainError then v_rel_raw*(1+faultActivation*(gainFault-1)) elseif faultMode==FaultMode.NoiseIncrease then v_rel_raw+faultActivation*biasFault*sin(997*time) elseif faultMode==FaultMode.Stuck then v_rel_raw+faultActivation*(stuckValue-v_rel_raw) elseif faultMode==FaultMode.Dropout then (1-faultActivation)*v_rel_raw elseif faultMode==FaultMode.Saturation then min(saturationLimit,max(-saturationLimit,v_rel_raw)) else v_rel_raw;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableRelSpeedSensor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    defaultComponentName="relSpeedSensor",Icon(graphics={Ellipse(extent={{-70,70},{70,-70}},lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableRelSpeedSensor;
