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

Invocation-gating rule: IF a skill is dangerous or powerful and must be
available but not volunteered THEN set
`metadata: {"opencode/autoinvoke": "false"}`: it is excluded from
`<available_skills>` but remains loadable by exact name.

## User-driven invocation algorithm

INPUT: whether users should fire the skill manually.

1. IF user-invoked access is wanted THEN set `metadata: {"opencode/slash": "true"}`: exposes the skill as a `/name` slash command in the TUI. Typing `/git-release` injects the SKILL.md content as a prompt.
2. IF a user/MCP command has the same name THEN the user/MCP command wins; rename one of them.
3. NEVER depend on auto-exposure: older OpenCode V1 installs auto-exposed *every* skill as `/name` with no metadata key needed. The current official docs describe the opt-in form -- author for the opt-in form ONLY.

## Permission-gating algorithm

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

Pattern matching (evaluate in order, first match wins):

- IF the action is `allow` THEN the skill loads immediately.
- ELSE IF the action is `deny` THEN the skill is hidden from the agent; access is rejected.
- ELSE IF the action is `ask` THEN the user is prompted before the skill loads.

Scope of control:

- Per-agent overrides: custom agents set `permission.skill` in their frontmatter; built-in agents via `opencode.json` -> `agent.<name>.permission.skill`.
- Full disable per agent: set `tools: { skill: false }` (agent frontmatter) or `agent.<name>.tools.skill: false` (`opencode.json`). The `<available_skills>` block is then omitted entirely for that agent.
- Patterns support wildcards: `internal-*` matches `internal-docs`, `internal-tools`, etc.

## Authoring rules

WHEN authoring a skill, run these rules:

1. IF the skill needs any permission (network, credentials, destructive commands) THEN document it in the skill body AND recommend the matching `permission.skill` posture.
2. IF the skill is untrusted or powerful THEN the recommended posture MUST be `ask` or `deny` by default.
3. IF the skill is sensitive THEN combine `metadata: {"opencode/autoinvoke": "false"}` (not volunteered) with the documented permission posture.
