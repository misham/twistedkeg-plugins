---
name: improve
description: >
  Analyze accumulated development-flow feedback and promote stable patterns into permanent skill rules.
  Use when asked to "improve development-flow skills", "promote feedback", "review development-flow feedback",
  or "improve skill rules". Do NOT use for code review, thorough review, or general improvement tasks.
version: 1.0.0
---

# Development-Flow Self-Improvement

Analyze feedback accumulated in `~/.claude/development-flow.global.yaml` and propose promotions into permanent skill reference files.

## Workflow

1. Read `~/.claude/development-flow.global.yaml` — if it doesn't exist, inform user there's no feedback to process
2. Group entries by skill (see `references/analysis-methodology.md`)
3. For each group, identify actionable patterns (see `references/promotion-criteria.md`)
4. Present each proposal to the user with: the pattern, source entries, target reference file, and proposed edit
5. For approved proposals, apply the edit to the target reference file and remove the source entries from the global file
6. For declined proposals, leave entries unchanged

## Key Rules

- Never modify skill reference files without user approval
- Present proposals one at a time for clear decision-making
- When editing reference files, follow the existing format of the target file
- After all proposals are processed, show a summary of changes made
- If no actionable patterns are found, tell the user and suggest they continue accumulating feedback
