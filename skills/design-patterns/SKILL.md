---
name: design-patterns
description: >
  Use this skill whenever the user wants to identify, apply, or refactor toward design patterns
  in their codebase. Triggers include: "apply design patterns", "identify patterns", "what patterns
  should I use", "refactor to strategy pattern", "apply factory method", "use observer pattern",
  "code smells that need patterns", "which design pattern fits", "improve architecture with patterns",
  "decouple this code", "make this extensible", "reduce coupling", "apply SOLID principles",
  or any mention of a specific GoF pattern name (Factory, Singleton, Observer, Strategy, etc.).
  Also triggers when the user mentions "Refactoring Guru", "Gang of Four", or "GoF patterns".
  Works standalone or as a companion to the refactor-code skill during Phase 3 (Transform).
  Do NOT use for general code analysis — use analyze-codebase for that.
---

# Design Patterns Skill

You are applying design patterns from the Refactoring Guru / Gang of Four catalog to help
the user improve their codebase's architecture. This skill works standalone or as part of
Phase 3 (Transform) of the Refactor Pilot Framework.

## Quick Decision Tree

```
What does the user need?
├── IDENTIFY which patterns to apply
│   └── Go to "Pattern Identification Workflow"
├── APPLY a specific pattern they already chose
│   └── Go to "Pattern Application Workflow"
├── LEARN about a pattern before deciding
│   └── Go to "Pattern Reference" (see references/)
└── REFACTOR existing code toward a pattern
    └── Go to "Pattern Refactoring Workflow"

Does a codebase analysis exist (refactor-notes/04-project-summary.md)?
├── YES → Use it to inform pattern recommendations
└── NO → Analyze the target code area before recommending patterns

Are safety net tests in place?
├── YES → Proceed with transformation
└── NO → Recommend running generate-tests first
```

## Pattern Identification Workflow

When the user wants to know which patterns fit their code:

### Step 1: Identify Code Smells That Patterns Solve

Scan the target code for these smell → pattern mappings:

| Code Smell | Suggested Pattern(s) |
|---|---|
| Giant `if/else` or `switch` on type | **Strategy**, **State**, **Command** |
| Copy-pasted logic with minor variations | **Template Method**, **Strategy** |
| Constructor with 5+ parameters | **Builder** |
| `new` keyword scattered everywhere | **Factory Method**, **Abstract Factory** |
| God class doing too many things | **Facade**, **Mediator**, **Command** |
| Tight coupling between modules | **Observer**, **Mediator**, **Bridge** |
| Adding features requires modifying existing code | **Decorator**, **Strategy**, **Visitor** |
| Complex object creation logic | **Builder**, **Factory Method**, **Prototype** |
| Need to support undo/history | **Memento**, **Command** |
| Traversing complex structures | **Iterator**, **Composite**, **Visitor** |
| Different behavior for different states | **State** |
| Adapting incompatible interfaces | **Adapter**, **Facade** |
| Controlling access to expensive resources | **Proxy**, **Flyweight** |
| Many similar objects consuming memory | **Flyweight**, **Prototype** |

### Step 2: Evaluate Fit

For each candidate pattern, assess:

1. **Problem match** — Does the pattern solve the actual problem, or just look similar?
2. **Complexity trade-off** — Is the pattern simpler than the current code, or does it add unnecessary indirection?
3. **Team familiarity** — Will the team understand and maintain this pattern?
4. **Language fit** — Does the language support this pattern idiomatically? (e.g., Strategy is trivial with first-class functions)
5. **Scale appropriateness** — Is the codebase large enough to justify the pattern's overhead?

**Rule of thumb:** If the pattern adds more classes/files than the problem warrants, it's over-engineering. Patterns should reduce complexity, not add it.

### Step 3: Recommend with Rationale

Present recommendations as:

```
## Pattern Recommendation: [Pattern Name]

**Problem:** [What code smell or structural issue this solves]
**Current code:** [Brief description of what exists now]
**After applying:** [What the code will look like]
**Trade-offs:** [What you gain vs. what complexity you add]
**Confidence:** HIGH / MEDIUM / LOW
**Files affected:** [List of files that would change]
```

## Pattern Application Workflow

When the user wants to apply a specific pattern:

### Step 1: Verify Prerequisites

- Confirm safety net tests exist (or accept the risk)
- Read the pattern reference (see `references/` docs)
- Identify all code locations that will change

### Step 2: Apply Incrementally

Follow the three-pass approach from the refactor-code skill:

1. **Extract** — Pull out the varying behavior or creation logic into separate units
2. **Introduce the pattern** — Create the pattern's structural elements (interfaces, base classes, factories, etc.)
3. **Wire up** — Replace the original code with the pattern-based implementation

### Step 3: Verify Behavior Preservation

- Run all tests after each step
- Confirm no public API changes (unless intentional)
- Add `// PATTERN: [PatternName]` comments at key structural points for documentation

### Step 4: Explain the Pattern Application

After applying, document:
- Why this pattern was chosen over alternatives
- How to extend the pattern (e.g., "to add a new strategy, create a class implementing X")
- Any simplifications made for the specific language/framework

## Pattern Refactoring Workflow

When refactoring existing code toward a pattern:

### Step 1: Map Current Structure to Pattern Roles

Identify which existing classes/functions/modules map to each role in the target pattern.
For example, for Strategy:
- Context → the class that currently contains the `if/else`
- Strategy interface → the abstraction to extract
- Concrete strategies → each branch of the conditional

### Step 2: Incremental Transformation

Transform in small, testable steps:

1. Extract the interface/protocol/trait
2. Implement one concrete variant
3. Verify tests pass
4. Migrate remaining variants one at a time
5. Remove the original conditional logic
6. Clean up and document

**Critical:** Never change more than one pattern role at a time. Each step should be independently committable and testable.

## Pattern Catalog Quick Reference

### Creational Patterns (object creation)

| Pattern | When to Use | Key Benefit |
|---|---|---|
| **Factory Method** | Subclasses decide which class to instantiate | Open/Closed principle for creation |
| **Abstract Factory** | Families of related objects | Consistent object families |
| **Builder** | Complex objects with many optional parts | Readable construction, immutable objects |
| **Prototype** | Copying existing objects is cheaper than creating new ones | Avoids complex initialization |
| **Singleton** | Exactly one instance needed globally | Controlled global access |

See `references/creational-patterns.md` for detailed guides with code examples.

### Structural Patterns (composition)

| Pattern | When to Use | Key Benefit |
|---|---|---|
| **Adapter** | Incompatible interfaces need to work together | Integration without modifying source |
| **Bridge** | Separate abstraction from implementation | Independent evolution of both |
| **Composite** | Tree structures with uniform treatment | Simplifies client code |
| **Decorator** | Add behavior without subclassing | Flexible runtime composition |
| **Facade** | Simplify a complex subsystem | Reduced coupling to internals |
| **Flyweight** | Many similar objects consuming memory | Shared state, lower memory |
| **Proxy** | Control access to another object | Lazy loading, access control, logging |

See `references/structural-patterns.md` for detailed guides with code examples.

### Behavioral Patterns (communication)

| Pattern | When to Use | Key Benefit |
|---|---|---|
| **Chain of Responsibility** | Multiple handlers for a request | Decoupled sender/receiver |
| **Command** | Encapsulate actions as objects | Undo, queue, log operations |
| **Iterator** | Traverse collections without exposing internals | Uniform traversal interface |
| **Mediator** | Reduce chaotic dependencies between objects | Centralized communication |
| **Memento** | Capture and restore object state | Undo without violating encapsulation |
| **Observer** | Notify dependents of state changes | Loose coupling, event-driven |
| **State** | Behavior changes based on internal state | Eliminates state conditionals |
| **Strategy** | Interchangeable algorithms | Open/Closed principle for behavior |
| **Template Method** | Algorithm skeleton with customizable steps | Code reuse with variation points |
| **Visitor** | Add operations to objects without modifying them | Separation of concerns |

See `references/behavioral-patterns.md` for detailed guides with code examples.

## Integration with Refactor Pilot Phases

This skill integrates with the broader framework:

- **Phase 1 (Analyze):** During codebase analysis, flag code smells that indicate pattern opportunities
- **Phase 2 (Test):** Ensure safety nets cover the behavior that patterns will restructure
- **Phase 3 (Transform):** Apply patterns using the three-pass approach
- **Phase 4 (Verify):** Confirm pattern application didn't change behavior, check extensibility

## Output

After pattern work, present:
1. Summary of patterns identified or applied
2. Before/after comparison of key code sections
3. Extensibility guide (how to add new variants/behaviors using the pattern)
4. Any `// REVIEW` flags where the pattern application needs human judgment

## Critical Rules

- **Patterns are tools, not goals.** Don't apply a pattern just because you can.
- **Simpler is better.** If a function solves the problem, don't create a class hierarchy.
- **Language idioms first.** Use language-native features (closures, protocols, traits) before reaching for classical OOP patterns.
- **One pattern at a time.** Apply and verify one pattern before starting the next.
- **Preserve behavior.** Pattern refactoring must not change what the code does.
- **Document the "why."** Every pattern application should explain the problem it solves.
