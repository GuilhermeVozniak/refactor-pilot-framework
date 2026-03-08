# Prompt: Apply a Design Pattern

Use this prompt to refactor code toward a specific design pattern. This is a companion
to Phase 3 (Transform) and should be used after identifying pattern opportunities.

---

## Instructions

Apply the **[PATTERN NAME]** pattern to the following code. Follow these steps:

### Step 1: Map Existing Code to Pattern Roles

Before writing any code, identify how the current code maps to the pattern's structural roles.

For example, if applying Strategy:
- **Context** = the class/function that currently contains the conditional
- **Strategy interface** = the abstraction to extract
- **Concrete strategies** = each branch of the conditional

Present this mapping for review before proceeding.

### Step 2: Incremental Transformation

Apply the pattern in small, testable steps. After each step, all existing tests must pass.

1. **Extract the interface or abstraction** — define the contract that variants will implement
2. **Implement the first concrete variant** — migrate one branch/case to the new structure
3. **Verify tests pass** — confirm no behavior change
4. **Migrate remaining variants** — one at a time, testing after each
5. **Update client code** — replace the original conditional with the pattern-based dispatch
6. **Remove the old code** — delete the original conditional logic
7. **Document** — add `// PATTERN: [PatternName]` comments at key structural points

### Step 3: Verify and Document

After applying the pattern:
- Run the full test suite
- Confirm no public API changes (unless explicitly planned)
- Document how to extend the pattern (e.g., "to add a new strategy, create a function implementing X and add it to the strategies map")

## Important Guidelines

- **Preserve all behavior.** The refactored code must do exactly what the original did.
- **Use language idioms.** Prefer functions over classes when the language supports first-class functions. Use traits/protocols/interfaces native to the language.
- **Don't over-engineer.** Apply the minimum pattern structure that solves the problem.
- **Flag uncertainty.** Add `// REVIEW` comments where the pattern application needs human judgment.
- **Explain decisions.** After each step, briefly explain what you did and why.

## Output Format

Present the refactored code with:

1. **Role mapping** — how existing code maps to pattern roles
2. **Refactored code** — the final implementation
3. **Before/after comparison** — key sections showing the structural change
4. **Extensibility guide** — how to add new variants using the pattern
5. **Test verification** — confirmation that all tests pass

## Pattern Reference

For detailed guides on all 22 GoF patterns including code examples, language-idiomatic
alternatives, and step-by-step refactoring instructions, see:
- `skills/design-patterns/references/creational-patterns.md`
- `skills/design-patterns/references/structural-patterns.md`
- `skills/design-patterns/references/behavioral-patterns.md`

---

## Code to Refactor

**Target pattern:** [PATTERN NAME]
**Reason for applying:** [Code smell or structural issue being addressed]

[Paste target code here, or reference the file paths]
