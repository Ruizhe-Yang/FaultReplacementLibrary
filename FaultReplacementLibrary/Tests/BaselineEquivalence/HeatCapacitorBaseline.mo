within FaultReplacementLibrary.Tests.BaselineEquivalence;
model HeatCapacitorBaseline "Executable HeatTransfer Normal equivalence test"
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow heatOriginal(Q_flow=10) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),heatFaultable(Q_flow=10) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor original(C=100,T(start=300,fixed=true)) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  FaultReplacementLibrary.Thermal.HeatTransfer.Components.FaultableHeatCapacitor faultable(C=100,T(start=300,fixed=true),severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(heatOriginal.port,original.port)
    annotation(Line(points={{-80,40},{0,40}}, color={0,0,255})); connect(heatFaultable.port,faultable.port)
    annotation(Line(points={{-80,-40},{80,-40}}, color={0,0,255}));
  assert(noEvent(abs(original.T-faultable.T)<1e-8),"HeatCapacitor Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 HeatCapacitorBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-8));
end HeatCapacitorBaseline;
