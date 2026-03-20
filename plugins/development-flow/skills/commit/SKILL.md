---
name: development-flow-commit
description: >
  Git commit workflow with user approval and no Claude attribution.
  Use when asked to "commit changes", "create a commit", "commit this work",
  "save progress", or "commit what we did". Commits are authored solely by
  the user. Do NOT use for pushing, creating PRs, or branch management.
version: 1.0.0
---

# Commit Changes

Create git commits for changes made during the current session.

## Prerequisites

Validation (`/validate`) should have been run before committing. If the user hasn't mentioned running validation, remind them it's available.

## Process

1. **Review what changed** — check conversation history and run `git status` / `git diff`
2. **Plan commits** — identify which files belong together logically
3. **Present plan to user** — list files and commit messages, ask for approval
4. **Execute on confirmation** — stage specific files and commit

## Rules

- **NEVER add co-author information or Claude attribution**
- Commits are authored solely by the user
- No "Generated with Claude" messages
- No "Co-Authored-By" lines
- Write commit messages as if the user wrote them
- Use `git add` with specific files — never use `-A` or `.`
- Use imperative mood in commit messages
- **Commit message content rules:**
  - Lead with WHAT changed at a high level (the user-visible or system-visible effect)
  - Follow with WHY the change was made (motivation, problem solved, goal achieved)
  - Do NOT describe HOW the change was implemented (no file lists, no method names, no technical steps)
  - The reader should understand the purpose without reading the diff
  - Bad: "Add validation function to user-input.ts and update handler to call it"
  - Good: "Validate user input before processing to prevent malformed data errors"
- Group related changes together
- Keep commits focused and atomic when possible
