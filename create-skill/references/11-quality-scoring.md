<!--
  references/11-quality-scoring.md -- The complete standalone 0-100
  skill-quality scoring algorithm: B1-B10 (55 pts) + G1-G9 (45 pts).
-->

# Quality Scoring Algorithm (0-100)

## Band legend

| Range | Band | Meaning |
|---|---|---|
| 0-39 | Critical | Structurally broken or unusable; do not publish |
| 40-69 | Developing | Loads, but selection and quality are unreliable |
| 70-89 | Mature | Solid, production-ready skill |
| 90-100 | Exemplary | Publishable; worth imitating |

## Hard gate

IF any of **B1, B2, B3, B4** FAILS (frontmatter missing/malformed, name
invalid, name != directory, description missing) THEN the score is **0**,
regardless of everything else. Without these, the skill does not load or is
invisible to the model -- there is nothing to grade.

## B: binary checks (55 pts, fully automated)

Each item is pass (full points) or fail (0). Vacuous truth: no `scripts/`
passes B9; no `metadata` passes B10.

| # | Check | Exact criterion | Pts |
|---|---|---|---|
| B1 | Frontmatter at byte 0 | `text.startswith("---\n")` and a closing `---` line terminates the block | 5 |
| B2 | Name valid | `name` matches `^[a-z0-9]+(-[a-z0-9]+)*$` **and** `1 <= len(name) <= 64` | 8 |
| B3 | Name == directory | `frontmatter["name"] == basename(skill_dir)`, exact string equality | 8 |
| B4 | Description present | `description` is a string and non-empty after stripping | 8 |
| B5 | Description length | `1 <= len(description) <= 1024` (characters) | 6 |
| B6 | Third person | description does **not** match `^(I\|We\|You)\b` | 5 |
| B7 | Body budget | SKILL.md body (after frontmatter) is <= 500 lines | 5 |
| B8 | References resolve | every `references/<file>` path mentioned in the body exists on disk | 5 |
| B9 | Scripts sane | every file under `scripts/` has a shebang (`#!`) or the executable bit | 3 |
| B10 | Metadata portable | every `metadata` value is a string (quoted form) | 2 |

**Total: 55.** Implemented in `scripts/validate.py`.

## G: graded quality aspects (45 pts, heuristic + human rubric)

Each item scores full / partial / none per the exact levels below. The
automated heuristic in `validate.py --score` computes a first pass; a human
(or a rubric JSON file, `--rubric rubric.json`) MAY override any G-item with
an explicit score in `0..max`. Overrides are reported as `human`; everything
else is `auto`. The rubric format:

```json
{
  "G1": 8, "G2": 3, "G3": 5, "G4": 0, "G5": 3,
  "G6": 8, "G7": 4, "G8": 4, "G9": 4,
  "_notes": { "G2": "only two artifact tokens; needs one more" }
}
```

| # | Aspect | Levels (pts) | Automated heuristic | What the human judges |
|---|---|---|---|---|
| G1 | Description formula: capability clause + trigger clause | 8 / 4 / 0 | trigger marker `(?i)\buse when\b\|\bwhen the user\b\|\bwhen you need\b` present (trigger clause); text before it >= 8 words (capability clause). Both = 8, one = 4, neither = 0. | Whether the clauses are *substantive*, not just present. |
| G2 | Description specificity: concrete artifact tokens | 6 / 3 / 0 | Count unique tokens matching file extensions (`name.ext`), backticked terms, or `scripts/`/`references/`/`assets/` mentions. >= 3 = 6, 1-2 = 3, 0 = 0. | Whether the tokens are the *right* artifacts, not filler. |
| G3 | Trigger richness: user-phrasing variants | 5 / 2 / 0 | >= 2 distinct quoted phrases, or >= 4 comma/semicolon-separated trigger terms in the trigger clause = 5; 1 quoted phrase or 2-3 terms = 2; else 0. | Whether the variants match how users *actually* phrase the task. |
| G4 | Negative triggers ("not for X") | 3 / 0 | Matches `(?i)\bnot for\b\|do not use (it\|this )?when\|instead of\|not to be confused with` = 3, else 0. | Whether a negative trigger is *needed* (no adjacent skill to disambiguate = still 0, honestly). |
| G5 | Description concision: 1-3 sentences | 3 / 1 / 0 | Sentence count 1-3 = 3, 4-5 = 1, 6+ = 0. (>1024 chars already fails B5.) | Whether every word earns its place. |
| G6 | Disclosure layering: body holds <= 60% of content | 8 / 4 / 0 | `body_lines / (body_lines + reference_lines)`: <= 0.60 = 8, <= 0.80 = 4, else 0. No `references/` dir and body <= 500 lines = 8 (nothing further to disclose). | **Content duplication across layers** (paid twice, drifts) -- subtract up to 4 via rubric. Not mechanically detectable. |
| G7 | References flat and focused | 4 (2+2) | No subdirectories under `references/` = 2; every reference file <= 150 lines = 2. No `references/` dir = 4. | Whether each file truly covers *one* topic. |
| G8 | Deterministic logic lives in `scripts/` | 4 / 0 | Body contains >= 2 procedural markers (`validat*`, `pars*`, `convert*`, `transform*`, `generat*`, `lint*`, `comput*`) and `scripts/` is non-empty = 4; >= 2 markers but no scripts = 0; fewer than 2 markers = 4 (nothing to bundle). | Whether the *right* logic was bundled; whether scripts are actually deterministic. |
| G9 | Security hygiene | 4 (2+2) | No `curl ... \| sh` / `\| bash` pipe in `scripts/` or body = 2; no exfiltration pattern (`(?i)(send\|upload\|post\|transmit\|exfiltrat)[^.]{0,60}(http\|url\|webhook\|endpoint\|api[_ -]?key\|secret\|credential\|token\|password)`) = 2. | **Whether a sensitive skill** (network, credentials, destructive ops -- detected by keyword, confirmed by human) **carries `metadata: {"opencode/autoinvoke": "false"}` and documents its `permission.skill` posture.** A sensitive skill without both loses all 4 via rubric. Prompt-injection review of prose is human-only. |

**Total: 45. Grand total: 100.**

## What cannot be automated (stated openly)

- [ ] **Duplication across disclosure layers** (G6): needs semantic comparison.
- [ ] **Trigger quality** (G1-G3): presence is mechanical; *fit* to real user phrasing needs a human who has watched the skill succeed or fail.
- [ ] **Bundling judgment** (G6/G8): whether the *right* content was moved or bundled, not just that something was.
- [ ] **Prompt-injection review** (G9): natural-language instruction manipulation defeats pattern scanners (see `09-security.md`, AST08) -- read SKILL.md as an attacker would.
- [ ] **Live triggering**: only observable by testing in the client (see `10-validation-checklist.md` phase 4).

## Pseudocode

```
function score_skill(skill_dir, rubric = {}):
    b = run_binary_checks(skill_dir)          # B1..B10 -> {pass: bool, pts: int}
    results = [b]

    if not (b.B1.pass and b.B2.pass and b.B3.pass and b.B4.pass):
        return { score: 0, band: "Critical",
                 verdict: "HARD GATE FAIL", results: results }

    total = sum(b.pts)                        # max 55
    for i in 1..9:
        if "G"+i in rubric:
            pts, source = clamp(rubric["G"+i], 0, max_i), "human"
        else:
            pts, source = heuristic_Gi(skill_dir), "auto"
        total += pts
        results.append({ id: "G"+i, pts: pts, max: max_i, source: source })

    return { score: total, band: band_for(total), verdict: "SCORED",
             results: results }

function band_for(s):
    if s >= 90: return "Exemplary"
    if s >= 70: return "Mature"
    if s >= 40: return "Developing"
    return "Critical"
```

Run it: `python3 scripts/validate.py --score <skill-dir> [--rubric rubric.json]`

## Worked example: scoring this skill (`create-skill` itself)

Reproduce: `python3 scripts/validate.py --score ~/workspace/skills/create-skill/`.
All B-items automated; G-items automated except where noted.

| # | Result | Pts |
|---|---|---|
| B1 | `---` at byte 0, block terminates | 5/5 |
| B2 | `create-skill` matches regex, 12 chars | 8/8 |
| B3 | dir name == `create-skill` | 8/8 |
| B4 | description present, non-empty | 8/8 |
| B5 | 477 chars, within 1-1024 | 6/6 |
| B6 | starts "Guides the creation..." (third person) | 5/5 |
| B7 | body ~64 lines | 5/5 |
| B8 | all `references/*.md` links resolve | 5/5 |
| B9 | `scripts/validate.py` has shebang + executable bit | 3/3 |
| B10 | no `metadata` in frontmatter (vacuous pass) | 2/2 |
| G1 | capability clause + "Use when" trigger clause | 8/8 |
| G2 | 3 artifact tokens (`SKILL.md`, `validate.py`, `scripts/`) | 6/6 |
| G3 | trigger terms (create/scaffold/review/validate/score/improve) | 5/5 |
| G4 | negative trigger present ("not for one-off prompt shortcuts...") | 3/3 |
| G5 | 3 sentences | 3/3 |
| G6 | body ~64 lines vs ~800 reference lines (ratio ~0.08) | 8/8 |
| G7 | `references/` flat, all files <= 150 lines | 4/4 |
| G8 | `validate.py` bundles the deterministic checks | 4/4 |
| G9 | no `curl\|bash`, no exfiltration patterns; skill is not sensitive | 4/4 |

**Total: 55 + 45 = 100/100 -- Exemplary.** The ceiling is attainable, not
theoretical: every point above was earned by a mechanical rule in this file.
