# Prompt: Transform Code

> **Phase:** 3 — Transform
> **Purpose:** AI rewrites code according to the refactor plan. Three modes: extract utilities, convert patterns, restructure.
> **Input:** Original code + refactor plan + supporting files

## Mode 1: Extract Utilities

```
Extract shared utility functions from the source code below, following
the refactor plan.

For each extracted utility:
- Create a standalone function with a clear name and purpose
- Add complete TypeScript types (or type hints for Python, etc.)
- Handle edge cases (null, undefined, empty values, boundary values)
- Add a JSDoc/docstring comment explaining the function
- Ensure the function is pure (no side effects) where possible
- Export it as a named export

After extraction, show the updated original file with the utility calls
replacing the inline logic.

IMPORTANT:
- The original file must work exactly the same after extraction
- All existing tests must still pass
- Do not change any public API or interface

---

REFACTOR PLAN:
[Paste the relevant section of the refactor plan]

SOURCE CODE:
[Paste the original file]

SUPPORTING FILES (types, related utilities):
[Paste any files the utilities need to reference]
```

## Mode 2: Convert Patterns

```
Convert the source code below from legacy patterns to modern patterns,
following the refactor plan.

Conversions to apply:
[List the specific conversions from the refactor plan, e.g.:]
- Class component → Functional component with hooks
- Lifecycle methods → useEffect, useMemo, useCallback
- this.state / this.setState → useState
- this.props → destructured props parameter
- Callbacks → async/await
- var → const/let
- String concatenation → template literals

Requirements:
- Preserve ALL existing behavior exactly
- Preserve ALL error handling
- Preserve ALL side effects (API calls, events, storage)
- Do NOT change the component's public API (props, exports)
- Do NOT add new dependencies without noting them
- Add inline comments for any non-obvious transformation choices

After conversion, provide:
1. The converted code
2. A change summary listing every transformation applied
3. Any areas that need manual review (marked with // REVIEW comments)

---

REFACTOR PLAN:
[Paste the relevant section]

SOURCE CODE:
[Paste the original file]

EXTRACTED UTILITIES (from Mode 1):
[Paste any utilities extracted in the previous step]

TYPE DEFINITIONS:
[Paste relevant type files]
```

## Mode 3: Restructure and Document

```
Restructure the refactored code below according to the target file structure
in the refactor plan, and add documentation.

Tasks:
1. Organize files into the target directory structure
2. Update all import paths to reflect the new locations
3. Add JSDoc/docstrings to every exported function, class, and component
4. Add inline comments explaining non-obvious logic
5. Remove all dead code (unused imports, unreachable branches, commented-out blocks)
6. Remove all TODO/FIXME comments that have been addressed by the refactoring
7. Apply consistent formatting

For each file in the output, provide:
- The file path (relative to project root)
- The complete file contents
- A one-line summary of what changed

IMPORTANT:
- Do NOT change any logic or behavior in this step
- This step is purely organizational and documentation
- All tests must continue to pass unchanged

---

REFACTOR PLAN (target structure section):
[Paste the target structure from the refactor plan]

REFACTORED CODE (from Mode 2):
[Paste all refactored files]

PROJECT CONVENTIONS:
[Describe import style, file naming, documentation format, etc.]
```

## Usage Notes

- Execute modes in order: Extract → Convert → Restructure.
- Commit after each mode. This gives you clean rollback points.
- If the AI output is very large, process one file at a time.
- Always run tests between modes to catch issues early.
- For the Convert mode, be explicit about which patterns to convert. Vague instructions lead to unexpected changes.
