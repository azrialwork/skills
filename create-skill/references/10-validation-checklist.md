<!--
  references/10-validation-checklist.md -- Pre-publish checklist and testing
  procedure for a new skill, including scripts/validate.py and live OpenCode
  verification.
-->

# Validation Checklist

Work through this list before publishing or sharing a skill. Fix every error;
treat warnings as errors unless you can justify them.

## Automated: scripts/validate.py

Run from the skill's parent directory:

```
python3 <skill-repo>/create-skill/scripts/validate.py <skill-name>/
```

It checks (stdlib only, no dependencies):

- `SKILL.md` exists; frontmatter parses; frontmatter is at byte 0.
- `name` present, matches `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64 chars, equals the
  directory name.
- `description` present, 1-1024 chars, third-person heuristics (flags leading
  "I"/"We"/"You can").
- `metadata` values are strings (portability); warns on unknown top-level
  fields; warns on V1-ignored fields (`license`, `compatibility`, `metadata`,
  `disable-model-invocation`) when targeting V1.
- Body under ~500 lines; every `references/*.md` link in SKILL.md resolves to
  an existing file; scripts are executable or have a shebang.

## Manual checklist

- [ ] One skill = one job. The description's "Use when" triggers do not overlap
      another skill's triggers.
- [ ] Description follows `05-description-guide.md`: third person, specific,
      trigger-rich, slightly pushy, 1-1024 chars.
- [ ] Body is imperative, explains why, documents non-obvious steps only;
      input/output examples and edge cases present.
- [ ] Repeated deterministic logic lives in `scripts/`, not in prose.
- [ ] All file references are relative to the skill root, one level deep.
- [ ] Security review done per `09-security.md`; required `permission.skill`
      posture documented in the body if the skill is powerful.
- [ ] V1/V2 behavior differences accounted for (see `02-frontmatter.md` and
      `07-invocation-permissions.md`); no reliance on V2-only fields if the
      skill must run on V1.
- [ ] No secrets, tokens, or personal data in the skill.

## Live test in OpenCode

1. Point `skills.paths` at the skill's parent directory (see
   `04-discovery.md`) and restart OpenCode.
2. Run `opencode debug skill` (if available) and confirm the skill is listed
   with the expected name and description.
3. Give the agent a task matching the triggers **without naming the skill**;
   confirm it discovers and loads the skill via the `skill` tool.
4. Invoke it explicitly (`/name`) and confirm the full instructions apply.
5. If the skill should *not* auto-trigger, confirm it stays out of
   `<available_skills>` (V2 `autoinvoke: false`) yet loads by exact name.
