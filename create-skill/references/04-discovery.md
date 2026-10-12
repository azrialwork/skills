<!--
  references/04-discovery.md -- Where OpenCode finds skills: built-in locations,
  config-driven paths/URLs, precedence, caching, and diagnostics.
-->

# Discovery: Where Skills Are Found

## Built-in locations (V1)

| # | Location | Scope |
|---|---|---|
| 1 | `.opencode/skills/<name>/SKILL.md` (also `.opencode/skill/`) | Project -- walks up from cwd to the git worktree |
| 2 | `~/.config/opencode/skills/<name>/SKILL.md` | Global (current user) |
| 3 | `.claude/skills/<name>/SKILL.md` | Project, Claude-compatible (walk-up) |
| 4 | `~/.claude/skills/<name>/SKILL.md` | Global |
| 5 | `.agents/skills/<name>/SKILL.md` | Project, agent-compatible (walk-up) |
| 6 | `~/.agents/skills/<name>/SKILL.md` | Global |

Because locations 3-6 are shared with Claude Code and other spec adopters, one
skill install serves multiple agents. Put personal skills in `~/.config/opencode/skills/`
or `~/.claude/skills/`; put project skills in the project's `.opencode/skills/`.

## Config-driven sources (`opencode.json`)

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
plugins/MCP/permissions. A user skill with the same name overrides it. Plugins
can register skills through the plugin API as well.

## Precedence and caching

- **Duplicate names:** a warning is logged and the **later-scanned copy wins**.
  Do not rely on shadowing order -- keep skill names unique across all locations.
- **Startup scan:** discovery (glob + frontmatter parse of name/description) runs
  once at startup and is **cached per instance**. Restart OpenCode after
  adding, renaming, or changing skills.
- **Kill switches:** `OPENCODE_DISABLE_EXTERNAL_SKILLS=1` drops the `.agents`
  compat dirs; `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1` (or
  `OPENCODE_DISABLE_CLAUDE_CODE`) drops the `.claude` dirs.
- **Diagnostic:** `opencode debug skill` prints the parsed skills actually loaded
  (community-verified; useful when a skill does not appear).
