within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidPressureBaseline "Executable Modelica.Fluid sensor Normal equivalence test"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  inner Modelica.Fluid.System system;
  Modelica.Fluid.Sources.Boundary_pT boundaryOriginal(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Fluid.Sources.Boundary_pT boundaryFaultable(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Fluid.Sensors.Pressure original(redeclare package Medium=Medium) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  FaultReplacementLibrary.Fluid.Sensors.FaultablePressure faultable(redeclare package Medium=Medium,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(boundaryOriginal.ports[1],original.port)
    annotation(Line(points={{-80,40},{0,40}}, color={0,127,255})); connect(boundaryFaultable.ports[1],faultable.port)
    annotation(Line(points={{-80,-40},{80,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.p-faultable.p)<1e-6),"Pressure Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidPressureBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidPressureBaseline;
