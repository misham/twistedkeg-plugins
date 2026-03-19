# Agent Dispatch Rules

## Available Agents

| Agent | Purpose | Tools | When to Use |
|-------|---------|-------|-------------|
| codebase-locator | Find WHERE code lives | Grep, Glob, LS | First pass — locate relevant files |
| codebase-analyzer | Understand HOW code works | Read, Grep, Glob, LS | Deep dive — trace data flow and implementation |
| codebase-pattern-finder | Find existing patterns and examples | Grep, Glob, Read, LS | Find similar implementations to model after |
| research-locator | Find docs in docs/ai/ and kb | Grep, Glob, LS, Bash | Find prior research and plans |
| research-analyzer | Extract insights from research docs | Read, Grep, Glob, LS, Bash | Analyze kb documents or research files |
| web-search-researcher | Research on the web via Gemini CLI | Bash, WebFetch, TodoWrite, Read, Grep, Glob, LS | When external API/service docs needed, unfamiliar library features, current best practices required, kb has no prior research on the topic, or user explicitly asks |

## Dispatch Strategy

1. **Start with locators** to find what exists
2. **Then use analyzers** on the most promising findings
3. **Run agents in parallel** when they're searching for different things
4. **Spawn kb document analyzers in background** alongside codebase agents

## Prompt Guidelines

- Be specific about what to search for
- Include which directories to focus on
- Specify what information to extract
- Request file:line references in responses
- Remind agents they are documenting, not evaluating
- Don't write detailed prompts about HOW to search — agents already know

## All Agents Are Documentarians

Every agent has strict instructions to:
- Document what EXISTS without critiquing
- Show patterns without evaluating them
- Describe implementations without suggesting improvements
- Report findings without identifying "problems"
