# lyapunov-odes-lean

[![Lean 4](https://img.shields.io/badge/Lean-4.28.0-blue)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.28.0-purple)](https://github.com/leanprover-community/mathlib4)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Proofs](https://img.shields.io/badge/proofs-proven%20%2F%200%20sorry-brightgreen)](LyapunovOdes)
[![Zenodo](https://img.shields.io/badge/Zenodo-10.5281%2Fzenodo.20475912-blue)](https://zenodo.org/records/20475912)

**lyapunov-odes-lean: Formal Proofs of Lyapunov Stability Theorems for Autonomous ODEs in Lean 4**

Lean 4 formal proofs of the three classical Lyapunov theorems for autonomous ODEs: Lyapunov stability, asymptotic stability, and exponential decay.

**Zero sorry statements.** Standard axioms only (`propext`, `Classical.choice`, `Quot.sound`).

## Why it matters

Lyapunov's "direct method" is the foundational tool of stability theory: rather than solving an ODE, you exhibit an energy-like function V that decreases along trajectories and read off the stability of an equilibrium from the behaviour of V alone. It underpins control theory, dynamical systems, and the convergence analysis of optimisation and learning dynamics. This library machine-checks the three theorems at the heart of the method — stability, asymptotic stability, and exponential decay — over a general real normed vector space.

## Setting

An autonomous ODE ẋ = f(x) with an equilibrium at x* = 0, over a general real normed vector space `E` (so the results apply to `EuclideanSpace ℝ (Fin n)` or any Banach space). Solutions are defined via Mathlib's `HasDerivAt`, matching the output format of the Picard–Lindelöf existence theorem (`IsPicardLindelof`).

## Headline theorems

- **`lyapunov_stable`** — Lyapunov stability. If V(0) = 0, V is continuous at 0, positive-definite (bounded below away from the origin), and non-increasing along solutions, then 0 is Lyapunov stable.
- **`lyapunov_asymptotic_stable`** — Asymptotic stability. Stability hypotheses + a class-𝒦 lower bound α(‖x‖) ≤ V(x) + V(x(t)) → 0 along nearby trajectories ⟹ x(t) → 0.
- **`lyapunov_exponential_decay`** — Exponential decay. If V̇(t) ≤ −μ·V(t) with μ ≥ 0, then V(t) ≤ V(a)·e^{−μ(t−a)}.

## Project structure

```
LyapunovOdes/
├── Defs.lean                 — IsSolution (via HasDerivAt), LyapunovStable,
│                               AsymptoticallyStable
├── Stability.lean            — lyapunov_stable
├── AsymptoticStability.lean  — tendsto_zero_of_strictMono_squeeze,
│                               lyapunov_asymptotic_stable
└── ExponentialDecay.lean     — hasDerivWithinAt_Ici_liminf_slope,
                                 lyapunov_exponential_decay
LyapunovOdes.lean             — Root module
```

## Theorem inventory

| # | Name | Statement |
|---|------|-----------|
| 1 | `IsSolution` | x : ℝ → E solves ẋ = f(x) via `HasDerivAt` (Picard–Lindelöf-compatible) |
| 2 | `LyapunovStable` | ε–δ stability of the equilibrium at 0 |
| 3 | `AsymptoticallyStable` | stable, and nearby trajectories converge to 0 |
| 4 | `lyapunov_stable` | V pos-def + V(0)=0 + continuous at 0 + non-increasing ⟹ stable |
| 5 | `tendsto_zero_of_strictMono_squeeze` | squeeze helper for trajectory convergence |
| 6 | `lyapunov_asymptotic_stable` | stability + class-𝒦 bound + V(x(t))→0 ⟹ x(t)→0 |
| 7 | `hasDerivWithinAt_Ici_liminf_slope` | `HasDerivWithinAt` → liminf-slope bridge for Grönwall |
| 8 | `lyapunov_exponential_decay` | V̇ ≤ −μV (μ ≥ 0) ⟹ V(t) ≤ V(a)·e^{−μ(t−a)} |

## Design notes

- **Solutions via `HasDerivAt`.** `IsSolution` is stated with Mathlib's `HasDerivAt`, the same form produced by the Picard–Lindelöf existence theorem, so the stability results compose directly with existence results.
- **Exponential decay via Grönwall.** `lyapunov_exponential_decay` is derived from Mathlib's `le_gronwallBound_of_liminf_deriv_right_le` (`Mathlib.Analysis.ODE.Gronwall`) — the same core bound used in [contraction-lean](https://github.com/velvetmonkey/contraction-lean) — with `hasDerivWithinAt_Ici_liminf_slope` bridging `HasDerivWithinAt` to the required liminf-slope condition.
- **LaSalle step factored out.** The asymptotic-stability theorem takes the convergence V(x(t)) → 0 as an explicit hypothesis (`hVlim`), factoring out the LaSalle invariance argument (which needs compactness of sublevel sets). This keeps the theorem general; the docstring explains how V̇ < 0 for x ≠ 0 yields `hVlim` under suitable compactness.

## Dependencies

- Lean 4.28.0
- Mathlib v4.28.0

## Paper

**lyapunov-odes-lean: Formal Proofs of Lyapunov Stability Theorems for Autonomous ODEs in Lean 4**
Ben Cassie (2026). Companion paper: [paper.md](paper.md).

DOI: https://doi.org/10.5281/zenodo.20475912

## Related work

- [contraction-lean](https://github.com/velvetmonkey/contraction-lean) — Lean 4 contraction theory: Banach fixed point, geometric / exponential convergence
- [kuramoto-lean](https://github.com/velvetmonkey/kuramoto-lean) — Lean 4 Kuramoto synchronisation and Lyapunov descent
- [lasalle-lean](https://github.com/velvetmonkey/lasalle-lean) — Lean 4 LaSalle invariance principle
- [gradient-descent-lean](https://github.com/velvetmonkey/gradient-descent-lean) — Lean 4 gradient descent convergence (O(1/k) rate)

## Acknowledgements

Proofs in this library were generated using [Aristotle](https://aristotle.harmonic.fun), an AI proof assistant for Lean 4 and Mathlib. The proof discipline — zero sorry, standard axioms only — was specified by the author and enforced by the Lean type checker.

## Author

Ben Cassie · [@thevelvetmonke](https://x.com/thevelvetmonke)
## Part of the Lean proof corpus

One of a family of small, machine-checked Lean 4 developments. Index: [velvetmonkey/lean](https://github.com/velvetmonkey/lean) ([live index](https://velvetmonkey.github.io/lean)).
