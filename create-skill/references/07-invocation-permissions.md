<!--
  references/07-invocation-permissions.md -- How skills get invoked (model-driven
  vs user-driven) and how access is gated: permission.skill patterns and
  per-agent controls. Verified 2026-10-13 against the official OpenCode skills
  docs (opencode.ai/docs/skills); the Agent Skills spec defines no invocation
  or access-control behavior.
-->

# Invocation and Permissions

## Model-driven invocation (primary path)

OpenCode lists available skills in the `skill` tool description as an
`<available_skills>` block (each entry: `name` + `description`). The agent
matches the current task against descriptions and calls the tool:

```
skill({ name: "git-release" })
```

The tool returns the skill's full content as a tool result and the model
follows it. Users never need to name skills -- "I need to create a release"
should be enough for the agent to infer `git-release`, provided the
description is trigger-rich (see `05-description-guide.md`).

Skills with `metadata: {"opencode/autoinvoke": "false"}` are **not** included
in `<available_skills>` -- they stay hidden from auto-selection but remain
loadable by exact name. This is the right setting for dangerous or powerful
skills you want available but not volunteered.

## User-driven invocation

Set `metadata: {"opencode/slash": "true"}` to expose the skill as a `/name`
slash command in the TUI. Typing `/git-release` injects the SKILL.md content
as a prompt. If a user/MCP command has the same name, the user/MCP command
wins.

Historical note: older OpenCode V1 installs auto-exposed *every* skill as
`/name` with no metadata key needed. The current official docs describe the
opt-in form above -- author for the opt-in form; do not depend on
auto-exposure.

## Permission gating

`permission.skill` in `opencode.json` uses wildcard patterns with three actions:

```jsonc
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

- `allow` -- the skill loads immediately.
- `deny` -- the skill is hidden from the agent; access is rejected.
- `ask` -- the user is prompted before the skill loads.

Scope of control:

- Per-agent overrides: custom agents set `permission.skill` in their frontmatter;
  built-in agents via `opencode.json` -> `agent.<name>.permission.skill`.
- Full disable per agent: `tools: { skill: false }` (agent frontmatter) or
  `agent.<name>.tools.skill: false` (`opencode.json`). The `<available_skills>`
  block is then omitted entirely for that agent.
- Patterns support wildcards: `internal-*` matches `internal-docs`,
  `internal-tools`, etc.

When authoring: document any permission the skill needs (network, credentials,
destructive commands) in the skill body, and recommend the matching
`permission.skill` posture -- `ask` or `deny` by default for untrusted or
powerful skills. For sensitive skills, combine
`metadata: {"opencode/autoinvoke": "false"}` (not volunteered) with a
documented permission posture.
