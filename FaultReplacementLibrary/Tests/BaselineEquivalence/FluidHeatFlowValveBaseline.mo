within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidHeatFlowValveBaseline "MSL FluidHeatFlow Valve and faultable annotation(Placement(transformation(extent={{-26,30},{-6,50}}))) Normal equivalence"
  parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Medium();
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient inletOriginal(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{6,30},{26,50}}))),outletOriginal(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{70,30},{90,50}}))),inletFaultable(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{6,-50},{26,-30}}))),outletFaultable(medium=medium,constantAmbientPressure=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow pumpOriginal(medium=medium,m=0,constantVolumeFlow=0.1) annotation(Placement(transformation(extent={{38,30},{58,50}}))),pumpFaultable(medium=medium,m=0,constantVolumeFlow=0.1) annotation(Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Thermal.FluidHeatFlow.Components.Valve original(medium=medium,Kv1=0.1,dp0=100,rho0=medium.rho) annotation(Placement(transformation(extent={{-58,-50},{-38,-30}})));
  FaultReplacementLibrary.Thermal.FluidHeatFlow.Components.FaultableValve faultable(medium=medium,Kv1=0.1,dp0=100,rho0=medium.rho,severity=0);
  Modelica.Blocks.Sources.Constant command(k=0.7) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(command.y,original.y)
    annotation(Line(points={{-70,40},{-54,40},{-54,-40},{-38,-40}}, color={0,0,127})); connect(command.y,faultable.y)
    annotation(Line(points={{-70,40},{-6,40}}, color={0,0,127})); connect(inletOriginal.flowPort,pumpOriginal.flowPort_a)
    annotation(Line(points={{16,40},{48,40}}, color={0,127,255})); connect(pumpOriginal.flowPort_b,original.flowPort_a)
    annotation(Line(points={{48,40},{0,40},{0,-40},{-48,-40}}, color={0,127,255})); connect(original.flowPort_b,outletOriginal.flowPort)
    annotation(Line(points={{-48,-40},{16,-40},{16,40},{80,40}}, color={0,127,255}));
  connect(inletFaultable.flowPort,pumpFaultable.flowPort_a)
    annotation(Line(points={{16,-40},{48,-40}}, color={0,127,255})); connect(pumpFaultable.flowPort_b,faultable.flowPort_a)
    annotation(Line(points={{48,-40},{16,-40},{16,40},{-16,40}}, color={0,127,255})); connect(faultable.flowPort_b,outletFaultable.flowPort)
    annotation(Line(points={{-16,40},{32,40},{32,-40},{80,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.dp-faultable.dp)<1e-7 and abs(original.V_flow-faultable.V_flow)<1e-9),"FluidHeatFlow Valve Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidHeatFlowValveBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end FluidHeatFlowValveBaseline;
