<!--
  references/08-spec-compatibility.md -- OpenCode's relationship to Anthropic's
  Agent Skills open standard: what "compatible" means in practice and how to
  keep a skill portable across clients.
-->

# Agent Skills Spec Compatibility

OpenCode implements Anthropic's **Agent Skills** open standard
(agentskills.io): the packaging format -- a `<name>/SKILL.md` directory with
YAML frontmatter -- is identical, so one skill serves OpenCode, Claude Code,
Codex, Cursor, Gemini CLI, and other adopters. There is no shared library;
compatibility is achieved through the identical file format.

## What "compatible" means in practice

1. **Shared directories.** OpenCode natively reads `~/.claude/skills`,
   `.claude/skills`, `~/.agents/skills`, and `.agents/skills` -- the same
   folders other spec clients use. A skill installed once is visible
   everywhere.
2. **Shared frontmatter.** `name` (required), `description` (required),
   `license` / `compatibility` / `metadata` (optional), the name regex
   `^[a-z0-9]+(-[a-z0-9]+)*$`, and the 1024-char description cap match the spec
   verbatim.
3. **Namespaced extensions.** Client-specific behavior lives in `metadata`
   under namespaced keys (`opencode/slash`, `opencode/autoinvoke`) -- exactly
   what the spec recommends ("clients can use this to store additional
   properties"; keep keys unique). Never invent new top-level fields.

## OpenCode differences from the spec baseline

- Skills are surfaced via the `skill` tool / system prompt `<available_skills>`
  block (V1 uses system-prompt injection; the presentation has moved toward the
  tool over versions).
- OpenCode ships a built-in `customize-opencode` skill and supports remote
  skills via `skills.urls` -- neither is in the spec.
- OpenCode's permission layer (`permission.skill` allow/ask/deny, per-agent
  `tools.skill: false`) is product-specific; the spec defines no access control.
- `allowed-tools` is spec-experimental and not implemented by OpenCode.

## Portability rules for authors

- Keep `metadata` values as **strings** (quoted) -- the spec defines the map as
  string-to-string; unquoted booleans are an OpenCode convenience, not portable.
- Do not depend on OpenCode-only behavior in the skill body unless the skill is
  OpenCode-only; mark that with `compatibility: opencode`.
- Test the skill in at least one other spec client (e.g. Claude Code reading
  the same `~/.claude/skills` directory) if portability matters.
