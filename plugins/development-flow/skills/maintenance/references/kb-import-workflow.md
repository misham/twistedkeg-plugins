# KB Import Workflow for Plan Maintenance

## Import Command

Use the safety script for import-and-cleanup:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/kb_import_and_cleanup.sh plan <plan_file> [research_files...] [requirements_files...]
```

The script verifies the import before deleting source files. Never delete files manually.

## Requirements Files

Requirements files (`docs/ai/requirements/*.md`) are already imported into kb during `/gather_requirements`. Include them in the cleanup script call **only for file deletion**, not re-import. The script handles this correctly — it imports the first argument and deletes all listed files after verification.

## Linking

After import, link the new plan to related kb documents:

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb link <new_plan_id> <research_id> -r related --db kb.db --plain
```

Link to:
- Research documents that informed the plan
- Requirements documents the plan implements
- Prior plans for the same area (if iterating on an existing feature)

## Report Format

After successful compaction and import, present:

```
Plan compacted and imported to kb:

- **KB Document ID**: <id>
- **Type**: plan
- **Files deleted**: <list>
- **Linked to**: <linked kb IDs>

Use `kb get <id>` to retrieve it.
```

## Full KB Reference

See the [KB skill](../../kb/SKILL.md) for complete CLI reference, import rules, and git merge support.
