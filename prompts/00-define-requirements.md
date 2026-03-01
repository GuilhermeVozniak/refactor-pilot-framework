# Prompt: Define Refactoring Requirements

> **Phase:** Pre-work (before Phase 1)
> **Purpose:** Establish clear requirements, constraints, and success criteria before any analysis begins.
> **Input:** Your knowledge of the project's goals and constraints

## The Prompt

```
Help me define the requirements for a code refactoring effort.

I'm going to describe my project and what I want to achieve. Based on that,
produce a structured requirements document covering:

1. **Refactoring Goals**
   What specific improvements are we targeting?
   - Code quality improvements (readability, maintainability, testability)
   - Pattern modernization (class → function, callbacks → async/await)
   - Performance improvements (bundle size, runtime speed, memory)
   - Type safety improvements (add TypeScript, remove `any`)
   - Dependency updates (remove deprecated packages, reduce bundle)
   - Architecture changes (extract modules, add layers, separate concerns)

2. **Success Criteria**
   How will we know the refactoring succeeded?
   - All existing tests still pass
   - No regression in [specific metrics]
   - Code coverage stays at or above [X]%
   - Bundle size stays within [X]% of current
   - [Specific feature] still works as expected

3. **Constraints**
   What can't we change?
   - Public API must remain backward compatible
   - No new dependencies allowed / only approved dependencies
   - Must support [browsers / runtimes / platforms]
   - Cannot modify [specific files or modules]
   - Must complete within [timeframe]
   - Budget for AI API calls: [amount]

4. **Coding Standards**
   What standards must the refactored code follow?
   - Naming conventions
   - File organization patterns
   - Framework-specific patterns (hooks over classes, composition over inheritance)
   - TypeScript strictness level
   - Testing requirements (minimum coverage, required test types)

5. **Scope**
   What's in scope and what's out?
   - Modules/files to refactor
   - Modules/files explicitly out of scope
   - Depth of changes (surface-level cleanup vs. architectural changes)

6. **Risk Tolerance**
   - Are we willing to change public APIs?
   - Can we accept a brief period of increased complexity during migration?
   - Do we need feature flags for gradual rollout?
   - Do we have a rollback plan?

---

PROJECT DESCRIPTION:
[Describe your project: what it does, tech stack, team size, current pain points]

WHAT I WANT TO IMPROVE:
[Describe what's bothering you about the current code]

HARD CONSTRAINTS:
[List anything that absolutely cannot change]
```

## Usage Notes

- Complete this before starting Phase 1. It sets the scope for everything that follows.
- Save the output as `refactor-notes/00-requirements.md`.
- Reference this document in every subsequent phase prompt as context.
- Review and update requirements as you learn more about the codebase in Phase 1.
- Share requirements with stakeholders and get sign-off before Phase 2.
