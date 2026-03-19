# Compaction Rules

When compacting a plan, apply these rules to reduce verbosity while preserving information.

## What to Compact

1. **Replace inline code examples with file references** — use `file:line` references instead of duplicating code that now exists in the codebase
2. **Update implementation notes** — reflect what was actually done vs. what was originally planned
3. **Mark completed phases** — check off success criteria that were met
4. **Remove redundant detail** — collapse verbose sections into concise summaries
5. **Collapse resolved open questions** — replace with the decision that was made

## What to Preserve

1. **Plan template structure** — keep all section headings from the original template
2. **Key decisions and discoveries** — compacting removes verbosity, not information
3. **File:line references** — these are the most valuable part of a compacted plan
4. **Architecture design section** — if present, keep the recommended approach and rationale (drop rejected alternatives)
5. **Success criteria** — keep as a record of what was verified

## Frontmatter Updates

Add to the plan's YAML frontmatter:

```yaml
status: complete
compacted: YYYY-MM-DD
```

## Quality Check

After compaction, the plan should:
- Be readable as a standalone record of what was built and why
- Have every code reference pointing to actual files (no stale references)
- Be 30-60% shorter than the original
- Retain enough context that someone unfamiliar can understand the decisions made
