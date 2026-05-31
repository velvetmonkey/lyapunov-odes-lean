/-
Copyright (c) 2025. All rights reserved.
Released under the MIT license.

# Lyapunov Stability Theorem

If there exists a Lyapunov function candidate V with
  • V(0) = 0,
  • V continuous at 0,
  • V positive-definite in the sense that V is bounded below
    by a positive constant on every sphere {‖y‖ ≥ r}, r > 0,
  • V is non-increasing along every solution of ẋ = f(x),
then the equilibrium x* = 0 is Lyapunov stable.
-/
import Mathlib
import LyapunovOdes.Defs

open Set Filter Topology Metric Real

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-
**Lyapunov Stability Theorem.**

Given a Lyapunov function `V` that is continuous at the origin with `V(0) = 0`,
positive-definite (bounded below by a positive constant on `{‖y‖ ≥ r}` for every `r > 0`),
and non-increasing along every solution of ẋ = f(x), the equilibrium `0` is Lyapunov stable.

**Proof sketch.** Given ε > 0, let c > 0 be the lower bound of V on {‖y‖ ≥ ε}.
By continuity of V at 0 with V(0) = 0, choose δ > 0 so that ‖y‖ < δ ⟹ |V(y)| < c.
For any trajectory x with ‖x(0)‖ < δ, V(x(t)) ≤ V(x(0)) < c for all t ≥ 0.
If ‖x(t)‖ ≥ ε then V(x(t)) ≥ c, contradicting V(x(t)) < c.
-/
theorem lyapunov_stable
    {f : E → E} {V : E → ℝ}
    (hV0 : V 0 = 0)
    (hVcont : ContinuousAt V 0)
    (hVpos : ∀ r > 0, ∃ c > 0, ∀ y : E, r ≤ ‖y‖ → c ≤ V y)
    (hVdecr : ∀ x : ℝ → E, IsSolution f x →
      ∀ s t : ℝ, 0 ≤ s → s ≤ t → V (x t) ≤ V (x s)) :
    LyapunovStable f := by
  intro ε hεpos
  obtain ⟨c, hcpos, hV⟩ := hVpos ε hεpos
  obtain ⟨δ, hδpos, hδ⟩ := Metric.continuousAt_iff.1 hVcont c hcpos
  use δ, hδpos
  intro x hx hzero t hpos
  by_contra hcontr
  have hcontr' : V (x t) ≥ c := by
    exact hV _ ( le_of_not_gt hcontr )
  have hcontr'' : V (x t) ≤ V (x 0) := by
    exact hVdecr x hx 0 t le_rfl hpos
  have hcontr''' : V (x 0) < c := by
    linarith [ abs_lt.mp ( hδ ( show dist ( x 0 ) 0 < δ by simpa [ dist_eq_norm ] using hzero ) ) ]
  linarith [hcontr', hcontr'', hcontr''']