<!--
  references/08-spec-compatibility.md -- OpenCode's relationship to Anthropic's
  Agent Skills open standard: what "compatible" means in practice and how to
  keep a skill portable across clients. Verified 2026-10-13 against
  agentskills.io/specification and opencode.ai/docs/skills.
-->

# Agent Skills Spec Compatibility

OpenCode implements Anthropic's **Agent Skills** open standard
(agentskills.io): the packaging format -- a `<name>/SKILL.md` directory with
YAML frontmatter -- is identical, so one skill serves OpenCode, Claude Code,
Codex, Cursor, Gemini CLI, and other adopters. There is no shared registry;
compatibility is achieved through the identical file format.

## What "compatible" means in practice

1. **Shared directories.** OpenCode natively reads `~/.claude/skills`,
   `.claude/skills/`, `~/.agents/skills/`, and `.agents/skills/` -- the same
   folders other spec clients use. A skill installed once is visible
   everywhere.
2. **Shared frontmatter.** `name` (required, `^[a-z0-9]+(-[a-z0-9]+)*$`, 1-64
   chars, must match the directory name), `description` (required, 1-1024
   chars), `license` / `compatibility` / `metadata` (optional), and the
   experimental `allowed-tools` match the spec. Both the spec and the official
   OpenCode docs state the name rules identically.
3. **Namespaced extensions.** Client-specific behavior lives in `metadata`
   under namespaced keys (`opencode/slash`, `opencode/autoinvoke`) -- exactly
   what the spec recommends ("clients can use this to store additional
   properties"; keep keys unique). Never invent new top-level fields.

## OpenCode differences from the spec baseline

- Skills are surfaced via the `skill` tool and the `<available_skills>` block;
  `metadata: {"opencode/autoinvoke": "false"}` removes a skill from that block
  without unloading it.
- OpenCode ships a built-in `customize-opencode` skill and supports remote
  skills via `skills.urls` -- neither is in the spec.
- OpenCode's permission layer (`permission.skill` allow/ask/deny, per-agent
  `tools.skill: false`) is product-specific; the spec defines no access control.
- `allowed-tools` is spec-experimental and not implemented by OpenCode.

## Verified divergences (community claims vs official docs)

Two claims circulate in community docs that do **not** match the official
sources. The official sources win:

1. **"V2 does not enforce the name regex."** The spec requires the name rules,
   and the official OpenCode docs state them explicitly, including the
   equivalent regex `^[a-z0-9]+(-[a-z0-9]+)*$` and the directory-match rule.
   Author every skill to the strict rule regardless of what a lenient loader
   might accept.
2. **"`disable-model-invocation` is a V2 field."** It appears in neither the
   spec nor OpenCode's official docs. Do not use it; the documented portable
   form is `metadata: {"opencode/autoinvoke": "false"}`.

## Emerging (not the spec -- do not treat as normative)

- **OWASP Universal Skill Format v1.0** (proposal, Mar 2026,
  owasp.github.io/www-project-agentic-skills-top-10): proposes extra manifest
  fields (`version`, `permissions`, `signature`, `content_hash`, `risk_tier`)
  to mitigate supply-chain risks. It is a proposal, not the Agent Skills spec.
  Do not mix its fields into spec frontmatter; unknown top-level fields are
  ignored by spec parsers.

## Portability rules for authors

- Keep `metadata` values as **strings** (quoted) -- the spec defines the map as
  string-to-string; unquoted booleans are an OpenCode convenience, not portable.
- Do not depend on OpenCode-only behavior in the skill body unless the skill is
  OpenCode-only; mark that with `compatibility: opencode`.
- Test the skill in at least one other spec client (e.g. Claude Code reading
  the same `~/.claude/skills` directory) if portability matters.
