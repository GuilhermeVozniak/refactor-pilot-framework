# Prompt: Build Refactor Plan

> **Phase:** 2 — Prepare & Create Safety Nets
> **Purpose:** Create a detailed, step-by-step refactoring plan that guides Phase 3 transformation.
> **Input:** Phase 1 project summary + source code of the target area

## The Prompt

```
Create a detailed refactoring plan for the code below.

The plan should be specific enough that another developer (or an AI) could
execute each step without ambiguity.

Structure the plan as follows:

1. **Goal Statement**
   What does this refactoring achieve? What's the "before" and "after"?
   (e.g., "Convert from class component with lifecycle methods to functional
   component with hooks, extracting shared validation logic into utilities")

2. **Target Structure**
   Show the desired file/directory structure after refactoring:
   ```
   feature/
   ├── UserProfile.tsx          (functional component)
   ├── useUserProfile.ts        (custom hook)
   ├── UserProfile.test.tsx     (tests)
   ├── userProfile.types.ts     (TypeScript interfaces)
   └── utils/
       ├── validateUser.ts      (validation logic)
       └── formatUserData.ts    (data formatting)
   ```

3. **Step-by-Step Changes**
   Ordered list of discrete, atomic changes. Each step should be:
   - Small enough to be a single commit
   - Independently testable
   - Reversible without affecting other steps

   For each step, specify:
   - What to create, modify, or delete
   - What the input is (which files to read)
   - What the output is (what the new/changed file should contain)
   - Which tests should pass after this step

4. **New Utilities and Types**
   List every new file that will be created:
   - File path
   - Purpose
   - Exports (function signatures, type definitions)
   - Where it will be used

5. **Breaking Changes**
   List any changes to public APIs, props, or interfaces:
   - What changed
   - Who is affected (which consumers need to be updated)
   - Migration path

6. **Dependencies**
   - New packages to install (if any)
   - Packages to remove (if any)
   - Internal dependencies that change

7. **Risk Assessment**
   For each step, rate the risk (low / medium / high) and explain:
   - What could go wrong
   - How to detect if it went wrong
   - How to roll back

---

PROJECT CONTEXT:
[Paste project summary from Phase 1]

SOURCE CODE TO REFACTOR:
[Paste the source file(s)]

CODING STANDARDS / CONVENTIONS:
[Describe your team's preferences: naming conventions, file organization,
preferred patterns, etc. Or write "Use modern best practices."]

CONSTRAINTS:
[List any constraints: "Must remain backward compatible",
"Cannot add new dependencies", "Must support IE11", etc.
Or write "No constraints beyond standard best practices."]
```

## Usage Notes

- Review the plan thoroughly before proceeding to Phase 3. This is your last checkpoint.
- Share the plan with teammates for review. It's a great async review artifact.
- If the plan has more than 10 steps, consider splitting it into multiple phases.
- The risk assessment in section 7 helps you decide the order of execution — start with low-risk steps.
- Save this plan — it's the primary input for Phase 3 transformation prompts.
