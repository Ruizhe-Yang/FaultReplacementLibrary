within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidHeatFlowPipeBaseline "MSL FluidHeatFlow Pipe and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient inletOriginal(medium=medium,constantAmbientPressure=0,constantAmbientTemperature=293.15) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),outletOriginal(medium=medium,constantAmbientPressure=0,constantAmbientTemperature=293.15) annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient inletFaultable(medium=medium,constantAmbientPressure=0,constantAmbientTemperature=293.15) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),outletFaultable(medium=medium,constantAmbientPressure=0,constantAmbientTemperature=293.15) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow pumpOriginal(medium=medium,m=0,constantVolumeFlow=0.1) annotation(Placement(transformation(extent={{-50,30},{-30,50}}))),pumpFaultable(medium=medium,m=0,constantVolumeFlow=0.1) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Thermal.FluidHeatFlow.Components.Pipe original(medium=medium,m=0,V_flowLaminar=0.01,dpLaminar=10,V_flowNominal=0.1,dpNominal=100) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  FaultReplacementLibrary.Thermal.FluidHeatFlow.Components.FaultablePipe faultable(medium=medium,m=0,V_flowLaminar=0.01,dpLaminar=10,V_flowNominal=0.1,dpNominal=100,severity=0);
equation
  connect(inletOriginal.flowPort,pumpOriginal.flowPort_a)
    annotation(Line(points={{-80,40},{-40,40}}, color={0,127,255})); connect(pumpOriginal.flowPort_b,original.flowPort_a)
    annotation(Line(points={{-40,40},{0,40}}, color={0,127,255})); connect(original.flowPort_b,outletOriginal.flowPort)
    annotation(Line(points={{0,40},{40,40}}, color={0,127,255}));
  connect(inletFaultable.flowPort,pumpFaultable.flowPort_a)
    annotation(Line(points={{-80,-40},{-40,-40}}, color={0,127,255})); connect(pumpFaultable.flowPort_b,faultable.flowPort_a)
    annotation(Line(points={{-40,-40},{80,-40}}, color={0,127,255})); connect(faultable.flowPort_b,outletFaultable.flowPort)
    annotation(Line(points={{80,-40},{40,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.dp-faultable.dp)<1e-7 and abs(original.T_q-faultable.T_q)<1e-7),"FluidHeatFlow Pipe Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidHeatFlowPipeBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FluidHeatFlowPipeBaseline;
