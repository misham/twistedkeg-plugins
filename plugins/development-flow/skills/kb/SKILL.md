---
name: development-flow-kb
description: >
  This skill should be used when needing to "search kb", "import into kb",
  "get kb document", "list kb documents", "link kb documents", "kb import
  and cleanup", or any direct interaction with the kb CLI or kb.db database.
  Covers all kb CLI commands, document types (research, plan, requirements),
  the safe import-and-cleanup workflow, and git merge support. This is the
  canonical reference for all kb usage within development-flow.
  Do NOT use for general codebase research or plan creation — use the
  corresponding development-flow skills for those workflows.
version: 1.0.0
---

# KB Database Operations

The `kb` CLI provides persistent cross-session storage for research, plans, and requirements documents. The binary is at `${CLAUDE_PLUGIN_ROOT}/bin/kb` and is auto-installed and auto-updated by the SessionStart hook (see [Installation](references/installation.md)).

**All commands require `--db kb.db --plain`** (database relative to project root, machine-readable output).

## Quick Reference

| Operation | Command |
|-----------|---------|
| Search all | `kb search "<query>" --db kb.db --plain` |
| Search by type | `kb search "<query>" -t <type> --db kb.db --plain` |
| Get by ID | `kb get <id> --db kb.db --plain` |
| List all | `kb list --db kb.db --plain` |
| List by type | `kb list -t <type> --db kb.db --plain` |
| Import | `kb import <file> -t <type> --db kb.db --plain` |
| Link | `kb link <id1> <id2> -r related --db kb.db --plain` |
| Show links | `kb links <id> --db kb.db --plain` |
| Git merge setup | `kb setup-git --db kb.db` |

All commands use `${CLAUDE_PLUGIN_ROOT}/bin/kb` as the binary path.

## Document Types

- **research** — codebase research findings from `/research_codebase`
- **plan** — implementation plans from `/create_plan`
- **requirements** — feature requirements from `/gather_requirements`

## Detailed References

- [CLI Commands](references/cli-commands.md) — full command syntax and examples
- [Import and Cleanup](references/import-and-cleanup.md) — safe import workflow with verification
- [Git Merge Support](references/git-merge-support.md) — automatic merge conflict resolution for kb.db
- [Installation](references/installation.md) — auto-install hook, platform detection, manual fallback
