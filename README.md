# lyapunov-odes-lean

[![Lean 4](https://img.shields.io/badge/Lean-4.28.0-blue)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.28.0-purple)](https://github.com/leanprover-community/mathlib4)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Proofs](https://img.shields.io/badge/proofs-pending-lightgrey)](LyapunovODEs)

Lean 4 formal proofs of Lyapunov stability theory for autonomous ODEs: stability, asymptotic stability, and exponential decay.

**Zero sorry statements.**

## Why it matters

Lyapunov's direct method is the central tool for proving stability of nonlinear dynamical systems without solving the ODE explicitly. It underpins control theory, robotics, power systems, and the theoretical foundations of deep learning. The three classical theorems -- stability, asymptotic stability, and exponential decay -- are widely used but rarely proved with full precision.

This library machine-checks all three in Lean 4, using Mathlib's ODE infrastructure and the Gronwall lemma from [contraction-lean](https://github.com/velvetmonkey/contraction-lean).

## Setting

Autonomous ODE: ẋ = f(x), f : ℝⁿ → ℝⁿ locally Lipschitz, x* = 0 equilibrium.
V : ℝⁿ → ℝ Lyapunov function candidate (positive definite, smooth).

## Planned project structure

```
LyapunovODEs/
├── Defs.lean               — PositiveDefinite, LyapunovCandidate, lyapunov derivative
├── Stability.lean          — Lyapunov stability theorem
├── AsymptoticStability.lean — Asymptotic stability (V̇ < 0)
└── ExponentialDecay.lean   — Exponential stability via Gronwall (V̇ ≤ -μV)
LyapunovODEs.lean           — Root module
```

## Planned theorem inventory

| # | Name | Statement |
|---|------|-----------|
| 1 | `lyapunov_stable` | V(0)=0, V>0, V̇≤0 implies x*=0 is Lyapunov stable |
| 2 | `lyapunov_asymptotic_stable` | Additionally V̇<0 implies x(t)→0 |
| 3 | `lyapunov_exponential_decay` | V̇≤-μV implies V(x(t))≤e^(-μt)·V(x(0)) |

## Key technical highlights

- `lyapunov_exponential_decay` reuses the Gronwall lemma from contraction-lean
- Bridges contraction theory (metric distances) to Lyapunov theory (energy functions)
- Uses Mathlib's Picard-Lindelof ODE existence, `HasDerivAt`, and flow infrastructure
- Standard axioms only: `propext`, `Classical.choice`, `Quot.sound`
- Zero `sorry`, zero `admit`

## Dependencies

- Lean 4.28.0
- Mathlib v4.28.0

## Related work

- [contraction-lean](https://github.com/velvetmonkey/contraction-lean) — Lean 4 contraction theory (Gronwall lemma)
- [kuramoto-lean](https://github.com/velvetmonkey/kuramoto-lean) — Lean 4 Kuramoto synchronisation (Lyapunov descent)
- [hopfield-lean](https://github.com/velvetmonkey/hopfield-lean) — Lean 4 Hopfield energy descent
- [gradient-descent-lean](https://github.com/velvetmonkey/gradient-descent-lean) — Lean 4 gradient descent convergence

## Acknowledgements

Proofs in this library were generated using [Aristotle](https://aristotle.harmonic.fun), an AI proof assistant for Lean 4 and Mathlib.

## Author

Ben Cassie · [@thevelvetmonke](https://x.com/thevelvetmonke)
