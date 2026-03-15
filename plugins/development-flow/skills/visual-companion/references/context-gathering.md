# Context Gathering

Before generating mockups, scan the codebase to understand the existing UI. This runs once when the visual companion is first activated in a session. The output is a **design context** used to generate mockups that match the existing app.

## Step 1: Find the Design Token Source

Search for the theme/token source of truth. Check in priority order — stop at the first match:

### Tailwind CSS
```
Glob: **/tailwind.config.{js,ts,mjs,cjs}
```
Extract: colors, spacing, borderRadius, fontFamily, fontSize, screens (breakpoints).

### CSS Custom Properties
```
Grep: :root\s*\{
Glob: **/*.css
```
Extract: all `--` prefixed variables, especially colors, spacing, font values.

### MUI (Material UI)
```
Grep: createTheme\(
Glob: **/*.{ts,tsx,js,jsx}
```
Extract: palette, typography, spacing, shape.borderRadius, components overrides.

### Chakra UI
```
Grep: extendTheme\(
Glob: **/*.{ts,tsx,js,jsx}
```
Extract: colors, fonts, space, radii, components.

### Styled-Components / Emotion Theme
```
Grep: ThemeProvider
Glob: **/*.{ts,tsx,js,jsx}
```
Follow the `theme=` prop to find the theme object. Extract colors, fonts, spacing.

### Generic Token Files
```
Glob: **/tokens.{json,ts,js}
Glob: **/theme.{ts,js,tsx,jsx}
Glob: **/theme/index.{ts,js}
Glob: **/design-tokens.{json,ts,js}
Glob: **/styles/variables.{css,scss,less}
```

## Step 2: Component Inventory

Scan for existing UI components. Focus on layout and interactive components — these are what matter for wireframes.

### Find Component Directories
```
Glob: **/components/**/index.{ts,tsx,js,jsx}
Glob: **/components/**/*.{tsx,jsx}
Glob: **/ui/**/*.{tsx,jsx}
```

### Categorize Components

Group discovered components into these categories:

| Category | Examples | Why It Matters |
|----------|----------|----------------|
| Layout | Sidebar, Header, Footer, Layout, Container, Grid, Stack | Defines page structure in mockups |
| Navigation | Nav, Menu, Breadcrumb, Tabs, Link | How users move between sections |
| Data Display | Table, DataGrid, Card, List, Badge, Avatar | How data is presented |
| Input | Form, Input, Select, Checkbox, Button, DatePicker | Interactive elements |
| Feedback | Modal, Dialog, Toast, Alert, Spinner, Progress | System responses |
| Overlay | Drawer, Popover, Tooltip, Dropdown | Layered UI elements |

### Extract Component Signatures

For each component found, capture:
- Component name
- Key props (from TypeScript interface/type, or PropTypes)
- Whether it's a wrapper/layout component or a leaf component

Use grep patterns:
```
Grep: export (default )?(function|const) [A-Z]
Glob: **/*.{tsx,jsx}
```

For TypeScript props:
```
Grep: (interface|type) \w+Props
Glob: **/*.{ts,tsx}
```

## Step 3: Build the Design Context

Compile findings into a design context object. This is not written to a file — it's held in conversation context and used when generating mockups.

### Design Context Structure

```
## Design Context

### Token Source
- Type: [tailwind | css-variables | mui | chakra | styled-components | custom]
- Location: [file path]

### Color Palette
- Primary: [value]
- Secondary: [value]
- Background: [value]
- Surface: [value]
- Text primary: [value]
- Text secondary: [value]
- Border: [value]
- Error/Success/Warning: [values]

### Typography
- Font family: [value]
- Heading sizes: [values]
- Body size: [value]

### Spacing & Shape
- Base unit: [value, e.g., 4px or 0.25rem]
- Border radius: [value]
- Common spacing values: [values]

### Existing Components
- Layout: [list]
- Navigation: [list]
- Data Display: [list]
- Input: [list]
- Feedback: [list]

### Key Patterns
- [Notable patterns, e.g., "all pages use <AppLayout> with <Sidebar>"]
- [e.g., "data tables use <DataGrid> from MUI"]
- [e.g., "forms use react-hook-form with <FormField> wrapper"]
```

## Step 4: Apply to Mockups

When generating HTML mockups, replace the default CSS variables with the extracted tokens:

```css
:root {
  /* Replace these with actual values from the design context */
  --bg-primary: [extracted background];
  --bg-secondary: [extracted surface];
  --text-primary: [extracted text color];
  --accent: [extracted primary color];
  /* ... etc */
}
```

When building wireframes:
- Use component names from the inventory in labels (e.g., label a region "&lt;Sidebar&gt;" not "sidebar area")
- Mirror the existing layout structure (if the app uses a sidebar layout, don't mockup a top-nav layout unless proposing a change)
- Reference existing components in descriptions ("this would use your existing DataGrid component")

## When Context Gathering Fails

If no theme source or components are found (e.g., new project, non-standard structure):
- Use the default CSS framework as-is
- Note in the conversation that mockups use generic styling
- Ask the user if there are specific colors, fonts, or patterns to match
