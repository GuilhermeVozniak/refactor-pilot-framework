# Refactor Pilot Framework — Skill Registry

This document lists all available skills (agents) in the Refactor Pilot Framework.
Skills are designed for Claude Code but the underlying methodology works with any AI tool.

## Skills Overview

| Skill | Phase | Purpose | Trigger Examples |
|-------|-------|---------|------------------|
| `analyze-codebase` | 1 | Understand the codebase | "analyze this project", "what does this code do" |
| `generate-tests` | 2 | Create safety nets | "generate tests", "add tests before refactoring" |
| `refactor-code` | 3 | Transform the code | "refactor this", "convert to hooks", "modernize" |
| `verify-changes` | 4 | Validate and deploy | "verify the refactoring", "is it safe to deploy" |

## Skill Details

### analyze-codebase

**Location:** `skills/analyze-codebase/`

Performs Phase 1 analysis: extracts project metadata, maps file structure, runs per-file
analysis with file-type-specific prompts, analyzes code coverage, captures performance
baselines, and produces a comprehensive project summary.

**Outputs:** `refactor-notes/01-metadata.md`, `refactor-notes/02-file-structure.md`, `refactor-notes/03-file-summaries.md`,
`refactor-notes/03b-coverage-analysis.md`, `refactor-notes/baselines.md`, `refactor-notes/05-security-analysis.md`, `refactor-notes/04-project-summary.md`

**References:** `references/file-type-prompts.md`, `references/anonymization.md`

---

### generate-tests

**Location:** `skills/generate-tests/`

Performs Phase 2: defines requirements (if not done), generates a test plan, produces
test code, verifies tests pass, refines scope, and builds a detailed refactor plan.

**Outputs:** `refactor-notes/00-requirements.md`, `refactor-notes/05-test-plan.md`, test files,
`refactor-notes/06-refactor-plan.md`

**References:** `references/test-patterns.md`

---

### refactor-code

**Location:** `skills/refactor-code/`

Performs Phase 3: executes the refactor plan in three passes — extract utilities, convert
patterns, restructure and document. Includes the "explain your decisions" pattern for
surfacing AI reasoning.

**Outputs:** Refactored source files, `// REVIEW` comments for manual verification

**References:** `references/pattern-conversions.md`

---

### verify-changes

**Location:** `skills/verify-changes/`

Performs Phase 4: runs the full test suite, compares benchmarks against baselines,
generates a tailored verification checklist, and recommends a deployment strategy.

**Outputs:** `refactor-notes/07-verification-report.md`

**References:** `references/deployment-strategies.md`

## Installation

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed on your system
- A project you want to refactor

### Method 1: Full Setup (Recommended)

Clone the repo and copy everything into your project. This gives skills access to
scripts, prompts, and docs.

```bash
# 1. Clone Refactor Pilot Framework
git clone https://github.com/GuilhermeVozniak/refactor-pilot-framework.git

# 2. Copy skills into your project's .claude directory
mkdir -p /path/to/your/project/.claude/skills
cp -r refactor-pilot-framework/skills/* /path/to/your/project/.claude/skills/

# 3. Copy scripts into your project (skills reference these)
cp -r refactor-pilot-framework/scripts/ /path/to/your/project/scripts/

# 4. Make scripts executable
chmod +x /path/to/your/project/scripts/*.sh
```

Your project should now look like:

```
your-project/
├── .claude/
│   └── skills/
│       ├── analyze-codebase/
│       │   ├── SKILL.md              # Phase 1 skill
│       │   └── references/
│       │       ├── file-type-prompts.md
│       │       └── anonymization.md
│       ├── generate-tests/
│       │   ├── SKILL.md              # Phase 2 skill
│       │   └── references/
│       │       └── test-patterns.md
│       ├── refactor-code/
│       │   ├── SKILL.md              # Phase 3 skill
│       │   └── references/
│       │       └── pattern-conversions.md
│       └── verify-changes/
│           ├── SKILL.md              # Phase 4 skill
│           └── references/
│               └── deployment-strategies.md
├── scripts/
│   ├── analyze-project.sh
│   ├── map-file-structure.sh
│   ├── generate-file-summaries.sh
│   └── capture-baselines.sh
├── src/
└── ...
```

### Method 2: Skills Only (Quick Start)

If you just want the skills without the scripts:

```bash
mkdir -p /path/to/your/project/.claude/skills
cp -r refactor-pilot-framework/skills/* /path/to/your/project/.claude/skills/
```

Note: Some skill steps reference automation scripts (`capture-baselines.sh`,
`analyze-project.sh`, etc.). Without these scripts, you can still use the skills —
just skip the script-dependent steps and use the prompt templates manually instead.

### Method 3: Claude Code Marketplace (Easiest)

Install directly from the marketplace without cloning anything:

```bash
# Add the Refactor Pilot Framework marketplace
/plugin marketplace add GuilhermeVozniak/refactor-pilot-framework

# Install the plugin
/plugin install refactor-pilot@refactor-pilot-marketplace
```

To update later:

```bash
/plugin marketplace update refactor-pilot-marketplace
```

To manage the plugin:

```bash
# Temporarily disable
/plugin disable refactor-pilot@refactor-pilot-marketplace

# Re-enable
/plugin enable refactor-pilot@refactor-pilot-marketplace

# Uninstall
/plugin uninstall refactor-pilot@refactor-pilot-marketplace
```

### Method 4: Git Submodule

Add Refactor Pilot Framework as a submodule for easy updates:

```bash
cd /path/to/your/project
git submodule add https://github.com/GuilhermeVozniak/refactor-pilot-framework.git .refactor-pilot-framework

# Symlink the skills into .claude
mkdir -p .claude/skills
ln -s ../../.refactor-pilot-framework/skills/analyze-codebase .claude/skills/analyze-codebase
ln -s ../../.refactor-pilot-framework/skills/generate-tests .claude/skills/generate-tests
ln -s ../../.refactor-pilot-framework/skills/refactor-code .claude/skills/refactor-code
ln -s ../../.refactor-pilot-framework/skills/verify-changes .claude/skills/verify-changes
```

### Verifying the Installation

Open Claude Code in your project directory and try one of these:

- "analyze this codebase" → should trigger the `analyze-codebase` skill
- "generate tests for this module" → should trigger the `generate-tests` skill
- "refactor this file" → should trigger the `refactor-code` skill

Claude will automatically pick up skills from `.claude/skills/` and use them
when it detects a matching request.

### Using Without Claude Code

The skills are plain Markdown files — they work as workflow guides with any AI tool.
To use with ChatGPT, Copilot, Cursor, Windsurf, or any other tool:

1. Open the relevant `SKILL.md` file
2. Read the workflow steps and decision tree
3. Use the corresponding prompt templates from `prompts/` — copy-paste them
   into your AI tool along with your code
4. Follow the methodology step by step

The prompt templates are designed to be **tool-agnostic** and **copy-paste ready**.

## Creating Custom Skills

See `docs/creating-domain-skills.md` for a guide on creating your own domain-specific
skills that encode your team's patterns, conventions, and preferences.
