# Phase 3: Skills Extraction

> Part of [Development Flow Plugin Plan](./2026-03-09-development-flow-plugin-plan.md)

Tasks 9–13: Extract methodology from commands into 5 separate skills (research, planning, implementation, maintenance, commit).

**Status**: ✅ COMPLETE (2026-03-09)

---

### Task 9: Create research skill ✅ COMPLETE

**Files created:**
- `plugins/development-flow/skills/research/SKILL.md` — Research methodology skill with parallel agent dispatch, kb-first context, file-first reading philosophy
- `plugins/development-flow/skills/research/references/kb-usage.md` — KB CLI commands (search, get, list, import, link) and safety import script usage
- `plugins/development-flow/skills/research/references/agent-dispatch.md` — Agent table (6 agents), dispatch strategy, prompt guidelines, documentarian rules
- `plugins/development-flow/skills/research/references/output-format.md` — Research document template with frontmatter, naming convention, follow-up update rules

**Source**: Content defined inline in plan. Research output format sourced from existing conventions.

---

### Task 10: Create planning skill ✅ COMPLETE

**Files created:**
- `plugins/development-flow/skills/planning/SKILL.md` — Interactive planning skill with skeptical, iterative philosophy and 10-step workflow
- `plugins/development-flow/skills/planning/references/plan-template.md` — Full plan template extracted from `~/.dotfiles/claude/commands/create_plan_kb.md:210-351` with `${CLAUDE_PLUGIN_ROOT}/` path substitution. Includes success criteria guidelines.
- `plugins/development-flow/skills/planning/references/research-integration.md` — KB search before planning, input types, plan storage conventions

**Implementation note**: Plan template was extracted from the source command and includes all sections: Overview, Research documents, Current State Analysis, Desired End State, Key Discoveries, What We're NOT Doing, Implementation Approach, API Contract, Phase structure, Final Manual Verification, Testing Strategy, Performance Considerations, Migration Notes, References. Path substitution (`~/.claude/` → `${CLAUDE_PLUGIN_ROOT}/`) was applied but no `~/.claude/` paths existed in the template itself (the template uses generic placeholders).

---

### Task 11: Create implementation skill ✅ COMPLETE

**Files created:**
- `plugins/development-flow/skills/implementation/SKILL.md` — TDD-driven implementation skill with phase gate verification, requires approved plan
- `plugins/development-flow/skills/implementation/references/tdd-cycle.md` — Red/Green/Refactor cycle with strict rules (never skip Red, run tests after every edit, reassess after 3+ failures)
- `plugins/development-flow/skills/implementation/references/phase-gates.md` — Phase gate protocol (automated verification → mark complete → proceed), plan completion gate with manual verification prompt, mismatch handling

---

### Task 12: Create maintenance skill ✅ COMPLETE

**Files created:**
- `plugins/development-flow/skills/maintenance/SKILL.md` — Plan compaction rules (8 rules), kb import via safety script, linking, report format

---

### Task 13: Create commit skill ✅ COMPLETE

**Files created:**
- `plugins/development-flow/skills/commit/SKILL.md` — Git commit workflow with user approval, no Claude attribution, atomic commits, imperative mood

---

## Verification

All 12 files verified present:
```
plugins/development-flow/skills/commit/SKILL.md
plugins/development-flow/skills/implementation/SKILL.md
plugins/development-flow/skills/implementation/references/phase-gates.md
plugins/development-flow/skills/implementation/references/tdd-cycle.md
plugins/development-flow/skills/maintenance/SKILL.md
plugins/development-flow/skills/planning/SKILL.md
plugins/development-flow/skills/planning/references/plan-template.md
plugins/development-flow/skills/planning/references/research-integration.md
plugins/development-flow/skills/research/SKILL.md
plugins/development-flow/skills/research/references/agent-dispatch.md
plugins/development-flow/skills/research/references/kb-usage.md
plugins/development-flow/skills/research/references/output-format.md
```
