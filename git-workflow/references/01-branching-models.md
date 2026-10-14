<!--
  01-branching-models.md -- Reference for git-workflow.

  The four standard branching models: rules, trade-offs, and the
  decision tree for picking one. Distilled from the primary sources
  (verified 2026-10-13): Driessen 2010 (+2020 note), Chacon 2011,
  GitLab Flow docs, trunkbaseddevelopment.com. Read when selecting a
  model for a project.
-->

# Branching models

## Selection algorithm
> Why: The model shapes every future commit, review, and release, so a wrong pick compounds daily while a right one disappears into the background.

INPUT: the five inputs below. OUTPUT: one of the four models.

1. Answer the five inputs:

| Input | Type | Meaning |
|---|---|---|
| `parallel_versions` | boolean | Two or more released versions must be maintained at once (e.g. v1.x and v2.x in the wild). |
| `staged_envs` | boolean | Code must pass gates beyond the integration branch: staging -> production, QA sign-off, regulated release. |
| `team_size` | integer | Active committers. |
| `continuous_deployment` | boolean | Every integration-branch commit is a candidate for immediate production release. |
| `ci_maturity` | none / basic / mature | none: no CI. basic: CI exists but not on every push, or main is not kept green. mature: CI on every push to the integration branch, green-main discipline, feature flags available. |

2. Evaluate in order; the first match wins:

```
if parallel_versions:                                          -> GITFLOW
elif staged_envs:                                              -> GITLAB_FLOW
elif team_size <= 1:                                           -> TRUNK_BASED
elif continuous_deployment and ci_maturity == "mature":        -> TRUNK_BASED
else:                                                          -> GITHUB_FLOW
```

3. IF no row matched THEN select GITHUB_FLOW (the default for a new
   project without special needs: the simplest model that still gives
   review and CI a place to live).
4. IF considering upgrading the model later THEN require a concrete
   pain; NEVER upgrade in anticipation of one.

## GitFlow (Vincent Driessen, 2010; note of reflection added 2020-03-05)
> Why: Teams reach for GitFlow by habit and then pay its ceremony on every single release for years, which is why its own creator walked it back.

Primary source: nvie.com/posts/a-successful-git-branching-model/

- **Branches:** `main` (production releases only, tagged) and `develop`
  (integration branch) live forever. Supporting branches are short-lived:
  `feature/*` branches from `develop` and merges back to `develop`;
  `release/*` branches from `develop`, stabilizes, then merges to both
  `main` (tagged) and `develop`; `hotfix/*` branches from `main` and
  merges to both `main` (tagged) and `develop`.
- **Naming:** feature branches may be anything except `main`, `develop`,
  `release-*`, `hotfix-*`. Release and hotfix branches MUST use the
  `release-*` / `hotfix-*` prefixes.
- **Key rule:** ALWAYS merge with `--no-ff` so every merge creates a
  commit object. This records that the feature branch existed, groups
  the commits that implemented the feature, and makes whole-feature
  reverts possible. Fast-forwarding loses that information.
- **Tagging:** tag releases with annotated tags; signing them
  (`-s`/`-u`) is suggested by Driessen.
- **Shines:** versioned software with multiple releases maintained in
  parallel. **Fails:** continuous delivery -- the ceremony slows every
  release.
- **Status:** in 2020 Driessen wrote that the model had become dogma for
  some teams and recommended a simpler workflow (like GitHub Flow) for
  teams doing continuous delivery. IF the model choice is GitFlow THEN
  the justification MUST be parallel maintained versions.

## GitHub Flow (Scott Chacon, 2011)

Primary source: scottchacon.com/2011/08/31/github-flow

- **Branches:** `main` + short-lived, descriptively named feature
  branches (examples from the source: `new-oauth2-scopes`,
  `user-content-cache-key`).
- **The flow:** (1) anything in `main` is deployable -- the one hard
  rule; (2) create a descriptively named branch off `main`; (3) commit
  locally, push regularly to the same-named branch on the server;
  (4) open a pull request when you need feedback or the branch is ready;
  (5) merge after someone else reviews and signs off; (6) deploy
  immediately after merging.
- **Main:** NEVER rewind `main`. Fix problems with revert commits or
  new commits, never by moving the branch backward. Pushing something
  untested to `main` breaks the team's social contract.
- **Resyncing:** IF a long-running branch drifts from `main` THEN
  merging `main` into the topic branch to catch up is acceptable in
  this flow.
- **Shines:** small teams doing continuous delivery. **Fails:** staged
  environments and parallel maintained versions.
- **Note:** with disciplined short branches (hours to a day), GitHub
  Flow converges with trunk-based development. The models are closer
  than the debates suggest.

## GitLab Flow (GitLab documentation)

Primary source: GitLab's "Introduction to GitLab Flow"
(docs.gitlab.com). Core rule: `main` is the single source of truth.
Every change reaches `main` through a merge request from a short-lived
feature branch. Deployments flow *out* of `main`, never back into it.

Three documented variants; pick exactly one per project:

1. **Environment branches:** `main` -> `staging` -> `production`. Code
   moves downstream only, each hop via merge (or merge request). Fixes
   land in `main` first, then flow down -- NEVER patched directly into
   `production`.
2. **Release branches:** `release/*` sustains a version with patches
   while `main` moves on; merged back to `main` and deployed.
3. **Main + tags:** tags on `main` trigger deployment (closest to
   GitHub Flow).

- **Shines:** staged environments, regulated releases, batched deploys,
  manual QA gates, release trains -- continuous *delivery* as opposed
  to continuous deployment. **Fails:** adds branch bookkeeping a small
  team will not use.

## Trunk-based development (Paul Hammant; trunkbaseddevelopment.com)
> Why: Trunk-based without real CI discipline is just everyone pushing to main, and the first broken trunk becomes everyone's emergency.

- **Branches:** one long-lived trunk (`main`); every commit on it is
  releasable. Branches live hours, at most 1-2 days. The scaled variant
  used by teams that require code review allows short-lived feature
  branches of a few days max -- beyond that it is not trunk-based.
- **Rules:** integrate at least daily; CI runs on every commit and the
  trunk stays green (a broken trunk is the whole team's top priority);
  unfinished work hides behind **feature toggles/flags**, not long
  branches; releases are cut from trunk at any point; large refactors
  use branch-by-abstraction (new abstraction alongside the old, migrate
  callers incrementally, delete the old).
- **Shines:** high-velocity teams with mature CI and feature-flag
  discipline. DORA research correlates short branch lifetimes with
  better delivery performance (correlation, not proven causation).
- **Fails:** without CI discipline and feature flags it degrades into
  chaos on main.
- **Solo-dev form:** working directly on `main` with small atomic
  commits is trunk-based development in its simplest shape.

## Per-model parameters (what the scorer measures against)

| Model | Integration branch(es) | Work-branch pattern | Max lifetime | Merge method | Deploy from |
|---|---|---|---|---|---|
| GITFLOW | `main`, `develop` | `feature/*`, `release/*`, `hotfix/*` | days-weeks | `--no-ff` merge commits | `main`, tagged |
| GITHUB_FLOW | `main` | descriptively named, short-lived | <= 1 day | squash (common default) | `main`, immediately |
| GITLAB_FLOW | `main` (+`staging`/`production`, or `release/*`) | feature branches -> `main`; promotion MRs downstream | days | one consistent method | downstream branch/tag |
| TRUNK_BASED | `main` only | none, or <= 1-2 day branches | <= 2 days | squash or fast-forward | any `main` commit |
