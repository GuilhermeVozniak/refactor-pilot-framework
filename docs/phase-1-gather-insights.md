# Phase 1: Gather Insights

The first phase is about building a complete mental model of the codebase before changing anything. AI accelerates this from days of manual exploration to minutes of automated analysis.

## Why This Phase Matters

Refactoring without understanding the codebase is like renovating a house without blueprints. You'll tear down a load-bearing wall. This phase produces the blueprints.

## The Workflow

```
Project Directory
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Extract    │────▶│   Map File   │────▶│  Per-File    │
│   Metadata   │     │  Structure   │     │  Analysis    │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                     │
       ▼                    ▼                     ▼
  Dependencies         File manifest         Component
  Framework info       by type               summaries
  Build config         (TS, JSX, JSON...)    Data flow maps
       │                    │                     │
       └────────────────────┴─────────────────────┘
                            │
                            ▼
                   ┌──────────────┐
                   │   Project    │
                   │   Summary    │
                   └──────────────┘
```

## Step 1: Extract Project Metadata

Pull out the foundational information about the project — what it depends on, how it builds, what framework it uses.

**What to extract:**
- `package.json` (or equivalent: `requirements.txt`, `Cargo.toml`, `go.mod`, `Gemfile`)
- Dependency list with versions
- Build scripts and configuration
- Framework and runtime versions
- Linting and formatting config
- CI/CD configuration

**Using the script:**
```bash
./scripts/analyze-project.sh /path/to/your/project
```

**Using the prompt manually:**
Copy the prompt from `prompts/01-project-metadata.md`, paste your `package.json` (or equivalent) alongside it, and ask the AI to analyze it.

**Expected output:**
A structured summary listing the project's tech stack, dependency health (outdated, deprecated, or vulnerable packages), build pipeline, and any immediate red flags.

## Step 2: Map File Structure

Build a manifest of every file in the project, categorized by type and purpose.

**Categories to identify:**
- Components (UI elements, views, pages)
- Utilities and helpers
- Configuration files
- Test files
- Type definitions
- Styles (CSS, SCSS, styled-components)
- Data files (JSON fixtures, constants)
- Build and tooling files

**Using the script:**
```bash
./scripts/map-file-structure.sh /path/to/your/project
```

**Using the prompt manually:**
Copy the prompt from `prompts/02-file-structure-analysis.md` and include a directory tree (you can generate one with `tree` or `find`).

**Expected output:**
A categorized file manifest that tells you exactly where components, utilities, tests, and config live. This becomes the roadmap for the rest of the refactor.

## Step 3: Per-File Analysis

For each file (or each file in the target area), generate a concise summary of what it does, what it depends on, and what depends on it.

**What the analysis covers per file:**
- Purpose and responsibility (one sentence)
- Exports (functions, classes, components, constants)
- Imports and dependencies
- Complexity indicators (line count, cyclomatic complexity, nesting depth)
- Code smells (duplicated logic, long parameter lists, god functions)
- Data flow (where data comes from, where it goes)

**Using the script:**
```bash
./scripts/generate-file-summaries.sh /path/to/your/project
```

**Using the prompt manually:**
Copy the prompt from `prompts/03-file-summary.md`, paste the file contents, and let AI generate the analysis.

**Tip:** Process files in batches. Don't try to analyze the entire project in one prompt. Group by directory or feature area.

## Step 4: Generate Project Summary

Feed all the outputs from steps 1-3 into the project summary prompt. This produces a high-level document that anyone on the team can read to understand the codebase.

**The project summary includes:**
- Tech stack overview
- Architecture description (monolith, micro-frontends, modular, etc.)
- Key data flows
- Areas of high complexity or risk
- Dependency concerns
- Recommended refactoring targets (prioritized)

**Using the prompt:**
Copy `prompts/04-project-summary.md` and include the outputs from the previous three steps as context.

## Step 5: Analyze Code Coverage

If your project has existing tests, run a coverage report and feed it into the coverage analysis prompt to identify areas that are safe to refactor versus areas that need safety net tests first.

**Using the prompt:**
Copy `prompts/01b-coverage-analysis.md`, paste your coverage report output, and let AI assess refactoring risk by coverage level.

**How to generate coverage reports:**
```bash
# JavaScript/TypeScript (Jest)
npx jest --coverage --coverageReporters=text

# JavaScript/TypeScript (Vitest)
npx vitest --coverage

# Python
pytest --cov=src --cov-report=term-missing

# Go
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
```

**Expected output:**
A risk-ranked list of files/modules: well-tested areas (safe to refactor), undertested areas (need safety nets), and untested areas (high risk).

## Step 6: Capture Performance Baselines

Before making any changes, capture quantitative measurements you can compare against after refactoring.

**Using the script:**
```bash
./scripts/capture-baselines.sh /path/to/your/project
```

This captures codebase size, build output, dependency counts, test file counts, TODO/FIXME comments, `!important` counts, console.* statements, and TypeScript `any` usage. Output goes to `refactor-notes/baselines.md`.

**Additional baselines to capture manually:**
- Build time: `time npm run build`
- Test duration: `time npm test`
- Bundle analysis: `npx webpack-bundle-analyzer` or `npx vite-bundle-visualizer`
- Lighthouse score for web projects

## Step 7: Check Build Configuration Flags

Build configuration often contains flags and settings that directly affect what refactoring is possible. Review your build config for:

- **TypeScript `strict` mode** — If `strict: false`, enabling strictness incrementally can be a refactoring goal
- **Module format** — CommonJS vs. ESM affects import/export patterns
- **Target** — ES version targets constrain what syntax you can use
- **Path aliases** — Affect how imports are restructured
- **Tree shaking** — Whether unused exports are eliminated affects dead code decisions

Use the config file analysis prompt (`prompts/03b-file-summary-config.md`) on your `tsconfig.json`, `webpack.config.js`, `vite.config.ts`, or equivalent.

## Step 8: Generate Architecture Diagram

Ask AI to produce a text-based architecture diagram from the Phase 1 outputs. This gives the team a shared visual of how modules connect.

**Prompt:**
```
Based on the file structure and per-file analysis, produce a text-based architecture
diagram showing how the major modules connect. Use arrows to indicate data flow
and dependency direction. Group files by feature area or layer.
```

This is especially valuable when onboarding new developers or getting team buy-in for the refactor plan.

## Step 9: Security-Aware Analysis

Ask AI to scan the codebase for security issues that should be addressed during refactoring. This goes beyond dependency vulnerability scanning — it examines the code itself for patterns that introduce risk.

**What to look for:**

- **Deprecated APIs** — Functions that still work but have known security issues (e.g., `gets()` in C, `getVersion()` in Windows API, `md5` for password hashing). AI is particularly good at spotting these because it knows deprecation timelines across languages.
- **Unsafe constructs** — Raw pointers, unsafe memory operations, unvalidated buffer access, deserialization of untrusted data. In Rust, these live in explicit `unsafe` blocks; in C/C++, they're everywhere.
- **Injection vectors** — Unsanitized user inputs passed to SQL queries, shell commands, file paths, or HTML templates.
- **Hardcoded secrets** — API keys, passwords, tokens, or connection strings embedded in source code.
- **Overly permissive error handling** — Catch-all blocks that swallow errors silently, or error messages that leak internal details to users.

**Prompt:**
```
Analyze this codebase for security concerns that should be addressed during refactoring.
For each issue found, classify it as:
- CRITICAL: Must fix during this refactor (injection vectors, hardcoded secrets)
- HIGH: Should fix during this refactor (deprecated APIs with known vulnerabilities)
- MEDIUM: Fix if scope permits (unsafe constructs that have safe alternatives)
- LOW: Note for future work (overly broad error handling, missing input validation)

For each issue, provide the file, line, the problem, and a suggested fix.
```

Feed the output into your refactor plan in Phase 2 — security fixes become explicit steps in the plan rather than afterthoughts.

## Tips for Phase 1

**Scope your analysis.** For large codebases, don't try to analyze everything at once. Pick a module, feature, or directory and start there.

**Save your outputs.** The metadata, file manifests, and summaries from this phase are context that every subsequent phase needs. Store them in a `refactor-notes/` directory in your project.

**Iterate.** If the AI's analysis seems off, provide more context — adjacent files, README sections, or your own knowledge of the system. AI gets better with more context.

**Use local models for sensitive code.** If your codebase contains trade secrets or proprietary logic, run the analysis with a local model (Ollama, LM Studio) rather than sending code to external APIs. See [Anonymization Guide](anonymization-guide.md) for detailed strategies.

**Use file-type-specific prompts for deeper analysis.** The generic file summary prompt (`03-file-summary.md`) works well, but for more targeted insights, use the specialized variants: `03a` for UI components, `03b` for config files, `03c` for utilities, and `03d` for stylesheets.
