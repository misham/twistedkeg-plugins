# Development Flow Plugin Design

## Overview

Convert the existing `plugins/development-flow-plugin/` directory into a fully structured Claude Code plugin with kb integration, skills architecture, and automated binary management. The plugin provides a research-driven development workflow: codebase research → planning → TDD implementation → archival.

## Current State

- `plugins/development-flow-plugin/` has 6 agents and 6 commands but no plugin manifest, skills, hooks, or scripts
- kb binary installed manually at `~/.dotfiles/claude/bin/kb` (Go binary, v1.1.1, from github.com/misham/kb releases)
- kb-enabled command variants exist separately in `~/.dotfiles/claude/commands/` (compact_plan_kb, create_plan_kb, research_codebase_kb)
- Helper scripts (`kb_import_and_cleanup.sh`, `spec_metadata.sh`) live in `~/.dotfiles/claude/scripts/`
- No skills layer — all methodology is inline in commands

## Decisions

1. **Consolidate to kb-only commands** — remove non-kb variants, replace with kb versions
2. **Move gemini_review.md to thorough-review plugin** — it's a review tool, not a dev-flow tool (separate task, out of scope)
3. **Rename directory** — `development-flow-plugin/` → `development-flow/`
4. **Plugin name** — `development-flow`
5. **SessionStart hook** — auto-downloads kb binary from GitHub releases
6. **Separate skills per workflow** — research, planning, implementation, maintenance, commit
7. **Bundle scripts** — `kb_import_and_cleanup.sh` and `spec_metadata.sh` in `scripts/`
8. **No dotfiles changes** — everything stays local to this repo

## What We're NOT Doing

- Modifying `~/.dotfiles` in any way
- Moving `gemini_review.md` to thorough-review (separate task)
- Reworking command workflows beyond plugin conversion + path updates
- Adding new commands or agents
- Changing kb CLI behavior or building from source

## Target Structure

```
plugins/development-flow/
├── .claude-plugin/
│   └── plugin.json
├── .gitignore                    # Ignores bin/kb
├── README.md
├── bin/                          # kb binary (downloaded by hook)
│   └── .gitkeep
├── scripts/
│   ├── kb_import_and_cleanup.sh
│   └── spec_metadata.sh
├── hooks/
│   └── session-start.md          # Downloads kb binary on session start
├── agents/
│   ├── codebase-analyzer.md
│   ├── codebase-locator.md
│   ├── codebase-pattern-finder.md
│   ├── research-analyzer.md      # Paths updated to ${CLAUDE_PLUGIN_ROOT}
│   ├── research-locator.md       # Paths updated to ${CLAUDE_PLUGIN_ROOT}
│   └── web-search-researcher.md
├── commands/
│   ├── commit.md
│   ├── create_plan.md            # kb version from dotfiles, paths updated
│   ├── research_codebase.md      # kb version from dotfiles, paths updated
│   ├── compact_plan.md           # kb version from dotfiles, paths updated
│   └── implement_plan.md
└── skills/
    ├── research/
    │   ├── SKILL.md
    │   └── references/
    │       ├── kb-usage.md
    │       ├── agent-dispatch.md
    │       └── output-format.md
    ├── planning/
    │   ├── SKILL.md
    │   └── references/
    │       ├── plan-template.md
    │       └── research-integration.md
    ├── implementation/
    │   ├── SKILL.md
    │   └── references/
    │       ├── tdd-cycle.md
    │       └── phase-gates.md
    ├── maintenance/
    │   ├── SKILL.md
    │   └── references/           # (if needed)
    └── commit/
        └── SKILL.md
```

## SessionStart Hook

- Checks if `${CLAUDE_PLUGIN_ROOT}/bin/kb` exists
- If exists, checks version against expected (hardcoded, e.g., `v1.1.1`)
- If missing or outdated: detects platform/arch, downloads from `https://github.com/misham/kb/releases/download/<version>/kb-<os>-<arch>`
- Makes binary executable
- Uses `allowed-tools: Bash`

## Skills Architecture

### research/
- **Triggers on:** "research codebase", "investigate code", "explore how X works"
- **SKILL.md:** Research methodology overview, agent dispatch strategy
- **references/kb-usage.md:** kb CLI commands, search patterns, import workflow
- **references/agent-dispatch.md:** When to use which agent, parallel dispatch rules
- **references/output-format.md:** Research document template with frontmatter

### planning/
- **Triggers on:** "create plan", "implementation plan", "design plan"
- **SKILL.md:** Planning methodology, iteration protocol
- **references/plan-template.md:** Full plan template (extracted from create_plan command)
- **references/research-integration.md:** How to incorporate kb research into plans

### implementation/
- **Triggers on:** "implement plan", "execute plan", "start implementation"
- **SKILL.md:** TDD cycle, phase gate protocol
- **references/tdd-cycle.md:** Red/green/refactor rules
- **references/phase-gates.md:** Phase completion criteria, verification protocol

### maintenance/
- **Triggers on:** "compact plan", "archive plan", "clean up plan"
- **SKILL.md:** Compaction rules, kb archival process

### commit/
- **Triggers on:** "commit changes", "create commit"
- **SKILL.md:** Commit workflow, no-attribution rule, staging strategy

## Path Migration

| Old path | New path |
|----------|----------|
| `~/.claude/bin/kb` | `${CLAUDE_PLUGIN_ROOT}/bin/kb` |
| `~/.claude/scripts/kb_import_and_cleanup.sh` | `${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh` |
| `~/.claude/scripts/spec_metadata.sh` | `${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh` |

## Marketplace Integration

Add entry to `.claude-plugin/marketplace.json`:
```json
{
  "name": "development-flow",
  "source": "./plugins/development-flow",
  "description": "Research-driven development workflow with kb-backed planning, TDD implementation, and codebase research"
}
```

## plugin.json

```json
{
  "name": "development-flow",
  "description": "Research-driven development workflow with kb-backed planning, TDD implementation, and codebase research",
  "version": "1.0.0",
  "author": {
    "name": "Misha Manulis"
  }
}
```

## Out of Scope (Separate Tasks)

- Moving `gemini_review.md` into thorough-review plugin
- Any changes to `~/.dotfiles`
- Reworking command workflows beyond plugin conversion
