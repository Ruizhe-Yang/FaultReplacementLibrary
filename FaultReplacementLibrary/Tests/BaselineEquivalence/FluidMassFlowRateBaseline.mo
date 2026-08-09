within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidMassFlowRateBaseline "Executable Modelica.Fluid flow sensor Normal equivalence test"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  inner Modelica.Fluid.System system;
  Modelica.Fluid.Sources.Boundary_pT sourceOriginal(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),sourceFaultable(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Fluid.Sources.Boundary_pT sinkOriginal(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{30,30},{50,50}}))),sinkFaultable(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Fluid.Sensors.MassFlowRate original(redeclare package Medium=Medium) annotation(Placement(transformation(extent={{-50,30},{-30,50}})));
  FaultReplacementLibrary.Fluid.Sensors.FaultableMassFlowRate faultable(redeclare package Medium=Medium,severity=0) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Fluid.Pipes.StaticPipe loadOriginal(redeclare package Medium=Medium,length=1,diameter=0.02) annotation(Placement(transformation(extent={{-10,30},{10,50}}))),loadFaultable(redeclare package Medium=Medium,length=1,diameter=0.02) annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(sourceOriginal.ports[1],original.port_a)
    annotation(Line(points={{-80,40},{-50,40}}, color={0,127,255})); connect(original.port_b,loadOriginal.port_a)
    annotation(Line(points={{-30,40},{-10,40}}, color={0,127,255})); connect(loadOriginal.port_b,sinkOriginal.ports[1])
    annotation(Line(points={{10,40},{40,40}}, color={0,127,255}));
  connect(sourceFaultable.ports[1],faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={0,127,255})); connect(faultable.port_b,loadFaultable.port_a)
    annotation(Line(points={{90,-40},{-10,-40}}, color={0,127,255})); connect(loadFaultable.port_b,sinkFaultable.ports[1])
    annotation(Line(points={{10,-40},{40,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.m_flow-faultable.m_flow)<1e-6),"MassFlowRate Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidMassFlowRateBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidMassFlowRateBaseline;
