# Prompt: Analyze File Structure

> **Phase:** 1 — Gather Insights
> **Purpose:** Categorize every file in the project by type and purpose to build a structural map.
> **Input:** Directory tree output (from `tree`, `find`, or `ls -R`)

## The Prompt

```
Analyze this project's file structure and produce a categorized manifest.

Group files into the following categories:
- **Components** — UI elements, views, pages, layouts
- **Utilities** — Helper functions, shared logic, formatters, validators
- **Services** — API clients, data fetching, external service integrations
- **State Management** — Stores, reducers, contexts, state machines
- **Types** — Type definitions, interfaces, schemas
- **Styles** — CSS, SCSS, styled-components, Tailwind configs
- **Tests** — Unit tests, integration tests, e2e tests, test utilities
- **Configuration** — Build config, env files, deployment configs
- **Data** — Static data, fixtures, constants, i18n files
- **Documentation** — README, docs, changelogs, comments

For each category, list:
1. The files in that category
2. A one-line summary of what each file likely does (based on name and path)
3. The approximate number of files

Also identify:
- **Orphaned files** — Files that appear unused or disconnected from the main structure
- **Naming inconsistencies** — Mixed conventions (camelCase vs. kebab-case, etc.)
- **Structural concerns** — Deeply nested directories, flat directories with too many files, misplaced files

Format as a clean markdown document with each category as a heading.

---

PROJECT FILE STRUCTURE:

[Paste your directory tree here]
```

## How to Generate the Input

```bash
# Option 1: tree (if installed)
tree -I 'node_modules|.git|dist|build|coverage' --dirsfirst

# Option 2: find
find . -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  | sort

# Option 3: ls recursive
ls -R --ignore={node_modules,.git,dist,build}
```

## Usage Notes

- Exclude `node_modules`, `.git`, `dist`, `build`, and other generated directories.
- For very large projects (500+ files), analyze one top-level directory at a time.
- The output of this prompt feeds into per-file analysis (Prompt 03) and the project summary (Prompt 04).
