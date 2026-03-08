# Prompt: Identify Design Pattern Opportunities

Use this prompt to scan code for structural issues that design patterns can solve.
This is a companion to Phase 1 (Gather Insights) and feeds into the refactor plan in Phase 2.

---

## Instructions

Analyze the following code and identify opportunities to apply design patterns from the
Gang of Four (GoF) catalog. For each opportunity found, provide:

1. **Pattern name** and category (Creational / Structural / Behavioral)
2. **Location** — file(s) and line ranges affected
3. **Code smell** — what structural problem you observed (e.g., "switch statement choosing algorithm", "constructor with 8 parameters", "tight coupling between modules")
4. **Why this pattern** — explain how the pattern solves the specific problem
5. **Complexity** — estimate the effort to apply: LOW (< 1 hour), MEDIUM (1-4 hours), HIGH (4+ hours)
6. **Trade-offs** — what you gain and what complexity the pattern adds
7. **Priority** — HIGH (apply now, high impact), MEDIUM (apply if time permits), LOW (defer to future cycle)

## Code Smell → Pattern Quick Reference

Use this table to guide your analysis:

| Code Smell | Candidate Pattern(s) |
|---|---|
| Giant if/else or switch on type | Strategy, State, Command |
| Copy-pasted logic with minor variations | Template Method, Strategy |
| Constructor with 5+ parameters | Builder |
| `new` keyword scattered across codebase | Factory Method, Abstract Factory |
| God class doing too many things | Facade, Mediator, Command |
| Tight coupling between modules | Observer, Mediator, Bridge |
| Adding features requires modifying existing code | Decorator, Strategy, Visitor |
| Complex object creation with many steps | Builder, Factory Method, Prototype |
| Need to support undo or history | Memento, Command |
| Traversing complex tree/graph structures | Iterator, Composite, Visitor |
| Behavior changes based on internal state | State |
| Adapting incompatible interfaces | Adapter, Facade |
| Controlling access to expensive resources | Proxy, Flyweight |
| Many similar objects consuming memory | Flyweight, Prototype |

## Important Guidelines

- **Don't force patterns.** If the code is simple and clear, no pattern is needed.
- **Prefer language idioms.** In JavaScript/TypeScript, a function is often better than a Strategy class. In Python, a decorator function is better than the Decorator pattern as a class.
- **Consider team familiarity.** A pattern the team doesn't know adds maintenance cost.
- **Scale matters.** A 50-line module with one conditional doesn't need the Strategy pattern.
- **One at a time.** Recommend applying patterns incrementally, not all at once.

## Output Format

Save findings to `refactor-notes/03c-pattern-opportunities.md` with this structure:

```markdown
# Design Pattern Opportunities

## Summary
- X opportunities identified across Y files
- Z rated HIGH priority for this refactoring cycle

## Opportunities

### 1. [Pattern Name] — [Brief description]
- **Location:** `path/to/file.ts` (lines X-Y)
- **Smell:** [Description of the structural issue]
- **Solution:** [How the pattern addresses it]
- **Complexity:** LOW / MEDIUM / HIGH
- **Trade-offs:** [Gains vs. costs]
- **Priority:** HIGH / MEDIUM / LOW

### 2. ...
```

---

## Code to Analyze

[Paste target code here, or reference the file paths from Phase 1 analysis]
