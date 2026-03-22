---
description: Interactively gather feature requirements and produce structured requirements documents
model: opus
argument-hint: [feature description or topic]
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(kb:*), Bash(git:*), Bash(${CLAUDE_PLUGIN_ROOT}/scripts/*), Bash(mkdir:*), Agent, TodoWrite, mcp__claude-in-chrome__navigate, mcp__claude-in-chrome__javascript_tool, mcp__claude-in-chrome__read_page, mcp__claude-in-chrome__tabs_create_mcp, mcp__claude-in-chrome__tabs_context_mcp
---

# Gather Requirements

You are tasked with interactively gathering feature requirements through structured conversation, producing a requirements document stored in the kb database.

If `$ARGUMENTS` is provided, use it as starting context for elicitation and proceed to Step 1. Otherwise, follow the Initial Setup below.

## CRITICAL: THIS IS A COLLABORATIVE CONVERSATION, NOT A RESEARCH TASK
- DO NOT spawn codebase research agents — requirements gathering is pre-research
- DO NOT investigate code or architecture — that's what `/research_codebase` is for
- DO ask questions one at a time
- DO challenge assumptions and simplify scope
- DO explain back your understanding at every step
- This is for features only, not bugs

## KB Tool

The `kb` CLI must be installed in your system PATH. The database path should always be specified with `--db kb.db` relative to the project root. Use `--plain` for machine-readable output.

Key commands:
- `kb search <query> --db kb.db --plain` — Search existing knowledge
- `kb search <query> -t requirements --db kb.db --plain` — Search requirements documents
- `kb search <query> -t research --db kb.db --plain` — Search research documents
- `kb list -t requirements --db kb.db --plain` — List requirements documents
- `kb import <file> -t requirements --db kb.db --plain` — Import a requirements document
- `kb link <id1> <id2> -r related --db kb.db --plain` — Link two documents

## Initial Setup

If no `$ARGUMENTS` was provided, respond with:
```
I'll help you define what needs to be built. Describe the feature or problem you're thinking about, and I'll work with you to create a clear, structured requirements document.

You can provide:
- A brief description of the feature idea
- A problem you've observed that needs solving
- A rough concept you want to refine

I'll ask questions one at a time to fill in the details.
```
Then wait for the user's input.

If `$ARGUMENTS` was provided, proceed immediately with it as starting context.

## Process Steps

### Step 1: Context & Prior Search

Before beginning elicitation:

1. Search kb for existing requirements on the topic:
   ```bash
   kb search "<topic>" -t requirements --db kb.db --plain
   ```
2. Search for related research:
   ```bash
   kb search "<topic>" -t research --db kb.db --plain
   ```
3. If related documents are found, note them and use as context — don't re-ask questions that are already answered in prior documents.

### Step 2: Interactive Elicitation

Follow the conversation technique sequence from the skill's `references/conversation-techniques.md`:

1. **Problem Discovery** — Start with the pain point, not the solution. If the user describes a solution, ask why — find the root problem.
2. **User & Context** — Who uses this and in what situation?
3. **Offer Visual Companion** — If upcoming questions will involve visual decisions (UI layouts, component designs, wireframes), offer the visual companion in its own message. See the `visual-companion` skill for the offering prompt, methodology, and CSS framework. This MUST be its own message — do not combine with a clarifying question. If the user declines, continue text-only. If the topic has no visual component, skip this step. If the user accepts, run context gathering (design token extraction + component inventory) before the next visual question — see `visual-companion` skill's `references/context-gathering.md`.
4. **Happy Path** — Walk through the ideal interaction from start to finish.
5. **Scope Boundaries** — Draw explicit lines using Is/Is Not pattern.
6. **Propose Approaches** — Present 2-3 approaches with concrete trade-offs and your recommendation. Always include a "simplest possible" option. Get user's selection before proceeding. If the visual companion is active, use it to show approaches with mockups when the approaches have visual differences.
7. **Acceptance Criteria** — Convert each requirement to Given/When/Then format. If a requirement can't be made testable, flag it. Ensure criteria align with the selected approach.
8. **Constraints & Assumptions** — Probe for hidden assumptions. For every stated requirement, identify one unstated assumption and validate it.
9. **Validation** — How will we know it works?

Rules during elicitation:
- **One question at a time** — never ask multiple questions in a single response
- **Multiple choice when possible** — lower friction than open-ended questions
- **Explain back for validation** — restate understanding before moving on
- **Challenge assumptions** — ask "why" to uncover the real need
- **YAGNI ruthlessly** — push back on unnecessary complexity
- **Detect ambiguity** — watch for fuzzy words ("fast", "easy", "secure", "flexible") and ask for 3 specific, measurable criteria
- Track progress through document sections using TodoWrite
- If scope is too large for a single research + plan cycle, propose decomposition into multiple requirements documents

### Step 3: Incremental Section Approval

Before writing the full document, present requirements in section groups for incremental approval:

**Group 1: Problem & Context**
- Problem Statement, Motivation & Value, User Context
- Ask: "Does this capture the problem correctly? Anything to add or change?"

**Group 2: Scope & Approach**
- Desired Behavior, Scope Boundaries, Considered Approaches (selected + alternatives)
- Ask: "Does the scope and chosen approach look right?"

**Group 3: Verification**
- Acceptance Criteria, Validation Approach, Constraints & Assumptions, Key Deliverables
- Ask: "Do these criteria and deliverables cover what we need?"

Rules:
- If the user requests changes, revise and re-present that group
- Only move to the next group after approval
- After all three groups are approved, proceed to document writing

### Step 4: Requirements Document Writing

Once all section groups are approved:

1. Gather metadata:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/spec_metadata.sh
   ```
2. Ensure the requirements directory exists:
   ```bash
   mkdir -p docs/ai/requirements
   ```
3. Write the requirements document using the template from the skill's `references/document-template.md`
   - File naming: `docs/ai/requirements/YYYY-MM-DD-ENG-XXXX-description.md`
     - `YYYY-MM-DD` — today's date
     - `ENG-XXXX` — ticket number (omit if no ticket)
     - `description` — brief kebab-case description
   - The **Open Questions** section MUST be empty — resolve all questions before writing
   - All sections must be populated with substantive content, including Considered Approaches

### Step 5: Automated Review Loop

After writing the document, dispatch a review agent:

1. Use the Agent tool with `subagent_type: "general-purpose"` to review the document using criteria from the skill's `references/review-criteria.md`
2. If the reviewer finds issues:
   - Fix them in the document
   - Re-dispatch the reviewer
3. Maximum 3 automated iterations
4. If issues remain after 3 rounds, present them to the user for manual resolution

### Step 6: User Review & Iteration

1. Present the document location to the user
2. Summarize key decisions: selected approach, scope boundaries, acceptance criteria
3. Iterate based on feedback — update the document in place
4. Continue until the user approves

### Step 7: KB Import

Once the user approves:

1. Import into kb:
   ```bash
   kb import docs/ai/requirements/<filename>.md -t requirements --db kb.db --plain
   ```
2. Link to related kb documents if any were found in Step 1:
   ```bash
   kb link <new_id> <related_id> -r related --db kb.db --plain
   ```
3. Suggest next step:
   ```
   You can now run `/research_codebase @docs/ai/requirements/<filename>.md` to research the codebase for this feature.
   ```

## Important Guidelines

- **Collaborative tone** — you're a partner in discovery, not an interrogator
- **Features only** — if the user describes a bug, redirect them to the appropriate bug tracking workflow
- **Decompose large features** — if scope spans multiple independent subsystems, create separate requirements documents for each
- **No codebase research** — this command is pre-research; that's what `/research_codebase` is for
- **No design/architecture** — capture WHAT and WHY, not HOW; the design comes later
- **Keep the markdown file** in `docs/ai/requirements/` — it will be cleaned up by `/compact_plan`
