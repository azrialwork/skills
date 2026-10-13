<!--
  references/10-validation-checklist.md -- Pre-publish checklist and testing
  procedure for a new skill: automated validation (scripts/validate.py),
  quality scoring (references/11-quality-scoring.md), manual review, and live
  testing in OpenCode.
-->

# Validation Checklist

Work through this list before publishing or sharing a skill. Fix every error;
treat warnings as errors unless you can justify them. Nothing here is
optional: each item maps to the quality-scoring algorithm
(`11-quality-scoring.md`), where automated checks are marked [A] and
human-rubric checks [H].

## 1. Automated: scripts/validate.py [A]

Run from the skill's parent directory:

```
python3 <skill-repo>/create-skill/scripts/validate.py <skill-name>/
```

It checks (stdlib only, no dependencies):

- `SKILL.md` exists; frontmatter parses; frontmatter is at byte 0. (B1)
- `name` present, matches `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64 chars, equals the
  directory name. (B2, B3)
- `description` present, 1-1024 chars; flags leading "I"/"We"/"You". (B4, B5, B6)
- `metadata` values are strings (portability). (B10)
- Warns on unknown top-level fields -- including `disable-model-invocation`,
  which is in neither the spec nor OpenCode's official docs (use
  `metadata: {"opencode/autoinvoke": "false"}` instead).
- Warns on `allowed-tools` (spec-experimental, unsupported by OpenCode).
- Body under ~500 lines; every `references/*.md` link in SKILL.md resolves to
  an existing file; scripts are executable or have a shebang. (B7, B8, B9)

## 2. Quality score [A+H]

```
python3 <skill-repo>/create-skill/scripts/validate.py --score <skill-name>/ [--rubric rubric.json]
```

This runs the full 0-100 scoring algorithm from `11-quality-scoring.md`:
B1-B10 (55 pts, automated) plus G1-G9 (45 pts). G-items that cannot be
measured mechanically take their values from `--rubric` (a JSON file with
one 0/1/2 score per G-item); without it they are reported as
needs-human-judgment and the score is shown as a range. **A publishable skill
scores 90+.** See `11-quality-scoring.md` for the exact criteria, the rubric
format, and a worked example.

## 3. Manual checklist [H]

- [ ] One skill = one job. The description's "Use when" triggers do not
      overlap another skill's triggers. (G3, G4)
- [ ] Description follows the formula in `05-description-guide.md`: third
      person, capability clause + trigger clause, specific artifacts,
      trigger-rich, slightly pushy, 1-3 sentences, 1-1024 chars. (G1, G2, G5)
- [ ] Body is imperative, explains why, documents non-obvious steps only;
      input/output examples and edge cases present. (G6)
- [ ] Progressive disclosure holds: detail lives in `references/`, not the
      body; no content duplicated across layers; each reference file covers
      one topic. (G6, G7)
- [ ] Repeated deterministic logic lives in `scripts/`, not in prose. (G8)
- [ ] All file references are relative to the skill root, one level deep.
- [ ] Security review done per `09-security.md`: no exfiltration patterns, no
      untrusted external instruction sources, scripts hardened; required
      `permission.skill` posture documented in the body if the skill is
      powerful; sensitive skills carry
      `metadata: {"opencode/autoinvoke": "false"}`. (G9)
- [ ] Implementation differences accounted for (see `02-frontmatter.md` and
      `07-invocation-permissions.md`); no reliance on undocumented fields if
      the skill must be portable.
- [ ] No secrets, tokens, or personal data in the skill.

## 4. Live test in OpenCode

1. Point `skills.paths` at the skill's parent directory (see
   `04-discovery.md`) and restart OpenCode.
2. Run `opencode debug skill` (if available) and confirm the skill is listed
   with the expected name and description.
3. Give the agent a task matching the triggers **without naming the skill**;
   confirm it discovers and loads the skill via the `skill` tool.
4. Invoke it explicitly (`/name`, if slash-exposed) and confirm the full
   instructions apply.
5. If the skill should *not* auto-trigger, confirm it stays out of
   `<available_skills>` (`autoinvoke: "false"`) yet loads by exact name.
6. For skills with objectively verifiable outputs: draft 2-3 realistic test
   prompts, run each with and without the skill loaded, compare the outputs
   against your expectations, and iterate on the skill until the with-skill
   runs are clearly better. (This eval loop mirrors the iterative
   test-and-refine practice of Anthropic's canonical skill-creator.)
