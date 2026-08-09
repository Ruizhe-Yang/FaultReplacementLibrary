within FaultReplacementLibrary.Tests.BaselineEquivalence;
model GeneralHeatFlowToTemperatureAdaptorBaseline "MSL heat-flow adaptor and faultable annotation(Placement(transformation(extent={{17,30},{37,50}}))) Normal equivalence"
  Modelica.Thermal.HeatTransfer.Components.GeneralHeatFlowToTemperatureAdaptor original(use_pder=false) annotation(Placement(transformation(extent={{-37,-50},{-17,-30}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableGeneralHeatFlowToTemperatureAdaptor faultable(use_pder=false,severity=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature temperatureOriginal(T=310) annotation(Placement(transformation(extent={{70,30},{90,50}}))),temperatureFaultable(T=310) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Blocks.Sources.Constant heatFlow(k=10) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(heatFlow.y,original.f)
    annotation(Line(points={{-70,40},{-48,40},{-48,-40},{-27,-40}}, color={0,0,127})); connect(heatFlow.y,faultable.f)
    annotation(Line(points={{-70,40},{27,40}}, color={0,0,127})); connect(original.heatPort,temperatureOriginal.port)
    annotation(Line(points={{-27,-30},{26,-30},{26,40},{80,40}}, color={191,0,0})); connect(faultable.heatPort,temperatureFaultable.port)
    annotation(Line(points={{27,50},{54,50},{54,-40},{80,-40}}, color={191,0,0}));
  assert(noEvent(abs(original.p-faultable.p)<1e-9 and abs(original.heatPort.Q_flow-faultable.heatPort.Q_flow)<1e-9),"Heat-flow adaptor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 GeneralHeatFlowToTemperatureAdaptorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end GeneralHeatFlowToTemperatureAdaptorBaseline;
