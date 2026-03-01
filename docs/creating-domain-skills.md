# Creating Domain-Specific Skills

The skills included in Refactor Pilot are general-purpose. For best results, create domain-specific skills that encode your team's expertise, coding standards, and technology stack preferences.

## Why Domain-Specific Skills Matter

A generic "refactor React code" skill produces generic results. A skill written by someone who deeply understands your stack — React 18 with TypeScript strict mode, Zustand for state, Tailwind for styling, Vitest for testing — will produce code that matches your project conventions without extra prompting.

The best skills are created by domain experts: someone who knows React concurrency creates the React concurrent mode refactoring skill; someone who knows Python async/await deeply creates the asyncio migration skill.

## Skill Structure

Follow the progressive disclosure pattern:

```
skills/your-skill-name/
├── SKILL.md                    # Entry point (max 100 lines)
└── references/                 # Detailed knowledge (max 500 lines each)
    ├── pattern-a.md
    ├── pattern-b.md
    └── common-pitfalls.md
```

### SKILL.md Format

```markdown
---
name: your-skill-name
description: >
  Use this skill whenever [specific trigger conditions].
  Triggers include: [list of phrases users might say].
  Do NOT use for [things this skill should not handle].
---

# Skill Title

Brief overview of what this skill does (2-3 sentences).

## Quick Decision Tree

- Converting class components to hooks? → See references/hooks-migration.md
- Adding TypeScript types to JS code? → See references/typescript-adoption.md
- Fixing performance issues? → See references/performance-patterns.md

## Agent Behavior

When this skill activates:

1. First, check the project's build configuration:
   - Read tsconfig.json for strict mode, target, module settings
   - Read package.json for framework versions

2. Then, based on the task:
   - [Step-by-step instructions for the AI agent]

## Key Principles

- [Principle 1 with brief explanation]
- [Principle 2 with brief explanation]
```

### Reference File Format

Each reference file is a deep dive into one specific topic:

```markdown
# Topic Title

## When This Applies

[1-2 sentences on when to use this reference]

## The Pattern

[Concrete code examples showing before/after]

## Common Mistakes

[What the AI should avoid doing]

## Edge Cases

[Situations that need special handling]
```

## Opinionated vs. Generic Skills

Skills should be opinionated. A React skill that says "you could use Redux, or Context, or Zustand, or Jotai..." isn't useful. A skill that says "use Zustand for state management with this pattern..." produces consistent results.

Create skill variants for different coding styles:

```
skills/react-refactor/
├── SKILL.md                         # Common React refactoring knowledge
└── variants/
    ├── typescript-strict/SKILL.md   # TypeScript strict mode + Zod validation
    ├── javascript-pragmatic/SKILL.md # Plain JS with PropTypes
    └── nextjs-app-router/SKILL.md   # Next.js 14+ App Router patterns
```

## Integrating with the Agent Skills Ecosystem

Your skills can be shared via the [Agent Skills](https://agentskills.io) open format. This makes them discoverable by Claude Code, Cursor, Windsurf, and other AI tools.

To install skills from the ecosystem into your project:

```bash
# Install the OpenSkills CLI
npm install -g openskills

# Install a skill into your project
cd your-project
openskills install github-user/repo-name/skill-folder

# Sync installed skills to agents.md for discovery
openskills sync
```

The `agents.md` file at your project root catalogs all installed skills so AI tools can discover them automatically.

## Tips for Quality Skills

**Write from experience, not theory.** The best skills come from solving real problems. If you've refactored 10 React class components to hooks, you know the edge cases. Encode that knowledge.

**Include anti-patterns.** Tell the AI what NOT to do. "Do NOT wrap every component in React.memo" is as valuable as "DO use useMemo for expensive computations."

**Keep reference files under 500 lines.** If a topic needs more, split it into subtopics. This keeps the AI's context focused.

**Test the skill on real code.** Run your skill against 3-5 different projects. If it produces inconsistent results, the instructions need refinement.

**Version your skills.** Tag releases so teams can pin to a known-good version. Update when frameworks release major versions (React 18 → 19, Python 3.11 → 3.12).
