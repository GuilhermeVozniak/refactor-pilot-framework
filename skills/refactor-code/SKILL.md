---
name: refactor-code
description: >
  Use this skill whenever the user wants to actually refactor, rewrite, modernize, or
  transform existing code. Triggers include: "refactor this", "rewrite this code",
  "convert to hooks", "modernize this", "extract utilities", "clean up this code",
  "apply the refactor plan", "transform this module", or any request to change code structure
  while preserving behavior. Also triggers for pattern conversions like "convert class to
  function", "switch to async/await", "extract shared logic", or "restructure this module".
  Do NOT use for analysis-only tasks — use analyze-codebase for those.
  Do NOT use for generating tests — use generate-tests for that.
---

# Refactor Code Skill

You are performing Phase 3 (Transform) of the Refactor Pilot framework. Your job is to
rewrite code according to a refactoring plan while preserving existing behavior.

## Prerequisites

- Phase 1 analysis should exist (`refactor-notes/04-project-summary.md`)
- Phase 2 tests and plan should exist (`refactor-notes/06-refactor-plan.md`)
- If these don't exist, ask the user if they want to proceed without them (riskier) or
  run the prerequisite phases first

## Workflow

Execute the refactoring in three passes. Commit after each pass.

### Pass 1: Extract Utilities

Read the refactor plan and identify all shared logic to extract.

For each extraction:
- Create a standalone function with clear naming
- Add complete type annotations
- Handle edge cases (null, undefined, empty, boundary)
- Add JSDoc/docstring documentation
- Ensure the function is pure where possible
- Update the original file to use the extracted utility

**Verification:** Run tests after extraction. All must pass.

### Pass 2: Convert Patterns

Apply modern pattern conversions as specified in the refactor plan:

Common conversions:
- Class components → Functional components with hooks
- Lifecycle methods → useEffect, useMemo, useCallback
- Callbacks/promises → async/await
- var → const/let
- Global state mutation → Modern state management
- !important CSS → Scoped styles
- CommonJS require → ESM import
- Mutable patterns → Immutable patterns

For each conversion:
- Preserve ALL existing behavior
- Preserve ALL error handling
- Preserve ALL side effects
- Do NOT change public APIs without explicit plan approval
- Add `// REVIEW` comments where manual verification is needed

**Verification:** Run tests after conversion. All must pass.

### Pass 3: Restructure and Document

- Move files to target locations per the refactor plan
- Update all import paths
- Add documentation to all exports
- Remove dead code, unused imports, commented-out blocks
- Apply consistent formatting

**Verification:** Run tests after restructuring. All must pass.

## Output

After each pass, present:
1. Summary of changes made
2. Test results
3. Any areas flagged for manual review

After all passes, provide:
1. Complete list of files changed, created, and deleted
2. Summary of all transformations applied
3. Any remaining `// REVIEW` comments that need human attention

## Critical Rules

- **Never change behavior.** The refactored code must do exactly what the original did.
- **Commit after each pass.** This gives rollback points.
- **Run tests between passes.** Catch issues early.
- **Flag uncertainty.** If you're unsure about a transformation, add a `// REVIEW` comment.
- **Watch for hallucinated imports.** Verify every import statement.
- **Don't refactor tests.** Keep original tests running against new code. Clean up tests later.
