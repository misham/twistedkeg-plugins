---
description: Create detailed implementation plans through interactive research and iteration, using kb database for context
model: opus
argument-hint: [file path, ticket reference, or kb document ID]
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(${CLAUDE_PLUGIN_ROOT}/bin/kb:*), Bash(git:*), Bash(gh:*), Bash(${CLAUDE_PLUGIN_ROOT}/scripts/*), Agent, TodoWrite
---

# Create Implementation Plan (KB)

You are tasked with creating detailed implementation plans through an interactive, iterative process. You should be skeptical, thorough, and work collaboratively with the user to produce high-quality technical specifications. The `kb` database is used to find prior research and plans for context. Plans are written to `docs/ai/plans/` and can be imported into kb once finalized.

If `$ARGUMENTS` is provided, use it as the input (file path or ticket reference) and skip the default message. Otherwise, follow the Initial Response step below.

## KB Tool

The `kb` CLI is available at `${CLAUDE_PLUGIN_ROOT}/bin/kb`. The database path should always be specified with `--db kb.db` relative to the project root. Use `--plain` for machine-readable output.

Key commands:
- `${CLAUDE_PLUGIN_ROOT}/bin/kb search <query> --db kb.db --plain` — Search existing knowledge
- `${CLAUDE_PLUGIN_ROOT}/bin/kb search <query> -t plan --db kb.db --plain` — Search only plan documents
- `${CLAUDE_PLUGIN_ROOT}/bin/kb search <query> -t research --db kb.db --plain` — Search only research documents
- `${CLAUDE_PLUGIN_ROOT}/bin/kb search <query> -t requirements --db kb.db --plain` — Search requirements documents
- `${CLAUDE_PLUGIN_ROOT}/bin/kb get <id> --db kb.db --plain` — Get a document by ID

## Initial Response

When this command is invoked:

1. **Check if arguments were provided** (`$ARGUMENTS`):
   - If `$ARGUMENTS` contains a file path, ticket reference, or kb document ID, skip the default message
   - For kb document IDs, retrieve with `${CLAUDE_PLUGIN_ROOT}/bin/kb get <id> --db kb.db --plain`
   - For file paths, read them FULLY
   - Begin the research process

2. **If `$ARGUMENTS` is empty**, respond with:
```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task/ticket description (or reference to a ticket)
2. Any relevant context, constraints, or specific requirements
3. Links to related research or previous implementations

I'll analyze this information and work with you to create a comprehensive plan.

For deeper analysis, try: `/create_plan think deeply about <thing>`
```

Then wait for the user's input.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

1. **Read all mentioned files immediately and FULLY**:
   - Ticket from Linear or GitHub
   - Research documents
   - Related implementation plans
   - Any JSON/data files mentioned
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: DO NOT spawn sub-tasks before reading these files yourself in the main context
   - **NEVER** read files partially - if a file is mentioned, read it completely

2. **Search existing knowledge base for prior research, plans, and requirements:**
   - Run `${CLAUDE_PLUGIN_ROOT}/bin/kb search "<relevant terms>" --db kb.db --plain` to find related prior work
   - Run `${CLAUDE_PLUGIN_ROOT}/bin/kb search "<relevant terms>" -t requirements --db kb.db --plain` to find related requirements documents
   - Note the IDs and titles of relevant documents — do NOT read them inline with `kb get`
   - These will be analyzed by background agents in step 3
   - Use prior findings as supplementary context, but always verify against live code

3. **Spawn initial research tasks to gather context**:
   Before asking the user any questions, use specialized agents to research in parallel:

   **For kb document analysis (from step 2 results):**
   - For each relevant kb document found in step 2, spawn a **research-analyzer** background agent
   - Pass the kb document ID so it can fetch and analyze the content: "Analyze kb document <id> for insights related to <planning task>"
   - These run in the background alongside codebase research agents, keeping full kb document content out of the main context

   **For codebase research:**
   - Use the **codebase-locator** agent to find all files related to the ticket/task
   - Use the **codebase-analyzer** agent to understand how the current implementation works
   - If a ticket URL is mentioned, read it directly

   These codebase agents will:
   - Find relevant source files, configs, and tests
   - Identify the specific directories to focus on for the repository
   - Trace data flow and key functions
   - Return detailed explanations with file:line references
   - Find tests and examples

4. **While research agents run, assess complexity and propose design phase**:

   Based on the input files already read, assess whether this feature warrants a deeper design phase.

   **Complexity signals** (if 2+ are present, propose the design phase):

   | Signal | Example |
   |--------|---------|
   | Multiple components/systems affected | Touches 3+ distinct modules or services |
   | New architectural patterns | Introducing something the codebase doesn't already do |
   | Cross-cutting concerns | Security, observability, performance requirements spanning the change |
   | Data model changes | New schemas, migrations, relationships |
   | Integration points | External APIs, message queues, third-party services |
   | Solution ambiguity | Requirements are clear on *what* but multiple valid *hows* exist |

   **If complexity signals are detected**, propose the design phase:

   ```
   Based on my initial read, this feature involves [signals detected]. I'd like to do a
   deeper design phase after codebase research to explore architectural approaches before
   writing the implementation phases. This will add an Architecture Design section to the
   plan with component design, data flow, and trade-off analysis.

   Sound good, or would you prefer I keep this lightweight?
   ```

   **User can override in either direction:**
   - "Yes, let's do the full design" → activates design phase
   - "No, keep it simple" → stays with existing lightweight flow
   - User can also request design explicitly at any point: "I want a full design for this one"

   **If no complexity signals detected**, continue with the existing lightweight flow. Do not mention the design phase unless the user asks.

   Note the user's decision — it determines whether Step 3 ends with the lightweight "Design Options" presentation or the full design phase.

5. **Read all newly identified files from research tasks**:
   - After all research tasks complete (including background kb analyzers), read any newly identified codebase files not already in context
   - Read them FULLY into the main context
   - Use kb analyzer summaries directly — no need to re-read full kb documents
   - This ensures you have complete understanding before proceeding

6. **Analyze and verify understanding**:
   - Cross-reference the ticket or request requirements with actual code
   - Identify any discrepancies or misunderstandings
   - Note assumptions that need verification
   - Determine true scope based on codebase reality

7. **Present informed understanding and focused questions**:
   ```
   Based on the ticket or request and my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint discovered]
   - [Potential complexity or edge case identified]

   Questions that my research couldn't answer:
   - [Specific technical question that requires human judgment]
   - [Business logic clarification]
   - [Design preference that affects implementation]
   ```

   Only ask questions that you genuinely cannot answer through code investigation.

### Step 2: Complexity Assessment Decision

The complexity assessment from Step 1 sub-step 4 is presented to the user during the research agent wait time. The user's response (confirm, decline, or no assessment needed) is noted before research results come back. This decision gates whether Step 3 uses the lightweight or full design flow.

### Step 3: Research & Discovery

After getting initial clarifications:

1. **If the user corrects any misunderstanding**:
   - DO NOT just accept the correction
   - Spawn new research tasks to verify the correct information
   - Read the specific files/directories they mention
   - Only proceed once you've verified the facts yourself

2. **Create a research todo list** using TodoWrite to track exploration tasks

3. **Spawn parallel sub-tasks for comprehensive research**:
   - Create multiple Task agents to research different aspects concurrently
   - Use the right agent for each type of research:

   **For deeper investigation:**
   - **codebase-locator** - To find more specific files (e.g., "find all files that handle [specific component]")
   - **codebase-analyzer** - To understand implementation details (e.g., "analyze how [system] works")
   - **codebase-pattern-finder** - To find similar features we can model after

   **For historical context (if kb search from Step 1 didn't cover this area):**
   - **research-locator** - To find any research, plans, or decisions about this area
   - **research-analyzer** - To extract key insights from the most relevant documents

   Each agent knows how to:
   - Find the right files and code patterns
   - Identify conventions and patterns to follow
   - Look for integration points and dependencies
   - Return specific file:line references
   - Find tests and examples

4. **Wait for ALL sub-tasks to complete** before proceeding

5. **Present findings and design options**:

   **If design phase is NOT active** (simple feature — existing behavior):
   ```
   Based on my research, here's what I found:

   **Current State:**
   - [Key discovery about existing code]
   - [Pattern or convention to follow]

   **Design Options:**
   1. [Option A] - [pros/cons]
   2. [Option B] - [pros/cons]

   **Open Questions:**
   - [Technical uncertainty]
   - [Design decision needed]

   Which approach aligns best with your vision?
   ```

   **If design phase IS active** (complex feature):

   Using the research findings, explore 2-3 architectural approaches. For each approach, consider:
   - How it fits with existing codebase patterns discovered in research
   - Component breakdown and boundaries
   - Data flow implications
   - Trade-offs (complexity, performance, maintainability, extensibility)

   Present the full Architecture Design section for review:

   ```
   Based on my codebase research, here's the Architecture Design for this feature:

   ## Approaches Considered

   **Approach 1: [Name]**
   - Description: [How it works]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

   **Approach 2: [Name]**
   - Description: [How it works]
   - Pros: [Benefits]
   - Cons: [Drawbacks]

   [Approach 3 if warranted]

   ## Recommended Approach: [Name]
   [Rationale — why this over the alternatives]

   ## Component Design
   [Components with responsibilities and interfaces]

   ## Data Flow
   [How data moves through the system]

   [Additional sections as relevant: Data Model, Error Handling, Integration Points, Cross-Cutting Concerns]

   Does this architecture look right? I'll incorporate your feedback before writing the implementation phases.
   ```

   Wait for user approval of the architecture before proceeding to Step 4.
   Incorporate any feedback into the design before moving on.
   The approved Architecture Design section will be included in the plan document as-is.

### Step 4: Plan Structure Development

Once aligned on approach:

1. **Create initial plan outline**:
   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes]
   2. [Phase name] - [what it accomplishes]
   3. [Phase name] - [what it accomplishes]

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

2. **Get feedback on structure** before writing details

### Step 5: Detailed Plan Writing

After structure approval:

1. **Write the plan** to `docs/ai/plans/YYYY-MM-DD-ENG-XXXX-description.md`
   - Format: `YYYY-MM-DD-ENG-XXXX-description.md` where:
     - YYYY-MM-DD is today's date
     - ENG-XXXX is the ticket number (omit if no ticket)
     - description is a brief kebab-case description
   - Examples:
     - With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
     - Without ticket: `2025-01-08-improve-error-handling.md`

2. **Use the plan template** from `skills/planning/references/plan-template.md` as the structure.
   Read the template file and follow its section structure exactly.

3. **If the design phase was active**, include the "Architecture Design" section in the plan
   (positioned between "Implementation Approach" and "API Contract"), populated with the
   approved design from Step 3. If the design phase was not active, omit the Architecture
   Design section entirely.

### Step 6: Sync and Review

1. **Present the draft plan location**:
   ```
   I've created the initial implementation plan at:
   `docs/ai/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   Please review it and let me know:
   - Are the phases properly scoped?
   - Are the success criteria specific enough?
   - Any technical details that need adjustment?
   - Missing edge cases or considerations?
   ```

2. **Iterate based on feedback** - be ready to:
   - Add missing phases
   - Adjust technical approach
   - Clarify success criteria (both automated and manual)
   - Add/remove scope items

3. **Continue refining** until the user is satisfied

4. **Note**: The plan file stays in `docs/ai/plans/` for review and iteration. Importing into kb is handled separately once the plan is finalized.

## Important Guidelines

1. **Be Skeptical**:
   - Question vague requirements
   - Identify potential issues early
   - Ask "why" and "what about"
   - Don't assume - verify with code

2. **Be Interactive**:
   - Don't write the full plan in one shot
   - Get buy-in at each major step
   - Allow course corrections
   - Work collaboratively

3. **Be Thorough**:
   - Read all context files COMPLETELY before planning
   - Research actual code patterns using parallel sub-tasks
   - Include specific file paths and line numbers
   - Write measurable success criteria with TDD and automated checks per phase, manual verification at end

4. **Be Practical**:
   - Focus on incremental, testable changes
   - Consider migration and rollback
   - Think about edge cases
   - Include "what we're NOT doing"

5. **Track Progress**:
   - Use Todos to track planning tasks
   - Update todos as you complete research
   - Mark planning tasks complete when done

6. **No Open Questions in Final Plan**:
   - If you encounter open questions during planning, STOP
   - Research or ask for clarification immediately
   - Do NOT write the plan with unresolved questions
   - The implementation plan must be complete and actionable
   - Every decision must be made before finalizing the plan

## Success Criteria Guidelines

**Each phase has automated success criteria following red/green TDD. Manual verification is collected in a single "Final Manual Verification" section at the end of the plan.**

1. **Per-Phase Automated Verification** (runs after each phase, must pass before proceeding):
   - Red/green TDD: failing test written first, then implementation
   - Commands that can be run: `make test`, `npm run lint`, `rspec`, etc.
   - Specific files that should exist
   - Code compilation/type checking
   - Automated test suites

2. **Final Manual Verification** (runs once after all phases complete):
   - UI/UX functionality
   - Performance under real conditions
   - Edge cases that are hard to automate
   - User acceptance criteria

**Per-phase manual verification**: Only add per-phase manual verification pauses if the user explicitly requests them.

**Format example:**
```markdown
### Success Criteria:
- [ ] Each change follows red/green TDD (failing test → implementation → refactor)
- [ ] Database migration runs successfully
- [ ] All unit tests pass
- [ ] No linting errors
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`
```

And at the end of the plan:
```markdown
## Final Manual Verification

_Run once after all phases are complete and all automated checks pass._

- [ ] New feature appears correctly in the UI
- [ ] Performance is acceptable with 1000+ items
- [ ] Error messages are user-friendly
- [ ] Feature works correctly on mobile devices
```

## Common Patterns

### For Database Changes:
- Start with schema/migration
- Add store methods
- Update business logic
- Expose via API
- Update clients

### For New Features:
- Research existing patterns first
- Start with data model
- Build backend logic
- Add API endpoints
- Implement UI last

### For Refactoring:
- Document current behavior
- Plan incremental changes
- Maintain backwards compatibility
- Include migration strategy

## Sub-task Spawning Best Practices

When spawning research sub-tasks:

1. **Spawn multiple tasks in parallel** for efficiency
2. **Each task should be focused** on a specific area
3. **Provide detailed instructions** including:
   - Exactly what to search for
   - Which directories to focus on
   - What information to extract
   - Expected output format
4. **Be EXTREMELY specific about directories**:
   - Never use generic terms like "UI" when you mean "admin-portal"
   - Include the full path context in your prompts
5. **Specify read-only tools** to use
6. **Request specific file:line references** in responses
7. **Wait for all tasks to complete** before synthesizing
8. **Verify sub-task results**:
   - If a sub-task returns unexpected results, spawn follow-up tasks
   - Cross-check findings against the actual codebase
   - Don't accept results that seem incorrect

Example of spawning multiple tasks concurrently:
- **codebase-locator**: "Find all files related to the database schema for [feature]"
- **codebase-analyzer**: "Analyze how the API layer handles [pattern]"
- **codebase-pattern-finder**: "Find similar UI components we can model after"
- **research-locator**: "Find any existing research or plans about [area]"

## Example Interaction Flow

```
User: /create_plan docs/ai/research/2025-01-08-parent-child-tracking.md
Assistant: Let me read that research document completely first...

[Reads file fully, searches kb for related documents, spawns research agents]

Based on the research and my analysis of the codebase, I understand we need to...

[Interactive process continues...]
```

```
User: /create_plan
Assistant: I'll help you create a detailed implementation plan...

User: We need to add parent-child tracking for Claude sub-tasks. See PRJ-111 Linear ticket
Assistant: Let me read that ticket completely first...

[Reads file fully, searches kb for related documents, spawns research agents]

Based on the ticket, I understand we need to track parent-child relationships...

[Interactive process continues...]
```
