---
name: issue-manager-linear
description: >
  This skill should be used when the user asks to "create an issue", "list issues",
  "search issues", "update issue status", "close an issue", "view issue details",
  "add a comment", "list projects", "view project", "list cycles", "current sprint",
  "what's in my sprint", "list initiatives", "set team", "list teams",
  "check workflow states", "add label", "archive issue", "search Linear",
  "file a bug", "move issue to done", or any interaction with Linear including
  issue tracking, project management, sprint planning, and initiative tracking.
  Provides CLI-based Linear integration via the lnr tool with --plain output for
  LLM consumption. Do NOT use for GitHub Issues (planned, not yet implemented).
version: 0.1.0
---

# Linear Integration via lnr CLI

Use the `lnr` CLI for fast, focused access to Linear issue tracking, project management, and sprint planning. The binary is at `${CLAUDE_PLUGIN_ROOT}/bin/lnr` and is auto-installed by the SessionStart hook.

**All commands require `--plain`** for machine-readable output suitable for LLM consumption. In all examples below, `lnr` refers to `${CLAUDE_PLUGIN_ROOT}/bin/lnr`.

**Authentication:** If any command returns an auth error, instruct the user to run `/issue-manager:login` to re-authenticate.

## Quick Reference

| Operation | Command |
|-----------|---------|
| List issues | `lnr issue list --plain` |
| View issue | `lnr issue view <ID> --plain` |
| Create issue | `lnr issue create --title "<title>" --plain` |
| Update issue | `lnr issue update <ID> --title/--description/--priority --plain` |
| Close issue | `lnr issue close <ID> --plain` |
| Archive issue | `lnr issue archive <ID> --plain` |
| Search issues | `lnr issue search "<query>" --plain` |
| Add comment | `lnr issue comment add <ID> --body "<text>" --plain` |
| List comments | `lnr issue comment list <ID> --plain` |
| Add label | `lnr issue label add <ID> --label "<name>" --plain` |
| List labels | `lnr issue label list <ID> --plain` |
| List projects | `lnr project list --plain` |
| View project | `lnr project view <ID> --plain` |
| Project issues | `lnr project issues <ID> --plain` |
| List cycles | `lnr cycle list --plain` |
| Current cycle | `lnr cycle current --plain` |
| View cycle | `lnr cycle view <ID> --plain` |
| Add to cycle | `lnr cycle add-issue <ID> --plain` |
| Remove from cycle | `lnr cycle remove-issue <ID> --plain` |
| List initiatives | `lnr initiative list --plain` |
| View initiative | `lnr initiative view <ID> --plain` |
| Initiative projects | `lnr initiative projects <ID> --plain` |
| List teams | `lnr team list --plain` |
| Set default team | `lnr team set <name>` |
| Workflow states | `lnr state list --plain` |
| Auth status | `lnr auth status` |

## Unsupported Operations

Issue assignment (assignee) is not currently supported by `lnr`. Do not attempt `--assignee` or similar flags.

## Team Context

Most commands scope to a team. Set a default team to avoid specifying `--team` on every call:

```bash
lnr team set <team-name>
```

To override the default for a single command, pass `--team <name>`.

## Common Workflows

### Triage and status updates

1. List issues for the current cycle: `lnr cycle current --plain` then `lnr cycle view <ID> --plain`
2. Close completed issues: `lnr issue close <ID> --plain`
3. Update issue details: `lnr issue update <ID> --priority 2 --plain`

### Creating and organizing issues

1. Create an issue: `lnr issue create --title "<title>" --plain`
2. Add labels: `lnr issue label add <ID> --label "<name>" --plain`
3. Add to a cycle: `lnr cycle add-issue <ID> --plain`
4. Add comments with context: `lnr issue comment add <ID> --body "<text>" --plain`

### Research and discovery

1. Search across issues: `lnr issue search "<query>" --plain`
2. Browse by project: `lnr project list --plain` then `lnr project issues <ID> --plain`
3. View initiative breakdown: `lnr initiative list --plain` then `lnr initiative projects <ID> --plain`

## Error Handling

- **Auth errors:** Suggest `/issue-manager:login` for re-authentication
- **Team not set:** Run `lnr team list --plain` to show available teams, then `lnr team set <name>`
- **Unknown states:** Run `lnr state list --plain` to show valid workflow states for the team

## Detailed References

- [Issue Commands](references/issue-commands.md) — full issue, comment, and label command details
- [Project and Initiative Commands](references/project-commands.md) — project and initiative operations
- [Cycle and Team Commands](references/cycle-team-commands.md) — cycle management, team setup, workflow states
