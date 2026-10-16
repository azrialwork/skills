<!--
  references/10-validation-checklist.md -- Pre-publish checklist and testing
  procedure for a new skill: automated validation (scripts/validate.py),
  quality scoring (references/11-quality-scoring.md), manual review, and live
  testing in OpenCode.
-->

# Validation Checklist

Work through this list before publishing or sharing a skill. NOTHING here is
optional: each item maps to the quality-scoring algorithm
(`11-quality-scoring.md`), where automated checks are marked [A] and
human-rubric checks [H]. Gate rule: IF a phase FAILS THEN fix it before
starting the next phase. NEVER publish with a known failure.

## Phase 1 -- Automated: scripts/validate.py [A]

> Why: Automated checks catch the structural failures that no amount of careful reading will reliably find.

Run from the skill's parent directory:

```sh
python3 <skill-repo>/create-skill/scripts/validate.py <skill-name>/
```

PASS/FAIL criteria (stdlib only, no dependencies):

- [ ] PASS: `SKILL.md` exists; frontmatter parses; frontmatter is at byte 0. (B1)
- [ ] PASS: `name` present, matches `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64 chars, equals the directory name. (B2, B3)
- [ ] PASS: `description` present, 1-1024 chars; does NOT start with "I"/"We"/"You". (B4, B5, B6)
- [ ] PASS: every `metadata` value is a string (portability). (B10)
- [ ] PASS: no unknown top-level fields -- including `disable-model-invocation`, which is in neither the spec nor OpenCode's official docs (use `metadata: {"opencode/autoinvoke": "false"}` instead).
- [ ] PASS: `allowed-tools`, if present, is spec-experimental and unsupported by OpenCode (warning only, per `02-frontmatter.md` and `scripts/validate.py`).
- [ ] PASS: body under ~500 lines; every `references/*.md` link in SKILL.md resolves to an existing file; scripts are executable or have a shebang. (B7, B8, B9)

IF any item FAILS THEN fix it and re-run. Only proceed on all-PASS.

## Phase 2 -- Quality score [A+H]

> Why: A score below 90 does not mean the skill is bad. It means specific, named things are wrong, and named problems get fixed.

```sh
python3 <skill-repo>/create-skill/scripts/validate.py --score <skill-name>/ [--rubric rubric.json]
```

This runs the full 0-100 scoring algorithm from `11-quality-scoring.md`:
B1-B10 (55 pts, automated) plus G1-G9 (45 pts). G-items that cannot be
measured mechanically take their values from `--rubric` (a JSON file with
one 0/1/2 score per G-item); without it they are reported as
needs-human-judgment and the score is shown as a range.

Gate rule: IF the score is < 90 THEN the skill is NOT publishable: fix the
losing items and re-score. See `11-quality-scoring.md` for the exact criteria,
the rubric format, and a worked example.

## Phase 3 -- Manual checklist [H]

> Why: Human review exists for exactly the failures automation cannot see: trigger fit, duplication, and prose that reads like an attack.

- [ ] PASS: one skill = one job. The description's "Use when" triggers do NOT overlap another skill's triggers. (G3, G4)
- [ ] PASS: description follows the formula in `05-description-guide.md`: third person, capability clause + trigger clause, specific artifacts, trigger-rich, slightly pushy, 1-3 sentences, 1-1024 chars. (G1, G2, G5)
- [ ] PASS: body is imperative, explains why, documents non-obvious steps only; input/output examples and edge cases present. (G6)
- [ ] PASS: progressive disclosure holds: detail lives in `references/`, not the body; NO content duplicated across layers; each reference file covers one topic. (G6, G7)
- [ ] PASS: repeated deterministic logic lives in `scripts/`, not in prose. (G8)
- [ ] PASS: all file references are relative to the skill root, one level deep.
- [ ] PASS: security review done per `09-security.md`: no exfiltration patterns, no untrusted external instruction sources, scripts hardened; required `permission.skill` posture documented in the body if the skill is powerful; sensitive skills carry `metadata: {"opencode/autoinvoke": "false"}`. (G9)
- [ ] PASS: implementation differences accounted for (see `02-frontmatter.md` and `07-invocation-permissions.md`); no reliance on undocumented fields if the skill must be portable.
- [ ] PASS: no secrets, tokens, or personal data in the skill.

## Phase 4 -- Live test in OpenCode (algorithm)

> Why: A skill that passes every static check can still fail the only test that matters, whether the agent actually reaches for it.

1. Point `skills.paths` at the skill's parent directory (see `04-discovery.md`) and restart OpenCode.
2. Run `opencode debug skill` (if available) and confirm the skill is listed with the expected name and description. IF not listed THEN diagnose per `04-discovery.md` step 4.
3. Give the agent a task matching the triggers **without naming the skill**. IF the agent does not discover it via the `skill` tool THEN the description fails the trigger test: rewrite it per `05-description-guide.md` and re-test.
4. Invoke it explicitly (`/name`, if slash-exposed) and confirm the full instructions apply.
5. IF the skill must NOT auto-trigger THEN confirm it stays out of `<available_skills>` (`autoinvoke: "false"`) AND still loads by exact name.
6. IF the skill has objectively verifiable outputs THEN run the eval loop: draft 2-3 realistic test prompts; run each with and without the skill loaded; compare outputs against expectations; iterate on the skill until the with-skill runs are clearly better. (This mirrors the iterative test-and-refine practice of Anthropic's canonical skill-creator.)
