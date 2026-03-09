# development-flow

Research-driven development workflow with kb-backed planning, TDD implementation, and codebase research.

## Commands

| Command | Description |
|---------|-------------|
| `/research_codebase` | Research codebase and store findings in kb database |
| `/create_plan` | Create implementation plans through interactive research and iteration |
| `/implement_plan` | Implement plans with TDD cycles and phase gates |
| `/compact_plan` | Compact finished plans, import to kb, clean up source files |
| `/commit` | Create git commits with user approval, no Claude attribution |

## Agents

| Agent | Purpose |
|-------|---------|
| codebase-locator | Find where code lives in a codebase |
| codebase-analyzer | Analyze implementation details and trace data flow |
| codebase-pattern-finder | Find similar implementations and usage patterns |
| research-locator | Find documents in docs/ai/ and kb database |
| research-analyzer | Extract insights from research documents |
| web-search-researcher | Research on the web using Gemini CLI |

## Skills

| Skill | Triggers |
|-------|----------|
| research | "research codebase", "investigate how X works" |
| planning | "create plan", "implementation plan" |
| implementation | "implement plan", "execute plan" |
| maintenance | "compact plan", "archive plan" |
| commit | "commit changes", "create commit" |

## KB Integration

This plugin uses the [kb](https://github.com/misham/kb) CLI for storing and retrieving research documents and plans. The kb binary is automatically downloaded on first session start via a SessionStart hook.

## Development Workflow

1. `/research_codebase` — Document existing code
2. `/create_plan` — Design implementation plan with kb context
3. Review and iterate on the plan
4. `/implement_plan` — Execute with TDD and phase gates
5. `/compact_plan` — Archive completed plan to kb
6. `/commit` — Create focused git commits
