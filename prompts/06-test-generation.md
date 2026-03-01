# Prompt: Generate Test Code

> **Phase:** 2 — Prepare & Create Safety Nets
> **Purpose:** Generate actual test files that implement the test plan from Prompt 05.
> **Input:** Test plan + source code of the file to test + project testing conventions

## The Prompt

```
Generate test code for the following source file based on the test plan provided.

Requirements:
- Use [FRAMEWORK] for testing (e.g., Jest, Vitest, pytest, Go testing)
- Use [LIBRARY] for component testing (e.g., React Testing Library, Vue Test Utils)
- Follow the project's existing test patterns if examples are provided
- Test BEHAVIOR, not implementation details
- Each test should have a clear, descriptive name
- Group related tests using describe/context blocks
- Include setup and teardown where needed
- Mock external dependencies (API calls, localStorage, etc.)
- Use meaningful assertions (not just "it renders without crashing")

Guidelines:
- DO NOT use snapshot tests (they break during refactoring)
- DO test the public API (props, return values, rendered output, callbacks)
- DO NOT test internal state or private methods
- DO test error states and edge cases
- DO include comments explaining WHY each test exists if the reason isn't obvious
- DO handle async operations properly (await, act(), etc.)

The tests MUST pass against the CURRENT (un-refactored) code.
If a test would not pass against the current code, do not include it.

---

TEST PLAN:
[Paste the test plan from Prompt 05]

SOURCE CODE TO TEST:
[Paste the source file]

PROJECT TEST EXAMPLES (for style reference):
[Paste 1-2 existing test files from the project, or write "No existing tests — use standard conventions"]

TESTING DEPENDENCIES AVAILABLE:
[List installed test packages, e.g., "jest, @testing-library/react, msw"]
```

## Usage Notes

- Run generated tests immediately. If they don't pass against the current code, they're wrong.
- Review each test for meaningful assertions. AI sometimes writes tests that test nothing.
- Check that mocks are realistic. AI might mock functions with incorrect return types.
- For complex components, generate tests in batches (one describe block at a time).
- Save the generated tests alongside your source code before starting Phase 3.
