# TDD Cycle

For each change within a phase, follow this strict cycle:

## 1. Red — Write Failing Test

- Write a test that describes the desired behavior
- Run it to confirm it fails for the expected reason
- The failure message should clearly indicate what's missing

## 2. Green — Minimal Implementation

- Write the minimum code to make the test pass
- Do not add extra functionality
- Run the test to confirm it passes

## 3. Refactor — Clean Up

- Clean up if needed (remove duplication, improve names)
- Re-run the test to confirm it still passes
- Do not change behavior during refactor

## Rules

- **Never skip Red** — a failing test must exist before implementation code
- **Run tests after every edit** — do not batch changes and test later
- **Stop on unexpected failures** — diagnose before continuing
- **Reassess after 3+ failures** — if the same approach keeps failing, step back and reconsider
- **One change at a time** — don't try to implement multiple features in a single cycle
