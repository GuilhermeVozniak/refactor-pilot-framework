# Phase 3: Transform

This is where AI rewrites the code. With insights gathered, tests in place, and a plan approved, you feed AI the original code alongside the refactor plan and let it produce the new version.

## Why This Phase Matters

This is the phase that delivers the biggest time savings. Tasks that would normally take a developer hours of careful, repetitive editing — renaming patterns across dozens of files, converting syntax, extracting shared logic — can be completed in minutes with AI assistance. And unlike a human on hour six of a refactoring marathon, AI applies the same level of attention to the last file as it does to the first.

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

### Approach D: Cross-Language Migration

When the goal is to move code from one language to another — Python 2 to Python 3, JavaScript to TypeScript, C to Rust, Java to Kotlin — the process requires extra steps beyond a normal refactor.

**Step 1: Understand the source.** Before any migration, ask AI to explain the original code thoroughly. Pay attention to language-specific features that don't have a direct equivalent in the target: preprocessor directives, unsafe memory operations, dynamic typing patterns, implicit conversions, or platform-specific APIs.

**Step 2: Identify migration risks.** Ask AI to list potential problems with the migration. This typically surfaces deprecated APIs, platform-specific behavior, unsafe constructs, and idioms that translate poorly. The video demo of C→Rust migration found that certain constants weren't available on macOS and that unsafe blocks were required for Windows API calls — these are the kinds of issues you want surfaced before writing any code.

**Step 3: Migrate and iterate.** The first generated version rarely compiles or runs cleanly. Expect multiple passes:
1. Initial migration → compile/build → fix errors from missing dependencies, unavailable APIs, or type mismatches
2. Safety and idiom pass → replace non-idiomatic code with target-language best practices (e.g., replace raw pointers with safe abstractions, replace dynamic types with proper type annotations)
3. Error handling pass → add proper error handling using target-language patterns (e.g., Rust's `Result` type, TypeScript's strict null checks, Python 3's exception chaining)

**Step 4: Test on all target platforms.** Cross-language migrations often involve cross-platform code. Build and test on every platform the code supports — don't assume that compiling on one OS means it works everywhere.

**Branch strategy for migrations:** Create a dedicated branch for the migration (e.g., `migrate/js-to-ts` or `refactor/py2-to-py3`). Keep the original code available on `main` until the migration is validated. See the branch-per-solution strategy in [Best Practices](best-practices.md#branch-per-solution) for the full workflow.

## Tips for Phase 3

**Review AI output line by line.** Don't just check if tests pass. Read the code. AI sometimes produces correct but overly complex solutions, or introduces patterns that don't match your team's style.

**Commit after each step.** Extract utilities → commit. Convert patterns → commit. Restructure → commit. This gives you rollback points and a clean git history.

**Watch for hallucinated imports.** AI will sometimes import packages or modules that don't exist. Check every import statement.

**Check for behavior changes.** AI might "improve" logic that was intentionally quirky. If the original code had a specific reason for doing something odd, make sure the refactored version preserves that behavior.

**Don't refactor tests in the same step.** Keep the original tests running against refactored code first. Once everything passes, you can clean up the test code in a separate step.

**Use AI to explain its changes.** If a refactored section looks different from what you expected, ask AI to explain its reasoning. Sometimes it found a better approach; sometimes it misunderstood the requirement.

**Try multiple approaches in parallel branches.** When a refactoring task has more than one reasonable approach, create a branch for each (e.g., `solution/approach-a`, `solution/approach-b`), implement both with AI, run tests and benchmarks, then merge the winner. AI makes each attempt fast and cheap. See [Best Practices](best-practices.md#branch-per-solution) for the full workflow.

## The "Explain Your Decisions" Pattern

When reviewing AI-generated refactored code, ask AI to explain every significant decision it made. This surfaces misunderstandings early and creates documentation for future developers.

**After each transformation pass, prompt:**
```
For the refactored code you just produced, explain:

1. Every structural decision you made and why
2. Any places where you changed behavior (even subtly) and the reasoning
3. Any alternative approaches you considered and why you chose this one
4. Any assumptions you made about the codebase or requirements
5. Areas where you are least confident about the change
```

**Why this matters:**

AI models are good at generating plausible code but may not always understand the deeper context. By asking them to explain their reasoning, you catch cases where the model:

- Misinterpreted a business rule as a bug and "fixed" it
- Made assumptions about concurrent access, caching, or state management
- Chose a pattern that conflicts with your team's conventions
- Over-simplified error handling that was complex for a reason

Save the explanations alongside your refactoring notes. They become valuable documentation for code reviewers and future maintainers.

**Example workflow:**
1. AI produces refactored `UserProfile.tsx`
2. You review and spot a change in how null users are handled
3. You ask AI to explain
4. AI reveals it assumed null users were an error case, but in your app they represent anonymous sessions
5. You catch the bug before it reaches production
