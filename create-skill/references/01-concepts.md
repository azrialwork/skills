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

## Mechanism selection algorithm

INPUT: the capability you want to add.

| IF you need... | THEN build... | Invoked by | Lives in |
|---|---|---|---|
| Recurring multi-step procedure, domain knowledge, or conventions | **Skill** (`SKILL.md`) | Agent, via the `skill` tool (matches task against `description`) | skill directories (see `04-discovery.md`) |
| A prompt template the user fires manually | **Command** (`/name`) | User, by typing `/name` | `.opencode/command/<name>.md`, MCP prompts, or a skill |
| An autonomous executor with its own model and permissions | **Agent / subagent** | User (`@mention`, `/agents`) or a parent agent | `.opencode/agents/` |
| Tool/data access to external APIs and services | **MCP server** | Agent, by calling its tools | `opencode.json` -> `mcp` |
| A new callable function (a capability no tool covers) | **Custom tool** (tool injection) | Agent, called directly | plugin `tool` definitions |

Decision rules (evaluate in order, first match wins):

1. IF the user triggers it manually every time THEN build a **command**, not a skill.
2. ELSE IF no existing tool can perform the operation THEN build a **custom tool or MCP server**, not a skill.
3. ELSE IF the procedure runs once and is never repeated THEN do the task directly; NEVER build a skill for a one-off.
4. ELSE IF the same procedure, knowledge, or conventions are needed repeatedly AND are currently re-explained every session THEN build a **skill**.
5. ELSE do not build anything.

Key distinctions (mechanical tests):

- **Skill vs command.** IF the agent must infer relevance from the task THEN skill. IF the user types a shortcut THEN command. A skill MAY additionally expose `/name` via `metadata: {"opencode/slash": "true"}` (see `07-invocation-permissions.md`).
- **Skill vs MCP.** MCP = tool access to external systems; skill = judgment for *when* to use those tools and what to do with them. Skills often *call* MCP tools. There is exactly one tool, `skill`; skills are the content it returns.
- **Skill vs agent.** Skills are instruction payloads; agents are executors. A subagent MAY call the `skill` tool, subject to its own permissions.
- **Skill vs tool injection.** A custom tool adds a *capability* (a callable function). A skill adds *knowledge* (how to approach a task, usually by combining existing tools).
