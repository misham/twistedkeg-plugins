---
name: development-flow-research
description: >
  Codebase research methodology for documenting existing code using parallel
  sub-agents and kb database. Use when asked to "research codebase",
  "investigate how X works", "explore the code", "document how X is
  implemented", or "understand the architecture of X". Do NOT use for code
  review, planning, or implementation tasks.
version: 1.0.0
---

# Codebase Research

Research and document existing codebase by spawning parallel sub-agents, synthesizing findings, and storing results in the kb database.

## Philosophy

- **Document what IS, not what SHOULD BE** — all agents are documentarians, not critics
- **Parallel dispatch** — maximize efficiency by running multiple specialized agents concurrently
- **KB-first context** — always search kb for prior research before decomposing a new query
- **File-first reading** — always read directly mentioned files FULLY before spawning sub-tasks

## Workflow

1. Read mentioned files fully (main context)
2. Search kb for prior research on the topic
3. Decompose research question into parallel agent tasks
4. Dispatch agents (see `references/agent-dispatch.md`)
5. Wait for ALL agents to complete
6. Gather metadata via `${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh`
7. Synthesize findings into research document (see `references/output-format.md`)
8. Import into kb (see `references/kb-usage.md`)
9. Present findings and ask for follow-ups

## Key Rules

- Never write research documents with placeholder values
- Always read mentioned files before spawning sub-tasks
- Always search kb before decomposing the research question
- Always wait for all sub-agents before synthesizing
- Document cross-component connections and how systems interact
- Include file:line references for all claims
