# Validation Report Template

## File Naming

Format: `docs/ai/validations/YYYY-MM-DD[-ENG-XXXX]-description.md`

- `YYYY-MM-DD` — today's date
- `ENG-XXXX` — ticket number (omit if no ticket)
- `description` — brief kebab-case description matching the plan name

Examples:
- `2025-01-08-ENG-1478-parent-child-tracking.md`
- `2025-01-08-improve-error-handling.md`

If multiple validation runs occur on the same day for the same plan, append a run number: `2025-01-08-improve-error-handling-run2.md`

## Template

```markdown
---
date: [ISO datetime with timezone]
git_commit: [current commit hash]
branch: [current branch]
repository: [repo name]
plan_path: [file path to the plan, e.g., docs/ai/plans/2025-01-08-improve-error-handling.md]
plan_kb_id: [kb document ID of the plan, if known — omit if not available]
plan_title: "[human-readable plan name]"
overall_result: [ALL_PASS or ISSUES_FOUND]
tags: [validation, plan-name, relevant-tags]
status: complete
last_updated: [YYYY-MM-DD]
last_updated_by: [validator]
---

# Validation Report: [Plan Title]

**Date**: [datetime with timezone]
**Git Commit**: [commit hash]
**Branch**: [branch name]
**Plan**: [plan title] ([plan path or kb #N])

## Requirements Source

**Source**: [kb #N (requirements doc title) or "plan fallback (Desired End State)"]

### Acceptance Criteria

1. [criterion 1]
2. [criterion 2]
...

## Layer Results

### Layer 1: Tests & Static Analysis

**Status**: [PASS/FAIL]

- Tests: [PASS/FAIL] — [summary]
- Linting: [PASS/FAIL] — [summary]
- Type checking: [PASS/FAIL] — [summary]

### Layer 2: Thorough Review

**Status**: [PASS/FAIL/REVIEW]

- Critical findings: [count]
- Important findings: [count]
- Minor findings: [count]

[List Critical and Important findings if any]

### Layer 3: Test Coverage

**Status**: [PASS/FAIL]

- Overall coverage: [X]%
- Target: 80%

[List any files with 0% coverage]

### Layer 4: Acceptance Criteria Tracing

**Status**: [PASS/FAIL]

| # | Criterion | Evidence | Status |
|---|-----------|----------|--------|
| 1 | ... | ... | PASS |
| 2 | ... | ... | FAIL |

### Layer 5: Browser Validation

**Status**: [PASS/FAIL/SKIPPED]

[Details if run, or "Skipped — not a frontend project"]

## Changes from Prior Run

_Include this section only if a prior validation report exists for the same plan. Omit entirely on the first validation run._

- **Resolved**: [issues that were FAIL in prior run, now PASS]
- **Persisting**: [issues still FAIL]
- **New**: [issues that were PASS or not checked in prior run, now FAIL]

## Overall Result

**Result**: [ALL PASS / N ISSUES FOUND]

[Summary of issues if any]
```
