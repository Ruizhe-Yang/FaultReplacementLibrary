within FaultReplacementLibrary.Examples.Benchmarks.Mechanical.Vehicle;
model DragIncrease "Vehicle aerodynamic drag increases"
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Mechanics.Translational.Components.FaultableVehicle vehicle(
      m=m, J=0, R=R, A=A, Cd=Cd, CrConstant=Cr, vWindConstant=vWind, useInclinationInput=true, s(fixed=true), v(fixed=true), faultMode=FaultReplacementLibrary.Mechanics.Translational.Components.FaultableVehicle.FaultMode.DragIncrease, severity=scenarioSeverity, faultStartTime=20, transitionTime=1, addedDragArea=2));
  parameter Real scenarioSeverity(min=0,max=1)=1
    "Sweep parameter: 0, 0.25, 0.5, 0.75, 1";
  annotation(Documentation(info="<html><p>用法：直接仿真 DragIncrease，或修改 scenarioSeverity 后重新仿真。该场景通过 extends 与 redeclare，把基准系统中的目标元件替换为 Faultable 元件。</p></html>"));
end DragIncrease;
