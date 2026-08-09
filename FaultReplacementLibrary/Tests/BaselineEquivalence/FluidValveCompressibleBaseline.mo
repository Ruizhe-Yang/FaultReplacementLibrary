within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidValveCompressibleBaseline "Executable Modelica.Fluid component Normal equivalence test"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  inner Modelica.Fluid.System system;
  Modelica.Blocks.Sources.Constant command(k=0.8) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Fluid.Sources.Boundary_pT sourceOriginal(redeclare package Medium=Medium,nPorts=1,p=3e5,T=300) annotation(Placement(transformation(extent={{30,30},{50,50}}))),sourceFaultable(redeclare package Medium=Medium,nPorts=1,p=3e5,T=300) annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Fluid.Sources.Boundary_pT sinkOriginal(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{70,30},{90,50}}))),sinkFaultable(redeclare package Medium=Medium,nPorts=1,p=2e5,T=300) annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.Fluid.Valves.ValveCompressible original(redeclare package Medium=Medium,dp_nominal=1e5,m_flow_nominal=1) annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  FaultReplacementLibrary.Fluid.Valves.FaultableValveCompressible faultable(redeclare package Medium=Medium,dp_nominal=1e5,m_flow_nominal=1,severity=0) annotation(Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(command.y,original.opening)
    annotation(Line(points={{-70,40},{-55,40},{-55,-40},{-40,-40}}, color={0,0,127})); connect(command.y,faultable.opening)
    annotation(Line(points={{-70,40},{0,40}}, color={0,0,127}));
  connect(sourceOriginal.ports[1],original.port_a)
    annotation(Line(points={{40,40},{-5,40},{-5,-40},{-50,-40}}, color={0,127,255})); connect(original.port_b,sinkOriginal.ports[1])
    annotation(Line(points={{-30,-40},{25,-40},{25,40},{80,40}}, color={0,127,255}));
  connect(sourceFaultable.ports[1],faultable.port_a)
    annotation(Line(points={{40,-40},{15,-40},{15,40},{-10,40}}, color={0,127,255})); connect(faultable.port_b,sinkFaultable.ports[1])
    annotation(Line(points={{10,40},{45,40},{45,-40},{80,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.port_a.m_flow-faultable.port_a.m_flow)<1e-5),"FluidValveCompressible Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidValveCompressibleBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidValveCompressibleBaseline;
