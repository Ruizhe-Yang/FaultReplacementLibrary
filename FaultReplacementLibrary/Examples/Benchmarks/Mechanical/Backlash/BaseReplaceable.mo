within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.Backlash;
model BaseReplaceable "Example to demonstrate backlash"
  extends Modelica.Icons.Example;
  Modelica.Mechanics.Rotational.Components.Fixed fixed1
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Mechanics.Rotational.Components.SpringDamper springDamper(
    c=20E3,
    d=50,
    phi_nominal=1)
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(
    J=5,
    w(fixed=true, start=0),
    phi(
      fixed=true,
      displayUnit="deg",
      start=1.570796326794897))
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed2
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  replaceable Modelica.Mechanics.Rotational.Components.ElastoBacklash elastoBacklash(
    c=20E3,
    d=50,
    b(displayUnit="deg") = 0.7853981633974483,
    phi_nominal=1)
    constrainedby Modelica.Mechanics.Rotational.Components.ElastoBacklash annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia2(
    J=5,
    w(fixed=true, start=0),
    phi(
      fixed=true,
      start=1.570796326794897,
      displayUnit="deg"))
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed3
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Mechanics.Rotational.Components.ElastoBacklash2           elastoBacklash2(
    c=20E3,
    d=50,
    phi_nominal=1,
    b(displayUnit="deg") = 0.78539816339745)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia3(
    J=5,
    w(fixed=true, start=0),
    phi(
      fixed=true,
      start=1.570796326794897,
      displayUnit="deg"))
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(springDamper.flange_b, inertia1.flange_a) annotation (Line(
      points={{0,40},{20,40}}));
  connect(elastoBacklash.flange_b, inertia2.flange_a) annotation (Line(
      points={{0,0},{20,0}}));
  connect(fixed1.flange, springDamper.flange_a) annotation (Line(
      points={{-40,40},{-20,40}}));
  connect(fixed2.flange, elastoBacklash.flange_a) annotation (Line(
      points={{-40,0},{-20,0}}));
  connect(elastoBacklash2.flange_b, inertia3.flange_a)
    annotation (Line(points={{0,-40},{20,-40}}));
  connect(fixed3.flange, elastoBacklash2.flange_a)
    annotation (Line(points={{-40,-40},{-20,-40}}));
  annotation (Documentation(info="<html><p>用法：本模型保留 MSL 4.0.0 官方 Example 的系统拓扑与图形，作为 replaceable 基准。通过 extends BaseReplaceable(redeclare ...) 创建故障场景，不需要修改其余连接。</p>
<p>
This model demonstrates the effect of a backlash on eigenfrequency, and
also that the damping torque does not lead to unphysical pulling torques
(since the ElastoBacklash model takes care of it).
Furthermore, it shows the differences of the
<a href=\"modelica://Modelica.Mechanics.Rotational.Components.ElastoBacklash\">ElastoBacklash</a> and
<a href=\"modelica://Modelica.Mechanics.Rotational.Components.ElastoBacklash2\">ElastoBacklash2</a> components
(the ElastoBacklash2 component generates events when contact occurs and the torque changes discontinuously).
</p>
</html>"),
       experiment(StopTime=1.0, Interval=0.001));
end BaseReplaceable;
