# Prompt: Generate File Summary

> **Phase:** 1 — Gather Insights
> **Purpose:** Produce a concise analysis of a single file — its purpose, dependencies, exports, and code quality indicators.
> **Input:** Source code of the file to analyze

## The Prompt

```
Analyze this source file and produce a structured summary:

1. **Purpose** (one sentence)
   What does this file do? What is its primary responsibility?

2. **Exports**
   List everything this file exports (functions, classes, components, constants, types).
   For each export, describe what it does in one line.

3. **Imports & Dependencies**
   - Internal imports (other project files)
   - External imports (npm packages, pip packages, etc.)
   - Note any circular dependency risks

4. **Complexity Indicators**
   - Approximate line count
   - Number of functions/methods
   - Nesting depth (deepest level of indentation)
   - Any functions over 50 lines

5. **Code Smells**
   Identify any of the following if present:
   - Duplicated logic
   - God functions (functions doing too many things)
   - Long parameter lists (>4 parameters)
   - Magic numbers or hardcoded strings
   - Mixed responsibilities (UI + data fetching + business logic in one file)
   - Global variable mutation
   - Commented-out code blocks
   - `// TODO` or `// FIXME` annotations
   - Excessive use of `any` types (TypeScript)
   - `!important` in CSS
   - Deeply nested callbacks or promise chains

6. **Data Flow**
   - Where does this file get its data? (props, API, context, global state)
   - Where does it send data? (callbacks, events, API calls, state updates)
   - Any side effects? (localStorage, cookies, analytics, DOM manipulation)

7. **Refactoring Opportunities**
   Based on the above, suggest 1-3 specific refactoring actions for this file.

Format as a clean, scannable markdown document.

---

FILE: [filename]

[Paste file contents here]
```

## Usage Notes

- Process files in batches of 3-5 for efficient AI usage.
- For very large files (500+ lines), you can ask AI to focus on a specific section.
- Save all file summaries in a single document — they become essential context for Phase 2.
- If a file is particularly complex, also provide its test file (if one exists) for behavioral context.
