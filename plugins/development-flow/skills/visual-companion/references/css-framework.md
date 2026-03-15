# Visual Companion CSS Framework

## HTML Template

Every mockup page should use this base template. It provides OS-aware light/dark theming, responsive layout, and all component styles.

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>[Page Title]</title>
  <style>
    /* ===== RESET & BASE ===== */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html { height: 100%; }
    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
      background: var(--bg-primary);
      color: var(--text-primary);
      line-height: 1.5;
      padding: 2rem;
      min-height: 100%;
    }

    /* ===== THEME VARIABLES ===== */
    :root {
      --bg-primary: #f5f5f7;
      --bg-secondary: #ffffff;
      --bg-tertiary: #e5e5e7;
      --border: #d1d1d6;
      --text-primary: #1d1d1f;
      --text-secondary: #86868b;
      --text-tertiary: #aeaeb2;
      --accent: #0071e3;
      --accent-hover: #0077ed;
      --success: #34c759;
      --warning: #ff9f0a;
      --error: #ff3b30;
      --selected-bg: #e8f4fd;
      --selected-border: #0071e3;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg-primary: #1d1d1f;
        --bg-secondary: #2d2d2f;
        --bg-tertiary: #3d3d3f;
        --border: #424245;
        --text-primary: #f5f5f7;
        --text-secondary: #86868b;
        --text-tertiary: #636366;
        --accent: #0a84ff;
        --accent-hover: #409cff;
        --selected-bg: rgba(10, 132, 255, 0.15);
        --selected-border: #0a84ff;
      }
    }

    /* ===== TYPOGRAPHY ===== */
    h2 { font-size: 1.5rem; font-weight: 600; margin-bottom: 0.5rem; }
    h3 { font-size: 1.1rem; font-weight: 600; margin-bottom: 0.25rem; }
    .subtitle { color: var(--text-secondary); margin-bottom: 1.5rem; }
    .section { margin-bottom: 2rem; }
    .label {
      font-size: 0.7rem;
      color: var(--text-secondary);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 0.5rem;
    }

    /* ===== OPTIONS (A/B/C choices) ===== */
    .options { display: flex; flex-direction: column; gap: 0.75rem; }
    .option {
      background: var(--bg-secondary);
      border: 2px solid var(--border);
      border-radius: 12px;
      padding: 1rem 1.25rem;
      cursor: pointer;
      transition: all 0.15s ease;
      display: flex;
      align-items: flex-start;
      gap: 1rem;
    }
    .option:hover { border-color: var(--accent); }
    .option[data-selected="true"] {
      background: var(--selected-bg);
      border-color: var(--selected-border);
    }
    .option .letter {
      background: var(--bg-tertiary);
      color: var(--text-secondary);
      width: 1.75rem; height: 1.75rem;
      border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      font-weight: 600; font-size: 0.85rem; flex-shrink: 0;
    }
    .option[data-selected="true"] .letter {
      background: var(--accent);
      color: white;
    }
    .option .content { flex: 1; }
    .option .content h3 { font-size: 0.95rem; margin-bottom: 0.15rem; }
    .option .content p {
      color: var(--text-secondary);
      font-size: 0.85rem;
      margin: 0;
    }

    /* ===== CARDS (visual designs/mockups) ===== */
    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1rem;
    }
    .card {
      background: var(--bg-secondary);
      border: 1px solid var(--border);
      border-radius: 12px;
      overflow: hidden;
      cursor: pointer;
      transition: all 0.15s ease;
    }
    .card:hover {
      border-color: var(--accent);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .card[data-selected="true"] {
      border-color: var(--selected-border);
      border-width: 2px;
    }
    .card-image {
      background: var(--bg-tertiary);
      aspect-ratio: 16/10;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .card-body { padding: 1rem; }
    .card-body h3 { margin-bottom: 0.25rem; }
    .card-body p { color: var(--text-secondary); font-size: 0.85rem; }

    /* ===== MOCKUP CONTAINER ===== */
    .mockup {
      background: var(--bg-secondary);
      border: 1px solid var(--border);
      border-radius: 12px;
      overflow: hidden;
      margin-bottom: 1.5rem;
    }
    .mockup-header {
      background: var(--bg-tertiary);
      padding: 0.5rem 1rem;
      font-size: 0.75rem;
      color: var(--text-secondary);
      border-bottom: 1px solid var(--border);
    }
    .mockup-body { padding: 1.5rem; }

    /* ===== SPLIT VIEW (side-by-side comparison) ===== */
    .split {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1.5rem;
    }
    @media (max-width: 700px) {
      .split { grid-template-columns: 1fr; }
    }

    /* ===== PROS/CONS ===== */
    .pros-cons {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin: 1rem 0;
    }
    .pros, .cons {
      background: var(--bg-secondary);
      border-radius: 8px;
      padding: 1rem;
    }
    .pros h4 { color: var(--success); font-size: 0.85rem; margin-bottom: 0.5rem; }
    .cons h4 { color: var(--error); font-size: 0.85rem; margin-bottom: 0.5rem; }
    .pros ul, .cons ul {
      margin-left: 1.25rem;
      font-size: 0.85rem;
      color: var(--text-secondary);
    }
    .pros li, .cons li { margin-bottom: 0.25rem; }

    /* ===== PLACEHOLDER (wireframe areas) ===== */
    .placeholder {
      background: var(--bg-tertiary);
      border: 2px dashed var(--border);
      border-radius: 8px;
      padding: 2rem;
      text-align: center;
      color: var(--text-tertiary);
    }

    /* ===== MOCK WIREFRAME ELEMENTS ===== */
    .mock-nav {
      background: var(--accent);
      color: white;
      padding: 0.75rem 1rem;
      display: flex;
      gap: 1.5rem;
      font-size: 0.9rem;
    }
    .mock-sidebar {
      background: var(--bg-tertiary);
      padding: 1rem;
      min-width: 180px;
    }
    .mock-content { padding: 1.5rem; flex: 1; }
    .mock-button {
      background: var(--accent);
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 6px;
      font-size: 0.85rem;
      cursor: pointer;
    }
    .mock-input {
      background: var(--bg-primary);
      border: 1px solid var(--border);
      border-radius: 6px;
      padding: 0.5rem;
      width: 100%;
      color: var(--text-primary);
    }
  </style>
</head>
<body>
  <!-- Your content here -->

  <script>
    // Selection tracking
    function toggleSelect(el) {
      const container = el.closest('.options') || el.closest('.cards');
      const multi = container && container.dataset.multiselect !== undefined;

      if (container && !multi) {
        container.querySelectorAll('.option, .card').forEach(o => {
          o.dataset.selected = 'false';
        });
      }

      el.dataset.selected = el.dataset.selected === 'true' ? 'false' : 'true';
    }

    // Attach click handlers to all selectable elements
    document.querySelectorAll('.option, .card').forEach(el => {
      el.addEventListener('click', () => toggleSelect(el));
    });
  </script>
</body>
</html>
```

## Component Patterns

### A/B/C Choice Options

For presenting 2-4 named approaches or designs:

```html
<h2>Which layout works better?</h2>
<p class="subtitle">Consider readability and visual hierarchy</p>

<div class="options">
  <div class="option" data-choice="a" data-selected="false">
    <div class="letter">A</div>
    <div class="content">
      <h3>Single Column</h3>
      <p>Clean, focused reading experience with centered content</p>
    </div>
  </div>
  <div class="option" data-choice="b" data-selected="false">
    <div class="letter">B</div>
    <div class="content">
      <h3>Two Column</h3>
      <p>Sidebar navigation with main content area</p>
    </div>
  </div>
</div>
```

### Multi-Select Options

Add `data-multiselect` to the container to allow selecting multiple items:

```html
<div class="options" data-multiselect>
  <!-- same option markup — users can select/deselect multiple -->
</div>
```

### Visual Design Cards

For showing mockups or design variations with preview images:

```html
<div class="cards">
  <div class="card" data-choice="minimal" data-selected="false">
    <div class="card-image">
      <!-- mockup content or placeholder -->
      <div class="placeholder">Preview</div>
    </div>
    <div class="card-body">
      <h3>Minimal</h3>
      <p>Clean white space, typography-focused</p>
    </div>
  </div>
</div>
```

### Wireframe Mockup

For showing a UI layout with labeled regions:

```html
<div class="mockup">
  <div class="mockup-header">Preview: Dashboard Layout</div>
  <div class="mockup-body">
    <div class="mock-nav">Logo | Home | Settings | Profile</div>
    <div style="display: flex;">
      <div class="mock-sidebar">
        <p><strong>Navigation</strong></p>
        <p>Dashboard</p>
        <p>Reports</p>
        <p>Settings</p>
      </div>
      <div class="mock-content">
        <h3>Main Content Area</h3>
        <p>Data tables, charts, and widgets go here</p>
        <div class="placeholder" style="margin-top: 1rem;">Chart Area</div>
      </div>
    </div>
  </div>
</div>
```

### Side-by-Side Comparison

For comparing two designs or approaches visually:

```html
<div class="split">
  <div class="mockup">
    <div class="mockup-header">Option A: Tabs</div>
    <div class="mockup-body"><!-- mockup content --></div>
  </div>
  <div class="mockup">
    <div class="mockup-header">Option B: Accordion</div>
    <div class="mockup-body"><!-- mockup content --></div>
  </div>
</div>
```

### Trade-offs Display

For showing pros and cons alongside a design:

```html
<div class="pros-cons">
  <div class="pros">
    <h4>Pros</h4>
    <ul>
      <li>Familiar pattern</li>
      <li>Works well on mobile</li>
    </ul>
  </div>
  <div class="cons">
    <h4>Cons</h4>
    <ul>
      <li>Limited to ~5 tabs before scrolling</li>
      <li>Harder to show nested hierarchy</li>
    </ul>
  </div>
</div>
```

## Design Guidelines

- **Scale fidelity to the question** — wireframes for layout, polish for polish
- **2-4 options max** per screen — too many causes decision paralysis
- **Explain the question on each page** — use `h2` for the question, `.subtitle` for context
- **Use real content when it matters** — placeholder text can obscure layout issues caused by real-world content length
- **Keep it self-contained** — no external dependencies, images via data URIs or CSS if needed
