/-
Copyright (c) 2025. All rights reserved.
Released under the MIT license.

# Lyapunov ODE Definitions

Core definitions for autonomous ODEs ẋ = f(x) and Lyapunov stability concepts.
We work in a real normed vector space E (typically ℝⁿ = EuclideanSpace ℝ (Fin n)).
The equilibrium is at the origin x* = 0, assumed to satisfy f(0) = 0.

## References

Solutions are characterised via `HasDerivAt` from Mathlib, consistent with
the output of the Picard–Lindelöf existence theorem
(`IsPicardLindelof.exists_forall_mem_closedBall_eq_forall_mem_Icc_hasDerivWithinAt`).
-/
import Mathlib

open Set Filter Topology Metric Real

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-! ### Solutions of autonomous ODEs -/

/-- `IsSolution f x` means `x : ℝ → E` is a (global) solution of the autonomous ODE ẋ = f(x),
i.e. `x` is differentiable everywhere and `x'(t) = f(x(t))` for every `t : ℝ`.

In finite-dimensional Banach spaces, such global solutions exist (at least locally) by the
Picard–Lindelöf theorem (`IsPicardLindelof`) when `f` is locally Lipschitz. -/
def IsSolution (f : E → E) (x : ℝ → E) : Prop :=
  ∀ t, HasDerivAt x (f (x t)) t

/-! ### Stability concepts -/

/-- **Lyapunov stability** of the equilibrium `0` for the ODE ẋ = f(x).

For every `ε > 0` there is a `δ > 0` such that every solution starting with `‖x(0)‖ < δ`
satisfies `‖x(t)‖ < ε` for all `t ≥ 0`. -/
def LyapunovStable (f : E → E) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x : ℝ → E, IsSolution f x → ‖x 0‖ < δ → ∀ t : ℝ, 0 ≤ t → ‖x t‖ < ε

/-- **Asymptotic stability** of the equilibrium `0` for the ODE ẋ = f(x).

The origin is Lyapunov stable **and** there exists a basin of attraction `δ > 0` such that
every solution starting within `δ` converges to the origin as `t → ∞`. -/
def AsymptoticallyStable (f : E → E) : Prop :=
  LyapunovStable f ∧
    ∃ δ > 0, ∀ x : ℝ → E, IsSolution f x → ‖x 0‖ < δ → Tendsto x atTop (𝓝 0)
