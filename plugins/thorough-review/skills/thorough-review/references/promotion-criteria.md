# Promotion Criteria

## When to Propose a Promotion

A feedback pattern is promotable when ANY of these conditions are met:

1. **Concrete incident with clear fix** — A single entry describes a specific failure with an obvious rule that would prevent recurrence. Example: "Flagged missing nil check on .find" → add to false positive definitions.

2. **Repeated pattern** — Two or more entries describe the same issue, even from the same project. Repetition confirms the pattern isn't a one-off.

3. **Positive pattern at risk** — A "what_worked" entry describes a behavior not encoded in any reference file. Propose adding it to preserve the pattern.

## When NOT to Propose

- **Vague feedback** — "The review was confusing" without specifics. Leave in the global file for potential future clustering.
- **One-off context-specific issue** — Feedback that only applies to a specific project or codebase, not generalizable to the review methodology.
- **Already covered** — The pattern is already in a reference file. Remove the entry and note it was already addressed.

## Proposal Format

For each proposed promotion, present:

```
### Proposal: [Brief title]

**Pattern:** [What the feedback describes]
**Source entries:** [Number of entries, from which projects]
**Target file:** `skills/thorough-review/references/<file>.md`
**Proposed edit:**

[The specific text to add or modify, shown as a diff or new section]

**Rationale:** [Why this will prevent the issue from recurring]

Approve this change? (yes/no)
```

## After Promotion

When a proposal is approved:
1. Use Edit to add the new rule to the target reference file
2. Read `~/.claude/thorough-review.global.yaml`, remove the promoted entries from the `entries` list, Write the complete file back (never use Edit on the YAML file)
3. If removing entries empties the `entries` list, write the file with `entries: []` rather than deleting it
