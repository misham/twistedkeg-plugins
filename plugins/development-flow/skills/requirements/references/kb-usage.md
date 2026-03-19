# KB Usage for Requirements

See the consolidated [KB skill](../../kb/SKILL.md) for full CLI reference, import workflows, and git merge support.

## Requirements-Specific Patterns

### Searching for Existing Requirements

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t requirements --db kb.db --plain
```

### Listing Requirements Documents

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t requirements --db kb.db --plain
```

### Importing Requirements Documents

```bash
${CLAUDE_PLUGIN_ROOT}/bin/kb import docs/ai/requirements/<filename>.md -t requirements --db kb.db --plain
${CLAUDE_PLUGIN_ROOT}/bin/kb link <requirements_id> <research_id> -r related --db kb.db --plain
```

After import, keep the markdown file in `docs/ai/requirements/` — it will be cleaned up by `/compact_plan`.

For import with cleanup, see [Import and Cleanup](../../kb/references/import-and-cleanup.md).

### Downstream Usage

- `/research_codebase` searches for `requirements` type to understand what to research
- `/create_plan` searches for `requirements` type to understand what to plan for
- Requirements docs can be referenced by file path or kb document ID
