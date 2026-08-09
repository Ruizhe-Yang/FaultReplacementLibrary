# FaultReplacementLibrary

**Version: v0.5.0 — Usable Alpha**  
A Modelica fault-enhanced component library for **non-intrusive fault injection by component replacement**.

> **核心思想：不修改原系统的连接拓扑，只通过可替换组件机制注入故障。**

## Overview

FaultReplacementLibrary provides fault-enabled alternatives to components from the **Modelica Standard Library (MSL) 4.0.0**. It is designed for simulation-driven fault analysis, safety assessment, and fault-effect studies while keeping the nominal system model as unchanged as possible.

The typical workflow is:

```text
Nominal model
   ↓
replaceable component
   ↓
extends + redeclare
   ↓
Faultable component
   ↓
Fault scenario simulation
```

In a base model, a target component is declared as `replaceable`. A fault scenario then inherits the complete nominal system and uses `redeclare` to replace only that component with a compatible `FaultableXXX` implementation.

**The component identity and system connections remain unchanged; only the component behavior is replaced.**

## Current Scope

The current library contains fault-enhanced models across multiple Modelica domains, including:

- Electrical
- Mechanics
- Fluid
- Thermal
- Magnetic
- Blocks

Fault models support configurable parameters such as:

- `faultMode`
- `severity` (`0 ... 1`)
- `faultStartTime`
- `faultEndTime`
- `transitionTime`

Typical fault modes include parameter drift, performance degradation, leakage, open circuit, short circuit, friction/stiffness changes, sensor faults, and other domain-specific failures.

## Example

```modelica
model CapacitanceLoss
  extends BaseReplaceable(
    redeclare FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor C3(
      C=c3,
      faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor.FaultMode.CapacitanceLoss,
      severity=1,
      faultStartTime=2,
      transitionTime=0.1));
end CapacitanceLoss;
```

This replaces `C3` in the inherited nominal model without rewriting its original `connect()` topology.

## Validation Status

This **v0.5.0** release is considered **usable for research and engineering experiments**, while the public API and fault-parameter calibration are still evolving.

Current validation includes:

- 378/378 top-level models passing `checkModel`
- 37 baseline observations across 10 MSL benchmark systems
- Nominal/BaseReplaceable trajectories verified for equivalence
- 21 system-level fault scenarios tested with five severity levels (`0`, `0.25`, `0.5`, `0.75`, `1`)
- Replacement behavior verified at `severity = 0`

Validated environment:

- Modelica Standard Library 4.0.0
- OpenModelica 1.25.5

## Project Status

**v0.5.0 = usable alpha.**  
The basic replacement architecture, multi-domain fault components, examples, and validation workflow are available and functional. Future releases will focus on stronger fault-model calibration, automated regression testing, documentation, and a more stable public interface.

> 中文说明：当前版本已经可以用于“组件替换式故障注入”的研究与案例构建，但尚不建议把所有故障参数理解为经过真实器件数据标定的工程失效率模型。

## Intended Use

This library is intended for research on:

- non-intrusive fault injection
- simulation-driven safety analysis
- FMEA / fault-effect simulation
- design-iteration safety reassessment
- system engineering and safety engineering collaboration

---

FaultReplacementLibrary is under active development.
