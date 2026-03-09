# twistedkeg-plugins

A Claude Code plugin marketplace with multiple plugins.

## Installation

Add this marketplace to Claude Code:

```
/plugin marketplace add https://github.com/<owner>/twistedkeg-plugins
```

Then install individual plugins:

```
/plugin install thorough-review@twistedkeg-plugins
```

## Plugins

### thorough-review

Source-first, verification-oriented code review with self-improving feedback loops.

**What it does:**

1. **Source-first** — reads full source files for context, not just diffs
2. **Verification-oriented** — verifies specific claims against actual code
3. **Concrete fixes** — every finding includes a specific remediation

Supports two review modes: **code review** (branch diffs, specific files) and **plan review** (implementation plans with verification tables).

All findings are confidence-scored (0-100) with only findings >= 75 reported, reducing noise and false positives.

#### Usage

**`/thorough-review`** — Run a thorough code review:

```
/thorough-review --branch          # Review branch changes against main
/thorough-review src/api/          # Review specific directory
/thorough-review path/to/plan.md   # Review a plan document
/thorough-review                   # Auto-detect from context
```

**`/thorough-review-improve`** — Promote accumulated feedback patterns into permanent rules:

```
/thorough-review-improve
```

Reads feedback from all projects, identifies patterns appearing in 2+ projects, and proposes promotions to the global feedback file or the skill itself.

#### Self-Improvement Loop

After each review, the plugin captures feedback:
- **False positives** — findings that were wrong get recorded to prevent recurrence
- **Missed patterns** — things the review should have caught get added as boosters
- **Calibrations** — severity adjustments for project-specific context

Feedback accumulates in `.claude/thorough-review.local.md` (per-project) and `~/.claude/thorough-review.global.md` (cross-project). Use `/thorough-review-improve` to promote stable patterns into permanent rules.

#### Interaction with Other Tools

| Tool | Relationship |
|------|-------------|
| `code-review` plugin | Posts to GitHub PRs. This plugin does local reviews. Complementary. |
| `pr-review-toolkit` plugin | Different trigger phrases. No conflict. |
| `/gemini_review` | Cross-model validation. Can be used after this plugin for a second opinion. |

### development-flow

Research-driven development workflow with kb-backed planning, TDD implementation, and codebase research.

**What it does:**

Provides a structured development workflow: research existing code, create implementation plans, execute with TDD, and archive completed work — all backed by a `kb` knowledge base for persistent context across sessions.

#### Commands

| Command | Description |
|---------|-------------|
| `/research_codebase` | Research codebase using parallel sub-agents, store findings in kb |
| `/create_plan` | Create implementation plans through interactive research and iteration |
| `/implement_plan` | Execute plans with strict TDD cycles and phase gates |
| `/compact_plan` | Compact finished plans, import to kb, clean up source files |
| `/commit` | Create git commits with user approval, no Claude attribution |

#### Agents

Six specialized sub-agents for parallel research:

- **codebase-locator** — find where code lives
- **codebase-analyzer** — understand how code works
- **codebase-pattern-finder** — find similar implementations and patterns
- **research-locator** — find documents in docs/ai/ and kb database
- **research-analyzer** — extract insights from research documents
- **web-search-researcher** — research on the web via Gemini CLI

#### KB Integration

Uses the [kb](https://github.com/misham/kb) CLI for storing and retrieving research documents and plans. The kb binary is automatically downloaded on first session start via a SessionStart hook.
