# Phase 2: Prepare & Create Safety Nets

This phase is about building the guardrails that let you refactor with confidence. You generate tests that lock down current behavior and create a detailed refactoring plan before touching any production code.

## Why This Phase Matters

Refactoring without tests is a gamble. If you don't know what the code is supposed to do, you can't know if your changes broke it. AI can generate tests much faster than you can write them manually — but you still need to review them.

## The Workflow

```
Phase 1 Outputs (codebase profile)
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Generate    │────▶│  Generate    │────▶│   Build      │
│  Test Plan   │     │  Test Code   │     │  Refactor    │
└──────────────┘     └──────────────┘     │  Plan        │
                                          └──────────────┘
```

## Step 1: Generate a Test Plan

Before writing any test code, produce a test plan that identifies what needs to be tested and why.

**The test plan should cover:**
- Component behavior (what each component renders, how it responds to user input)
- Edge cases (empty states, error states, boundary values, missing data)
- Integration points (API calls, shared state, event buses, context providers)
- Data transformations (utilities that process data, formatters, validators)
- Side effects (localStorage, cookies, analytics, external service calls)

**Using the prompt:**
Copy `prompts/05-test-plan.md` and include the Phase 1 outputs (file summaries and project summary) as context.

**Expected output:**
A structured document listing every test scenario, grouped by component or module, with expected behavior and priority level.

**Example test plan entry:**
```
Component: UserProfileCard
├── Renders user name and avatar when data is provided
├── Shows placeholder avatar when image URL is missing
├── Truncates long names to 30 characters with ellipsis
├── Calls onEdit callback when edit button is clicked
├── Disables edit button when isReadOnly prop is true
└── Handles null user object without crashing
```

## Step 2: Generate Test Code

With the test plan as a guide, have AI generate the actual test files.

**Using the prompt:**
Copy `prompts/06-test-generation.md`, include the test plan and the source file to be tested, and let AI produce the test code.

**Important guidelines for AI-generated tests:**

- **Review every test.** AI will sometimes test implementation details instead of behavior, or write tests that pass trivially.
- **Run the tests immediately.** If they don't pass against the current (un-refactored) code, they're wrong. Fix or discard them.
- **Check assertions.** Make sure tests are actually asserting something meaningful, not just checking that the component renders without crashing.
- **Look for missing scenarios.** Compare generated tests against the test plan. AI will sometimes skip edge cases.
- **Avoid snapshot tests for behavior.** Snapshots are brittle during refactoring. Prefer explicit assertions on rendered output and behavior.

**Test frameworks by ecosystem:**
- JavaScript/TypeScript: Jest, Vitest, React Testing Library, Playwright
- Python: pytest, unittest
- Go: built-in `testing` package
- Rust: built-in `#[cfg(test)]`
- Java: JUnit, Mockito

## Step 3: Build the Refactor Plan

This is the blueprint for Phase 3. A well-constructed refactor plan tells AI (and your team) exactly what changes to make and in what order.

**Using the prompt:**
Copy `prompts/07-refactor-plan.md`, include the Phase 1 outputs and the source code of the target area, and let AI produce the plan.

**A good refactor plan includes:**

1. **Goal statement** — What does this refactor achieve? (e.g., "Convert UserProfile from class component to functional component with hooks")
2. **New structure** — What will the file/directory structure look like after refactoring?
3. **Step-by-step changes** — Ordered list of discrete changes, each small enough to be a single commit:
   - Step 1: Extract validation logic into `utils/validateUser.ts`
   - Step 2: Create `useUserProfile` custom hook
   - Step 3: Convert `UserProfile` class to function component using the hook
   - Step 4: Update imports in consuming components
   - Step 5: Remove deprecated class component
4. **New utilities or types** — Any shared code that will be extracted
5. **Breaking changes** — Any changes to public APIs or interfaces
6. **Dependencies** — New packages needed (or old ones to remove)
7. **Risk areas** — Parts of the refactor that need extra attention

**Review the plan before proceeding.** This is the last checkpoint before AI starts rewriting code. Make sure the plan matches your team's coding standards, architectural preferences, and priorities.

## Tips for Phase 2

**Don't skip test generation.** It's tempting to go straight to refactoring. Don't. Tests are your safety net. They're what let you move fast without breaking things.

**Test behavior, not implementation.** Tests that assert on internal state or method calls will break the moment you refactor. Test what the user sees and what the public API returns.

**Keep refactor plans incremental.** Big-bang refactors are risky. Break the plan into steps that can each be committed, tested, and reviewed independently.

**Get team buy-in on the plan.** If you're working on a team, share the refactor plan before executing it. This is a great use of a pull request with just the plan document.

**Save the test plan and refactor plan.** These documents are valuable artifacts. They explain the "why" behind changes and help future developers understand the refactoring decisions.
