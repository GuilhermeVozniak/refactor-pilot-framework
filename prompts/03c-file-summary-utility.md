# Prompt: Analyze Utility / Helper File

> **Phase:** 1 — Gather Insights
> **Purpose:** Specialized analysis for utility functions, helpers, and shared logic files.
> **Input:** Source code of a utility/helper file

## The Prompt

```
Analyze this utility/helper file and produce a structured summary:

1. **File Purpose** (one sentence)
   What category of shared logic does this file provide?

2. **Exported Functions**
   For each exported function:
   - Name and signature (parameters with types, return type)
   - Purpose (one sentence)
   - Is it a pure function? (no side effects, same input → same output)
   - Estimated complexity (simple / moderate / complex)

3. **Dependencies**
   - External packages used (and whether they're heavy or lightweight)
   - Internal file imports
   - Could any external dependency be replaced with native code?

4. **Edge Case Handling**
   - Does it handle null/undefined inputs?
   - Does it validate input types or ranges?
   - What happens with empty strings, empty arrays, zero, NaN?
   - Are error messages descriptive?

5. **Performance Characteristics**
   - Any O(n²) or worse algorithms?
   - Any blocking operations (synchronous I/O, heavy computation)?
   - Candidates for memoization or caching?

6. **Type Safety**
   - Are TypeScript types complete or using `any`?
   - Are function parameters and returns properly typed?
   - Could generics improve reusability?

7. **Code Smells**
   - Functions doing too many things?
   - Duplicated logic between functions?
   - Side effects in functions that should be pure?
   - Magic numbers or hardcoded strings?
   - Functions that are never imported elsewhere (dead code)?

8. **Refactoring Opportunities**
   Suggest 1-3 specific actions (e.g., add types, split large functions,
   remove dead code, improve error handling).

---

FILE: [[FILE_PATH]]

```[[LANG]]
[[FILE_CONTENT]]
```
```
