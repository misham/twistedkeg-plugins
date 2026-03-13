# Validation Layers

Run these layers in order. Present results after each layer completes.

## Layer 1: Tests & Static Analysis

**Purpose**: Verify all automated checks pass and collect coverage data.

**Steps**:
1. Detect the project's test command (look for `Makefile`, `package.json` scripts, `pyproject.toml`, etc.)
2. Run the test suite **with coverage enabled** (e.g., `jest --coverage`, `pytest --cov`, `go test -cover`) — this produces both pass/fail results and coverage data for Layer 3
3. Detect and run the linter (eslint, ruff, rubocop, etc.)
4. Detect and run the type checker (tsc, mypy, pyright, etc.)
5. Report pass/fail for each
6. **Save the coverage output** for Layer 3 to analyze

**Pass criteria**: All tests pass, no lint errors, no type errors.

**If commands are unclear**: Ask the user what commands to run for tests, linting, type checking, and coverage.

## Layer 2: Thorough Review

**Purpose**: Source-first code review with confidence scoring.

**Steps**:
1. Invoke `/thorough-review --branch`
2. Wait for the review to complete
3. Extract findings rated Critical or Important
4. Present findings to the user

**Pass criteria**: No Critical findings. Important findings are presented for user judgment.

**Note**: `/thorough-review` internally offers to run `/gemini-review` for a second opinion. Let the thorough-review command handle that orchestration.

## Layer 3: Test Coverage Analysis

**Purpose**: Verify adequate test coverage for new/changed code.

**Steps**:
1. **Use the coverage output from Layer 1** — do NOT re-run the test suite
2. Parse the coverage output for the overall percentage
3. Compare against the target (~80% average, configurable)
4. Identify any new/changed files with significantly below-average coverage

**Pass criteria**: Overall coverage meets target. No new files with 0% coverage.

**If Layer 1 did not produce coverage data**: Ask the user what command generates coverage reports and run it once.

## Layer 4: Acceptance Criteria Tracing

**Purpose**: Map each acceptance criterion to verification evidence.

**Steps**:
1. For each acceptance criterion from the requirements doc:
   a. Search for related tests by keyword/description
   b. Check if the criterion is covered by an automated test
   c. Check if the criterion was verified during manual verification (Plan Completion Gate)
   d. Record the evidence: test file:line, command output, or "manual verification confirmed"
2. Present a traceability table:

```
| # | Criterion | Evidence | Status |
|---|-----------|----------|--------|
| 1 | Given X, when Y, then Z | test_file.py:42 - test_name | PASS |
| 2 | Given A, when B, then C | Manual verification confirmed | PASS |
| 3 | Given D, when E, then F | No evidence found | FAIL |
```

**Pass criteria**: Every acceptance criterion has evidence. No FAIL entries.

## Layer 5: Browser Validation (Conditional)

**Purpose**: Smoke test the UI for frontend projects.

**Activation**: Ask the user "Does this implementation have a frontend/UI component that should be validated in a browser?" OR infer from the user's prompt if they mention UI/frontend.

**Steps** (if activated):
1. Ask the user for the URL to test (or how to start the dev server)
2. Use chrome-devtools or claude-in-chrome MCP tools to:
   a. Navigate to the page
   b. Take a screenshot/snapshot
   c. Verify key UI elements are present
   d. Check console for JavaScript errors
   e. Test basic interactions (click, form submit)
3. Report findings with screenshots

**Pass criteria**: No JavaScript errors, key UI elements present, basic interactions work.

**If not activated**: Skip this layer entirely and note "Skipped — not a frontend project" in the report.
