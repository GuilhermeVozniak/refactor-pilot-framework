# Prompt: Generate Project Summary

> **Phase:** 1 — Gather Insights
> **Purpose:** Synthesize all Phase 1 outputs into a single, high-level project overview document.
> **Input:** Outputs from Prompts 01, 02, and 03

## The Prompt

```
Based on the project metadata, file structure analysis, and per-file summaries
provided below, produce a comprehensive project summary document.

The summary should cover:

1. **Executive Overview**
   - What does this project do? (2-3 sentences)
   - What is the tech stack?
   - Approximately how large is the codebase?

2. **Architecture**
   - What architectural pattern does the project follow? (monolith, modular, micro-frontends, MVC, etc.)
   - How is the code organized? (by feature, by type, mixed?)
   - Are there clear boundaries between modules or is everything tangled?

3. **Key Data Flows**
   - How does data enter the system? (user input, API calls, events)
   - How does data move through the system? (props, context, global state, events)
   - Where does data exit? (API calls, rendered UI, file output)

4. **Dependency Health**
   - Are dependencies up to date?
   - Any concerning or deprecated packages?
   - Any redundant dependencies?

5. **Code Quality Assessment**
   - Common code smells across the project
   - Testing coverage (estimated, based on presence of test files)
   - Consistency of coding patterns and conventions
   - Areas of high complexity

6. **Refactoring Priority Map**
   Rank areas of the codebase from highest to lowest refactoring priority.
   For each area, explain:
   - What's wrong
   - Impact of not refactoring
   - Estimated effort (small / medium / large)
   - Suggested approach

7. **Risks and Considerations**
   - Areas where refactoring could break things
   - Undocumented behavior that needs investigation
   - External dependencies that constrain refactoring options

Format as a professional document that a tech lead could hand to their team.

---

PROJECT METADATA:
[Paste output from Prompt 01]

FILE STRUCTURE:
[Paste output from Prompt 02]

FILE SUMMARIES:
[Paste outputs from Prompt 03]
```

## Usage Notes

- This is the capstone of Phase 1. Take time to review and refine it.
- Share the project summary with your team before proceeding to Phase 2.
- The priority map from section 6 helps you decide where to start refactoring.
- This document becomes the primary context for all Phase 2 prompts.
