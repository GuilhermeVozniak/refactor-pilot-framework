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

## Quick Decision Tree

```
Is this a new project you haven't analyzed?
├── YES → Start at Step 1
└── NO → Has the code changed since last analysis?
    ├── YES → Re-run steps 3-4 on changed files
    └── NO → Skip to Phase 2 (generate-tests)

Is the codebase sensitive or proprietary?
├── YES → Use local models for code analysis, see references/anonymization.md
└── NO → Proceed normally

Is the codebase large (>500 files)?
├── YES → Scope to one module/feature area first
└── NO → Analyze the whole project
```

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

Categorize every file into: Components/Views/Pages, Utilities/Helpers, Services/API clients,
State management, Types/Interfaces, Styles, Tests, Configuration, Data/Constants.

Flag orphaned files, naming inconsistencies, and structural concerns.

Save as `refactor-notes/02-file-structure.md`.

### Step 3: Per-File Analysis

For each file in the target area (or the most important 10-20 files if the project is
large), produce a summary. Use file-type-specific analysis:

- **UI Components** → Focus on props, state, rendering logic, side effects
- **Config files** → Focus on build flags, constraints, refactoring implications
- **Utilities** → Focus on function signatures, purity, performance, type safety
- **Stylesheets** → Focus on selectors, specificity, !important usage, layout patterns

See `references/file-type-prompts.md` for detailed analysis templates per file type.

Process files in batches. Save as `refactor-notes/03-file-summaries.md`.

### Step 4: Analyze Code Coverage (if tests exist)

Run a coverage report and assess refactoring risk by coverage level:
- **>80% coverage** → LOW RISK, safe to refactor
- **50-80% coverage** → MEDIUM RISK, some test generation needed
- **<50% coverage** → HIGH RISK, extensive test generation needed first

Save as `refactor-notes/03b-coverage-analysis.md`.

### Step 5: Capture Baselines

Run `./scripts/capture-baselines.sh` against the project to capture quantitative
measurements (codebase size, build output, dependencies, code quality indicators).

Save as `refactor-notes/baselines.md`.

### Step 6: Check Build Configuration Flags

Review build config files (`tsconfig.json`, `webpack.config.js`, `vite.config.ts`,
`Cargo.toml`, `pyproject.toml`, or equivalent) for flags that affect refactoring:

- TypeScript `strict` mode (enabling strictness can be a refactoring goal)
- Module format (CommonJS vs. ESM affects import/export patterns)
- Target version (constrains what syntax you can use)
- Path aliases (affect how imports are restructured)
- Tree shaking settings (affect dead code decisions)

Use `references/file-type-prompts.md` (config section) for detailed analysis.
Note findings in `refactor-notes/03-file-summaries.md` alongside the config file analysis.

### Step 7: Security-Aware Analysis

Scan the codebase for security concerns that should be addressed during refactoring:

- Deprecated APIs with known vulnerabilities
- Unsafe constructs (raw pointers, unvalidated buffers, deserialization of untrusted data)
- Injection vectors (unsanitized inputs in SQL, shell commands, templates)
- Hardcoded secrets (API keys, passwords, tokens in source files)
- Overly permissive error handling that leaks internal details

Classify each issue as CRITICAL, HIGH, MEDIUM, or LOW. Include file, line, and suggested fix.
Feed this into the refactor plan in Phase 2.

Save as `refactor-notes/05-security-analysis.md`.

### Step 8: Generate Architecture Diagram

Produce a text-based architecture diagram from the analysis outputs showing how major
modules connect. Use arrows for data flow and dependency direction. Group files by
feature area or layer.

Include the diagram in the project summary.

### Step 9: Project Summary

Synthesize all outputs into a single document covering:

- Executive overview
- Architecture diagram (from Step 8)
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
- For sensitive code, see `references/anonymization.md` for local model strategies.
- Save all outputs — they are required context for subsequent phases.
- Be honest about areas of uncertainty. If a file's purpose is unclear, say so.
