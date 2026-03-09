---
name: development-flow-maintenance
description: >
  Plan compaction and kb archival. Use when asked to "compact the plan",
  "archive the plan", "clean up the plan", "import plan to kb",
  "compact and import", or "finalize the plan". Handles compaction of
  finished plans, import into kb database, and cleanup of source files.
  Do NOT use for creating plans or research.
version: 1.0.0
---

# Plan Maintenance

Compact finished or in-progress implementation plans, import into kb database, and clean up source markdown files.

## Compaction Rules

1. **Replace inline code examples with file references** — use `file:line` references instead of duplicating code
2. **Update implementation notes** — reflect what was actually done vs. planned
3. **Mark completed phases** — check off success criteria that were met
4. **Remove redundant detail** — collapse verbose sections into concise summaries
5. **Preserve the structure** — keep plan template sections
6. **Update frontmatter** — add `status: complete` and `compacted: YYYY-MM-DD`
7. **Preserve key decisions and discoveries** — compacting removes verbosity, not information
8. **Keep file:line references** — these are the most valuable part

## KB Import

Use the safety script: `${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh plan <plan_file> [research_files...]`

The script verifies the import before deleting source files. Never delete files manually.

## Linking

If the plan references existing kb document IDs, link them:
```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb link <new_plan_id> <research_id> -r related --db kb.db --plain
```

## Report Format

```
Plan compacted and imported to kb:

- **KB Document ID**: <id>
- **Type**: plan
- **Files deleted**: <list>
- **Linked to**: <linked kb IDs>

Use `kb get <id>` to retrieve it.
```
