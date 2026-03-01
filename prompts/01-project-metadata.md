# Prompt: Extract Project Metadata

> **Phase:** 1 — Gather Insights
> **Purpose:** Analyze project configuration files to understand the tech stack, dependencies, and build pipeline.
> **Input:** Project manifest file (package.json, requirements.txt, Cargo.toml, go.mod, etc.)

## The Prompt

```
Analyze the following project configuration file and produce a structured report covering:

1. **Project Identity**
   - Name, version, description
   - License and author

2. **Tech Stack**
   - Runtime (Node.js version, Python version, etc.)
   - Framework (React, Vue, Django, Express, etc.) and version
   - Language (TypeScript, JavaScript, Python, etc.)
   - Build tools (webpack, vite, esbuild, etc.)

3. **Dependencies Audit**
   - Total count of production vs. dev dependencies
   - Potentially outdated packages (major versions behind latest)
   - Known deprecated packages
   - Packages with overlapping functionality (e.g., multiple date libraries)
   - Security-relevant packages (auth, crypto, HTTP clients)

4. **Build Pipeline**
   - Build scripts and their purpose
   - Test scripts and test framework
   - Linting and formatting configuration
   - Pre-commit hooks or CI/CD references

5. **Red Flags**
   - Pinned versions that are very old
   - Missing peer dependencies
   - Unusual scripts or post-install hooks
   - Dev dependencies that should be production (or vice versa)

Format the output as a structured markdown document with clear headings.
Be concise but thorough. Flag anything that would affect a refactoring effort.

---

PROJECT CONFIGURATION FILE:

[Paste your package.json / requirements.txt / etc. here]
```

## Usage Notes

- For monorepos, analyze the root config and each workspace/package config separately.
- If the project uses multiple config files (e.g., `package.json` + `tsconfig.json` + `.eslintrc`), include all of them for a more complete picture.
- Save the output — it's used as context in Phase 2 and beyond.
