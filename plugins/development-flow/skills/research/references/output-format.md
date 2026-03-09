# Research Document Format

## File Naming

Format: `docs/ai/research/YYYY-MM-DD-ENG-XXXX-description.md`

- `YYYY-MM-DD` — today's date
- `ENG-XXXX` — ticket number (omit if no ticket)
- `description` — brief kebab-case description

Examples:
- `2025-01-08-ENG-1478-parent-child-tracking.md`
- `2025-01-08-authentication-flow.md`

## Template

```markdown
---
date: [ISO datetime with timezone]
git_commit: [current commit hash]
branch: [current branch]
repository: [repo name]
topic: "[research topic]"
tags: [research, codebase, component-names]
status: complete
last_updated: [YYYY-MM-DD]
last_updated_by: [researcher]
---

# Research: [Topic]

**Date**: [datetime with timezone]
**Git Commit**: [commit hash]
**Branch**: [branch name]
**Repository**: [repo name]

## Research Question
[Original query]

## Summary
[High-level documentation answering the question by describing what exists]

## Detailed Findings

### [Component/Area 1]
- Description of what exists ([file.ext:line](link))
- How it connects to other components
- Current implementation details (without evaluation)

### [Component/Area 2]
...

## Code References
- `path/to/file.py:123` - Description
- `another/file.ts:45-67` - Description

## Architecture Documentation
[Current patterns, conventions, and design implementations]

## Related Research
[Links to related kb documents by ID]

## Open Questions
[Areas needing further investigation]
```

## Follow-up Updates

When updating an existing research document:
- Add `last_updated_note: "Added follow-up research for [description]"` to frontmatter
- Add a new section: `## Follow-up Research [timestamp]`
- Delete old kb document and re-import the updated version
