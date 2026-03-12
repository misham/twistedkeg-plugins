# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin marketplace called `twistedkeg-plugins` containing multiple plugins. Each plugin lives under `plugins/<name>/` with its own `.claude-plugin/plugin.json`. All plugins are pure-markdown with no build system, tests, or dependencies.

## Marketplace Structure

```
.claude-plugin/marketplace.json   # Marketplace manifest listing all plugins
plugins/
  thorough-review/                # Source-first code review plugin
    .claude-plugin/plugin.json
    agents/thorough-reviewer.md
    commands/
      thorough-review.md
      thorough-review-improve.md
      gemini-review.md
    skills/thorough-review/
      SKILL.md
      references/
        confidence-rules.md
        output-format.md
        self-improvement.md
        project-fingerprints.md
  development-flow/               # Research-driven development workflow plugin
    .claude-plugin/plugin.json
    agents/                       # 6 specialized sub-agents for parallel research
    bin/                          # kb binary (auto-downloaded by SessionStart hook)
    commands/
      gather_requirements.md
      research_codebase.md
      create_plan.md
      implement_plan.md
      compact_plan.md
      commit.md
    hooks/hooks.json              # Command hook: auto-downloads kb binary at session start
    scripts/
      install-kb.sh               # Downloads/updates kb binary from GitHub releases
      kb_import_and_cleanup.sh
      spec_metadata.sh
    skills/
      requirements/SKILL.md       # Interactive requirements gathering
        references/
          document-template.md
          conversation-techniques.md
          review-criteria.md
          kb-usage.md
      research/SKILL.md           # Codebase research methodology
      planning/SKILL.md           # Implementation plan creation
      implementation/SKILL.md     # TDD-driven plan execution
      maintenance/SKILL.md        # Plan compaction and kb archival
      commit/SKILL.md             # Git commit workflow
```

## Key Architecture Decisions (thorough-review)

- **Two-tier dispatch:** Commands (`commands/`) gather inputs and dispatch the `thorough-reviewer` agent (`agents/`) for actual analysis. The command handles context setup; the agent handles review logic.
- **Confidence filtering:** Findings use a 0-100 score with a hard threshold of >= 75 to report. Penalties and boosters in `references/confidence-rules.md` are the canonical rules.
- **Three-tier feedback storage:** Per-project (`.claude/thorough-review.local.md`), cross-project (`~/.claude/thorough-review.global.md`), and permanent (baked into `references/confidence-rules.md`). Patterns promote upward via `/thorough-review-improve`.
- **Two review modes:** Code review (branch diffs, files) and plan review (verification tables against codebase). Auto-detected from command arguments.
- **Plugin root resolution:** Files reference `${CLAUDE_PLUGIN_ROOT}` for portable paths. Fallback is scanning `~/.claude/plugins/` for a directory containing the thorough-review plugin.

## Key Architecture Decisions (development-flow)

- **Research-first workflow:** Every feature starts with `/gather_requirements`, then `/research_codebase`, then `/create_plan`, then `/implement_plan`. Commands enforce this sequence.
- **KB-backed context:** Research and plans are stored in a `kb` database for persistent cross-session context. The kb binary is auto-downloaded via a SessionStart hook.
- **Parallel sub-agent dispatch:** Research commands spawn specialized agents (locator, analyzer, pattern-finder) in parallel. Agents are documentarians — they describe what exists without critiquing.
- **Skills extract methodology from commands:** Each command references a corresponding skill for its methodology. Skills have reference files for detailed rules (TDD cycle, phase gates, plan template, etc.).
- **Strict TDD implementation:** `/implement_plan` enforces red/green/refactor cycles with phase gate verification before proceeding.
- **Safe kb import:** The `kb_import_and_cleanup.sh` script verifies imports before deleting source files — never delete manually.

## Editing Guidelines

- All plugin content is markdown with YAML frontmatter. Frontmatter fields are part of the Claude Code plugin API — do not add arbitrary fields.
- Agent frontmatter supports: `name`, `description`, `model`, `color`, `tools`.
- Command frontmatter supports: `description`, `model`, `argument-hint`, `allowed-tools`.
- Skill frontmatter supports: `name`, `description`, `version`.
- The `description` field in agents and skills controls when Claude triggers them — word choice matters for activation accuracy. Keep trigger phrases specific ("thorough review", "deep code review") and explicitly exclude generic phrases.
- Reference files under `skills/thorough-review/references/` are loaded by the command/agent at runtime — they are not standalone skills.

## Adding a New Plugin

1. Create `plugins/<plugin-name>/` with its own `.claude-plugin/plugin.json`
2. Add commands, agents, skills, and hooks as needed under that directory
3. Add an entry to `.claude-plugin/marketplace.json` in the `plugins` array
