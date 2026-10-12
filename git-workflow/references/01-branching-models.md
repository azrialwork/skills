<!--
  01-branching-models.md -- Reference for git-workflow.

  The four standard branching models: rules, trade-offs, and when to use
  each. Distilled from the 2026-10-12 git-workflows research. Read when
  selecting a model for a project.
-->

# Branching models

## GitFlow (Vincent Driessen, 2010)

- **Branches:** `main` (releases only), `develop` (integration),
  `feature/*`, `release/*`, `hotfix/*`.
- **Rules:** features branch from `develop` and merge back; releases are
  cut from `develop` into `release/*`, stabilized, then merged to both
  `main` (tagged) and `develop`; hotfixes branch from `main` and merge
  to both `main` and `develop`.
- **Shines:** versioned software with multiple releases maintained in
  parallel (e.g. v1.x and v2.x supported at once).
- **Fails:** continuous delivery -- the ceremony slows every release.
- **Status:** in 2020 Driessen himself added a note of reflection to the
  original post: GitFlow had become dogma, and he recommended GitHub Flow
  for teams doing continuous delivery. Use GitFlow only when parallel
  maintained versions are a real requirement.

## GitHub Flow (Scott Chacon, 2011)

- **Branches:** `main` + short-lived feature branches.
- **Rules:** branch from `main`; open a pull request early; review and let
  CI run; merge to `main`; deploy from `main` immediately.
- **Shines:** small teams doing continuous delivery; the simplest model
  that still gives review and CI a place to live.
- **Fails:** staged environments and parallel maintained versions.
- **Note:** with disciplined short branches (hours to a day), GitHub Flow
  converges with trunk-based development. The models are closer than the
  debates suggest.

## GitLab Flow

- **Branches:** environment branches (`main` -> `staging` -> `production`)
  and/or `release/*` branches.
- **Rules:** everything merges to `main`; promotion flows downstream:
  `main` to `staging`, `staging` to `production`. Release branches
  (`release/v1.2`) exist to sustain a version with patches while `main`
  moves on.
- **Shines:** projects with staged environments or a release train.
- **Fails:** adds branch bookkeeping a small team will not use.

## Trunk-based development (Paul Hammant; Google-scale practice)

- **Branches:** one trunk (`main`); branches live hours, at most 1-2 days.
- **Rules:** integrate constantly; hide unfinished work behind feature
  flags instead of long branches; CI runs on every commit; releases are
  cut from trunk at any point.
- **Shines:** high-velocity teams; DORA research correlates short branch
  lifetimes with better delivery performance (correlation, not proven
  causation).
- **Fails:** without CI discipline and feature flags it degrades into
  chaos on main.
- **Solo-dev form:** working directly on main with small atomic commits
  is trunk-based development in its simplest shape.

## Decision guide

1. One person, ship constantly -> trunk-based (direct-to-main is fine).
2. Small team, review wanted -> GitHub Flow.
3. Staging/production gates -> GitLab Flow.
4. Multiple versions supported in parallel -> GitFlow.
5. Unsure -> GitHub Flow. Upgrade only when a concrete pain appears,
   never in anticipation of one.
