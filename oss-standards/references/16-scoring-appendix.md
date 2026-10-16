<!--
  16-scoring-appendix.md -- Reference for oss-standards.

  Covers: supporting material for the 0-100 compliance scoring algorithm
  defined in 15-scoring-algorithm.md -- the anti-pattern table (each maps
  to exactly one criterion, no double counting), what automation cannot see
  (stated openly), the scoring pseudocode, a worked example, and the
  standard versions pinned by the algorithm (verified 2026-10-13).
-->
# Scoring appendix

## Anti-patterns (each maps to a criterion -- no double counting)

| Anti-pattern | Criterion hit |
|---|---|
| No strict mode | I1 = 0 (+ NOW-gate) |
| `curl \| sudo bash` | I3/I4 = 0 (+ NOW-gate) |
| Unquoted `rm -rf $var` | I5 = 0 |
| Binaries committed to git | R2 = 0 |
| No LICENSE / unapproved license | L1 = 0 (+ NOW-gate) |
| Floating action tags on release path | C4 = 0 |
| Checksum fetched over the same channel, no signature, undisclosed | S2 = 0 |
| Silent security fixes | P3 = 0 |

## What automation cannot see (stated openly)

These are `[rubric]` by necessity, or excluded by judgment:

- README tone (imperative, no marketing adjectives) -- heuristic at best.
- Whether the standards are disproportionate to the project size (the
  roadmap's SKIP judgment) -- requires the repo-shape classifier.
- Disclosure process quality (embargo negotiation, advisory wording).
- Diataxis mode-consistency (one page = one mode) for larger docs.
- `reuse lint` and Scorecard both need their pinned tool versions
  recorded for cross-repo comparability.

## Pseudocode

```text
function score(repo):
    results = {}
    for c in ALL_CRITERIA:                     # 33 criteria above
        if c.phase == LATER and not applicable(c, repo):
            results[c] = EXCLUDED; continue
        results[c] = probe(c, repo)             # auto command or rubric 0..max

    applicable = [c for c in results if results[c] != EXCLUDED]
    raw = 100 * sum(results[c] for c in applicable)
              / sum(c.max_points for c in applicable)

    now_failed = [c for c in applicable
                  if c.phase == NOW and results[c] == 0]
    final = min(raw, 59) if now_failed else raw

    band = "Teladan"    if final >= 90 else \
           "Matang"     if final >= 70 else \
           "Berkembang" if final >= 40 else "Kritis"
    return { score: round(final, 1), band: band,
             now_gate_triggered: now_failed != [],
             findings: [per-criterion evidence + remediation pointer] }
```

## Worked example

Repo `widget`, tiny single-binary, v0.3.0, no outside contributors yet
(L3, L4, S5 excluded as N/A; applicable max = 95):

| Cat | Earned | Notes |
|---|---|---|
| 1. Installer (20) | 18 | I8 = 0 (no `shfmt -d` in CI) |
| 2. Repo & README (15) | 14 | R3 = 2 (sections present, order off) |
| 3. Versioning (15) | 13 | V4 = 2 (80% CC-conformant: 0.8 x 3 = 2.4 -> 2); V5 = 1 |
| 4. Licensing (7 appl.) | 7 | L1 = 4, L2 = 3 |
| 5. Supply chain (13 appl.) | 9 | S2 = 0 (unsigned); S4 = 2 (Scorecard 7.2) |
| 6. Sec. process (10) | 10 | - |
| 7. CI/CD (15) | 13 | C1 = 2, C5 = 2 |

Earned = 84; applicable max = 95.
`score = 100 x 84 / 95 = 88.4` -> **88, Matang**.
No NOW criterion scored 0, so no gate. Remediation priority:
S2 (sign checksums -- SOON item 11), I8 (add `shfmt -d`), V4 (fix 2
vague subjects), S4 (raise Scorecard: cheap zeros first).

## Standard versions pinned by this algorithm (verified 2026-10-13)

POSIX.1-2024; SemVer 2.0.0; Conventional Commits 1.0.0; Keep a Changelog
1.1.0; SPDX spec 3.0.1 (ISO/IEC 5962:2021 = SPDX 2.2.1); SPDX License
List 3.29.0; REUSE 3.3; DCO 1.1; SLSA v1.2 (Build L0-L3, Source L1-L4);
Sigstore (living); OpenSSF Scorecard v5.5.0; NTIA SBOM 7 fields;
CycloneDX 1.6/1.7 (ECMA-424 2nd ed.); EU CRA (EU) 2024/2847, SBOM duty
Annex I Part II(1), applies 11 Dec 2027; Diataxis (living); Contributor
Covenant 3.0; curl `--proto '=https'` (7.20.2+), `--tlsv1.2` (7.34.0+).
