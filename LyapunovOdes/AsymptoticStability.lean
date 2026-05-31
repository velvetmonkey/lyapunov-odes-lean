/-
Copyright (c) 2025. All rights reserved.
Released under the MIT license.

# Lyapunov Asymptotic Stability Theorem

If the hypotheses of the Lyapunov stability theorem hold and additionally:
  • there is a *class-K lower bound* α (strictly increasing, α(0) = 0) with α(‖x‖) ≤ V(x),
  • V(x(t)) → 0 as t → ∞ for every trajectory starting near the origin,
then the equilibrium x* = 0 is asymptotically stable, i.e. x(t) → 0 as t → ∞.

The hypothesis `hVlim` (V(x(t)) → 0) follows classically from V̇(x) < 0 for x ≠ 0
together with compactness of sublevel sets (e.g. in finite-dimensional spaces),
via the LaSalle invariance principle. We factor this out to keep the Lean
proof self-contained and clean.
-/
import Mathlib
import LyapunovOdes.Defs
import LyapunovOdes.Stability

open Set Filter Topology Metric Real

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-
Auxiliary lemma: if a non-negative real-valued function is squeezed below a
strictly-monotone class-K function that tends to zero, the function itself tends to zero.
-/
theorem tendsto_zero_of_strictMono_squeeze
    {α : ℝ → ℝ} {u v : ℝ → ℝ}
    (hα_mono : StrictMono α) (hα0 : α 0 = 0)
    (hu : ∀ t, 0 ≤ u t)
    (hαu_le_v : ∀ t, α (u t) ≤ v t)
    (hv_nonneg : ∀ t, 0 ≤ v t)
    (hv : Tendsto v atTop (𝓝 0)) :
    Tendsto u atTop (𝓝 0) := by
  rw [ Metric.tendsto_nhds ] at *;
  intro ε hε; filter_upwards [ hv _ ( sub_pos_of_lt ( hα_mono hε ) ) ] with t ht; simp_all +decide [ abs_of_nonneg, dist_eq_norm ] ;
  exact hα_mono.lt_iff_lt.mp ( lt_of_le_of_lt ( hαu_le_v t ) ht )

/-
**Lyapunov Asymptotic Stability Theorem.**

Under the hypotheses of the Lyapunov stability theorem, if additionally
there is a class-K lower bound `α(‖x‖) ≤ V(x)` and `V(x(t)) → 0` for every
trajectory starting within a ball of radius `δ₀`, then the equilibrium
`0` is asymptotically stable.

The convergence `x(t) → 0` is deduced from:
1. `V(x(t)) → 0` (hypothesis),
2. the squeeze `0 ≤ α(‖x(t)‖) ≤ V(x(t)) → 0`,
3. strict monotonicity of `α` with `α(0) = 0`.
-/
theorem lyapunov_asymptotic_stable
    {f : E → E} {V : E → ℝ}
    (hV0 : V 0 = 0)
    (hVcont : ContinuousAt V 0)
    (hVnonneg : ∀ y : E, 0 ≤ V y)
    (hVpos : ∀ r > 0, ∃ c > 0, ∀ y : E, r ≤ ‖y‖ → c ≤ V y)
    (hVdecr : ∀ x : ℝ → E, IsSolution f x →
      ∀ s t : ℝ, 0 ≤ s → s ≤ t → V (x t) ≤ V (x s))
    {α : ℝ → ℝ} (hα_mono : StrictMono α) (hα0 : α 0 = 0)
    (hα_le : ∀ y : E, α ‖y‖ ≤ V y)
    {δ₀ : ℝ} (hδ₀ : 0 < δ₀)
    (hVlim : ∀ x : ℝ → E, IsSolution f x →
      ‖x 0‖ < δ₀ → Tendsto (V ∘ x) atTop (𝓝 0)) :
    AsymptoticallyStable f := by
  constructor;
  · exact lyapunov_stable hV0 hVcont hVpos hVdecr;
  · refine' ⟨ δ₀, hδ₀, fun x hx hx' => tendsto_zero_iff_norm_tendsto_zero.mpr _ ⟩;
    apply_rules [ tendsto_zero_of_strictMono_squeeze ];
    · exact fun t => norm_nonneg _;
    · exact fun t => hα_le _;
    · exact fun t => hVnonneg _