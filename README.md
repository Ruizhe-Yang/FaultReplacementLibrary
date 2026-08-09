# FaultReplacementLibrary

**A Modelica library for component-replacement-based fault injection and simulation-driven fault-effect analysis.**

> **核心思想：Replace behavior, not topology.**  
> 尽量保持原系统的连接拓扑不变，通过 `replaceable` / `redeclare` 替换目标组件，实现故障注入。

[![Version](https://img.shields.io/badge/version-v0.5.0--usable%20alpha-orange)](https://github.com/Ruizhe-Yang/FaultReplacementLibrary)
[![Modelica](https://img.shields.io/badge/Modelica-MSL%204.0.0-blue)](https://modelica.org/)
[![License](https://img.shields.io/badge/license-GPL--3.0-green)](LICENSE)

## Overview

`FaultReplacementLibrary` provides fault-enabled Modelica components (`FaultableXXX`) for multi-domain system simulation.

Instead of adding fault equations directly into the nominal system model, a target component is first declared as `replaceable`, and a fault scenario then uses `extends + redeclare` to replace it with a fault-enabled implementation.

```text
Nominal system
    ↓
replaceable component
    ↓
extends + redeclare
    ↓
FaultableXXX
    ↓
fault-effect simulation
```

The system-level `connect()` topology can therefore remain unchanged while the component behavior is replaced.

## Core Modelica mechanism

Nominal / replaceable component:

```modelica
replaceable Modelica.Electrical.Analog.Basic.Capacitor C3(
  C=c3,
  v(start=0, fixed=true))
  constrainedby Modelica.Electrical.Analog.Basic.Capacitor;
```

Fault scenario:

```modelica
model CapacitanceLoss
  extends BaseReplaceable(
    redeclare
      FaultReplacementLibrary.Electrical.Analog.Basic.FaultableCapacitor C3(
        C=c3,
        faultMode=FaultReplacementLibrary.Electrical.Analog.Basic.
          FaultableCapacitor.FaultMode.CapacitanceLoss,
        severity=scenarioSeverity,
        faultStartTime=2,
        transitionTime=0.1));

  parameter Real scenarioSeverity(min=0, max=1)=1;
end CapacitanceLoss;
```

The component is still named `C3` and keeps its original position in the system, but its internal physical behavior is replaced.

## Who is this for?

### Modelica users

Use the library to create fault variants of existing multi-domain models without rebuilding the complete system for each failure case. The current library covers areas including electrical, mechanical, fluid, thermal, magnetic, and signal/block models.

### Fault diagnosis and safety researchers

The library can be used as a **physics-based fault injection and labeled-data generation layer** for:

- fault detection and isolation (FDI);
- PHM and diagnostic algorithm evaluation;
- sensor / telemetry fault-effect studies;
- fault propagation analysis;
- simulation-driven FMEA and safety analysis.

A simulation can provide known ground truth such as:

```text
fault location + fault mode + severity + onset time + system response
```

This makes it possible to compare the true injected fault with what a diagnostic method can infer from observable sensor or telemetry variables.

## Fault parameters

Fault-enabled components commonly use parameters such as:

- `faultMode`
- `severity` (`0 ... 1`)
- `faultStartTime`
- `faultEndTime`
- `transitionTime`

Different physical faults use different constitutive equations. Open circuits, short circuits, leakage, parameter degradation, friction changes, sensor bias, and other failures are therefore modeled according to the affected component rather than through one universal fault equation.

> **Note:** some open/short-circuit models use finite numerical approximations to preserve a solvable fixed topology. Therefore, inactive fault behavior should be interpreted according to the model documentation and validation tolerance rather than assumed to be algebraically identical in every case.

## Getting started

### OpenModelica

The current validation baseline uses **OpenModelica + Modelica Standard Library 4.0.0**.

- [OpenModelica](https://openmodelica.org/)
- [OpenModelica User's Guide](https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/)

Typical use:

1. Clone this repository.
2. Load `FaultReplacementLibrary/package.mo` in OMEdit.
3. Open a model under `FaultReplacementLibrary.Examples`.
4. Simulate the nominal / replaceable model.
5. Simulate a corresponding fault scenario and change `severity` as required.

### MWORKS.Sysplorer

The library is written in standard Modelica and can also be explored in Modelica environments such as **MWORKS.Sysplorer**.

- [MWORKS.Sysplorer](https://en.tongyuan.cc/product/detail/?id=sysplorer)
- [Sysplorer Documentation](https://www.tongyuan.cc/docs/sysplorer/2026a/Help/)

The quantitative validation results currently reported by this project are primarily based on OpenModelica.

## Current status — v0.5.0

**v0.5.0 is a usable alpha release.** The replacement architecture and representative multi-domain fault scenarios are available for research and engineering experiments.

| Item | Status |
|---|---:|
| Fault-enabled components | 141 |
| Non-`Normal` fault modes | 681 |
| Top-level `checkModel` | 378 / 378 |
| Baseline benchmark observations | 37 / 37 |
| Five-level system fault scenarios | 21 / 21 |

These results describe current model and regression-test coverage. They do **not** imply that every fault mode has been calibrated against real hardware degradation data or certified for safety-critical use.

## License and attribution

This repository is distributed under the **GNU GPL-3.0** license; see [`LICENSE`](LICENSE).

Some model structures are based on or adapted from the **Modelica Standard Library (MSL)**, which is distributed under the **3-Clause BSD License**. Relevant upstream copyright and license notices should be preserved for MSL-derived material.

- [Modelica Standard Library](https://github.com/modelica/ModelicaStandardLibrary)

## Citation

If you use this library in academic work, please cite the repository and the exact version used:

```text
FaultReplacementLibrary, v0.5.0, GitHub repository, 2026.
https://github.com/Ruizhe-Yang/FaultReplacementLibrary
```

---

**FaultReplacementLibrary v0.5.0 — Usable Alpha**  
**组件数量体现覆盖度，故障方程与验证证据决定可信度。**
