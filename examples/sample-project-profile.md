# Example: Project Profile Output

> This is a sample output from Phase 1 (Gather Insights) to illustrate what a complete project profile looks like. Use it as a reference for the quality and detail level to aim for.

## Executive Overview

This is a React-based e-commerce dashboard built with TypeScript. It was originally a proof-of-concept from 2021 that became the production admin panel. The codebase has 47 components, 12 utility files, and no test coverage. It uses class components, global CSS with 187 `!important` declarations, and a mix of REST and GraphQL for data fetching.

**Tech Stack:** React 17.0.2 / TypeScript 4.5 / Webpack 5 / Redux (legacy) / Styled with global CSS

**Size:** ~15,000 lines of source code across 73 files

## Architecture

The project follows a loose feature-based organization, but boundaries between features are blurred. Several components reach directly into other feature directories for shared state.

```
src/
├── components/         # 28 UI components (mixed concerns)
├── pages/              # 8 page-level components
├── redux/              # 5 Redux slices (legacy patterns)
├── services/           # 3 API client files
├── utils/              # 12 utility files
├── styles/             # 4 global CSS files (2,400 lines total)
└── types/              # 2 type definition files (incomplete)
```

## Dependency Health

- **React 17.0.2** — Two major versions behind (current: 19.x). Blocks use of concurrent features, server components, and modern hooks.
- **Redux 4.1** — Uses legacy `connect()` pattern instead of Redux Toolkit. Significant boilerplate.
- **moment.js** — Deprecated. Used in 14 files. Should migrate to `date-fns` or `dayjs`.
- **lodash (full)** — Entire library imported for 3 functions. Should use individual imports or native alternatives.

## Refactoring Priority Map

| Priority | Area | Issue | Impact | Effort |
|----------|------|-------|--------|--------|
| 1 | Global CSS | 187 `!important`, styling leaks | High — blocks all UI work | Large |
| 2 | Class components | 19 class components with lifecycle methods | Medium — blocks React upgrade | Medium |
| 3 | Redux store | Legacy connect() pattern, no Redux Toolkit | Medium — excessive boilerplate | Medium |
| 4 | moment.js → date-fns | Deprecated dependency, large bundle | Low — works but increases bundle | Small |
| 5 | Test coverage | 0% coverage, no test infrastructure | High — blocks safe refactoring | Large |

## Risks

- The `OrderProcessor` component has 847 lines and handles payment, inventory, and email notifications. Refactoring this is the highest-risk change.
- Three components use `window.globalState` for cross-component communication. This pattern needs to be mapped before any state management changes.
- The CSS files have cascade dependencies — changing one style can break components in seemingly unrelated areas.
