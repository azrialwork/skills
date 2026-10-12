<!--
  references/07-invocation-permissions.md -- How skills get invoked (model-driven
  vs user-driven) and how access is gated: permission.skill patterns and
  per-agent controls. V1 vs V2 behavior is called out explicitly.
-->

# Invocation and Permissions

## Model-driven invocation (primary path)

The agent reads `<available_skills>`, matches the current task against
descriptions, and calls the `skill` tool:

- V1: `skill({ name: "git-release" })`
- V2: `skill({ id: "git-release" })`

The tool returns the skill's full content as a tool result and the model
follows it. Users never need to name skills -- "I need to create a release"
should be enough for the agent to infer `git-release`, provided the
description is trigger-rich (see `05-description-guide.md`).

## User-driven invocation

- **V1:** *every* skill is automatically exposed as a `/name` slash command
  (`source: "skill"`). Typing `/git-release` injects the SKILL.md content as a
  prompt. If a user/MCP command has the same name, the user/MCP command wins.
- **V2:** exposure needs `metadata: {"opencode/slash": "true"}`.
- Skills with `opencode/autoinvoke: "false"` are hidden from auto-selection but
  remain loadable by exact name -- the right setting for dangerous or powerful
  skills you want available but not volunteered.

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
- In V1 the tool asks for permission on each load unless the `always` pattern
  already allows it.

When authoring: document any permission the skill needs (network, credentials,
destructive commands) in the skill body, and recommend the matching
`permission.skill` posture in `10-validation-checklist.md` terms -- `ask` or
`deny` by default for untrusted or powerful skills.
