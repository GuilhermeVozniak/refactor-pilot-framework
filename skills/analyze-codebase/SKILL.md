---
name: analyze-codebase
description: >
  Use this skill whenever the user wants to understand, analyze, or audit a codebase before
  refactoring. Triggers include: "analyze this project", "what does this codebase do",
  "give me an overview of the code", "audit dependencies", "map the file structure",
  "what are the code smells", "assess code quality", "review this project",
  "what needs refactoring", or any request to understand a codebase before changing it.
  Also triggers when a user shares a project folder and wants to know where to start.
  Do NOT use for actually writing refactored code — use refactor-code for that.
---

# Analyze Codebase Skill

You are performing Phase 1 (Gather Insights) of the Refactor Pilot framework. Your job is
to build a comprehensive understanding of the codebase before any changes are made.

## Workflow

Execute these steps in order. Save all outputs to a `refactor-notes/` directory in the
project root.

### Step 1: Extract Project Metadata

Read the project's manifest file (`package.json`, `requirements.txt`, `Cargo.toml`,
`go.mod`, `pyproject.toml`, or equivalent) and produce a report covering:

- Project name, version, and description
- Runtime and framework (with versions)
- Production vs. dev dependencies (count and key packages)
- Build scripts and their purpose
- Red flags: outdated, deprecated, or conflicting packages

Save as `refactor-notes/01-metadata.md`.

### Step 2: Map File Structure

Generate a categorized file manifest by running a directory listing (excluding
`node_modules`, `.git`, `dist`, `build`, `__pycache__`, `.venv`, and similar).

Categorize every file into:
- Components / Views / Pages
- Utilities / Helpers
- Services / API clients
- State management
- Types / Interfaces
- Styles
- Tests
- Configuration
- Data / Constants

Flag orphaned files, naming inconsistencies, and structural concerns.

Save as `refactor-notes/02-file-structure.md`.

### Step 3: Per-File Analysis

For each file in the target area (or the most important 10-20 files if the project is
large), produce a summary covering:

- Purpose (one sentence)
- Exports
- Imports and dependencies
- Complexity indicators
- Code smells
- Data flow
- Refactoring opportunities

Process files in batches. Save as `refactor-notes/03-file-summaries.md`.

### Step 4: Project Summary

Synthesize all outputs into a single document covering:

- Executive overview
- Architecture description
- Key data flows
- Dependency health
- Code quality assessment
- Refactoring priority map (ranked by impact and effort)
- Risks and considerations

Save as `refactor-notes/04-project-summary.md`.

## Output

After completing all steps, present the user with:
1. A brief summary of findings (3-5 sentences)
2. The top 3 refactoring priorities with rationale
3. Links to the saved documents for full details

## Important Notes

- For large codebases, focus on one module or feature area at a time.
- For sensitive code, note that analysis can be done with local models.
- Save all outputs — they are required context for subsequent phases.
- Be honest about areas of uncertainty. If a file's purpose is unclear, say so.
