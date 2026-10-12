<!--
  references/02-frontmatter.md -- Every SKILL.md frontmatter field: semantics,
  constraints, required vs optional, and V1 vs V2 behavior differences.
-->

# Frontmatter Reference

The frontmatter is a YAML block delimited by `---` lines. It **must be the very
first thing in SKILL.md** (parsers expect `---` at byte 0). Do not put comments
or any other content before it.

## Fields

| Field | Required | V1 | V2 | Semantics / constraints |
|---|---|---|---|---|
| `name` | Yes | read | read, regex-enforced | 1-64 chars; `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase alnum, single hyphens, no leading/trailing `-`). **Must equal the parent directory name.** |
| `description` | Yes (docs) / optional (V1 code) | read | read | 1-1024 chars, non-empty. What the skill does + when to use it, with trigger keywords. The *only* thing the model sees at selection time. A skill without one still loads in V1 but is invisible to the model. |
| `license` | No | ignored | accepted | License name or pointer to a bundled license file. |
| `compatibility` | No | ignored | accepted | 1-500 chars. Environment requirements (target product, system packages, network). Convention: `compatibility: opencode`. |
| `metadata` | No | ignored | accepted | Arbitrary **string-to-string** map for client-specific keys. OpenCode behavior goes here, never as new top-level fields. |
| `disable-model-invocation` | No | ignored | parsed | V2 only: when truthy, sets `autoinvoke: false`. Loose boolean parsing (`true/yes/on/1`). Prefer `metadata["opencode/autoinvoke"]`. |
| `allowed-tools` | No | unsupported | unsupported | Spec-experimental, space-separated pre-approved tools. "Support may vary between implementations" -- OpenCode does not implement it. |

OpenCode `metadata` keys (V2):

- `opencode/slash: "true"` -- expose the skill as a `/name` command in the TUI.
  (Documented; in V1 every skill is already auto-exposed, no key needed.)
- `opencode/autoinvoke: "false"` -- hide from model-facing auto-selection
  (`<available_skills>`); still loadable by exact name. Use for powerful or
  sensitive skills you want available but not volunteered.

Quoted strings are the portable form (the spec defines metadata values as
strings); OpenCode also accepts YAML booleans.

## Rules

- Unknown top-level fields are tolerated and ignored -- but do not invent any;
  client-specific behavior belongs in `metadata`.
- `metadata` values should be strings for cross-client portability.
- V1 reads **only** `name` and `description`. `license`, `compatibility`,
  `metadata`, and `disable-model-invocation` have no effect in V1 -- they are
  documentation for V2 and other spec clients.
- There is no `version` field in the spec. Version skills with git tags or by
  vendoring.
