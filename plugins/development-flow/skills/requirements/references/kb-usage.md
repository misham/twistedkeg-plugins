# KB Usage for Requirements

## Commands

```bash
# Search for existing requirements
${CLAUDE_PLUGIN_ROOT}/bin/kb search "<query>" -t requirements --db kb.db --plain

# Import a requirements document
${CLAUDE_PLUGIN_ROOT}/bin/kb import docs/ai/requirements/<filename>.md -t requirements --db kb.db --plain

# Link requirements to related research
${CLAUDE_PLUGIN_ROOT}/bin/kb link <requirements_id> <research_id> -r related --db kb.db --plain

# List all requirements documents
${CLAUDE_PLUGIN_ROOT}/bin/kb list -t requirements --db kb.db --plain
```

## Import Flow

1. Write the requirements document to `docs/ai/requirements/`
2. Import into kb with type `requirements`
3. Link to any related prior requirements or research documents
4. Keep the markdown file in `docs/ai/requirements/` — it will be cleaned up separately

## Downstream Usage

- `/research_codebase` searches for `requirements` type to understand what to research
- `/create_plan` searches for `requirements` type to understand what to plan for
- Requirements docs can be referenced by file path or kb document ID
