within FaultReplacementLibrary.Electrical.Analog.Ideal;
model FaultableIdealTransformer "Ideal transformer core with or without magnetization"
  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
  parameter Real n(start=1) "Turns ratio primary:secondary voltage";
  parameter Boolean considerMagnetization=false
    "Choice of considering magnetization";
  parameter Modelica.Units.SI.Inductance Lm1(start=1)
    "Magnetization inductance w.r.t. primary side"
    annotation (Dialog(enable=considerMagnetization));
  type FaultMode=enumeration(Normal "正常", TurnsRatioDrift "变比漂移", MagnetizationLoss "励磁电感下降", PrimaryOpen "原边开路", SecondaryOpen "副边开路");
  parameter FaultMode faultMode=FaultMode.Normal;
  parameter Real severity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time faultEndTime=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  Real faultActivation(min=0,max=1);
  Real startActivation(min=0,max=1);
  Real endActivation(min=0,max=1);
  parameter Real nFault=0.8*n;
  parameter Modelica.Units.SI.Inductance Lm1Fault=0.2*Lm1;
  parameter Modelica.Units.SI.Resistance R_open=1e10;
  Real n_effective;
  Modelica.Units.SI.Inductance Lm1_effective;
  Modelica.Units.SI.Resistance R1_series;
  Modelica.Units.SI.Resistance R2_series;
protected
  Modelica.Units.SI.Current im1 "Magnetization current w.r.t. primary side";
  Modelica.Units.SI.MagneticFlux psim1 "Magnetic flux w.r.t. primary side";
equation
  startActivation = if time < faultStartTime then 0 else if transitionTime <= Modelica.Constants.eps then 1 else min(1,max(0,(time-faultStartTime)/transitionTime));
  endActivation = if time <= faultEndTime then 1 else if transitionTime <= Modelica.Constants.eps then 0 else max(0,1-(time-faultEndTime)/transitionTime);
  faultActivation = severity*startActivation*endActivation;
  n_effective=if faultMode==FaultMode.TurnsRatioDrift then n+faultActivation*(nFault-n) else n;
  Lm1_effective=if faultMode==FaultMode.MagnetizationLoss then Lm1+faultActivation*(Lm1Fault-Lm1) else Lm1;
  R1_series=if faultMode==FaultMode.PrimaryOpen then faultActivation*R_open else 0;
  R2_series=if faultMode==FaultMode.SecondaryOpen then faultActivation*R_open else 0;

  im1 = i1 + i2/n_effective;
  if considerMagnetization then
    psim1 = Lm1_effective*im1;
    v1 = der(psim1)+R1_series*i1;
  else
    psim1 = 0;
    im1 = 0;
  end if;
  v1 = n_effective*(v2-R2_series*i2);
  annotation (defaultComponentName="transformer",
    Documentation(info="<html><p>用法：将 FaultableIdealTransformer 按其 MSL 对应元件连接到系统中。faultMode=Normal 或 severity=0 表示名义行为；选择其他 faultMode，并设置 severity、faultStartTime、faultEndTime 和 transitionTime 后仿真故障响应。</p>
<p>
The ideal transformer is a two-port circuit element;
in case of Boolean parameter <code>considerMagnetization = false</code> it is characterized by the following equations:
</p>
<blockquote><pre>
i2 = -i1*n;
v2 =  v1/n;
</pre></blockquote>
<p>
where <code>n</code> is a real number called the turns ratio.
Due to this equations, also DC voltages and currents are transformed - which is not the case for technical transformers.
</p>
<p>
In case of Boolean parameter <code>considerMagnetization = true</code> it is characterized by the following equations:
</p>
<blockquote><pre>
im1  = i1 + i2/n \"Magnetizing current w.r.t. primary side\";
psim1= Lm1*im1   \"Magnetic flux w.r.t. primary side\";
v1 = der(psim1)  \"Primary voltage\";
v2 = v1/n        \"Secondary voltage\";
</pre></blockquote>
<p>
where <code>Lm</code> denotes the magnetizing inductance.
Due to this equations, the DC offset of secondary voltages and currents decrement according to the time constant defined by the connected circuit.
</p>
<p>
Taking primary <code>L1sigma</code> and secondary <code>L2ssigma</code> leakage inductances into account,
compared with the <a href=\"modelica://Modelica.Electrical.Analog.Basic.Transformer\">basic transformer</a>
the following parameter conversion can be applied (which leads to identical results):
</p>
<blockquote><pre>
L1 = L1sigma + M*n \"Primary inductance at secondary no-load\";
L2 = L2sigma + M/n \"Secondary inductance at primary no-load\";
M  = Lm1/n         \"Mutual inductance\";
</pre></blockquote>
<p>
For the backward conversion, one has to decide about the partitioning of the leakage to primary and secondary side.
</p>
</html>",
        revisions="<html>
<ul>
<li><em>June 3, 2009   </em>
       magnetisation current added by Anton Haumer<br>
       </li>
<li><em>1998   </em>
       initially implemented by Christoph Clauss<br>
       </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{-150,-110},{150,-150}},textString="n=%n"),
        Text(
          extent={{-100,20},{-60,-20}},
          textColor={0,0,255},
          textString="1"),
        Text(
          extent={{60,20},{100,-20}},
          textColor={0,0,255},
          textString="2"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(points={{-40,60},{-40,100},{-90,100}}, color={0,0,255}),
        Line(points={{40,60},{40,100},{90,100}}, color={0,0,255}),
        Line(points={{-40,-60},{-40,-100},{-90,-100}}, color={0,0,255}),
        Line(points={{40,-60},{40,-100},{90,-100}}, color={0,0,255}),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,45},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,15},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,-15},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-33,-45},
          rotation=270),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,45},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,15},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,-15},
          rotation=90),
        Line(
          points={{-15,-7},{-14,-1},{-7,7},{7,7},{14,-1},{15,-7}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={33,-45},
          rotation=90),
        Text(extent={{55,90},{90,55}},textString="F",textColor={255,0,0})}));
end FaultableIdealTransformer;

