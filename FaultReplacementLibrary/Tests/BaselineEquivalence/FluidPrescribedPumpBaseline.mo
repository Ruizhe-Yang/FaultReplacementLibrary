within FaultReplacementLibrary.Tests.BaselineEquivalence;
model FluidPrescribedPumpBaseline "MSL PrescribedPump and faultable annotation(Placement(transformation(extent={{70,-50},{90,-30}}))) Normal equivalence"
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal[3]={0,0.001,0.002}; parameter Modelica.Units.SI.Position head_nominal[3]={20,10,0};
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
  Modelica.Fluid.Sources.Boundary_pT inletOriginal(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{-90,30},{-70,50}}))),outletOriginal(redeclare package Medium=Medium,nPorts=1,p=1.2e5,T=300) annotation(Placement(transformation(extent={{17,30},{37,50}}))),inletFaultable(redeclare package Medium=Medium,nPorts=1,p=1e5,T=300) annotation(Placement(transformation(extent={{-90,-50},{-70,-30}}))),outletFaultable(redeclare package Medium=Medium,nPorts=1,p=1.2e5,T=300) annotation(Placement(transformation(extent={{17,-50},{37,-30}})));
  Modelica.Fluid.Machines.PrescribedPump original(redeclare package Medium=Medium,N_nominal=1500,use_N_in=false,N_const=1500,redeclare function flowCharacteristic=Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal=V_flow_nominal,head_nominal=head_nominal)) annotation(Placement(transformation(extent={{-37,30},{-17,50}})));
  FaultReplacementLibrary.Fluid.Machines.FaultablePrescribedPump faultable(redeclare package Medium=Medium,N_nominal=1500,use_N_in=false,N_const=1500,V_flow_nominal=V_flow_nominal,head_nominal=head_nominal,severity=0);
equation
  connect(inletOriginal.ports[1],original.port_a)
    annotation(Line(points={{-80,40},{-37,40}}, color={0,127,255})); connect(original.port_b,outletOriginal.ports[1])
    annotation(Line(points={{-17,40},{27,40}}, color={0,127,255})); connect(inletFaultable.ports[1],faultable.port_a)
    annotation(Line(points={{-80,-40},{70,-40}}, color={0,127,255})); connect(faultable.port_b,outletFaultable.ports[1])
    annotation(Line(points={{90,-40},{27,-40}}, color={0,127,255}));
  assert(noEvent(abs(original.port_a.m_flow-faultable.port_a.m_flow)<1e-5),"PrescribedPump Normal baseline mismatch");
  annotation(
    Documentation(info="<html><p>用法：直接仿真 FluidPrescribedPumpBaseline。该测试把名义 MSL 元件与 severity=0 的故障增强元件置于相同激励下，并以断言检查关键物理量的一致性；断言通过即表示 Normal 基线等价。</p></html>"),
    experiment(StopTime=1,Tolerance=1e-7));
end FluidPrescribedPumpBaseline;
