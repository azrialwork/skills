<!--
  references/05-description-guide.md -- How to write the description field:
  the highest-leverage field in a skill, since it is the entire selection
  surface the model sees.
-->

# Description Guide

The `description` is the **only thing the model sees when choosing a skill**.
A weak description means the skill never triggers; a precise, trigger-rich one
means it triggers exactly when it should. This is the highest-leverage field.

## Formula

```
<What the skill does -- specific capabilities>. Use when <trigger scenarios and key terms>.
```

- **Third person**, always: "Extracts text and tables from PDF files...",
  never "I can help you with PDFs...". The text is injected into model context.
- **Specific**: concrete inputs, outputs, file types, tools. "Parses" is vague;
  "Extracts text and tables from PDF files, fills AcroForm fields, and merges
  documents with qpdf" is selectable.
- **Trigger-rich**: include the words users actually say, synonyms, and adjacent
  contexts. Models **under-trigger**, so be slightly pushy: "...even when the
  user does not explicitly mention forms."
- **Combine what + when** into the single `description` field. There is no
  separate trigger field.

## Good vs bad

Bad:  "Helps with documents."
Good: "Extracts text and tables from PDF files, fills forms, and merges
       documents. Use when working with PDF files or when the user mentions
       PDFs, forms, or document extraction."

Bad:  "I can help you write better git commit messages."
Good: "Drafts conventional-commit messages from staged diffs and validates
       message format. Use when committing, or when the user mentions commit
       messages, changelogs, or release notes."

## Rules

- 1-1024 characters, non-empty. Aim for 1-3 sentences; every word should help
  selection.
- Name concrete artifacts (file types, tools, commands) the task involves.
- Include negative triggers when the skill is easily confused with another
  ("Use for X, not for Y").
- In V1 a missing description still loads the skill but hides it from the model
  -- always write one.
