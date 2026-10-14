<!--
  references/02-frontmatter.md -- Every SKILL.md frontmatter field: semantics,
  constraints, required vs optional. Verified 2026-10-13 against the Agent
  Skills spec (agentskills.io/specification) and the official OpenCode skills
  docs (opencode.ai/docs/skills), which are the source of truth.
-->

# Frontmatter Reference

The frontmatter is a YAML block delimited by `---` lines. It MUST be the very
first thing in SKILL.md: parsers expect `---` at byte 0. IF any comment or
content precedes it THEN the frontmatter FAILS to parse.

## Field validation algorithm

INPUT: the parsed frontmatter map. Evaluate every row; ANY FAIL rejects the skill.

| Field | Required | IF violated THEN |
|---|---|---|
| `name` | Yes | FAIL: MUST be 1-64 chars, match `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase alphanumeric, single hyphens, no leading/trailing `-`, no `--`), and EXACTLY equal the parent directory name. Required identically by the spec and the official OpenCode docs. |
| `description` | Yes | FAIL: MUST be 1-1024 chars, non-empty, stating what the skill does + when to use it, with trigger keywords. It is the ONLY thing the model sees at selection time. A skill without one still loads but is invisible to the model. |
| `license` | No | PASS: license name or pointer to a bundled license file. |
| `compatibility` | No | PASS IF absent or 1-500 chars: environment requirements (intended product, system packages, network). Convention: `compatibility: opencode` for OpenCode-only skills. |
| `metadata` | No | PASS IF absent or an arbitrary **string-to-string** map for client-specific keys. OpenCode behavior goes here, NEVER as new top-level fields. Quote values as strings for portability. |
| `allowed-tools` | No | PASS with warning: spec-experimental, space-separated pre-approved tools. "Support may vary between implementations" -- OpenCode does not implement it. |

OpenCode `metadata` keys (per the official OpenCode docs):

- `opencode/slash: "true"` -- IF the skill should be user-invokable THEN set this: exposes it as a `/name` command in the TUI.
- `opencode/autoinvoke: "false"` -- IF the skill is powerful or sensitive and must not be volunteered THEN set this: hides it from model-facing auto-selection (`<available_skills>`); still loadable by exact name.

The spec defines metadata values as strings, so quoted values are the portable
form; OpenCode also accepts YAML booleans as a convenience.

## Fields you must NEVER use

- **`disable-model-invocation`**: appears in some community docs, but it is in
  NEITHER the Agent Skills spec NOR OpenCode's official documentation. NEVER
  use it. The portable, documented equivalent is
  `metadata: {"opencode/autoinvoke": "false"}`.
- **Any invented top-level field** (e.g. `version`, `author`, `risk_tier`):
  unknown top-level fields are tolerated and ignored by parsers, but they are
  not portable. Client-specific behavior belongs in namespaced `metadata` keys.
  (The OWASP Universal Skill Format v1.0 *proposal*, Mar 2026, defines extra
  fields such as `version`, `permissions`, `signature` -- it is a proposal, not
  the spec. Do not mix it into spec frontmatter.)

## Rules

- IF a top-level field is unknown to the spec THEN parsers tolerate and ignore it -- but NEVER invent one; client-specific behavior belongs in `metadata`.
- `metadata` values MUST be strings for cross-client portability.
- There is no `version` field in the spec. Version skills with git tags or by vendoring: pin by git ref; "latest" is a moving target.
- Author to the strict rule ALWAYS: enforcement strictness varies between implementations (a lenient loader might accept a non-conforming skill), but the spec and the official OpenCode docs both state the rules above.
