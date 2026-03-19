# Agent Selection for Planning

## Agent Inventory

| Agent | Purpose | When to Dispatch |
|-------|---------|-----------------|
| codebase-locator | Find WHERE code lives — directories, files, components | Always — first pass for any planning task |
| codebase-analyzer | Understand HOW code works — data flow, implementation details | Always — deep dive on files found by locator |
| codebase-pattern-finder | Find similar implementations to model after | Always — identifies reusable patterns |
| research-locator | Find prior research, plans, and decisions in kb and docs/ai/ | When kb search returns relevant IDs |
| research-analyzer | Extract insights from kb documents | When kb search returns relevant documents — spawn one per document in background |
| web-search-researcher | Research external documentation, APIs, libraries via Gemini CLI | See decision criteria below |

## Web-Search-Researcher Decision Criteria

Dispatch the web-search-researcher agent when **any** of these conditions are met:

1. **External API or service integration** — the plan involves a third-party API, SDK, or service whose docs are not in the codebase
2. **Library or framework questions** — the plan requires using a library feature the codebase doesn't already demonstrate
3. **Current best practices needed** — the question involves evolving standards (security, accessibility, performance) where training data may be stale
4. **KB search returns no relevant results** — the topic is new to this codebase and has no prior research
5. **User explicitly requests web research** — "look this up", "check the docs", "what's the latest on X"

**Do NOT dispatch** when:
- The answer is fully derivable from the existing codebase (use codebase agents instead)
- The question is about internal business logic or project-specific conventions
- KB search already returned comprehensive prior research on the topic
- The question is about architecture or design decisions (these are codebase + user judgment, not web research)

## Dispatch Patterns

### Simple Feature (no complexity signals)

Spawn in parallel:
- codebase-locator
- codebase-analyzer
- codebase-pattern-finder

Plus in background (if kb search found relevant docs):
- research-analyzer (one per relevant kb document)

### Complex Feature (2+ complexity signals)

Spawn in parallel:
- codebase-locator
- codebase-analyzer
- codebase-pattern-finder
- web-search-researcher (if external integration or unfamiliar library)

Plus in background:
- research-analyzer (one per relevant kb document)
- research-locator (if kb search didn't cover the area)
