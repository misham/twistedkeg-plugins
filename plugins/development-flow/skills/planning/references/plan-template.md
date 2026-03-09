# Plan Template

## File Naming

Format: `docs/ai/plans/YYYY-MM-DD-ENG-XXXX-description.md`

- `YYYY-MM-DD` — today's date
- `ENG-XXXX` — ticket number (omit if no ticket)
- `description` — brief kebab-case description

Examples:
- `2025-01-08-ENG-1478-parent-child-tracking.md`
- `2025-01-08-improve-error-handling.md`

## Template

````markdown
# [Feature/Task Name] Implementation Plan

## Research documents

[List of research documents used to generate the plan, including kb document IDs if applicable]

## Overview

[Brief description of what we're implementing and why]

## Current State Analysis

[What exists now, what's missing, key constraints discovered]

## Desired End State

[A Specification of the desired end state after this plan is complete, and how to verify it]

### Key Discoveries:
- [Important finding with file:line reference]
- [Pattern to follow]
- [Constraint to work within]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

## Implementation Approach

[High-level strategy and reasoning]

## API Contract

[If this plan involves new or modified API endpoints, define the contract here. Remove this section if no API changes are needed.]

### [METHOD] /api/[resource]
**Request:**
```json
{
  "field": "value"
}
```

**Response ([status code]):**
```json
{
  "id": 123,
  "field": "value"
}
```

**Error Response ([status code]):**
```json
{
  "errors": { "field": ["message"] }
}
```

### [METHOD] /api/[resource]?[query_params]
**Query Parameters:**
- `include` - Comma-separated related resources
- `filter[field]` - Filter by field

**Response (200 OK):**
```json
{
  "data": [{ "id": 123, "field": "value" }],
  "meta": { "total": 42 }
}
```

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
```

### Success Criteria:
- [ ] Each change follows red/green TDD (failing test → implementation → refactor)
- [ ] Migration applies cleanly: `make migrate`
- [ ] Unit tests pass: `make test-component`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Linting passes: `make lint`
- [ ] Integration tests pass: `make test-integration`

---

## Phase 2: [Descriptive Name]

[Similar structure...]

---

## Final Manual Verification

_Run once after all phases are complete and all automated checks pass._

- [ ] Feature works as expected when tested via UI
- [ ] Performance is acceptable under load
- [ ] Edge case handling verified manually
- [ ] No regressions in related features

---

## Testing Strategy

### Unit Tests:
- [What to test]
- [Key edge cases]

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]
3. [Edge case to test manually]

## Performance Considerations

[Any performance implications or optimizations needed]

## Migration Notes

[If applicable, how to handle existing data/systems]

## References

- ticket: `<Linear or GitHub ticket>`
- Related research: kb document IDs and `docs/ai/research/[relevant].md`
- Similar implementation: `[file:line]`
````

## Success Criteria Guidelines

**Each phase has automated success criteria following red/green TDD. Manual verification is collected in a single "Final Manual Verification" section at the end of the plan.**

1. **Per-Phase Automated Verification** (runs after each phase, must pass before proceeding):
   - Red/green TDD: failing test written first, then implementation
   - Commands that can be run: `make test`, `npm run lint`, `rspec`, etc.
   - Specific files that should exist
   - Code compilation/type checking
   - Automated test suites

2. **Final Manual Verification** (runs once after all phases complete):
   - UI/UX functionality
   - Performance under real conditions
   - Edge cases that are hard to automate
   - User acceptance criteria

**Per-phase manual verification**: Only add per-phase manual verification pauses if the user explicitly requests them.
