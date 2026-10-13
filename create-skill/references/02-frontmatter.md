<!--
  references/02-frontmatter.md -- Every SKILL.md frontmatter field: semantics,
  constraints, required vs optional. Verified 2026-10-13 against the Agent
  Skills spec (agentskills.io/specification) and the official OpenCode skills
  docs (opencode.ai/docs/skills), which are the source of truth.
-->

# Frontmatter Reference

The frontmatter is a YAML block delimited by `---` lines. It **must be the very
first thing in SKILL.md** (parsers expect `---` at byte 0). Do not put comments
or any other content before it.

## Fields

| Field | Required | Semantics / constraints |
|---|---|---|
| `name` | Yes | 1-64 chars; `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase alphanumeric, single hyphens, no leading/trailing `-`, no consecutive `--`). **Must equal the parent directory name.** Required identically by the spec and the official OpenCode docs. |
| `description` | Yes | 1-1024 chars, non-empty. What the skill does + when to use it, with trigger keywords. The *only* thing the model sees at selection time. A skill without one still loads but is invisible to the model. |
| `license` | No | License name or pointer to a bundled license file. |
| `compatibility` | No | 1-500 chars if present. Environment requirements (intended product, system packages, network). Convention: `compatibility: opencode` for OpenCode-only skills. |
| `metadata` | No | Arbitrary **string-to-string** map for client-specific keys. OpenCode behavior goes here, never as new top-level fields. Quote values as strings for portability. |
| `allowed-tools` | No | Spec-experimental, space-separated pre-approved tools. "Support may vary between implementations" -- OpenCode does not implement it. |

OpenCode `metadata` keys (per the official OpenCode docs):

- `opencode/slash: "true"` -- expose the skill as a `/name` command in the TUI.
- `opencode/autoinvoke: "false"` -- hide from model-facing auto-selection
  (`<available_skills>`); still loadable by exact name. Use for powerful or
  sensitive skills you want available but not volunteered.

The spec defines metadata values as strings, so quoted values are the portable
form; OpenCode also accepts YAML booleans as a convenience.

## Fields you must NOT use

- **`disable-model-invocation`**: appears in some community docs, but it is in
  **neither** the Agent Skills spec **nor** OpenCode's official documentation.
  Never use it. The portable, documented equivalent is
  `metadata: {"opencode/autoinvoke": "false"}`.
- **Any invented top-level field** (e.g. `version`, `author`, `risk_tier`):
  unknown top-level fields are tolerated and ignored by parsers, but they are
  not portable. Client-specific behavior belongs in namespaced `metadata` keys.
  (Note: the OWASP Universal Skill Format v1.0 *proposal*, Mar 2026, defines
  extra fields such as `version`, `permissions`, and `signature` -- it is a
  proposal, not the spec. Do not mix it into spec frontmatter.)

## Rules

- Unknown top-level fields are tolerated and ignored -- but do not invent any;
  client-specific behavior belongs in `metadata`.
- `metadata` values should be strings for cross-client portability.
- There is no `version` field in the spec. Version skills with git tags or by
  vendoring (pin by git ref; "latest" is a moving target).
- Enforcement strictness may vary between implementations (a lenient loader
  might accept a non-conforming skill), but the spec and the official OpenCode
  docs both state the rules above -- always author to the strict rule.
