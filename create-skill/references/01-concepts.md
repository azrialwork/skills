<!--
  references/01-concepts.md -- What an Agent Skill is and how it differs from
  neighboring mechanisms (command, agent/subagent, MCP, tool injection).
  Read this before deciding whether a skill is the right vehicle.
-->

# Concepts: What a Skill Is

An Agent Skill is a **procedural-knowledge package**: a directory containing a
`SKILL.md` file (YAML frontmatter + Markdown instructions), optionally with
`scripts/`, `references/`, and `assets/`. It tells the agent *how* to do a
recurring task -- the judgment, steps, and domain knowledge -- and is loaded
into context **on demand**, only when relevant.

Skills are cheap extensibility: at startup the model sees only each skill's
`name` + `description` (~100 tokens per skill). The full body loads only when
the agent calls the `skill` tool. See `06-progressive-disclosure.md`.

## Skill vs neighboring mechanisms

| Mechanism | What it is | Who invokes it | Where it lives |
|---|---|---|---|
| **Skill** (`SKILL.md`) | Instruction package loaded into context on demand | **Agent decides**, via the `skill` tool | skill directories (see `04-discovery.md`) |
| **Command** (`/name`) | User-invoked prompt template; the system renders it, the agent receives the result | **User**, by typing `/name` | `.opencode/command/<name>.md`, MCP prompts, or skills |
| **Agent / subagent** | Autonomous executor with its own model, tools, and permissions, spawned via the `task` tool | User (`@mention`, `/agents`) or a parent agent | `.opencode/agents/` |
| **MCP server** | Gives the agent *tools and data access* to external APIs/services | Agent calls its tools | `opencode.json` -> `mcp` |
| **Tool injection** (custom tools) | New callable functions registered by plugins | Agent calls them directly | plugin `tool` definitions |

Key distinctions:

- **Skill vs command.** Skills are loaded *by* the agent (it infers relevance from
  the description). Commands are shortcuts *for* the user (`/init`). In V1 every
  skill is also auto-exposed as `/name`; in V2 that needs
  `metadata: {"opencode/slash": "true"}`. See `07-invocation-permissions.md`.
- **Skill vs MCP.** MCP gives the agent *tool access* to external systems. A
  skill provides the *judgment* for when to use those tools and what to do with
  them. Skills often *use* MCP tools for execution. Skills are not tools --
  there is exactly one tool, `skill`, and skills are the content it returns.
- **Skill vs agent.** Skills are instruction payloads; agents are executors. A
  subagent can itself call the `skill` tool, subject to its own permissions.
- **Skill vs tool injection.** A custom tool adds a new *capability* (a function
  the model can call). A skill adds *knowledge* (how to approach a task, often
  by combining existing tools).

## When to build a skill

Build a skill when the same multi-step procedure, domain knowledge, or set of
conventions is needed repeatedly and is currently re-explained every session.
Do NOT build a skill for: a one-off task (just do it), a new capability no
existing tool covers (write a custom tool or MCP server instead), or a pure
prompt shortcut the user triggers manually (write a command).
