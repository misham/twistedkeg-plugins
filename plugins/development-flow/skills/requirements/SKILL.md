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
4. At each step, explain back understanding and get confirmation
5. When all sections are covered, gather metadata via `${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh`
6. Write requirements document to `docs/ai/requirements/` (see `references/document-template.md`)
7. Run automated review loop — up to 3 iterations (see `references/review-criteria.md`)
8. Present document to user for review
9. Iterate based on user feedback
10. Import final document into kb with type `requirements` (see `references/kb-usage.md`)
11. Suggest next step: `/research_codebase @<requirements-file-path>`

## Key Rules

- Never ask multiple questions in a single response
- Never write the document with Open Questions still populated
- Always explain back understanding before writing
- Always run the automated review loop before presenting to the user
- Always search kb for existing requirements before starting elicitation
- Decompose into multiple requirements documents if scope is too large for a single plan cycle
- Use multiple choice when the question has a bounded set of answers
- Detect and resolve ambiguous words — "fast", "easy", "secure" need measurable definitions
- This is for features only, not bugs
