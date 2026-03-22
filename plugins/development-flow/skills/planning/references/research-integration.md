# Research Integration for Planning

## Using KB for Context

Before creating a plan, search kb for prior research and plans:

```bash
kb search "<relevant terms>" --db kb.db --plain
```

### What to search for:
- Prior research on the same area of code
- Previous plans that touched similar components
- Related architectural decisions
- Requirements documents (type `requirements`) that define what to build and why

### How to use results:
- Note IDs and titles of relevant documents — don't read them inline
- Spawn background research-analyzer agents for each relevant document
- Use prior findings as supplementary context, but always verify against live code
- Reference kb document IDs in the plan's "Research documents" section

## Accepting Input

The `/create_plan` command accepts:
- **File paths** — read them FULLY
- **Ticket references** — read ticket URLs directly
- **kb document IDs** — retrieve with `kb get <id> --db kb.db --plain`

## Plan Storage

Plans are written to `docs/ai/plans/YYYY-MM-DD-ENG-XXXX-description.md`:
- Stay in `docs/ai/plans/` for review and iteration
- Import into kb is handled separately by `/compact_plan` once finalized
