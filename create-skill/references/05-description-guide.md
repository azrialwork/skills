<!--
  references/05-description-guide.md -- How to write the description field:
  the highest-leverage field in a skill, since it is the entire selection
  surface the model sees.
-->

# Description Guide

The `description` is the **only thing the model sees when choosing a skill**.
A weak description means the skill never triggers; a precise, trigger-rich one
means it triggers exactly when it should. This is the highest-leverage field.

## Description construction algorithm

> Why: The description is the entire selection surface the model sees, so a vague description is how a good skill never gets invoked.

INPUT: the skill's capabilities and the user's task vocabulary. OUTPUT: one
`description` string. Follow the formula:

```
<What the skill does -- specific capabilities>. Use when <trigger scenarios and key terms>.
```

Steps:

1. **Capability clause.** State specific capabilities in third person: "Extracts text and tables from PDF files...", NEVER "I can help you with PDFs...". Name concrete artifacts: inputs, outputs, file types, tools. IF a verb is vague ("parses", "helps") THEN replace it with the concrete operation.
2. **Trigger clause.** Include the words users actually say, synonyms, and adjacent contexts. Models **under-trigger**, so be slightly pushy: "...even when the user does not explicitly mention forms."
3. **Combine** what + when into the single `description` field. There is no separate trigger field.
4. **Verify.** Run every check below; ANY FAIL means rewrite.

Verification checks (PASS/FAIL):

- [ ] PASS: third person throughout. IF it starts with "I"/"We"/"You" THEN FAIL.
- [ ] PASS: 1-1024 characters, non-empty. IF outside THEN FAIL.
- [ ] PASS: 1-3 sentences. IF more THEN FAIL.
- [ ] PASS: names concrete artifacts (file types, tools, commands) the task involves.
- [ ] PASS: contains trigger keywords a user would plausibly type.
- [ ] PASS: includes a negative trigger IF the skill is easily confused with another ("Use for X, not for Y").
- [ ] PASS: every word earns its place; nothing is filler.

## Good vs bad (mechanical comparison)

> Why: Authors cannot feel the difference between specific and vague in their own writing until they see both side by side.

| Verdict | Description | Why it fails/passes the checks |
|---|---|---|
| Bad | "Helps with documents." | FAIL: vague verb, no artifacts, no trigger clause. |
| Good | "Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction." | PASS: concrete operations, artifact names, trigger-rich clause. |
| Bad | "I can help you write better git commit messages." | FAIL: first person. |
| Good | "Drafts conventional-commit messages from staged diffs and validates message format. Use when committing, or when the user mentions commit messages, changelogs, or release notes." | PASS: third person, concrete input (staged diffs), trigger terms. |

## Rules

> Why: A missing description does not cause an error — it causes silence, the hardest failure to notice.

- A missing description still loads the skill but hides it from the model -- ALWAYS write one.
- Aim for 1-3 sentences; every word should help selection.
