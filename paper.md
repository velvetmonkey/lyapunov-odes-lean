# lyapunov-odes-lean: Formal Proofs of Lyapunov Stability Theorems for Autonomous ODEs in Lean 4

Ben Cassie  
2026

## Abstract

`lyapunov-odes-lean` is a Lean 4 / Mathlib library formalising core Lyapunov stability theorems for autonomous ordinary differential equations. The library defines solutions of `x' = f(x)` using `HasDerivAt`, states Lyapunov stability and asymptotic stability at the origin, proves a Lyapunov stability theorem, proves an asymptotic-stability theorem with the LaSalle convergence step factored into an explicit hypothesis, and proves exponential decay through Mathlib's Gronwall inequality. The development contains zero `sorry`, zero `admit`, and uses standard Lean/Mathlib axioms only. It provides a checked stability-theory component for later work on control, dynamical systems, optimisation dynamics, and AI safety.

## 1. Introduction

Lyapunov's direct method is one of the foundational tools of dynamical systems and control theory. Instead of solving an ODE explicitly, one exhibits a scalar function `V` that behaves like an energy. If `V` is positive near the equilibrium and does not increase along trajectories, then trajectories that start near the equilibrium stay nearby. If stronger convergence information is available, the equilibrium is asymptotically stable. If the derivative satisfies a linear decay inequality, `V` decays exponentially.

The library studies autonomous ODEs

```text
x' = f(x)
```

with equilibrium at `0` in a real normed vector space `E`. Solutions are defined using Mathlib's `HasDerivAt`:

```text
forall t, HasDerivAt x (f (x t)) t.
```

This choice is pragmatic. It matches the form produced by Mathlib's Picard-Lindelof infrastructure, so existence theorems can compose with the stability results without translating between solution representations.

The library formalises three related notions: `IsSolution`, `LyapunovStable`, and `AsymptoticallyStable`. It then proves the stability theorem, an asymptotic-stability theorem, and an exponential-decay theorem. The asymptotic theorem deliberately factors out the LaSalle step through a hypothesis that `V(x(t))` tends to zero. This keeps the theorem general and leaves compact omega-limit reasoning to `lasalle-lean`.

## 2. Library Overview

The project is organised into four implementation modules plus a root import file:

- `LyapunovOdes/Defs.lean` defines `IsSolution f x`, `LyapunovStable f`, and `AsymptoticallyStable f`.
- `LyapunovOdes/Stability.lean` proves the main Lyapunov stability theorem.
- `LyapunovOdes/AsymptoticStability.lean` proves a squeeze helper and the asymptotic-stability theorem.
- `LyapunovOdes/ExponentialDecay.lean` proves the bridge from derivative hypotheses to Mathlib's liminf-slope form and the exponential decay theorem via Gronwall.
- `LyapunovOdes.lean` is the root module importing the library.

The project depends on Lean `v4.28.0` and Mathlib `v4.28.0`.

The definitions are intentionally minimal. `LyapunovStable f` is the usual epsilon-delta stability statement at the origin. `AsymptoticallyStable f` combines stability with convergence to zero for sufficiently small initial conditions. These definitions are stated directly in metric terms so they can be applied in normed spaces without additional coordinate structure.

## 3. Theorem Inventory

The source contains eight headline definitions and theorems, organised into three layers.

### Layer 1 - Definitions

1. `IsSolution` — A trajectory `x : R -> E` solves the autonomous ODE using `HasDerivAt`:

```text
forall t, HasDerivAt x (f (x t)) t.
```

2. `LyapunovStable` — Epsilon-delta stability of the equilibrium at `0`: sufficiently small initial conditions remain within any prescribed neighbourhood of zero.

3. `AsymptoticallyStable` — Lyapunov stability plus convergence of nearby trajectories to zero as time tends to infinity.

### Layer 2 - Stability Theorems

4. `lyapunov_stable` — If `V(0) = 0`, `V` is continuous at `0`, `V` is positive definite away from the origin, and `V` is non-increasing along solutions, then the equilibrium is Lyapunov stable.

5. `tendsto_zero_of_strictMono_squeeze` — A helper theorem for asymptotic convergence, extracting convergence to zero from a monotone/squeeze-style argument.

6. `lyapunov_asymptotic_stable` — Stability plus a class-K lower bound

```text
alpha(||x||) <= V(x)
```

and convergence `V(x(t)) -> 0` imply `x(t) -> 0`.

### Layer 3 - Exponential Decay

7. `hasDerivWithinAt_Ici_liminf_slope` — A bridge lemma converting a `HasDerivWithinAt` hypothesis on a right half-line into the liminf-slope condition required by Mathlib's Gronwall theorem.

8. `lyapunov_exponential_decay` — If

```text
Vdot(t) <= -mu * V(t),
```

then

```text
V(t) <= V(a) * exp(-mu * (t - a)).
```

The proof uses Mathlib's `le_gronwallBound_of_liminf_deriv_right_le`.

## 4. Key Technical Highlights

### Solutions via `HasDerivAt`

Many textbook ODE treatments define solutions informally. In Lean, the representation matters. `HasDerivAt` is the natural local derivative predicate in Mathlib, and it is compatible with the output of Picard-Lindelof existence theorems. This makes `IsSolution` a bridge rather than an isolated custom abstraction.

### The Gronwall Bridge

Mathlib's Gronwall theorem is stated using a liminf right-derivative condition. Lyapunov decay hypotheses are more naturally expressed as derivative inequalities. The bridge theorem `hasDerivWithinAt_Ici_liminf_slope` converts the derivative information into the exact form needed by Gronwall.

This is a small but important formal engineering step. It means the library can reuse Mathlib's existing ODE analysis instead of reproving Gronwall.

### Factoring Out LaSalle

The asymptotic-stability theorem assumes the conclusion that `V(x(t))` tends to zero. In a classical development this often follows from LaSalle's invariance principle under compactness assumptions. Rather than folding that whole theory into the Lyapunov ODE library, the theorem factors it out as a hypothesis.

This makes the theorem more modular. `lyapunov-odes-lean` proves the implication from vanishing Lyapunov value to state convergence; `lasalle-lean` supplies omega-limit infrastructure that can justify the vanishing hypothesis in compact invariant settings.

### Connection to Contraction

The exponential-decay theorem uses the same Gronwall core that appears in contraction-style convergence proofs. A differential inequality of the form `Vdot <= -mu V` is the scalar analogue of metric contraction. Formalising it once against Mathlib's Gronwall result makes it reusable across dynamical systems and optimisation.

## 5. Relation to Sibling Libraries

`contraction-lean` has DOI `10.5281/zenodo.20474762` and uses Gronwall-type reasoning to prove contraction and exponential convergence. `lyapunov-odes-lean` applies the same analytic core to Lyapunov functions along ODE trajectories.

`lasalle-lean` supplies the omega-limit and invariant-set infrastructure that this library factors out through the `hVlim` hypothesis in the asymptotic-stability theorem.

`kuramoto-lean` has DOI `10.5281/zenodo.20468619` and uses Lyapunov descent as a proof engine for synchronisation. The ODE stability theorems here provide reusable components for that style of argument.

`gradient-descent-lean` and related optimisation libraries can be read as discrete-time analogues: their convergence proofs also use energy-like quantities, descent inequalities, and telescoping or Gronwall-style bounds.

## 6. AI Safety Significance

Stability claims are common in AI safety: a learning rule should remain near a safe equilibrium, a control system should not diverge, or a dynamical process should converge to a desired set. Lyapunov arguments are a standard mathematical language for such claims.

Formalising Lyapunov theorems clarifies the hypotheses. Stability is not obtained from an energy function alone; it requires positivity, continuity, non-increase along actual solutions, and the correct relationship between the ODE and the derivative of `V`. Exponential convergence requires a differential inequality of the right sign.

The library does not certify real AI systems. It provides checked building blocks for formal safety arguments about simplified dynamical models and learning processes.

## 7. Conclusion

`lyapunov-odes-lean` formalises the core Lyapunov stability toolkit for autonomous ODEs in Lean 4. It defines solutions and stability notions, proves Lyapunov stability, proves asymptotic stability from a vanishing Lyapunov value, and proves exponential decay through Gronwall. The result is a modular stability-theory artifact designed to compose with Mathlib ODE infrastructure and sibling libraries on contraction and LaSalle invariance.

## References

Lyapunov, A. M. (1892). *The General Problem of the Stability of Motion*. Translated 1992, Taylor & Francis.

Khalil, H. K. (2002). *Nonlinear Systems* (3rd ed.). Prentice Hall.

The Mathlib Community. (2024). *The Lean Mathematical Library*. GitHub repository. <https://github.com/leanprover-community/mathlib4>

Cassie, B. (2026). *contraction-lean*. Zenodo. <https://doi.org/10.5281/zenodo.20474762>

Cassie, B. (2026). *kuramoto-lean: A Sorry-Free Lean 4 Library for Finite-N Kuramoto Synchronisation Dynamics*. Zenodo. <https://doi.org/10.5281/zenodo.20468619>

