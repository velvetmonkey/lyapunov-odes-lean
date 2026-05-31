/-
Copyright (c) 2025. All rights reserved.
Released under the MIT license.

# Lyapunov Exponential Decay (Exponential Stability)

If V̇(x) ≤ -μ·V(x) along a trajectory, the Grönwall–Bellman inequality yields
  V(x(t)) ≤ e^{-μt} · V(x(0)).

We derive this directly from the Grönwall bound `le_gronwallBound_of_liminf_deriv_right_le`
in Mathlib (`Mathlib.Analysis.ODE.Gronwall`), which is the same core inequality used
in the `contraction-lean` library (github.com/velvetmonkey/contraction-lean).
-/
import Mathlib
import LyapunovOdes.Defs

open Set Filter Topology Metric Real

/-- `HasDerivWithinAt` on `Ici` implies the liminf-slope condition
needed by `le_gronwallBound_of_liminf_deriv_right_le`. -/
theorem hasDerivWithinAt_Ici_liminf_slope
    {f : ℝ → ℝ} {f' : ℝ} {x : ℝ}
    (hf : HasDerivWithinAt f f' (Ici x) x) :
    ∀ r, f' < r → ∃ᶠ z in 𝓝[>] x, (z - x)⁻¹ * (f z - f x) < r := by
  intro r hr
  have h_lim : Filter.Tendsto (fun z => (z - x)⁻¹ * (f z - f x))
      (nhdsWithin x (Set.Ioi x)) (nhds f') := by
    rw [hasDerivWithinAt_iff_tendsto_slope] at hf
    convert hf.mono_left <| nhdsWithin_mono _ _ using 2
    norm_num [div_eq_inv_mul, slope_def_field]
  exact (h_lim.eventually (gt_mem_nhds hr)).frequently

/-- **Lyapunov Exponential Decay (Grönwall bound).**

If the Lyapunov function `V` composed with a trajectory `x` is continuous on `[a, b]`,
has right derivative `Vdot(t)` at each `t ∈ [a, b)`, and satisfies the differential
inequality `Vdot(t) ≤ -μ · V(x(t))` with `μ ≥ 0`, then

  `V(x(t)) ≤ V(x(a)) · exp(-μ · (t - a))`

for all `t ∈ [a, b]`.

The proof applies `le_gronwallBound_of_liminf_deriv_right_le` with `K = -μ` and `ε = 0`,
then simplifies `gronwallBound δ (-μ) 0 (t - a) = δ · exp(-μ · (t - a))`. -/
theorem lyapunov_exponential_decay
    {a b μ : ℝ} {V : ℝ → ℝ} {Vdot : ℝ → ℝ}
    (hVcont : ContinuousOn V (Icc a b))
    (hVderiv : ∀ t ∈ Ico a b, HasDerivWithinAt V (Vdot t) (Ici t) t)
    (hVdot : ∀ t ∈ Ico a b, Vdot t ≤ -μ * V t) :
    ∀ t ∈ Icc a b, V t ≤ V a * exp (-μ * (t - a)) := by
  intro t ht
  have h := @le_gronwallBound_of_liminf_deriv_right_le V Vdot (V a) (-μ) 0 a b
    hVcont
    (fun t ht r hr => hasDerivWithinAt_Ici_liminf_slope (hVderiv t ht) r hr)
    le_rfl
    (fun t ht => by linarith [hVdot t ht])
    t ht
  rwa [gronwallBound_ε0] at h
