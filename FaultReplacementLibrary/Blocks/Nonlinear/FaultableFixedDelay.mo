within FaultReplacementLibrary.Blocks.Nonlinear;
block FaultableFixedDelay "Independent fault-enhanced MSL 4.0.0 FixedDelay"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Modelica.Units.SI.Time delayTime(start=1) "Delay time";
  type FaultMode=enumeration(Normal, DelayDrift, DelayIncrease, DelayDecrease, Bias, Dropout);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.Time delayTimeFault(min=0)=2*delayTime;
  parameter Real biasFault=1;
  final parameter Modelica.Units.SI.Time delayMax=max(delayTime,delayTimeFault);
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),y_raw;
  Modelica.Units.SI.Time delayTime_effective;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  delayTime_effective=if faultMode==FaultMode.DelayDrift or faultMode==FaultMode.DelayIncrease or faultMode==FaultMode.DelayDecrease then delayTime+faultActivation*(delayTimeFault-delayTime) else delayTime;
  y_raw=delay(u,delayTime_effective,delayMax);
  y=if faultMode==FaultMode.Bias then y_raw+faultActivation*biasFault elseif faultMode==FaultMode.Dropout then (1-faultActivation)*y_raw else y_raw;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableFixedDelay 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    Icon(graphics={Line(points={{-90,0},{-60,70},{-30,-60},{0,70},{30,-60},{60,0},{90,0}},color={255,0,0},smooth=Smooth.Bezier),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableFixedDelay;
