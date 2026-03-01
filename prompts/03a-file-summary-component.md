# Prompt: Analyze Component File

> **Phase:** 1 — Gather Insights
> **Purpose:** Specialized analysis for UI component files (React, Vue, Svelte, Angular).
> **Input:** Source code of a component file (.tsx, .jsx, .vue, .svelte)

## The Prompt

```
Analyze this UI component file and produce a structured summary:

1. **Component Purpose** (one sentence)
   What does this component render? What user-facing feature does it represent?

2. **Component Type**
   - Functional or class component?
   - Uses hooks? Which ones? (useState, useEffect, useMemo, custom hooks)
   - Connected to state management? (Redux, Zustand, Context, Vuex, etc.)

3. **Props / Inputs**
   For each prop:
   - Name, type, required/optional, default value
   - What does it control?
   List callback props separately (onSubmit, onChange, onClick, etc.)

4. **Internal State**
   - What state does the component manage locally?
   - Any derived state or computed values?
   - State that should arguably be lifted to a parent or store?

5. **Rendering Logic**
   - Conditional rendering branches (loading, error, empty, success states)
   - List rendering (map over arrays)
   - Child components used (and what props they receive)

6. **Side Effects**
   - API calls (what endpoints, when triggered)
   - Subscriptions (event listeners, WebSocket, intervals)
   - DOM manipulation outside React/Vue lifecycle
   - Analytics or logging events

7. **Styling Approach**
   - CSS modules, styled-components, Tailwind, inline styles, global CSS?
   - Any !important overrides?
   - Scoped or leaking styles?

8. **Code Smells**
   - Component doing too many things (mixed data fetching + rendering + business logic)?
   - Prop drilling (passing props through many layers)?
   - Inline functions in render (performance concern)?
   - Missing memoization for expensive computations?
   - Hardcoded values that should be props or constants?
   - Missing error boundaries?

9. **Refactoring Opportunities**
   Suggest 1-3 specific actions (e.g., extract custom hook, split into sub-components,
   convert class to function, add TypeScript types).

---

FILE: [[FILE_PATH]]

```[[LANG]]
[[FILE_CONTENT]]
```
```

## Script Integration

Scripts can replace the `[[PLACEHOLDERS]]` with actual values:
- `[[FILE_PATH]]` — relative path to the file
- `[[LANG]]` — language identifier for syntax highlighting (tsx, jsx, vue, svelte)
- `[[FILE_CONTENT]]` — raw file contents
