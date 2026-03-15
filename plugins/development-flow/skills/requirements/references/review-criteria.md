# Requirements Review Criteria

Use this when dispatching a requirements document reviewer agent.

**Purpose:** Verify the requirements document is complete, unambiguous, and ready to feed into `/research_codebase` and `/create_plan`.

**Dispatch after:** Requirements document is written to `docs/ai/requirements/`.

## Agent Dispatch

Use the Agent tool with `subagent_type: "general-purpose"` to dispatch the reviewer:

```
Agent tool call:
  description: "Review requirements document"
  subagent_type: "general-purpose"
  prompt: |
    Read the requirements document at [REQUIREMENTS_FILE_PATH] and review it
    for completeness and readiness. This is a read-only review — do not modify the file.

    ## What to Check

    | Category | What to Look For |
    |----------|--------------------|
    | Completeness | Empty sections, TODOs, placeholders, "TBD" |
    | Problem clarity | Is the problem statement specific and measurable? |
    | Scope | Does it have both In Scope and Out of Scope lists? |
    | Approaches | Does it have a Considered Approaches section with a selected approach and at least one alternative? Are trade-offs concrete and specific? |
    | Acceptance criteria | Are all criteria testable (Given/When/Then)? |
    | Ambiguity | Fuzzy words without measurable definitions ("fast", "easy", "secure") |
    | Assumptions | Are assumptions stated explicitly? |
    | Deliverables | Are concrete outputs listed? |
    | Open questions | This section should be EMPTY for a ready document |
    | Scope size | Can this be implemented in a single research + plan cycle? If not, flag for decomposition |
    | Internal consistency | Do acceptance criteria align with the selected approach? Do scope boundaries match the chosen direction? |

    ## CRITICAL

    Look especially hard for:
    - Open Questions section that still has items
    - Acceptance criteria that are not testable
    - Scope that's too large for a single plan cycle
    - Missing Out of Scope section
    - Problem statement that describes a solution rather than a problem
    - Missing or incomplete Considered Approaches section
    - Acceptance criteria that don't match the selected approach
    - Trade-offs that are vague or abstract instead of concrete

    ## Output Format

    ## Requirements Review

    **Status:** APPROVED | ISSUES FOUND

    **Issues (if any):**
    - [Section]: [specific issue] - [why it matters]

    **Recommendations (advisory):**
    - [suggestions that don't block approval]
```

**Review loop:** Maximum 3 automated iterations. If issues remain after 3 rounds, present them to the user for manual resolution.
