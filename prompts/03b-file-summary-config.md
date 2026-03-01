# Prompt: Analyze Configuration File

> **Phase:** 1 — Gather Insights
> **Purpose:** Specialized analysis for configuration and build files (tsconfig, webpack, vite, eslint, etc.).
> **Input:** Source code of a configuration file

## The Prompt

```
Analyze this configuration file and produce a structured summary:

1. **File Purpose** (one sentence)
   What does this config control? Which tool reads it?

2. **Configuration Type**
   - Build configuration (webpack, vite, rollup, esbuild)
   - Language configuration (tsconfig, .babelrc, .swiftrc)
   - Linter/formatter configuration (eslint, prettier, stylelint)
   - Test configuration (jest, vitest, pytest)
   - Deployment configuration (Dockerfile, CI/CD)
   - Package manifest (package.json, requirements.txt, Cargo.toml)
   - Environment configuration (.env, feature flags)

3. **Key Settings**
   List the most important settings and their values.
   For each, explain what it controls and whether the value is standard or unusual.

4. **Build/Compiler Flags That Affect Refactoring**
   Flag any settings that constrain what refactored code can look like:
   - TypeScript strict mode (changes valid patterns)
   - Target ES version (limits syntax)
   - Module system (ESM vs CommonJS)
   - JSX transform (classic vs automatic)
   - Compiler strictness flags

5. **Dependency Version Constraints**
   - Pinned versions vs. ranges
   - Peer dependency requirements
   - Engine requirements (Node version, Python version)

6. **Potential Issues**
   - Deprecated or non-standard settings
   - Settings that conflict with each other
   - Missing recommended settings for the project type
   - Settings that will block modernization efforts

7. **Refactoring Implications**
   How does this config affect a potential refactoring effort?
   What would need to change in this config to support modernized code?

---

FILE: [[FILE_PATH]]

```[[LANG]]
[[FILE_CONTENT]]
```
```
