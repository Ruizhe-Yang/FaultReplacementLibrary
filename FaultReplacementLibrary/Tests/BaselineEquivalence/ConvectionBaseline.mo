within FaultReplacementLibrary.Tests.BaselineEquivalence;
model ConvectionBaseline "Executable HeatTransfer Normal equivalence test"
  Modelica.Blocks.Sources.Constant conductance(k=5) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature hotOriginal(T=320) annotation(Placement(transformation(extent={{30,30},{50,50}}))),hotFaultable(T=320) annotation(Placement(transformation(extent={{30,-50},{50,-30}}))),coldOriginal(T=280) annotation(Placement(transformation(extent={{70,30},{90,50}}))),coldFaultable(T=280) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Thermal.HeatTransfer.Components.Convection original annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableConvection faultable(severity=0) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(conductance.y,original.Gc)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(conductance.y,faultable.Gc)
    annotation(Line(points={{-70,40},{0,40}}, color={0,0,127}));
  connect(hotOriginal.port,original.solid)
    annotation(Line(points={{40,40},{0,40},{0,-40},{-40,-40}}, color={0,0,255})); connect(original.fluid,coldOriginal.port)
    annotation(Line(points={{-40,-40},{20,-40},{20,40},{80,40}}, color={0,0,255}));
  connect(hotFaultable.port,faultable.solid)
    annotation(Line(points={{40,-40},{20,-40},{20,40},{0,40}}, color={0,0,255})); connect(faultable.fluid,coldFaultable.port)
    annotation(Line(points={{0,40},{40,40},{40,-40},{80,-40}}, color={0,0,255}));
  assert(noEvent(abs(original.Q_flow-faultable.Q_flow)<1e-9),"Convection Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ConvectionBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end ConvectionBaseline;
