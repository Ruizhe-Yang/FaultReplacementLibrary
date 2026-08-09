within FaultReplacementLibrary.Mechanics.Translational.Components;
model FaultableIdealGearR2T "Faultable ideal rotational-to-translational gear"
  extends Modelica.Mechanics.Rotational.Interfaces.PartialElementaryRotationalToTranslational;
  parameter Real ratio(start=1) "Transmission ratio (flangeR.phi/flangeT.s)";
  type FaultMode=enumeration(Normal "正常", GearRatioError "传动比误差", Slip "传动打滑", LockedGear "传动锁死");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real ratioFault=0.9*ratio;
  parameter Real slipRatioFault(min=0,max=1)=0.2;
  Real ratio_effective;
  Real transmissionScale;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  ratio_effective=if faultMode==FaultMode.GearRatioError then ratio+faultActivation*(ratioFault-ratio) else ratio;
  transmissionScale=if faultMode==FaultMode.Slip then 1-faultActivation*slipRatioFault elseif faultMode==FaultMode.LockedGear then 1-faultActivation else 1;
  (flangeR.phi-internalSupportR.phi)=ratio_effective*(flangeT.s-internalSupportT.s)*transmissionScale;
  0=ratio_effective*flangeR.tau+flangeT.f;
  annotation(
    Documentation(info="<html><p>用法：将 FaultableIdealGearR2T 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p></html>"),
    Icon(graphics={Rectangle(extent={{-60,60},{60,-60}},lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealGearR2T;

