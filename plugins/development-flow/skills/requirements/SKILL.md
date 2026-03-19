---
name: development-flow-requirements
description: >
  Interactive feature requirements gathering through structured elicitation
  and collaborative discovery. Use when asked to "gather requirements",
  "define a feature", "capture requirements", "what should we build",
  "requirements for X", or "spec out a feature". Do NOT use for codebase
  research (use development-flow-research), implementation planning
  (use development-flow-planning), design/architecture, or bug reports.
version: 1.0.0
---

# Requirements Gathering

Interactively elicit feature requirements through one-question-at-a-time conversation, producing a structured requirements document stored in the kb database.

## Philosophy

- **What and Why before How** — capture the problem and desired outcome, not the solution
- **One question at a time** — never overwhelm the user with multiple questions
- **YAGNI ruthlessly** — actively simplify scope and push back on unnecessary features
- **Challenge assumptions** — validate understanding at every step
- **Decompose when large** — split into multiple requirements docs if scope spans independent subsystems

## Workflow

1. Check for `$ARGUMENTS` — proceed if provided, show ready-prompt if empty
2. Search kb for prior requirements on the topic
3. Begin elicitation using conversation techniques (see `references/conversation-techniques.md`)
   - Before accepting any domain noun at face value, check disambiguation rules (see `references/disambiguation-rules.md`)
4. At each step, explain back understanding and get confirmation
5. After scope is clear, propose 2-3 approaches with trade-offs and get user's selection
6. When all sections are covered, gather metadata via `${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh`
7. Present requirements document section-by-section for incremental approval (see Incremental Presentation below)
8. Write approved document to `docs/ai/requirements/` (see `references/document-template.md`)
9. Run automated review loop — up to 3 iterations (see `references/review-criteria.md`)
10. Present document to user for final review
11. Iterate based on user feedback
12. Import final document into kb with type `requirements` (see `references/kb-usage.md`)
13. Suggest next step: `/research_codebase @<requirements-file-path>`
14. Ask for session feedback (see `skills/improve/references/feedback.md`)

## Visual Companion

When requirements involve UI or visual design decisions (layouts, navigation, component structure), consider offering the visual companion to show mockups alongside elicitation. See the [visual-companion skill](../visual-companion/SKILL.md).

**When to offer:**
- The feature involves new UI surfaces, layouts, or navigation changes
- The user is describing visual behavior that's easier to show than describe
- There are 2+ UI layout options to compare

**When NOT to offer:**
- Requirements are purely backend, API, or data-model focused
- The visual aspects are straightforward and don't need mockups
- The user has already declined visual companion in this session

## Key Rules

- Never ask multiple questions in a single response
- Never write the document with Open Questions still populated
- Always propose 2-3 approaches after scope is established, before locking down acceptance criteria
- Always present document sections incrementally for approval before writing the full document
- Always run the automated review loop before presenting to the user
- Always search kb for existing requirements before starting elicitation
- Decompose into multiple requirements documents if scope is too large for a single plan cycle
- Use multiple choice when the question has a bounded set of answers
- Detect and resolve ambiguous words — "fast", "easy", "secure" need measurable definitions
- Before accepting a domain noun that maps to an API entity, disambiguate per `references/disambiguation-rules.md`
- This is for features only, not bugs

## Incremental Presentation

Before writing the full document, present the requirements in logical section groups and get approval on each before proceeding:

1. **Problem & Context** — Problem Statement, Motivation & Value, User Context
2. **Scope & Approach** — Desired Behavior, Scope Boundaries, Considered Approaches
3. **Verification** — Acceptance Criteria, Validation Approach, Constraints & Assumptions, Key Deliverables

For each group:
- Present the drafted sections
- Ask: "Does this look right so far? Anything to add or change before I move on?"
- If the user requests changes, revise and re-present that group
- Only move to the next group after approval

This catches misunderstandings early — before they're buried in a completed document.
