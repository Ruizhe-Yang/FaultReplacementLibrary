within ;
package FaultReplacementLibrary
  "面向 Modelica Standard Library 4.0.0 的独立式故障增强替换库"
  extends Modelica.Icons.Package;

  annotation(
    uses(Modelica(version="4.0.0")),
    version="1.0.0",
    Documentation(info="<html><p>本库中的每个 FaultableXXX 均直接以对应 MSL 4.0.0 模型为源码模板，不继承本库自定义故障基类。故障枚举、激活参数和物理方程均位于元件自身文件中。</p></html>"));
end FaultReplacementLibrary;
