---
description: Run post-implementation validation against plan and requirements
model: opus
argument-hint: [plan path or kb plan ID]
---

# Validate Implementation

You are running post-implementation validation for a completed plan. This command runs after the Plan Completion Gate (user has confirmed manual verification) and before `/commit`.

## Getting Started

1. **Resolve the plan path** from `$ARGUMENTS`:
   - If a file path: read it directly
   - If a kb document ID: retrieve with `kb get <id> --db kb.db --plain`
   - If empty: look for the most recent `.md` file in `docs/ai/plans/`
   - If no plan found: ask the user

2. **Read the plan completely**

3. **Discover requirements** following the methodology in the validation skill:
   - Find kb document IDs in the plan's `## Research documents` section
   - Retrieve each and identify the requirements document (type `requirements` or contains `## Acceptance Criteria`)
   - Extract acceptance criteria
   - If no requirements doc found, use the plan's `## Desired End State` and `## Final Manual Verification`

4. **Discover prior validation reports** for the same plan:
   - If the plan was resolved from a kb ID, use `kb links <plan_kb_id> --db kb.db --plain` and filter results for type `validation`
   - Search kb by plan title as a fallback: `kb search "<plan title>" -t validation --db kb.db --plain`
   - Scan `docs/ai/validations/` for files with matching `plan_path` or `plan_kb_id` in frontmatter (most reliable — catches reports not yet linked or with title mismatches)
   - Deduplicate results across all three discovery methods
   - If prior reports found, retrieve the most recent one: use `kb get <id> --db kb.db --plain` if a kb ID is available, or read the file directly if discovered only via filesystem scan. Extract which layers had issues, which acceptance criteria failed, and the overall result
   - If no prior reports exist, skip silently (no error, no message)

5. **Present what was discovered**:

```
═══════════════════════════════════════
VALIDATION - REQUIREMENTS DISCOVERED
═══════════════════════════════════════

Plan: [plan title]
Requirements source: [kb #N or plan fallback]

Acceptance criteria found:
1. [criterion 1]
2. [criterion 2]
...

Proceeding with 5 validation layers.

[If prior validation reports were found:]
Prior validation reports found: [N]
Most recent (kb #X, YYYY-MM-DD):
  - Overall: [ISSUES_FOUND/ALL_PASS]
  - Issues: [brief summary of failed layers/criteria]

This run will check whether previously identified issues have been resolved.
═══════════════════════════════════════
```

## Validation Layers

Run each layer in order. Present results after each layer. Read `${CLAUDE_PLUGIN_ROOT}/skills/validation/references/validation-layers.md` for detailed rules on each layer.

### Layer 1: Tests & Static Analysis

1. Detect project test/lint/type-check commands
2. Run tests **with coverage enabled** (e.g., `jest --coverage`, `pytest --cov`) — save coverage output for Layer 3
3. Run linter and type checker
4. Present results:

```
── Layer 1: Tests & Static Analysis ──
Tests:        [PASS/FAIL] — [summary]
Linting:      [PASS/FAIL] — [summary]
Type checking:[PASS/FAIL] — [summary]
```

If any command is unclear, ask the user.

### Layer 2: Thorough Review

1. Invoke the thorough-review skill: use the Skill tool to run `thorough-review:thorough-review` with argument `--branch`
2. Wait for completion
3. Summarize findings:

```
── Layer 2: Thorough Review ──────────
Critical findings: [count]
Important findings: [count]
Minor findings: [count]

[List Critical and Important findings]
```

### Layer 3: Test Coverage

1. **Use the coverage output from Layer 1** — do not re-run the test suite
2. Parse overall coverage percentage
3. Present results:

```
── Layer 3: Test Coverage ────────────
Overall coverage: [X]%
Target: 80%
Status: [PASS/FAIL]

[List any files with 0% coverage]
```

If Layer 1 did not produce coverage data, ask the user for the coverage command and run it once.

### Layer 4: Acceptance Criteria Tracing

1. For each acceptance criterion, search for evidence:
   - Grep for related test names/descriptions
   - Check test files for matching scenarios
   - Note if criterion was covered by manual verification
2. Present traceability table:

```
── Layer 4: Acceptance Criteria ──────
| # | Criterion | Evidence | Status |
|---|-----------|----------|--------|
| 1 | ... | ... | PASS |
| 2 | ... | ... | FAIL |
```

### Layer 5: Browser Validation (Conditional)

1. Ask: "Does this implementation have a frontend/UI component that should be validated in a browser?" — OR infer from the user's prompt if they've already indicated this
2. If yes: run browser smoke tests using chrome-devtools/claude-in-chrome
3. If no: skip

```
── Layer 5: Browser Validation ───────
Status: [PASS/FAIL/SKIPPED]
[Details if run]
```

## Final Report

After all layers complete, present:

```
═══════════════════════════════════════
VALIDATION REPORT
═══════════════════════════════════════

Plan: [plan title]

Layer 1 - Tests & Static Analysis: [PASS/FAIL]
Layer 2 - Thorough Review:         [PASS/FAIL/REVIEW]
Layer 3 - Test Coverage:           [PASS/FAIL]
Layer 4 - Acceptance Criteria:     [PASS/FAIL]
Layer 5 - Browser Validation:      [PASS/FAIL/SKIPPED]

Overall: [ALL PASS / X ISSUES FOUND]

[If prior validation report exists:]
Changes from prior run:
  Resolved: [issues that were FAIL, now PASS]
  Persisting: [issues still FAIL]
  New: [issues that were PASS or not checked, now FAIL]

[If all pass:]
Validation complete. You can proceed with `/commit`.

[If issues found:]
[N] issue(s) found. Address the issues above
and re-run `/validate` to verify fixes.
═══════════════════════════════════════
```

## Report Persistence

After presenting the final report, persist the validation results:

1. **Gather metadata**:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh
   ```

2. **Create the validations directory**:
   ```bash
   mkdir -p docs/ai/validations
   ```

3. **Write the validation report** using the template from `${CLAUDE_PLUGIN_ROOT}/skills/validation/references/report-template.md`. Include all layer results, the acceptance criteria traceability table, and the overall verdict.

4. **Import to kb**:
   ```bash
   kb import docs/ai/validations/<filename>.md -t validation --db kb.db --plain
   ```

5. **Link to the plan** if the plan was resolved from a kb ID:
   ```bash
   kb link <report_id> <plan_kb_id> -r related --db kb.db --plain
   ```

6. **Present the report location**:
   ```
   Validation report saved:
   - File: docs/ai/validations/<filename>.md
   - KB ID: <id>
   ```

## Notes

- Layer 2 status is "REVIEW" if there are Important (but no Critical) findings — the user decides whether to act on them
- If the user re-runs `/validate`, all layers run fresh — no partial re-validation
- The validation report file persists in `docs/ai/validations/` and is cleaned up by `/compact_plan`
