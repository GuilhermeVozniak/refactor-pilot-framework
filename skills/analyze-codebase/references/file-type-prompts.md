# File-Type-Specific Analysis Prompts

Use these specialized analysis templates for deeper insights depending on the file type.

## UI Components (React, Vue, Svelte, etc.)

Analyze for:
- Props/inputs: types, required vs. optional, default values
- Internal state: useState, class state, reactive variables
- Rendering logic: conditional rendering, list rendering, fragments
- Side effects: useEffect, lifecycle methods, subscriptions, timers
- Event handlers: user interactions, callbacks to parent
- Styling approach: inline, CSS modules, styled-components, Tailwind
- Accessibility: ARIA attributes, semantic HTML, keyboard navigation
- Code smells: mixed concerns, prop drilling, excessive re-renders

## Configuration Files (tsconfig, webpack, vite, etc.)

Analyze for:
- Build/compiler flags that constrain or enable refactoring
- Module format (CommonJS vs. ESM) and its implications
- Target environment and syntax constraints
- Path aliases and module resolution
- Tree shaking and dead code elimination settings
- Source maps and debugging configuration
- Dependency on specific tool versions

## Utility/Helper Files

Analyze for:
- Function signatures (params, return types, generics)
- Purity: side effects, same input → same output
- Edge case handling: null, undefined, empty, boundary values
- Performance: O(n²) algorithms, blocking operations, memoization candidates
- Type safety: any usage, incomplete types, generic opportunities
- Dead code: functions never imported elsewhere

## Stylesheets (CSS, SCSS, Less)

Analyze for:
- Selector specificity and nesting depth
- !important declarations (count and locations)
- Layout patterns: Flexbox, Grid, float, position
- Responsive breakpoints and media queries
- Design token usage vs. hardcoded values
- Duplicated property groups
- Dead selectors targeting non-existent elements
