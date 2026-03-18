---
description: Analyze development-flow feedback and promote patterns into permanent skill rules
model: opus
allowed-tools: Read, Write, Edit, Grep, Glob
---

Analyze accumulated feedback from development-flow sessions and promote stable patterns into permanent skill reference files.

## Step 1: Read Feedback

Read `~/.claude/development-flow.global.yaml`. If the file doesn't exist or has no entries, inform the user:

```
No feedback has been accumulated yet. Feedback is captured at the end of each
development-flow skill session (requirements, planning, implementation, validation, research).

Run a few sessions and provide feedback when prompted, then come back to `/improve`.
```

## Step 2: Analyze and Group

Follow the analysis methodology from the improve skill's `references/analysis-methodology.md`:
- Group entries by skill
- Cluster similar entries within each group
- Identify actionable patterns

## Step 3: Present Proposals

For each actionable pattern, follow the proposal format from the improve skill's `references/promotion-criteria.md`:
- Present the pattern, source entries, target file, and proposed edit
- Wait for user approval before proceeding

Do not make changes without user approval.

## Step 4: Execute Approved Changes

For each approved proposal:
- Use Edit to add the new rule to the target reference file, following the file's existing format
- Read `~/.claude/development-flow.global.yaml`, remove promoted entries, Write the complete file back (never use Edit on the YAML file)

After all proposals are processed, present a summary:
```
## Summary

- Entries processed: [N]
- Proposals presented: [N]
- Approved and applied: [N]
- Declined (kept in feedback): [N]
- Reference files modified: [list]
```
