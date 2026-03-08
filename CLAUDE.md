# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin called `thorough-review` that provides source-first, verification-oriented code reviews with confidence-scored findings and self-improving feedback loops. It is a pure-markdown plugin with no build system, tests, or dependencies.

## Plugin Structure

```
.claude-plugin/plugin.json    # Plugin manifest (name, description, author)
agents/thorough-reviewer.md   # Subagent dispatched for heavy review analysis
commands/
  thorough-review.md          # /thorough-review slash command
  thorough-review-improve.md  # /thorough-review-improve slash command
skills/thorough-review/
  SKILL.md                    # Main skill definition with trigger phrases and methodology
  references/
    confidence-rules.md       # Scoring thresholds, penalties, and boosters
    output-format.md          # Code review and plan review output templates
    self-improvement.md       # Local/global feedback file formats and capture workflow
    project-fingerprints.md   # Project type detection for review calibration
```

## Key Architecture Decisions

- **Two-tier dispatch:** Commands (`commands/`) gather inputs and dispatch the `thorough-reviewer` agent (`agents/`) for actual analysis. The command handles context setup; the agent handles review logic.
- **Confidence filtering:** Findings use a 0-100 score with a hard threshold of >= 75 to report. Penalties and boosters in `references/confidence-rules.md` are the canonical rules.
- **Three-tier feedback storage:** Per-project (`.claude/thorough-review.local.md`), cross-project (`~/.claude/thorough-review.global.md`), and permanent (baked into `references/confidence-rules.md`). Patterns promote upward via `/thorough-review-improve`.
- **Two review modes:** Code review (branch diffs, files) and plan review (verification tables against codebase). Auto-detected from command arguments.
- **Plugin root resolution:** Files reference `${CLAUDE_PLUGIN_ROOT}` for portable paths. Fallback is scanning `~/.claude/plugins/` for a directory containing the thorough-review plugin.

## Editing Guidelines

- All plugin content is markdown with YAML frontmatter. Frontmatter fields are part of the Claude Code plugin API — do not add arbitrary fields.
- Agent frontmatter supports: `name`, `description`, `model`, `color`, `tools`.
- Command frontmatter supports: `description`, `model`, `argument-hint`, `allowed-tools`.
- Skill frontmatter supports: `name`, `description`, `version`.
- The `description` field in agents and skills controls when Claude triggers them — word choice matters for activation accuracy. Keep trigger phrases specific ("thorough review", "deep code review") and explicitly exclude generic phrases.
- Reference files under `skills/thorough-review/references/` are loaded by the command/agent at runtime — they are not standalone skills.
