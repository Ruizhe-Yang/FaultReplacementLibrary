within FaultReplacementLibrary.Tests.Replacement;
model ResistorReplacement "通过 redeclare 注入开路故障"
  extends FaultReplacementLibrary.Examples.Electrical.ResistorOpenCircuitScenario;
equation
  when terminal() then
    assert(abs(load.i) < 1e-6, "开路故障未显著降低电流");
  end when;
  annotation(
    Documentation(info="<html><p>用法：直接仿真 ResistorReplacement，验证 replaceable/redeclare 替换及预设故障效果。按 experiment 设置运行，并观察目标元件的外部系统响应和模型中的终止时断言。</p></html>"),
    experiment(StopTime=2, Tolerance=1e-8));
end ResistorReplacement;
