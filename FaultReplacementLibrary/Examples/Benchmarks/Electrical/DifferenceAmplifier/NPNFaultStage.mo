within FaultReplacementLibrary.Examples.Benchmarks.Electrical.DifferenceAmplifier;
model NPNFaultStage "Transistor stage containing a faultable NPN"

  parameter FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNPN.FaultMode faultMode=FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNPN.FaultMode.Normal;
  parameter Real scenarioSeverity(min=0,max=1)=1;
  parameter Modelica.Units.SI.Time faultStartTime=0;
  parameter Modelica.Units.SI.Time transitionTime(min=0)=0;
  parameter Modelica.Units.SI.Time driftTime(min=Modelica.Constants.small)=1;
  parameter Real BfFault(min=Modelica.Constants.small)=10;
  parameter Modelica.Units.SI.Conductance GbcFault=1e-12;
  parameter Modelica.Units.SI.Conductance GbeFault=1e-12;

  Modelica.Electrical.Analog.Basic.Resistor rtb(R=0.05) annotation (Placement(transformation(extent={{-80,
            -10},{-60,10}})));
  Modelica.Electrical.Analog.Basic.Resistor rtc(R=0.1) annotation (Placement(transformation(extent={{40,0},
            {60,20}})));
  Modelica.Electrical.Analog.Basic.Capacitor ct(C=1e-10) annotation (Placement(transformation(
        origin={-40,-30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  FaultReplacementLibrary.Electrical.Analog.Semiconductors.FaultableNPN Tr(
    Bf=50,
    Br=0.1,
    Is=1e-16,
    Vak=0.02,
    Tauf=0.12e-9,
    Taur=5e-9,
    Ccs=1e-12,
    Cje=0.4e-12,
    Cjc=0.5e-12,
    Phie=0.8,
    Me=0.4,
    Phic=0.8,
    Mc=0.333,
    Gbc=1e-15,
    Gbe=1e-15,
    Vt=0.02585,
    UIC=true, faultMode=faultMode, severity=scenarioSeverity, faultStartTime=faultStartTime, transitionTime=transitionTime, driftTime=driftTime, BfFault=BfFault, GbcFault=GbcFault, GbeFault=GbeFault) annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Electrical.Analog.Basic.Ground Ground1 annotation (Placement(transformation(extent={{-50,-80},{
            -30,-60}})));
  Modelica.Electrical.Analog.Interfaces.Pin c annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Electrical.Analog.Interfaces.Pin b annotation (Placement(transformation(extent={{-110,-10},{-90,
            10}})));
  Modelica.Electrical.Analog.Interfaces.Pin e annotation (Placement(transformation(extent={{90,-70},{110,
            -50}})));
equation
  connect(rtb.n, Tr.B) annotation (Line(points={{-60,0},{-20,0}}));
  connect(rtb.n, ct.p) annotation (Line(points={{-60,0},{-40,0},{-40,-20}}));
  connect(ct.n, Ground1.p) annotation (Line(points={{-40,-40},{-40,-60}}));
  connect(Tr.C, rtc.p) annotation (Line(points={{20,10},{40,10}}));
  connect(rtc.n, c) annotation (Line(points={{60,10},{80,10},{80,60},{100,60}}));
  connect(b, rtb.p) annotation (Line(points={{-100,0},{-80,0}}));
  connect(Tr.E, e) annotation (Line(points={{20,-10},{80,-10},{80,-60},{100,-60}}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{80,60},{100,60}}, color={0,0,255}),
        Line(points={{80,-60},{100,-60}}, color={0,0,255}),
        Line(points={{-100,0},{-80,0}}, color={0,0,255}),
        Line(points={{-60,0},{-10,0}}, color={0,0,255}),
        Line(points={{-10,40},{-10,-40}}, color={0,0,255}),
        Line(points={{60,60},{40,60},{-10,10}}, color={0,0,255}),
        Line(points={{-10,-10},{40,-60},{60,-60}}, color={0,0,255}),
        Text(
          extent={{-150,130},{150,90}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html><p>用法：直接仿真 NPNFaultStage，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p>
<p>Since the simple bipolar transistor model does not have base or collector resistances both are added in this component. Additionally, a capacity is added to the base pin. See the schematic for more details.  In such a way the transistor model can be enhanced to become more common.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-76,82},{-2,54}},
          textColor={0,0,255},
          textString="Transistor")}));
end NPNFaultStage;
