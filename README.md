# Refactor Pilot

**A systematic, AI-assisted framework for safely refactoring legacy codebases.**

Refactor Pilot gives you a repeatable, four-phase process for using large language models (LLMs) to understand, test, transform, and verify code — turning weeks of manual refactoring into hours of guided, AI-accelerated work.

Whether you use Claude, ChatGPT, Copilot, Cursor, or any other AI coding tool, the prompts and scripts in this repo are designed to be **tool-agnostic** and **copy-paste ready**. If you use [Claude Code](https://docs.anthropic.com/en/docs/claude-code), you can drop the included skills directly into your workflow for an even more integrated experience.

---

## Why This Exists

Every team has code like this: a proof-of-concept that became production, CSS files with 250+ `!important` declarations, global variables mutating state from three different modules, and comments that say `// TODO: fix this later` from 2019. Legacy code is the beach staircase that collapsed — and someone bolted wooden platforms over the gap so people could keep walking.

AI can now do the heavy lifting of refactoring that code. But "throw it at ChatGPT" is not a strategy. You need a **systematic process** that keeps your codebase safe while AI does the grunt work. That's what Refactor Pilot provides.

### What You Get

- A **four-phase methodology** that mirrors how senior engineers refactor, augmented with AI at every step
- **Ready-to-use prompt templates** for codebase analysis, test generation, refactor planning, and code transformation
- **Automation scripts** (Node.js) for extracting project metadata, mapping file structures, and analyzing code
- **Claude Code skills** you can install for a fully integrated refactoring workflow
- **Checklists and guardrails** to keep AI-assisted refactoring safe and reviewable

---

## The Four Phases

```
┌─────────────────────────────────────────────────────────────────┐
│                      REFACTOR PILOT                             │
│                                                                 │
│  Phase 1          Phase 2          Phase 3         Phase 4      │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐   ┌──────────┐   │
│  │ GATHER   │───▶│ PREPARE  │───▶│TRANSFORM │──▶│ VERIFY   │   │
│  │ INSIGHTS │    │ SAFETY   │    │          │   │ & DEPLOY │   │
│  └──────────┘    │ NETS     │    └──────────┘   └──────────┘   │
│                  └──────────┘                                   │
│  Understand       Tests &         AI rewrites     Run tests,    │
│  the codebase     refactor plan   the code        benchmark,    │
│                                                   ship it       │
└─────────────────────────────────────────────────────────────────┘
```

### Phase 1: Gather Insights

Before touching a single line of code, understand what you're working with. AI helps you build a mental model of the project in minutes instead of days.

**What happens:**
- Extract project metadata (package.json, dependencies, framework versions)
- Map the file structure by type (components, utilities, configs, tests)
- Run per-file analysis to generate summaries of what each module does
- Produce a high-level project summary and dependency graph

**Output:** A comprehensive codebase profile that serves as context for all subsequent phases.

[Read the full Phase 1 guide →](docs/phase-1-gather-insights.md)

### Phase 2: Prepare & Create Safety Nets

Never refactor without a safety net. AI generates tests that lock down current behavior so you can change the internals with confidence.

**What happens:**
- Generate a test plan covering components, edge cases, and integration points
- AI produces unit and integration tests based on current behavior
- Review and adjust AI-generated tests (don't trust blindly)
- Build a detailed refactor plan with step-by-step changes

**Output:** A test suite protecting current behavior and a concrete refactoring plan.

[Read the full Phase 2 guide →](docs/phase-2-prepare-safety-nets.md)

### Phase 3: Transform

With tests in place and a plan approved, AI rewrites the code. This is where the 90% time savings happen.

**What happens:**
- AI extracts shared utilities and helper functions
- Converts legacy patterns (e.g., class components → hooks, callbacks → async/await)
- Restructures files and modules according to the refactor plan
- Adds inline documentation and type annotations

**Output:** Refactored code with explanatory comments, following the approved plan.

[Read the full Phase 3 guide →](docs/phase-3-transform.md)

### Phase 4: Verify & Deploy

Trust but verify. Run the safety net, benchmark performance, and deploy with confidence.

**What happens:**
- Run the full test suite against refactored code
- Compare bundle size, load time, and runtime performance
- Use feature flags for gradual rollout
- Run regression tests and manual smoke tests

**Output:** Verified, deployed refactored code with performance baselines.

[Read the full Phase 4 guide →](docs/phase-4-verify-deploy.md)

---

## Repository Structure

```
refactor-pilot/
├── README.md                          # You are here
├── LICENSE                            # MIT License
├── CONTRIBUTING.md                    # How to contribute
│
├── docs/                              # Detailed phase guides
│   ├── phase-1-gather-insights.md
│   ├── phase-2-prepare-safety-nets.md
│   ├── phase-3-transform.md
│   ├── phase-4-verify-deploy.md
│   └── best-practices.md
│
├── prompts/                           # Copy-paste prompt templates
│   ├── 01-project-metadata.md
│   ├── 02-file-structure-analysis.md
│   ├── 03-file-summary.md
│   ├── 04-project-summary.md
│   ├── 05-test-plan.md
│   ├── 06-test-generation.md
│   ├── 07-refactor-plan.md
│   ├── 08-code-transform.md
│   └── 09-verify-checklist.md
│
├── scripts/                           # Automation scripts (Node.js)
│   ├── analyze-project.js
│   ├── map-file-structure.js
│   └── generate-file-summaries.js
│
├── skills/                            # Claude Code skills
│   ├── analyze-codebase/
│   │   └── SKILL.md
│   ├── generate-tests/
│   │   └── SKILL.md
│   ├── refactor-code/
│   │   └── SKILL.md
│   └── verify-changes/
│       └── SKILL.md
│
└── examples/                          # Example outputs
    ├── sample-project-profile.md
    ├── sample-test-plan.md
    └── sample-refactor-plan.md
```

---

## Quick Start

### Option 1: Use the Prompt Templates (Any AI Tool)

1. Clone this repo
2. Open the `prompts/` directory
3. Start with `01-project-metadata.md` — copy the prompt, paste it into your AI tool along with your project files
4. Work through the prompts sequentially (01 → 09), feeding outputs from earlier steps as context for later ones

### Option 2: Use the Scripts + Prompts

1. Clone this repo
2. Run the analysis scripts against your project:
   ```bash
   node scripts/analyze-project.js /path/to/your/project
   node scripts/map-file-structure.js /path/to/your/project
   node scripts/generate-file-summaries.js /path/to/your/project
   ```
3. Feed the script outputs into the prompt templates for deeper analysis

### Option 3: Install Claude Code Skills

1. Copy the `skills/` directory into your Claude Code project
2. Use the skills directly in your workflow:
   - `analyze-codebase` — Phase 1 analysis
   - `generate-tests` — Phase 2 test generation
   - `refactor-code` — Phase 3 transformation
   - `verify-changes` — Phase 4 verification

---

## Best Practices & Safety Guidelines

AI-assisted refactoring is powerful, but it requires discipline. Here are the guardrails:

**Start small.** Begin with internal projects or personal code. Build confidence before touching production systems.

**Never blindly trust AI output.** Always review generated tests, refactored code, and plans. AI is an assistant, not an autopilot.

**Be careful with sensitive code.** Don't paste proprietary algorithms, secrets, or PII into external AI services. Use local models or enterprise-grade tools with data protection guarantees.

**Inspect diffs carefully.** AI might add unexpected dependencies, change public APIs, or alter behavior in subtle ways. Review every diff line by line.

**Validate inputs and outputs.** Before and after refactoring, ensure the module's public interface behaves identically. Property-based testing and snapshot testing help here.

**Use feature flags.** Deploy refactored code behind feature flags so you can roll back instantly if something breaks in production.

**Treat AI as a junior developer.** It's fast and tireless, but it needs code review. The quality of its output depends heavily on the quality of your prompts and context.

[Read the full best practices guide →](docs/best-practices.md)

---

## Who Is This For?

- **Developers** drowning in legacy code who want a systematic way to modernize it
- **Tech leads** looking for a repeatable process to reduce technical debt across teams
- **AI enthusiasts** who want to see practical, production-grade uses of LLMs beyond chat
- **Open source contributors** maintaining aging codebases that need modernization

---

## Contributing

Contributions are welcome. Whether it's improving prompts, adding scripts for new languages, or sharing your refactoring results — open a PR.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

[MIT](LICENSE) — use it, fork it, build on it.

---

**Built by [@GuilhermeVozniak](https://github.com/GuilhermeVozniak)**
