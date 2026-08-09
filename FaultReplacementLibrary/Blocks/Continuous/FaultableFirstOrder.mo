within FaultReplacementLibrary.Blocks.Continuous;
block FaultableFirstOrder "Independent fault-enhanced MSL 4.0.0 FirstOrder"
  import Init=Modelica.Blocks.Types.Init;
  parameter Real k(unit="1")=1 "Gain";
  parameter Modelica.Units.SI.Time T(start=1) "Time constant";
  parameter Init initType=Init.NoInit annotation(Evaluate=true,Dialog(group="Initialization"));
  parameter Real y_start=0 annotation(Dialog(group="Initialization"));
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start));
  type FaultMode=enumeration(Normal, GainDrift, TimeConstantDrift, Bias, Stuck, Dropout);
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real kFault=0.5*k;
  parameter Modelica.Units.SI.Time TFault(min=Modelica.Constants.eps)=2*T;
  parameter Real biasFault=1;
  Real faultActivation(min=0,max=1),startActivation(min=0,max=1),endActivation(min=0,max=1),k_effective;
  Modelica.Units.SI.Time T_effective;
  Real x(start=y_start);
initial equation
  if initType==Init.SteadyState then
    der(x)=0;
  elseif initType==Init.InitialState or initType==Init.InitialOutput then
    x=y_start;
  end if;
equation
  startActivation=if time<faultStartTime then 0 elseif transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 elseif transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  k_effective=if faultMode==FaultMode.GainDrift then k+faultActivation*(kFault-k) else k;
  T_effective=if faultMode==FaultMode.TimeConstantDrift then T+faultActivation*(TFault-T) else T;
  der(x)=(if faultMode==FaultMode.Stuck then 1-faultActivation else 1)*(k_effective*u-x)/T_effective;
  y=if faultMode==FaultMode.Bias then x+faultActivation*biasFault elseif faultMode==FaultMode.Dropout then (1-faultActivation)*x else x;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableFirstOrder 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    Icon(graphics={Line(points={{-80,-80},{-20,30},{80,70}},color={255,0,0},smooth=Smooth.Bezier),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableFirstOrder;
