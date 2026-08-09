within FaultReplacementLibrary.Electrical.Analog.Sources;
model FaultableSineCurrent "SineCurrent 独立故障增强模型"
  type FaultMode=enumeration(Normal "正常", OutputLoss "输出丢失", AmplitudeDrift "幅值漂移", AmplitudeDrop "幅值下降", OffsetDrift "偏置漂移", FrequencyDrift "频率漂移", StuckOutput "输出卡死");
  parameter Modelica.Units.SI.Current I(start=1) "Amplitude of sine wave";
  parameter Modelica.Units.SI.Angle phase=0 "Phase of sine wave";
  parameter Modelica.Units.SI.Frequency f(start=1) "Frequency of sine wave";
  parameter Modelica.Units.SI.Current offset=0 "Output offset";
  parameter Modelica.Units.SI.Time startTime=0 "Time offset";

  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Icons.CurrentSource;
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Real amplitudeFault=0.5 "幅值漂移目标比例";
  parameter Real offsetFault=0 "偏置漂移目标值";
  parameter Real frequencyFault=0.5 "频率漂移目标比例";
  parameter Real stuckOutput=0 "输出卡死值";
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  Real nominalOutput;
  Real effectiveOutput;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  effectiveOutput = if faultMode == FaultMode.OutputLoss then nominalOutput*(1-faultActivation)
    elseif faultMode == FaultMode.AmplitudeDrift or faultMode == FaultMode.AmplitudeDrop then nominalOutput*(1+faultActivation*(amplitudeFault-1))
    elseif faultMode == FaultMode.OffsetDrift then nominalOutput+faultActivation*offsetFault
    elseif faultMode == FaultMode.StuckOutput then nominalOutput+faultActivation*(stuckOutput-nominalOutput)
    else nominalOutput;
  nominalOutput = offset + (if time < startTime then 0 else I*sin(2*Modelica.Constants.pi*f*(1+faultActivation*(if faultMode==FaultMode.FrequencyDrift then frequencyFault-1 else 0))*(time-startTime)+phase));
  i = effectiveOutput;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Line(points={{-70,0},{-60.2,29.9},{-53.8,46.5},
              {-48.2,58.1},{-43.3,65.2},{-38.3,69.2},{-33.4,69.8},{-28.5,67},
              {-23.6,61},{-18.6,52},{-13,38.6},{-5.98,18.6},{8.79,-26.9},{
              15.1,-44},{20.8,-56.2},{25.7,-64},{30.6,-68.6},{35.5,-70},{40.5,
              -67.9},{45.4,-62.5},{50.3,-54.1},{55.9,-41.3},{63,-21.7},{70,0}},
            color={192,192,192}),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}),Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(revisions="<html>
<ul>
<li><em> 1998   </em>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>",
        info="<html><p>用法：将 FaultableSineCurrent 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>This current source uses the corresponding signal source of the Modelica.Blocks.Sources package. Care for the meaning of the parameters in the Blocks package. Furthermore, an offset parameter is introduced, which is added to the value calculated by the blocks source. The startTime parameter allows to shift the blocks source behavior on the time axis.</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Electrical/Analog/Sources/SineCurrent.png\"
     alt=\"SineCurrent.png\">
</p>
</html>"));

end FaultableSineCurrent;
