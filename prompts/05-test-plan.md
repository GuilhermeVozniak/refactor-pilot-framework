# Prompt: Generate Test Plan

> **Phase:** 2 — Prepare & Create Safety Nets
> **Purpose:** Produce a detailed test plan that identifies every scenario to lock down before refactoring.
> **Input:** Phase 1 project summary + source code of the target module

## The Prompt

```
You are preparing to refactor the code below. Before any code changes happen,
we need a comprehensive test plan that locks down the current behavior.

Generate a test plan covering:

1. **Component/Module Behavior Tests**
   For each exported function, component, or class:
   - What does it do when given valid input?
   - What does it render / return in its default state?
   - How does it respond to user interactions (clicks, input, focus)?
   - What callbacks does it invoke and when?

2. **Edge Case Tests**
   For each function/component:
   - Empty input (null, undefined, empty string, empty array, 0)
   - Boundary values (max int, very long strings, special characters)
   - Missing optional parameters
   - Invalid types (string where number expected, etc.)
   - Concurrent calls or rapid state changes

3. **Integration Tests**
   - How does this module interact with its dependencies?
   - What happens when an API call fails?
   - What happens when shared state is in an unexpected shape?
   - Are there race conditions or timing dependencies?

4. **Side Effect Tests**
   - localStorage / sessionStorage reads and writes
   - Cookie access
   - API calls (what endpoints, what payloads)
   - Analytics events
   - DOM manipulation outside the component tree
   - Console warnings or errors

5. **Error Handling Tests**
   - What errors does this code throw?
   - What errors does it catch and how?
   - Are there error boundaries?
   - What does the user see when something goes wrong?

Format the test plan as a nested list:
```
Module: [name]
├── Scenario: [description]
│   ├── Given: [precondition]
│   ├── When: [action]
│   └── Then: [expected result]
```

Prioritize each test as:
- **Critical** — Must exist before refactoring
- **Important** — Should exist, covers common paths
- **Nice to have** — Edge cases that rarely occur

---

PROJECT CONTEXT:
[Paste project summary from Phase 1]

SOURCE CODE TO TEST:
[Paste the source file(s)]

EXISTING TESTS (if any):
[Paste existing test files, or write "No existing tests"]
```

## Usage Notes

- AI tends to generate comprehensive but sometimes redundant test plans. Trim duplicates.
- Focus on "Critical" and "Important" tests first. "Nice to have" tests can come later.
- If the module has existing tests, include them so AI doesn't duplicate effort.
- Save the test plan — it's referenced when generating test code (Prompt 06) and during verification (Phase 4).
