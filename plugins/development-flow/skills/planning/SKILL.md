---
name: development-flow-planning
description: >
  Implementation plan creation through interactive research and iteration.
  Use when asked to "create a plan", "write an implementation plan",
  "plan the implementation", "design a plan for X", or "plan how to build X".
  Do NOT use for codebase research (use development-flow-research) or
  implementation (use development-flow-implementation).
version: 1.0.0
---

# Implementation Planning

Create detailed implementation plans through interactive research, kb-backed context gathering, and collaborative iteration with the user.

## Philosophy

- **Be skeptical** — question vague requirements, identify potential issues early
- **Be interactive** — don't write the full plan in one shot, get buy-in at each step
- **Be thorough** — read all context files COMPLETELY, research actual code patterns
- **Be practical** — focus on incremental, testable changes with TDD
- **No open questions in final plan** — every decision must be made before finalizing

## Workflow

1. Read all mentioned files FULLY (main context, before spawning agents)
2. Search kb for prior research and plans (see `references/research-integration.md`)
3. Spawn parallel research agents (codebase-locator, codebase-analyzer, codebase-pattern-finder)
4. Spawn background research-analyzer agents for relevant kb documents
5. While agents run: assess complexity from loaded input, propose design phase if 2+ signals detected, user confirms
6. Read newly identified files from research results
7. Present informed understanding with focused questions
8. Create research todo list and iterate on design options (lightweight) or full architecture exploration (design phase)
9. If design phase: present Architecture Design section for approval before proceeding
10. Build plan outline, get user feedback on structure
11. Write plan to `docs/ai/plans/` using template (see `references/plan-template.md`)
    - When referencing API entities in the plan, verify mapping per disambiguation rules (see `references/disambiguation-rules.md`)
12. Iterate based on user feedback until approved
13. After user approves the plan, ask for session feedback (see `skills/improve/references/feedback.md`)

## Key Rules

- Read files FULLY — never use limit/offset parameters
- Read mentioned files yourself BEFORE spawning sub-tasks
- Search kb BEFORE decomposing the research question
- Wait for ALL sub-agents before synthesizing
- Only ask questions you genuinely cannot answer through code investigation
- If user corrects a misunderstanding, verify with new research — don't just accept
- Include specific file paths and line numbers in the plan
- Write measurable success criteria with TDD per phase
- Include concrete output examples in every phase that changes user-visible behavior
- Verify API entity mappings against requirements disambiguation (see `references/disambiguation-rules.md`)
