---
name: generate-tests
description: >
  Use this skill whenever the user wants to generate tests before refactoring, create a test
  plan, add safety net tests, lock down behavior with tests, or generate test code for
  existing modules. Triggers include: "generate tests", "create test plan", "add tests before
  refactoring", "write tests for this", "I need safety net tests", "test this module",
  "lock down behavior", or any request to add tests in preparation for code changes.
  Also use when the user asks to "prepare for refactoring" and needs the testing phase.
  Do NOT use for running tests or verifying test results — use verify-changes for that.
---

# Generate Tests Skill

You are performing Phase 2 (Prepare & Create Safety Nets) of the Refactor Pilot Framework.
Your job is to generate tests that lock down current behavior and build a refactoring plan.

## Quick Decision Tree

```
Does refactor-notes/ exist with Phase 1 outputs?
├── NO → Suggest running analyze-codebase first
└── YES → Continue

Does refactor-notes/00-requirements.md exist?
├── NO → Start with Step 1 (Define Requirements)
└── YES → Skip to Step 2

Does the project have existing tests?
├── YES → Run coverage analysis, focus on gaps
└── NO → Generate safety net tests for everything in scope

What testing framework does the project use?
├── Jest/Vitest → Use describe/it/expect patterns
├── pytest → Use test_ functions with assert
├── Go testing → Use Test* functions with t.Error
└── None configured → Recommend one based on stack
```

## Prerequisites

Phase 1 analysis should be complete. If `refactor-notes/` does not exist, suggest running
the `analyze-codebase` skill first.

## Workflow

### Step 1: Define Requirements (if not done)

If `refactor-notes/00-requirements.md` doesn't exist, help the user define:
- Refactoring goals and success criteria
- Hard constraints (what can't change)
- Coding standards for the refactored code
- Scope (what's in, what's out)

Save as `refactor-notes/00-requirements.md`.

### Step 2: Generate Test Plan

For the target module or file, produce a test plan covering:

- **Behavior tests**: What each export does with valid input
- **Edge cases**: Empty, null, undefined, boundary values, special characters
- **Integration points**: API calls, shared state, event handlers
- **Side effects**: Storage, cookies, analytics, DOM manipulation
- **Error handling**: Thrown errors, caught errors, error states

Format as a nested list with priority levels (Critical / Important / Nice to have).

Present the test plan to the user for review before generating code.

### Step 3: Generate Test Code

After the user approves the plan, generate test files:

**Detect the testing framework** from the project:
- Look for `jest.config.*`, `vitest.config.*`, `pytest.ini`, `conftest.py`, etc.
- Check `package.json` or `pyproject.toml` for test dependencies
- If no framework is configured, recommend one based on the project's stack

**Generate tests that:**
- Test behavior, not implementation details
- Use descriptive test names that explain the scenario
- Group related tests in describe/context blocks
- Mock external dependencies
- Handle async operations correctly
- Include meaningful assertions (not just "doesn't crash")

**DO NOT:**
- Generate snapshot tests (they break during refactoring)
- Test private methods or internal state
- Generate tests that won't pass against the current code
- Use implementation-specific selectors (prefer role-based or text-based)

### Step 3b: Verify Tests Pass

Run the generated tests against the current (un-refactored) code. Fix any failures.
Tests MUST pass before proceeding.

### Step 4: Refine Scope

Based on test coverage results, refine the refactoring scope:
- Which areas are now safe to refactor (good coverage)?
- Which areas need more tests before they can be touched?
- Are there quick wins to tackle first?
- What should be deferred to a future cycle?

Update `refactor-notes/00-requirements.md` with refined scope.

### Step 5: Build Refactor Plan

Generate a detailed refactoring plan with:

1. Goal statement
2. Target file/directory structure
3. Step-by-step changes (each small enough for a single commit)
4. New utilities and types to create
5. Design patterns to introduce (if `refactor-notes/03c-pattern-opportunities.md` exists,
   incorporate HIGH-priority patterns into the plan; see `skills/design-patterns/` for guides)
6. Breaking changes and migration paths
7. Risk assessment per step

Present the refactor plan to the user for approval.

## Output

Save all artifacts:
- `refactor-notes/00-requirements.md` (if created)
- `refactor-notes/05-test-plan.md`
- Test files alongside the source (following project conventions)
- `refactor-notes/06-refactor-plan.md`

## Important Notes

- Always present the test plan for review before generating code.
- Run tests immediately after generating them. If they fail, fix them.
- The refactor plan must be approved before Phase 3 begins.
- Be skeptical of your own test generation — encourage the user to review.
- Use expensive models for the refactor plan, cheaper models for test code generation.
