---
name: development-flow-implementation
description: >
  TDD-driven implementation of approved technical plans with phase gates
  and verification. Use when asked to "implement the plan", "execute the plan",
  "start implementation", "implement phase N", or "continue implementation".
  Requires an approved plan in docs/ai/plans/. Do NOT use for creating plans
  (use development-flow-planning) or research (use development-flow-research).
version: 1.0.0
---

# Plan Implementation

Implement approved technical plans from `docs/ai/plans/` using strict TDD cycles and phase gate verification.

## Philosophy

- **TDD always** — never write implementation code before a failing test exists
- **Phase gates** — all automated checks must pass before proceeding to next phase
- **Plan is guide, not gospel** — follow intent while adapting to reality
- **Forward momentum** — no manual pauses between phases unless explicitly requested

## Workflow

1. Read the plan completely, check for existing checkmarks
2. Read original ticket and all referenced files FULLY
3. Create todo list to track progress
4. For each change: follow TDD cycle (see `references/tdd-cycle.md`)
5. After each phase: run phase gate protocol (see `references/phase-gates.md`)
6. After all phases: stop for plan completion gate

## Key Rules

- Do NOT write implementation code before a failing test exists
- Run relevant test file after every edit — do not batch changes
- If 3+ test failures on same approach, reassess the approach
- Do not proceed to next phase with failing checks
- Update checkboxes in plan file as you complete sections
