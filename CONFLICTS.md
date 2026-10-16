<!--
  CONFLICTS.md -- Conflict matrix for the skills collection.

  Purpose: records every rule conflict found during the consistency
  refactor, the decision taken, and the reason. Nothing is resolved
  silently. Historical entries in CHANGELOG.md are kept as history;
  only the [Unreleased] section is corrected.
-->

# Conflict matrix

Audit date: 2026-10-16. Scope: the five skills in this repo
(`research`, `oss-standards`, `no-slop`, `git-workflow`,
`create-skill`), within each skill (SKILL.md vs `references/` vs
`scripts/` vs `assets/`), across skills, and against the config repo
where the config references a skill (read-only check of
`config/muse/AGENTS.md`). Basis: the research in
`agent-config-skill-standards/` (verified as of 2026-10-16) and
decisions from Boss. Pointers are allowed for skills: SKILL.md may
point to `references/`, `assets/`, and `scripts/` in the same skill
and to authoritative external sources. Mandatory rules must stay in
SKILL.md or be clearly referenced from it.

## Matrix

| ID | Scope | File A | File B | Conflicting rules | Decision | Reason | Substantive rule removed |
| --- | --- | --- | --- | --- | --- | --- | --- |
| C-001 | Skills policy | CHANGELOG.md (`[Unreleased]`, 2026-10-14 refactor notes) | Boss correction + `create-skill/references/03-anatomy.md`, `06-progressive-disclosure.md` | CHANGELOG: "Each skill is now standalone: no cross-skill references; every concept a skill needs is defined inline" and "content now lives inline with no external pointers" vs progressive disclosure with pointers | Pointers allowed; CHANGELOG gains a new `[Unreleased]` entry recording the supersession; the old entries stay as history | Boss correction overrides the earlier standalone policy; research confirms pointers are the intended mechanism for skills | The standalone-no-pointer policy for skills is superseded, recorded in CHANGELOG.md, not deleted silently |
| C-002 | Within one skill | `create-skill/references/02-frontmatter.md` + `scripts/validate.py` | `create-skill/references/10-validation-checklist.md` Phase 1 | 02: `allowed-tools` gets "PASS with warning"; validate.py warns on `allowed-tools`. 10: "PASS: no `allowed-tools`" | Keep 02 + validate.py; fix 10 to warning language | The field table and the validator agree; the checklist overstated the rule. The spec lists `allowed-tools` as an optional experimental field | none |
| C-003 | Within one skill | `git-workflow/SKILL.md` Step 1 table | `git-workflow/references/01-branching-models.md` decision tree | SKILL table row 1: "Solo dev or 2-3 people, continuous delivery" maps to trunk-based, evaluated trunk-first. 01: `team_size <= 1` maps to trunk-based; continuous delivery needs mature CI for trunk-based; evaluation order is GitFlow, GitLab Flow, trunk-based, then GitHub Flow | 01 is authoritative; rewrite the SKILL table to match 01 (order + rows) | The reference holds the full decision tree; the SKILL table is a summary and must not disagree with it | none; the SKILL table is corrected, not weakened |
| C-004 | Within one skill | `git-workflow/SKILL.md` Step 2.1 | `git-workflow/references/02-conventional-commits.md` + `scripts/commit-lint.sh` | SKILL: description "~50-72 chars". 02 + linter: description "at most 72 chars", no minimum enforced | Linter + 02 are authoritative; SKILL.md now says "at most 72 chars" | The enforced rule is the maximum; the "~50" lower bound was never enforced and misled authors | none |
| C-005 | Across skills | `oss-standards/references/08-versioning-releases.md` | `git-workflow` | 08: "Enforce with commitlint in CI". git-workflow ships `scripts/commit-lint.sh` as the in-repo linter | Keep both; 08 now says "Enforce with commitlint in CI, or with the git-workflow skill's `commit-lint.sh`" | Both tools enforce the same spec; the cross-skill mention follows the existing name-mention pattern in DO NOT USE WHEN sections | none |
| C-006 | Across skills | `no-slop/references/10-scoring-algorithm.md`, `12-scoring-worked-example.md`; `oss-standards/references/15-scoring-algorithm.md`, `16-scoring-appendix.md` | `research`, `git-workflow`, `create-skill` band legends | no-slop + oss-standards use Indonesian band labels (`Teladan`, `Matang`, `Berkembang`, `Kritis`, `Lulus`); the other three skills use English band labels | Unify all band labels to American English: Exemplary, Disciplined, Developing, Critical, Pass (no-slop), FAIL (no-slop, unchanged) | Repo prose is American English; band labels are part of that prose. Score ranges stay per skill (each rubric keeps its own bands) | none; labels translated, ranges unchanged |
| C-007 | Within one skill | `no-slop/references/08-rule-to-check-mapping.md`, `18-ui-direction.md` | `no-slop/SKILL.md` Step 2 + reference map | 08: "Modules 05 and 06"; 18: "the other 06 modules". Current numbering: code comments are 14, UI patterns are 15-18 | Current numbering is authoritative; fix 08 and 18 to 14 and 15-18 | The old numbers are stale from before the UI/code-comment split | none |
| C-008 | Within one skill | `create-skill/references/11-quality-scoring.md` worked example | `create-skill/SKILL.md` actual file + `scripts/validate.py` output | 11: "body ~64 lines", "~800 reference lines (ratio ~0.08)". Actual: 74 body lines, 774 reference lines, ratio 0.09 (validator reports body share 9%) | Actual counts are authoritative; fix 11 to 74 lines, 774 lines, ratio 0.09 | A worked example must reproduce from the real files; the old numbers predate the 2026-10-14 rewrite | none |
| C-009 | Within one skill | `oss-standards/references/15-scoring-algorithm.md` header comment | Same header comment | Header says the file "is self-contained: it does not depend on any other file in this skill", then says the worked example, pseudocode, anti-patterns, and pinned versions "live in 16-scoring-appendix.md" | Fix the header to point to 16 instead of claiming self-containment | The header contradicted itself; pointers to a sibling reference are the intended pattern | none |
| C-010 | Within one skill | `oss-standards/SKILL.md` + `assets/SECURITY-template.md` header | The template file itself | Both claim the template is "(15 lines)". The file has 25 lines total (19 content lines below the header comment) | Drop the exact line count from both claims | The count was wrong under any counting; guidance in 06/11/14 ("15 lines is enough") stays because it is a guideline, not a file measurement | none |
| C-011 | Across skills | `research/SKILL.md` description ("deep dive"); `oss-standards/SKILL.md` description, trigger, verify ("best practices") | `no-slop/assets/slop-phrases.txt` + `scripts/slop-scan.sh` | The phrases are genuine trigger vocabulary (create-skill 05: include words users say), but no-slop flags them as cliches (+4 and +6 in slop-scan) | Replace with synonyms that keep the trigger meaning: "in-depth investigation" and "established practices" | SKILL.md files must stay scanner-clean with margin; the synonyms preserve the trigger intent | none |
| C-012 | Repo CI vs skills | `.github/workflows/validate.yml` | Repo contents | CI loops over 4 skills (missing `research`), comment says "Dogfoods all three skills", POSIX check covers only 2 of 4 shell scripts | Fix the loops to all 5 skills, the POSIX check to all 4 shell scripts, and the comment | CI must dogfood every skill it claims to cover | none |
| C-013 | Within one skill | `oss-standards/references/16-scoring-appendix.md` pseudocode comment | `oss-standards/references/15-scoring-algorithm.md` | 16 comment says "33 criteria above"; the 33 criteria tables live in 15, not in 16 | Fix the comment to "33 criteria in 15-scoring-algorithm.md" | The comment pointed at the wrong file | none |
| C-014 | Cross-repo | Config `muse/AGENTS.md` no-slop section | `no-slop/SKILL.md` | Config: no-slop always-on, Mode 1 (DURING) by default, Mode 2 (AFTER) only for review, one-line replies and pure logistics exempt. Skill: Mode 1/2 resolution with no exemption | No conflict; no edit on either side | The config exemption is a deployment scoping by Boss, not a change to the skill's rules | none |
| C-015 | Across skills | `create-skill`, `research` (publishable at 90); `no-slop` (PASS at 80); `git-workflow`, `oss-standards` (own bands) | Each other | Publishable thresholds differ across skills | Not a conflict; no edit | Each threshold belongs to a different artifact (skill, deliverable, text, workflow, repo) | none |
| C-016 | Within one skill | `oss-standards/references/06-repo-structure.md` ("install.sh at root MANDATORY") | `oss-standards/scripts/repo-audit.sh` (vacuous pass without install.sh) + this repo (no install.sh) | 06 mandates install.sh; the audit passes without one | Not a conflict; no edit | 06's mandate is scoped to the tiny single-binary repo shape; the audit's vacuous pass is by design for other shapes | none |
| C-017 | Across skills | "standalone 0-100 scoring algorithm" in `research`, `no-slop`, `oss-standards`, `create-skill` descriptions | C-001 | The word "standalone" could read as the superseded no-pointer policy | Not a conflict; no edit | Here "standalone" means a self-contained algorithm, not a no-pointer policy | none |
| C-018 | Format exemption | `.github/pull-request-template.md`, `git-workflow/assets/pull-request-template.md` | One-H1-per-file rule | Both files have zero H1 headings | Exemption recorded; no H1 added | They are PR-body fragments; an H1 would inject a heading into every PR | none |
| C-019 | Rule tension | TOC rule (references over 100 lines get a TOC) | `create-skill/scripts/validate.py` G7 (reference files over 150 lines lose 2 points) | A TOC would push `create-skill/references/11-quality-scoring.md` (148 lines), `git-workflow/references/01-branching-models.md` (148 lines), and `no-slop/references/14-code-comment-hygiene.md` (136 lines, 16 headings) over 150 lines | TOC omitted in those 3 files; the 150-line flatness rule wins | The validator enforces the 150-line limit mechanically; a TOC that costs score points is not worth it. The other 13 files over 100 lines get a TOC | none |
| C-020 | Format exemption | `oss-standards/references/16-scoring-appendix.md` | One-H1-per-file rule | The file had zero H1 headings (started at H2) | Fix: add "# Scoring appendix" as the H1 | Unlike C-018, this is a standalone reference document, so the rule applies | none |

## Mechanical fixes (not conflicts)

Applied repo-wide in the same refactor, recorded here so the diff is auditable:

- Em dash: all 116 literal em dash characters (U+2014) removed from
  `.md` files. Prose uses a comma, period, colon, or parentheses
  instead. The two places where the em dash is the subject of the rule
  (`no-slop/references/07-anti-slop-rules.md` H-02,
  `no-slop/references/09-self-audit.md` Block 1) now name it as
  U+2014 instead of showing the literal character, so the files pass
  their own scanner.
- Emoji: the one literal emoji example
  (`no-slop/references/14-code-comment-hygiene.md`, decorative emoji
  in comments) now names the emoji (`[check mark]`, `[rocket]`)
  instead of showing the literal characters.
- Code fences: all 16 bare fences now carry a language tag
  (`text`, `sh`, `python`, `markdown`, or `console` as appropriate).
- TOCs: the 13 reference files over 100 lines that fit under 150
  lines with a TOC got a `## Contents` block after the H1. See C-019
  for the 3 omissions.
- H1: see C-020.
- CHANGELOG.md `[Unreleased]`: new entry records this refactor and
  the C-001 supersession; "dogfoods all four skills" corrected to
  five (the `[Unreleased]` section is still unreleased, so this is a
  live correction, not rewritten history). Older released entries
  keep their original wording, including the pre-rename filename
  `06-ui-slop-patterns.md`.

## Known gaps (not changed)

- `create-skill/references/09-security.md` cites 2026 incident
  statistics (Snyk, Antiy CERT, Air Security, Check Point) without
  URLs. The claims are left as written: adding URLs without opening
  the sources would risk fabrication, and verifying them is new
  research, out of scope for a consistency refactor.
- `oss-standards` ships shell scripts but the repo has no
  `.shellcheckrc`, although `06-repo-structure.md` calls it
  non-negotiable for repos that ship shell scripts and
  `05-install-sh-testing.md` assumes one exists. The audit reports
  it as INFO [SOON], not NOW. Adding the file is new behavior, so it
  is left as a gap for Boss to approve.
