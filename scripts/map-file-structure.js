#!/usr/bin/env node

/**
 * Map File Structure — Categorizes project files by type and purpose.
 *
 * Usage: node map-file-structure.js /path/to/project
 *
 * Outputs a categorized file manifest to stdout.
 * Excludes node_modules, .git, dist, build, coverage, and other generated directories.
 */

const fs = require("fs");
const path = require("path");

const IGNORE_DIRS = new Set([
  "node_modules",
  ".git",
  "dist",
  "build",
  "coverage",
  ".next",
  ".nuxt",
  ".output",
  "__pycache__",
  ".venv",
  "venv",
  "env",
  ".tox",
  ".mypy_cache",
  ".pytest_cache",
  ".ruff_cache",
  "target",
  "vendor",
  ".cache",
  ".turbo",
  ".parcel-cache",
]);

const CATEGORIES = {
  components: {
    label: "Components / UI",
    extensions: [],
    patterns: [
      /components?\//i,
      /views?\//i,
      /pages?\//i,
      /layouts?\//i,
      /screens?\//i,
      /widgets?\//i,
    ],
  },
  utilities: {
    label: "Utilities / Helpers",
    extensions: [],
    patterns: [/utils?\//i, /helpers?\//i, /lib\//i, /shared\//i, /common\//i],
  },
  services: {
    label: "Services / API",
    extensions: [],
    patterns: [
      /services?\//i,
      /api\//i,
      /clients?\//i,
      /fetchers?\//i,
      /hooks?\//i,
    ],
  },
  state: {
    label: "State Management",
    extensions: [],
    patterns: [
      /stores?\//i,
      /reducers?\//i,
      /actions?\//i,
      /slices?\//i,
      /contexts?\//i,
      /state\//i,
    ],
  },
  types: {
    label: "Types / Interfaces",
    extensions: [".d.ts"],
    patterns: [/types?\//i, /interfaces?\//i, /models?\//i, /schemas?\//i],
  },
  styles: {
    label: "Styles",
    extensions: [".css", ".scss", ".sass", ".less", ".styl"],
    patterns: [/styles?\//i, /css\//i, /themes?\//i],
  },
  tests: {
    label: "Tests",
    extensions: [],
    patterns: [
      /\.test\./,
      /\.spec\./,
      /__tests__\//,
      /tests?\//i,
      /\.stories\./,
    ],
  },
  config: {
    label: "Configuration",
    extensions: [],
    patterns: [
      /\.config\./,
      /\.rc$/,
      /\.env/,
      /config\//i,
      /\.eslintrc/,
      /\.prettierrc/,
      /tsconfig/,
      /webpack/,
      /vite\.config/,
      /jest\.config/,
    ],
  },
  data: {
    label: "Data / Constants",
    extensions: [".json", ".yaml", ".yml", ".toml"],
    patterns: [
      /constants?\//i,
      /fixtures?\//i,
      /data\//i,
      /i18n\//i,
      /locales?\//i,
      /mocks?\//i,
    ],
  },
  docs: {
    label: "Documentation",
    extensions: [".md", ".mdx", ".txt", ".rst"],
    patterns: [/docs?\//i, /documentation\//i],
  },
};

function main() {
  const projectPath = process.argv[2];

  if (!projectPath) {
    console.error("Usage: node map-file-structure.js /path/to/project");
    process.exit(1);
  }

  const resolvedPath = path.resolve(projectPath);

  if (!fs.existsSync(resolvedPath)) {
    console.error(`Error: Directory not found: ${resolvedPath}`);
    process.exit(1);
  }

  const files = walkDirectory(resolvedPath);
  const categorized = categorizeFiles(files, resolvedPath);

  // Output report
  const report = [];
  report.push("# File Structure Report\n");
  report.push(`**Project:** ${resolvedPath}`);
  report.push(`**Total files:** ${files.length}`);
  report.push(`**Date:** ${new Date().toISOString().split("T")[0]}\n`);

  // Summary table
  report.push("## Summary\n");
  report.push("| Category | Count |");
  report.push("|----------|-------|");
  for (const [key, cat] of Object.entries(CATEGORIES)) {
    const count = categorized[key]?.length || 0;
    if (count > 0) {
      report.push(`| ${cat.label} | ${count} |`);
    }
  }
  const uncategorizedCount = categorized.uncategorized?.length || 0;
  if (uncategorizedCount > 0) {
    report.push(`| Uncategorized | ${uncategorizedCount} |`);
  }
  report.push("");

  // Extension breakdown
  const extCounts = {};
  for (const file of files) {
    const ext = path.extname(file) || "(no extension)";
    extCounts[ext] = (extCounts[ext] || 0) + 1;
  }
  report.push("## File Types\n");
  report.push("| Extension | Count |");
  report.push("|-----------|-------|");
  for (const [ext, count] of Object.entries(extCounts).sort(
    (a, b) => b[1] - a[1]
  )) {
    report.push(`| ${ext} | ${count} |`);
  }
  report.push("");

  // Detailed categories
  for (const [key, cat] of Object.entries(CATEGORIES)) {
    const files = categorized[key];
    if (files && files.length > 0) {
      report.push(`## ${cat.label} (${files.length} files)\n`);
      for (const file of files.sort()) {
        report.push(`- ${file}`);
      }
      report.push("");
    }
  }

  if (categorized.uncategorized?.length > 0) {
    report.push(
      `## Uncategorized (${categorized.uncategorized.length} files)\n`
    );
    for (const file of categorized.uncategorized.sort()) {
      report.push(`- ${file}`);
    }
    report.push("");
  }

  console.log(report.join("\n"));
}

function walkDirectory(dir) {
  const files = [];

  function walk(currentDir) {
    let entries;
    try {
      entries = fs.readdirSync(currentDir, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      if (IGNORE_DIRS.has(entry.name)) continue;
      if (entry.name.startsWith(".") && entry.isDirectory()) continue;

      const fullPath = path.join(currentDir, entry.name);

      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.isFile()) {
        files.push(fullPath);
      }
    }
  }

  walk(dir);
  return files;
}

function categorizeFiles(files, basePath) {
  const result = {};
  for (const key of Object.keys(CATEGORIES)) {
    result[key] = [];
  }
  result.uncategorized = [];

  for (const file of files) {
    const relativePath = path.relative(basePath, file);
    const ext = path.extname(file);
    let categorized = false;

    for (const [key, cat] of Object.entries(CATEGORIES)) {
      // Check extension match
      if (cat.extensions.includes(ext)) {
        result[key].push(relativePath);
        categorized = true;
        break;
      }

      // Check pattern match
      for (const pattern of cat.patterns) {
        if (pattern.test(relativePath)) {
          result[key].push(relativePath);
          categorized = true;
          break;
        }
      }

      if (categorized) break;
    }

    if (!categorized) {
      result.uncategorized.push(relativePath);
    }
  }

  return result;
}

main();
