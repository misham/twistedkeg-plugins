# Interaction Patterns

## Opening the Browser

Generate an HTML file and open it in Chrome:

1. Create the temp directory if needed:
   ```bash
   mkdir -p /tmp/visual-companion
   ```

2. Write the HTML file using the Write tool with a semantic filename:
   - `/tmp/visual-companion/layout-options.html`
   - `/tmp/visual-companion/nav-wireframe.html`

3. Open in Chrome:
   ```
   mcp__claude-in-chrome__navigate
   url: file:///tmp/visual-companion/layout-options.html
   ```

4. Tell the user what's on screen and ask them to look.

## Reading Selections

After the user interacts with the page, read their selections:

```
mcp__claude-in-chrome__javascript_tool
javascript: |
  JSON.stringify(
    Array.from(document.querySelectorAll('[data-selected="true"]'))
      .map(el => ({
        choice: el.dataset.choice,
        label: el.querySelector('h3')?.textContent || el.dataset.choice
      }))
  )
```

For multi-select containers:

```
mcp__claude-in-chrome__javascript_tool
javascript: |
  JSON.stringify(
    Array.from(document.querySelectorAll('[data-multiselect] [data-selected="true"]'))
      .map(el => ({
        choice: el.dataset.choice,
        label: el.querySelector('h3')?.textContent || el.dataset.choice
      }))
  )
```

## Combining Browser and Terminal Feedback

The terminal message is the primary feedback channel. Browser selections provide structured data. Always merge both:

1. Read browser selections via `javascript_tool`
2. Read the user's terminal message
3. If they conflict, the terminal message takes priority
4. If the user only responded in the terminal (no browser clicks), that's fine — don't ask them to click

## Iteration Flow

When the user wants changes to a visual:

1. Write a new HTML file with a version suffix: `layout-options-v2.html`
2. Navigate to the new file — this replaces the current page
3. Describe what changed
4. Ask for feedback

Never modify an existing file — always create a new version. This keeps a history of iterations.

## Returning to Terminal

When the next question doesn't need the browser, simply tell the user:

> "Continuing in the terminal for the next question."

Don't close the tab or navigate away — the user may want to reference it. The browser just becomes inactive until the next visual question.

## Common Patterns

### Layout Comparison

Show 2-3 layout options as wireframe mockups, each in a card or side-by-side view. Use `.split` for two options, `.cards` for three.

### Component Picker

Show component variations (button styles, form layouts, card designs) as clickable `.option` elements with preview mockups inside each.

### Design Direction

Show full-page mockups as `.card` elements with `.card-image` containing the wireframe and `.card-body` with a name and description.

### Before/After

Use `.split` with two `.mockup` containers labeled "Current" and "Proposed" to show what changes.

### Multi-Select Features

Use `data-multiselect` on the container when the user needs to select which features to include (e.g., "Which of these dashboard widgets should we include?").

## Error Handling

- If Chrome tools aren't available, fall back to text descriptions
- If the user can't see the browser (remote session, etc.), describe the options in text and offer to continue without visuals
- If `navigate` fails on a `file://` URL, check that the file was written successfully
