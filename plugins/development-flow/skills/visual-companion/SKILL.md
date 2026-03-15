---
name: visual-companion
description: >
  Browser-based visual companion for showing mockups, wireframes, and design
  options during conversations. Use when asked to "show a mockup", "visual
  comparison", "show me options", "wireframe", "show layout options", or when
  a conversation involves visual design decisions that are better shown than
  described. Do NOT use for non-visual questions, text-based comparisons, or
  architecture discussions that don't involve UI.
version: 1.0.0
---

# Visual Companion

Show mockups, wireframes, and visual options in the user's browser during conversations. Uses Chrome browser automation to display HTML files and read user selections.

## Philosophy

- **Tool, not mode** — the companion is available for questions that benefit from visual treatment; not every question goes through the browser
- **Per-question decision** — even after the user accepts, decide for each question whether browser or terminal is better
- **Scale fidelity to the question** — wireframes for layout questions, polish for polish questions
- **Terminal is the primary channel** — the browser supplements the conversation, it doesn't replace it

## When to Use

The test: **would the user understand this better by seeing it than reading it?**

**Use the browser** when the content itself is visual:
- UI mockups, wireframes, layouts, navigation structures
- Side-by-side visual comparisons (two layouts, two design directions)
- Component designs and visual hierarchy questions
- Spatial relationships, flowcharts, state machines rendered as diagrams

**Use the terminal** when the content is text:
- Requirements and scope questions
- Conceptual A/B/C choices described in words
- Trade-off lists, pros/cons tables
- Technical decisions, API design, data modeling
- Clarifying questions where the answer is words

A question *about* a UI topic is not automatically a visual question. "What kind of wizard do you want?" is conceptual — use the terminal. "Which of these wizard layouts feels right?" is visual — use the browser.

## Workflow

### Offering the Companion

When you anticipate that upcoming questions will involve visual content, offer it once for consent:

> "Some of what we're working on might be easier to show visually in your browser — mockups, layout options, comparisons. Want me to use that when it helps?"

This offer MUST be its own message. Do not combine it with clarifying questions or other content. If declined, proceed with text-only conversation.

### Context Gathering

When the user accepts, gather design context from the codebase **before generating any mockups**. This is a one-time step per session. See `references/context-gathering.md` for the full methodology.

Summary:
1. **Find design tokens** — scan for Tailwind config, CSS variables, MUI/Chakra theme, styled-components theme, or token files. Extract colors, typography, spacing, border-radius.
2. **Build component inventory** — scan for existing React components, categorize by type (Layout, Navigation, Data Display, Input, Feedback), capture key props.
3. **Compile design context** — hold in conversation context (not written to file). Use to override default CSS variables and inform mockup structure.

If no tokens or components are found (new project, non-standard setup), use defaults and note this to the user.

### The Loop

1. **Generate HTML** — write a self-contained HTML file to a temp location using the CSS framework (see `references/css-framework.md`)
2. **Open in Chrome** — use `mcp__claude-in-chrome__navigate` with a `file://` URL
3. **Tell the user** — describe what's on screen, ask them to look and respond
4. **Read selections** — use `mcp__claude-in-chrome__javascript_tool` to read `data-selected` attributes, or use `mcp__claude-in-chrome__read_page` to get page state
5. **Iterate or advance** — if feedback changes current screen, write a new file. Only move to the next question when the current one is validated.
6. **Return to terminal** — when the next step doesn't need the browser, tell the user you're continuing in the terminal

### File Management

- Write HTML files to `/tmp/visual-companion/` (create if needed)
- Use semantic filenames: `layout-options.html`, `nav-wireframe.html`
- Never reuse filenames — each screen gets a fresh file
- For iterations: `layout-options-v2.html`, `layout-options-v3.html`

### Reading User Selections

After the user interacts with the page, read selections via JavaScript:

```javascript
// Get all selected options
JSON.stringify(
  Array.from(document.querySelectorAll('[data-selected="true"]'))
    .map(el => ({
      choice: el.dataset.choice,
      label: el.querySelector('h3')?.textContent || el.dataset.choice
    }))
)
```

Merge browser selections with the user's terminal text to get the full picture. The terminal message is the primary feedback.

## Key Rules

- Always offer the companion before first use — never surprise the user with a browser window
- Always gather design context before generating the first mockup
- One visual question per screen — don't overload
- 2-4 options max per screen
- Always provide a text summary of what's on screen (accessibility, and in case the browser isn't visible)
- Keep mockups simple — focus on layout and structure, not pixel-perfect design
- Use real content when it matters for the decision (e.g., actual copy length for layout decisions)
- Use the app's actual colors, fonts, and spacing when design context is available — mockups should feel like the existing app
- Reference existing components by name in wireframe labels (e.g., "&lt;Sidebar&gt;" not "sidebar area")
- Mirror the app's existing layout patterns unless proposing a change to them

## Building Mockups

See `references/css-framework.md` for the HTML template, CSS classes, and component patterns available for building mockup pages. When design context is available, replace the default CSS variables with extracted tokens.

See `references/context-gathering.md` for how to scan the codebase for design tokens and existing components.

See `references/interaction-patterns.md` for detailed patterns on handling multi-select, comparisons, and iteration flows.
