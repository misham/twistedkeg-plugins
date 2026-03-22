---
name: development-flow-validation
description: >
  Post-implementation validation with systematic quality gates.
  Use when asked to "validate the implementation", "run validation",
  "validate before commit", "check the implementation", or "validate the plan".
  Runs after implementation is complete and Plan Completion Gate has passed.
  Do NOT use for implementation (use development-flow-implementation)
  or code review (use thorough-review).
version: 1.0.0
---

# Post-Implementation Validation

Validate completed implementations against requirements, code quality standards, and test coverage before committing.

## Philosophy

- **Evidence-based** — every claim of "done" requires verifiable evidence
- **Requirements traceability** — each acceptance criterion maps to concrete proof
- **Layered quality gates** — tests (with coverage), review, coverage analysis, criteria, browser (if frontend)
- **Report incrementally** — present each layer's results immediately, but run all layers

## Workflow

1. Read the plan and discover linked requirements doc (see `references/requirements-discovery.md`)
2. Extract acceptance criteria from requirements doc
3. Run validation layers in order (see `references/validation-layers.md`)
4. Present validation report with pass/fail per layer and per criterion
5. Write validation report to `docs/ai/validations/` and import to kb (see `references/report-template.md`)
6. If all pass, indicate readiness for `/commit`
7. Ask for session feedback (see `skills/improve/references/feedback.md`)

## Key Rules

- Do NOT skip layers — each layer runs even if previous layers found issues
- Present results after each layer completes — do not batch all results to the end
- Browser validation is conditional — ask user or infer from context
- Test coverage target is ~80% average, but configurable per project
- Acceptance criteria require explicit evidence (test name, file:line, command output)
- The validation report captures all layer results and is persisted for downstream consumers
