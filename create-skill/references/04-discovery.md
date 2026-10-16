<!--
  references/04-discovery.md -- Where OpenCode finds skills: built-in locations,
  config-driven paths/URLs, precedence, caching, and diagnostics.
-->

# Discovery: Where Skills Are Found

## Install-location algorithm

> Why: A skill installed in the wrong scope is either invisible to the project that needs it or leaks into projects that do not.

INPUT: who the skill serves. Per the official OpenCode docs
(opencode.ai/docs/skills):

| # | Location | Scope |
|---|---|---|
| 1 | `.opencode/skills/<name>/SKILL.md` (also `.opencode/skill/`) | Project -- walks up from cwd to the git worktree |
| 2 | `~/.config/opencode/skills/<name>/SKILL.md` | Global (current user) |
| 3 | `.claude/skills/<name>/SKILL.md` | Project, Claude-compatible (walk-up) |
| 4 | `~/.claude/skills/<name>/SKILL.md` | Global |
| 5 | `.agents/skills/<name>/SKILL.md` | Project, agent-compatible (walk-up) |
| 6 | `~/.agents/skills/<name>/SKILL.md` | Global |

Selection rules:

- IF the skill is personal THEN install to `~/.config/opencode/skills/` or `~/.claude/skills/`.
- ELSE IF the skill belongs to a project THEN install to that project's `.opencode/skills/`.
- Locations 3-6 are shared with Claude Code and other spec adopters: one skill install serves multiple agents.

## Config-driven sources (`opencode.json`)

> Why: Remote skills arrive over the network, so every URL in this config is a supply-chain decision, not just a path.

```jsonc
{
  "skills": {
    "paths": ["~/path/to/skills-repo", ".opencode/skills"],  // recursive SKILL.md scan; ~ expands; relative resolves from cwd
    "urls": ["https://example.com/.well-known/skills/"]       // remote skills, pulled at startup
  }
}
```

Remote URLs are fetched via `<url>/index.json` (`{skills: [{name, files[], version?}]}`)
and cached under `~/.cache/opencode/skills/<name>/` with atomic updates
(stage to a temp dir, then rename; rollback on failure).

OpenCode also ships one **built-in skill**, `customize-opencode` (location
`"<built-in>"`), restricted to editing OpenCode's own config/agents/skills/
plugins/MCP/permissions. IF a user skill has the same name THEN the user skill
overrides it. Plugins can register skills through the plugin API as well.

## Precedence, caching, and diagnostics algorithm

> Why: When two skills share a name, the loser is silently shadowed, and silent shadowing is how the wrong instructions get followed with full confidence.

1. **Duplicate names.** IF two locations contain the same skill name THEN a warning is logged and the **later-scanned copy wins**. NEVER rely on shadowing order -- keep skill names unique across all locations.
2. **Startup scan.** Discovery (glob + frontmatter parse of name/description) runs once at startup and is cached per instance. IF you add, rename, or change a skill THEN restart OpenCode.
3. **Kill switches.** IF `OPENCODE_DISABLE_EXTERNAL_SKILLS=1` THEN the `.agents` compat dirs are dropped. IF `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1` (or `OPENCODE_DISABLE_CLAUDE_CODE`) THEN the `.claude` dirs are dropped.
4. **Diagnostic.** IF a skill does not appear THEN run `opencode debug skill`: it prints the parsed skills actually loaded (community-verified).
