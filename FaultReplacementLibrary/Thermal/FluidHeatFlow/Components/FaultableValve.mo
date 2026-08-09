within FaultReplacementLibrary.Thermal.FluidHeatFlow.Components;
model FaultableValve "Simple valve"
  extends Modelica.Thermal.FluidHeatFlow.BaseClasses.TwoPort(m(start=0), final tapT=1);

  parameter Boolean LinearCharacteristic(start=true)
    "Type of characteristic"
    annotation(Dialog(group="Standard characteristic"), choices(choice=true "Linear", choice=false
        "Exponential"));
  parameter Real y1(min=small, start=1) "Max. valve opening"
    annotation(Dialog(group="Standard characteristic"));
  parameter Modelica.Units.SI.VolumeFlowRate Kv1(min=small, start=1)
    "Max. flow @ y = y1"
    annotation(Dialog(group="Standard characteristic"));
  parameter Real kv0(min=small,max=1-small, start=0.01)
    "Leakage flow / max.flow @ y = 0"
    annotation(Dialog(group="Standard characteristic"));
  parameter Modelica.Units.SI.Pressure dp0(start=1) "Standard pressure drop"
    annotation(Dialog(group="Standard characteristic"));
  parameter Modelica.Units.SI.Density rho0(start=10)
    "Standard medium's density"
    annotation(Dialog(group="Standard characteristic"));
  parameter Real frictionLoss(min=0, max=1, start=0)
    "Part of friction losses fed to medium";
  type FaultMode=enumeration(Normal "正常", StuckClosed "阀门卡闭", StuckOpen "阀门卡开", OpeningBias "开度偏置", LeakageIncrease "泄漏增加", Blockage "堵塞");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real stuckOpening(min=0)=0;
  parameter Real openingBias=0.1;
  parameter Real leakageFault(min=Modelica.Constants.small,max=1)=0.1;
  Real y_effective;
  Real kv0_effective;
protected
  constant Modelica.Units.SI.VolumeFlowRate unitVolumeFlowRate = 1;
  constant Real small = Modelica.Constants.small;
  constant Modelica.Units.SI.VolumeFlowRate smallVolumeFlowRate = eps*unitVolumeFlowRate;
  constant Real eps = Modelica.Constants.eps;
  Real yLim "Limited fault-affected valve opening";
  Modelica.Units.SI.VolumeFlowRate Kv "Standard flow rate";
public
  Modelica.Blocks.Interfaces.RealInput y annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
initial algorithm
  assert(y1>small, "Valve characteristic: y1 has to be > 0 !");
  assert(Kv1>smallVolumeFlowRate, "Valve characteristic: Kv1 has to be > 0 !");
  assert(kv0>small, "Valve characteristic: kv0 has to be > 0 !");
  assert(kv0<1-eps, "Valve characteristic: kv0 has to be < 1 !");
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  y_effective=if faultMode==FaultMode.StuckClosed then y+faultActivation*(stuckOpening-y) elseif faultMode==FaultMode.StuckOpen then y+faultActivation*(y1-y) elseif faultMode==FaultMode.OpeningBias then y+faultActivation*openingBias elseif faultMode==FaultMode.Blockage then y*(1-faultActivation) else y;
  kv0_effective=if faultMode==FaultMode.LeakageIncrease then kv0+faultActivation*(leakageFault-kv0) else kv0;
  yLim=max(min(y_effective,y1),0);
  // evaluate standard characteristic
  Kv/Kv1=if LinearCharacteristic then (kv0_effective+(1-kv0_effective)*yLim/y1) else kv0_effective*exp(Modelica.Math.log(1/kv0_effective)*yLim/y1);
  // pressure drop under real conditions
  dp/dp0 = medium.rho/rho0*(V_flow/Kv)*abs(V_flow/Kv);
  // no energy exchange with medium
  Q_flow = frictionLoss*V_flow*dp;
annotation (Documentation(info="<html><p>用法：将 FaultableValve 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>Simple controlled valve.</p>
<p>
Standard characteristic Kv=<em>f </em>(y) is given at standard conditions (dp0, rho0),
</p>
<ul>
<li>either linear :<code> Kv/Kv1 = Kv0/Kv1 + (1-Kv0/Kv1) * y/Y1</code></li>
<li>or exponential:<code> Kv/Kv1 = Kv0/Kv1 * exp[log(Kv1/Kv0) * y/Y1]</code></li>
</ul>
<p>
where:
</p>
<ul>
<li><code>Kv0 ... min. flow @ y = 0</code></li>
<li><code>Y1 .... max. valve opening</code></li>
<li><code>Kv1 ... max. flow @ y = Y1</code></li>
</ul>
<p>
Flow resistance under real conditions is calculated by
</p>
<blockquote><pre>
V_flow**2 * rho / dp = Kv(y)**2 * rho0 / dp0
</pre></blockquote>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-90,10},{-60,10},{-60,60},{0,0},{60,60},{60,10},{90,10},
              {90,-10},{60,-10},{60,-60},{0,0},{-60,-60},{-60,-10},{-90,-10},
              {-90,10}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{0,80},{0,0}}, color={0,0,127}),
                                          Text(extent={{-150,-70},{150,-110}},
          textString="%name",
          textColor={0,0,255}),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableValve;

