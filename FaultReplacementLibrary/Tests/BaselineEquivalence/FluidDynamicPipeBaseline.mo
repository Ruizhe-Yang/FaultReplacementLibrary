within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidDynamicPipeBaseline "Executable Modelica.Fluid component Normal equivalence test"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  inner Modelica.Fluid.System system(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    momentumDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
  Modelica.Fluid.Sources.Boundary_pT sourceOriginal(redeclare package Medium=Medium,nPorts=1,p=3e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(redeclare package Medium=Medium,nPorts=1,p=3e5,T=300) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Fluid.Sources.Boundary_pT sinkOriginal(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{17,30},{37,50}}))),sinkFaultable(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Fluid.Pipes.DynamicPipe original(redeclare package Medium=Medium,length=1,diameter=0.02,nNodes=2) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Fluid.Pipes.FaultableDynamicPipe faultable(redeclare package Medium=Medium,length=1,diameter=0.02,nNodes=2,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
equation
  connect(sourceOriginal.ports[1],original.port_a)
    annotation(Line(points={{-80,40},{-37,40}}, color={0,127,255})); connect(original.port_b,sinkOriginal.ports[1])
    annotation(Line(points={{-17,40},{27,40}}, color={0,127,255}));
  connect(sourceFaultable.ports[1],faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={0,127,255})); connect(faultable.port_b,sinkFaultable.ports[1])
    annotation(Line(points={{90,-40},{27,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.port_a.m_flow-faultable.port_a.m_flow)<1e-5),"FluidDynamicPipe Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidDynamicPipeBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidDynamicPipeBaseline;
