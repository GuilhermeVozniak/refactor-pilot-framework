# Phase 3: Transform

This is where AI rewrites the code. With insights gathered, tests in place, and a plan approved, you feed AI the original code alongside the refactor plan and let it produce the new version.

## Why This Phase Matters

This is the phase that delivers the 90% time savings. What used to take a senior developer a full day of careful, manual refactoring can be completed in roughly 30 minutes with AI assistance — and the result is often cleaner because AI doesn't get fatigued or cut corners when it's 4pm on a Friday.

## The Workflow

```
Original Code + Refactor Plan + Supporting Files
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Extract    │────▶│   Convert    │────▶│  Restructure │
│   Utilities  │     │   Patterns   │     │   & Document │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                     │
       ▼                    ▼                     ▼
  Shared helpers       Modern patterns       Final refactored
  Type definitions     (hooks, async/await)  code with comments
```

## Step 1: Extract Shared Utilities

Before transforming the main code, pull out reusable logic into dedicated utility files. This makes the main refactoring step cleaner.

**Common extractions:**
- Validation functions (email validation, form rules, data sanitization)
- Formatting utilities (dates, currencies, strings)
- API call wrappers and data transformers
- Constants and configuration values
- Type definitions and interfaces

**Using the prompt:**
Copy `prompts/08-code-transform.md` and set the mode to "extract utilities." Provide the original file(s) and the refactor plan. AI will identify and extract shared logic.

**Review checklist for extracted utilities:**
- [ ] Each utility has a single, clear responsibility
- [ ] Function names are descriptive and follow project conventions
- [ ] Type signatures are complete (no implicit `any` in TypeScript)
- [ ] Edge cases are handled (null, undefined, empty strings, boundary values)
- [ ] No side effects in pure utility functions
- [ ] Exports are properly defined

## Step 2: Convert Legacy Patterns

Apply modern patterns to replace outdated ones. This is where AI shines — it has seen millions of pattern conversions and can apply them consistently.

**Common pattern conversions:**

| Legacy Pattern | Modern Pattern |
|---|---|
| Class components | Functional components with hooks |
| Callbacks and promises | async/await |
| `var` declarations | `const` / `let` |
| jQuery DOM manipulation | React/Vue/Svelte declarative rendering |
| Global state mutation | Context, Redux, Zustand, or signals |
| `!important` CSS overrides | Scoped styles, CSS modules, or Tailwind |
| Manual string concatenation | Template literals |
| Prototype-based inheritance | ES6 classes or composition |
| CommonJS `require` | ESM `import` |
| Mutable data structures | Immutable patterns |

**Using the prompt:**
Copy `prompts/08-code-transform.md` and set the mode to "convert patterns." Provide the original code, the refactor plan, and any extracted utilities from Step 1.

**Review checklist for pattern conversions:**
- [ ] All tests still pass after conversion
- [ ] Public API (props, exports, function signatures) is unchanged or intentionally updated per the plan
- [ ] No new runtime dependencies added without approval
- [ ] Error handling is preserved or improved
- [ ] Performance characteristics are equivalent (no accidental O(n) → O(n²) changes)

## Step 3: Restructure and Document

The final transformation step: reorganize file structure, add documentation, and clean up.

**What happens here:**
- Move files to their new locations per the refactor plan
- Update all import paths
- Add JSDoc / docstrings to exported functions and components
- Add inline comments explaining non-obvious logic
- Remove dead code, unused imports, and commented-out blocks
- Apply consistent formatting

**Using the prompt:**
Copy `prompts/08-code-transform.md` and set the mode to "restructure." Provide the converted code from Step 2 and the refactor plan.

## Executing the Transform

### Approach A: One File at a Time

For small to medium refactors (1-10 files), transform each file individually. Provide AI with:
1. The original file
2. The relevant section of the refactor plan
3. Any extracted utilities it should use
4. Any type definitions it needs

This gives you maximum control and the easiest review process.

### Approach B: Feature-Level Transform

For larger refactors, group files by feature and transform them together. Provide AI with:
1. All files in the feature area
2. The complete refactor plan for that feature
3. Extracted utilities and types
4. Test files (so AI can see expected behavior)

This produces more coherent results because AI can see the full picture, but the output is harder to review.

### Approach C: Iterative Refinement

Transform in multiple passes:
1. First pass: structural changes (extract, reorganize)
2. Second pass: pattern modernization (class → function, var → const)
3. Third pass: documentation and cleanup

Each pass is smaller and easier to review.

## Tips for Phase 3

**Review AI output line by line.** Don't just check if tests pass. Read the code. AI sometimes produces correct but overly complex solutions, or introduces patterns that don't match your team's style.

**Commit after each step.** Extract utilities → commit. Convert patterns → commit. Restructure → commit. This gives you rollback points and a clean git history.

**Watch for hallucinated imports.** AI will sometimes import packages or modules that don't exist. Check every import statement.

**Check for behavior changes.** AI might "improve" logic that was intentionally quirky. If the original code had a specific reason for doing something odd, make sure the refactored version preserves that behavior.

**Don't refactor tests in the same step.** Keep the original tests running against refactored code first. Once everything passes, you can clean up the test code in a separate step.

**Use AI to explain its changes.** If a refactored section looks different from what you expected, ask AI to explain its reasoning. Sometimes it found a better approach; sometimes it misunderstood the requirement.
