---
description: Promote review feedback patterns into permanent skill rules
model: opus
allowed-tools: Read, Write, Edit, Grep, Glob
---

Analyze accumulated review feedback and promote stable patterns into permanent reference files.

## Step 1: Read Feedback

Read `~/.claude/thorough-review.global.yaml`. If the file doesn't exist or has no entries, inform the user:

```
No feedback has been accumulated yet. Feedback is captured at the end of each
thorough-review session.

Run a few reviews and provide feedback when prompted, then come back to `/thorough-review-improve`.
```

## Step 2: Analyze and Group

Follow the analysis methodology from `${CLAUDE_PLUGIN_ROOT}/skills/thorough-review/references/analysis-methodology.md`:
- Cluster entries by category + overlapping keywords
- Identify actionable patterns
- Determine target reference files for each cluster

If `${CLAUDE_PLUGIN_ROOT}` is not set, locate the plugin directory by searching `~/.claude/plugins/` for a directory containing a `thorough-review` plugin.

## Step 3: Present Proposals

For each actionable pattern, follow the proposal format from `${CLAUDE_PLUGIN_ROOT}/skills/thorough-review/references/promotion-criteria.md`:
- Present the pattern, source entries, target file, and proposed edit
- Wait for user approval before proceeding

Do not make changes without user approval.

## Step 4: Execute Approved Changes

For each approved proposal:
- Use Edit to add the new rule to the target reference file, following the file's existing format
- Read `~/.claude/thorough-review.global.yaml`, remove promoted entries, Write the complete file back (never use Edit on the YAML file)

After all proposals are processed, present a summary:
```
## Summary

- Entries processed: [N]
- Proposals presented: [N]
- Approved and applied: [N]
- Declined (kept in feedback): [N]
- Reference files modified: [list]
```
