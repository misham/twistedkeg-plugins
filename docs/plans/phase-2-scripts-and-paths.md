# Phase 2: Scripts and Path Updates

> Part of [Development Flow Plugin Plan](./2026-03-09-development-flow-plugin-plan.md)

Tasks 6-8: Bundle helper scripts, update command paths, update agent paths.

**Status**: complete
**Compacted**: 2026-03-09

---

### Task 6: Bundle helper scripts ✅ COMPLETE

Created two scripts copied from `~/.dotfiles/claude/scripts/`, with `KB` path updated to use `${CLAUDE_PLUGIN_ROOT}/bin/kb`.

**Files created:**
- `plugins/development-flow/scripts/kb_import_and_cleanup.sh` — imports markdown into kb, verifies import, then deletes source files. Key path change at line 21: `KB="${CLAUDE_PLUGIN_ROOT}/bin/kb"`
- `plugins/development-flow/scripts/spec_metadata.sh` — collects git/timestamp metadata (no path changes needed, only uses git commands)

Both scripts are executable.

---

### Task 7: Update command paths to use CLAUDE_PLUGIN_ROOT ✅ COMPLETE

Replaced all `~/.claude/bin/kb` with `${CLAUDE_PLUGIN_ROOT}/bin/kb` and `~/.claude/scripts/` with `${CLAUDE_PLUGIN_ROOT}/scripts/` across 3 command files. The other 2 commands (`commit.md`, `implement_plan.md`) had no kb/script references.

**Files modified:**
- `plugins/development-flow/commands/create_plan.md` — 8 kb path + 1 scripts path replacements (including frontmatter `allowed-tools` line)
- `plugins/development-flow/commands/research_codebase.md` — 15 kb path + 1 scripts path replacements (including frontmatter `allowed-tools` line)
- `plugins/development-flow/commands/compact_plan.md` — 3 kb path + 1 scripts path replacements (including frontmatter `allowed-tools` line)

**Verified**: `grep -r "~/.claude" plugins/development-flow/commands/` returns no output.

---

### Task 8: Update agent path references ✅ COMPLETE

Replaced all `~/.claude/bin/kb` with `${CLAUDE_PLUGIN_ROOT}/bin/kb` in agent files.

**Files modified:**
- `plugins/development-flow/agents/research-locator.md` — 4 occurrences (lines 15-17, 37)
- `plugins/development-flow/agents/research-analyzer.md` — 1 occurrence (line 33)

**Verified**: `grep -r "~/.claude" plugins/development-flow/agents/` returns no output. Zero `~/.claude` references remain anywhere in the plugin.
