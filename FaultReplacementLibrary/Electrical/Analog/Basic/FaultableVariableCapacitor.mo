within FaultReplacementLibrary.Electrical.Analog.Basic;
model FaultableVariableCapacitor
  "Ideal linear electrical capacitor with variable capacitance"
  import SI = Modelica.Units.SI;
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  Modelica.Blocks.Interfaces.RealInput C(unit="F") annotation (Placement(
        transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  parameter SI.Capacitance Cmin=Modelica.Constants.eps
    "Lower bound for variable capacitance";
  SI.ElectricCharge Q;
  parameter SI.Voltage IC=0 "Initial Value";
  parameter Boolean UIC=false "Decision if initial value IC shall be used";
  type FaultMode = enumeration(Normal "正常", CapacitanceScaleError "输入容量比例误差", CapacitanceBias "输入容量偏置", StuckInput "容量输入卡死", CapacitanceLoss "容量损失");
  parameter FaultMode faultMode=FaultMode.Normal "故障模式";
  parameter Real severity(min=0,max=1)=1 "故障严重度";
  parameter SI.Time faultStartTime=0 "故障开始时刻";
  parameter SI.Time faultEndTime=Modelica.Constants.inf "故障结束时刻";
  parameter SI.Time transitionTime(min=0)=0 "故障渐变时间";
  Real faultActivation(min=0,max=1) "含严重度的故障激活量";
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real scaleFault=0.5 "比例故障目标";
  parameter SI.Capacitance biasFault=1e-6 "偏置故障目标";
  parameter SI.Capacitance stuckValue=1e-6 "卡死容量";
  parameter SI.Capacitance lossValue=Cmin "容量损失目标";
  SI.Capacitance C_effective "故障后的命令容量";
initial equation
  if UIC then
    v = IC;
  end if;
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  assert(C >= 0, "Capacitance C (= " + String(C) + ") has to be >= 0!");
  // protect solver from index change
  C_effective = if faultMode == FaultMode.CapacitanceScaleError then C*(1 + faultActivation*(scaleFault - 1))
    elseif faultMode == FaultMode.CapacitanceBias then C + faultActivation*biasFault
    elseif faultMode == FaultMode.StuckInput then C + faultActivation*(stuckValue - C)
    elseif faultMode == FaultMode.CapacitanceLoss then C + faultActivation*(lossValue - C) else C;
  Q = noEvent(max(C_effective, Cmin))*v;
  i = der(Q);
  annotation (defaultComponentName="capacitor",
    Documentation(info="<html><p>用法：将 FaultableVariableCapacitor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>The linear capacitor connects the branch voltage <em>v</em> with the branch current <em>i</em> by
<br><em><strong>i = dQ/dt</strong></em> with <em><strong>Q = C * v</strong></em>.
<br>The capacitance <em>C</em> is given as input signal.
It is required that C &ge; 0, otherwise an assertion is raised. To avoid a variable index system,
C = Cmin, if 0 &le; C &lt; Cmin, where Cmin is a parameter with default value Modelica.Constants.eps.</p>
<p><br>Besides the Cmin parameter the capacitor model has got the two parameters IC and UIC that belong together. With the IC parameter the user can specify an initial value of the voltage over the capacitor, which is defined from positive pin p to negative pin n (v=p.v - n.v).</p>
<p><br>Hence the capacitor is charged at the beginning of the simulation. The other parameter UIC is of type Boolean. If UIC is true, the simulation tool uses</p>
<p><br>the IC value at the initial calculation by adding the equation v= IC. If UIC is false, the IC value can be used (but it does not need to!) to calculate the initial values in order to simplify the numerical algorithms of initial calculation.</p>
</html>",
        revisions="<html>
<ul>
<li><em>June 7, 2004   </em>
       by Christoph Clauss<br>changed, docu added<br>
       </li>
<li><em>April 30, 2004</em>
       by Anton Haumer<br>implemented.
       </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),graphics={
        Line(points={{-90,0},{-6,0}}, color={255,0,0}),
        Line(points={{6,0},{90,0}}, color={255,0,0}),
        Line(points={{-6,28},{-6,-28}}, color={0,0,255}),
        Line(points={{6,28},{6,-28}}, color={0,0,255}),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}}, textString="F", textColor={255,0,0})}));
end FaultableVariableCapacitor;
