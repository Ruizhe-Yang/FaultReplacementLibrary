within FaultReplacementLibrary.Thermal.HeatTransfer.Components;
model FaultableThermalConductor
  "Lumped thermal element transporting heat without storing it"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  parameter Modelica.Units.SI.ThermalConductance G
    "Constant thermal conductance of material";

  type FaultMode=enumeration(Normal "正常", ConductanceDrift "热导漂移", ConductanceLoss "热导下降", ThermalOpen "热开路", ThermalShort "热短路");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Modelica.Units.SI.ThermalConductance GFault=0.5*G;
  parameter Modelica.Units.SI.ThermalConductance GOpen=1e-9;
  parameter Modelica.Units.SI.ThermalConductance GShort=1e9;
  Modelica.Units.SI.ThermalConductance G_effective;
equation
  startActivation=if time<faultStartTime then 0 else if transitionTime<=Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation=if time<=faultEndTime then 1 else if transitionTime<=Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation=severity*startActivation*endActivation;
  G_effective=if faultMode==FaultMode.ConductanceDrift or faultMode==FaultMode.ConductanceLoss then G+faultActivation*(GFault-G) elseif faultMode==FaultMode.ThermalOpen then G+faultActivation*(GOpen-G) elseif faultMode==FaultMode.ThermalShort then G+faultActivation*(GShort-G) else G;
  Q_flow=G_effective*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-90,70},{90,-70}},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-90,70},{-90,-70}},
          thickness=0.5),
        Line(
          points={{90,70},{90,-70}},
          thickness=0.5),
        Text(
          extent={{-150,120},{150,80}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-150,-80},{150,-110}},
          textString="G=%G"),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}),
    Documentation(info="<html><p>用法：将 FaultableThermalConductor 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
This is a model for transport of heat without storing it; see also:
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>.
It may be used for complicated geometries where
the thermal conductance G (= inverse of thermal resistance)
is determined by measurements and is assumed to be constant
over the range of operations. If the component consists mainly of
one type of material and a regular geometry, it may be calculated,
e.g., with one of the following equations:
</p>
<ul>
<li><p>
    Conductance for a <strong>box</strong> geometry under the assumption
    that heat flows along the box length:</p>
    <blockquote><pre>
G = k*A/L
k: Thermal conductivity (material constant)
A: Area of box
L: Length of box
    </pre></blockquote>
    </li>
<li><p>
    Conductance for a <strong>cylindrical</strong> geometry under the assumption
    that heat flows from the inside to the outside radius
    of the cylinder:</p>
    <blockquote><pre>
G = 2*pi*k*L/log(r_out/r_in)
pi   : Modelica.Constants.pi
k    : Thermal conductivity (material constant)
L    : Length of cylinder
log  : Modelica.Math.log;
r_out: Outer radius of cylinder
r_in : Inner radius of cylinder
    </pre></blockquote>
    </li>
</ul>
<blockquote><pre>
Typical values for k at 20 degC in W/(m.K):
  aluminium   220
  concrete      1
  copper      384
  iron         74
  silver      407
  steel        45 .. 15 (V2A)
  wood         0.1 ... 0.2
</pre></blockquote>
</html>"));
end FaultableThermalConductor;

