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

## Tips for Phase 1

**Scope your analysis.** For large codebases, don't try to analyze everything at once. Pick a module, feature, or directory and start there.

**Save your outputs.** The metadata, file manifests, and summaries from this phase are context that every subsequent phase needs. Store them in a `refactor-notes/` directory in your project.

**Iterate.** If the AI's analysis seems off, provide more context — adjacent files, README sections, or your own knowledge of the system. AI gets better with more context.

**Use local models for sensitive code.** If your codebase contains trade secrets or proprietary logic, run the analysis with a local model (Ollama, LM Studio) rather than sending code to external APIs.
