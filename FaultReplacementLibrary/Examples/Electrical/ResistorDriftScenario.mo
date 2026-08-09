within FaultReplacementLibrary.Examples.Electrical;
model ResistorDriftScenario "电阻漂移故障替换场景"
  extends ReplaceableResistorExample(
    redeclare FaultReplacementLibrary.Electrical.Analog.Basic.FaultableResistor load(
      R=10,
      R_drift=20,
      faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableResistor.FaultMode.ResistanceDrift,
      faultStartTime=0.5,
      transitionTime=1,
      severity=1));
  annotation(Documentation(info="<html><p>用法：在 OMEdit 中打开 ResistorDriftScenario 查看连接图，设置公开参数后直接仿真。若模型声明了 replaceable 元件，可在派生模型中通过 redeclare 切换名义件或故障件。</p></html>"));
end ResistorDriftScenario;
