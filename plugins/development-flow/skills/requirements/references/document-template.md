# Requirements Document Template

## File Naming

Format: `docs/ai/requirements/YYYY-MM-DD-ENG-XXXX-description.md`

- `YYYY-MM-DD` — today's date
- `ENG-XXXX` — ticket number (omit if no ticket)
- `description` — brief kebab-case description

Examples:
- `2025-01-08-ENG-1478-parent-child-tracking.md`
- `2025-01-08-user-notification-preferences.md`

## Template

```markdown
---
date: [ISO datetime with timezone]
git_commit: [current commit hash]
branch: [current branch]
repository: [repo name]
feature: "[Feature name]"
tags: [requirements, feature-name, relevant-tags]
status: complete
last_updated: [YYYY-MM-DD]
last_updated_by: [who updated]
---

# Requirements: [Feature Name]

## Problem Statement

[1-2 sentences: What pain point does this solve? What's broken or missing today?]

## Motivation & Value

[Why is this worth building? Why now? What's the impact of NOT doing this?]

## User Context

[Who uses this and in what situation? What's their technical proficiency? What workflow are they in when they need this?]

## Desired Behavior

[What should it do? Describe the happy path from the user's perspective — step by step.]

## Scope Boundaries

### In Scope
- [Must-have capability 1]
- [Must-have capability 2]

### Out of Scope
- [Explicitly not building X]
- [Future enhancement Y — not now]

## Considered Approaches

### Selected: [Approach Name]
[2-3 sentences: what this approach does and why it was chosen]

### Alternatives Considered

**[Alternative 1 Name]**
- How it works: [brief description]
- Trade-offs: [what you gain vs. give up]
- Why not chosen: [specific reason]

**[Alternative 2 Name]** *(if applicable)*
- How it works: [brief description]
- Trade-offs: [what you gain vs. give up]
- Why not chosen: [specific reason]

## Acceptance Criteria

[Measurable, testable conditions for "done". Each should be verifiable.]

- [ ] [Given X, when Y, then Z]
- [ ] [Given A, when B, then C]

## Validation Approach

[How to verify the feature works correctly — what to test, how to test it, what signals success.]

## Constraints & Assumptions

[Known limitations, dependencies, technical boundaries, assumptions about user behavior or environment.]

## Key Deliverables

[What concrete artifacts or outputs are expected? Files, commands, integrations, documentation?]

## Open Questions

[Anything unresolved — should be empty before handoff to research/planning.]
```
