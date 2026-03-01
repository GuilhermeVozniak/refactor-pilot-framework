#!/usr/bin/env node

/**
 * Analyze Project — Extracts metadata from project configuration files.
 *
 * Usage: node analyze-project.js /path/to/project
 *
 * Outputs a structured markdown report to stdout covering:
 * - Project identity and tech stack
 * - Dependencies (production vs. dev, counts, key packages)
 * - Build scripts and tooling
 * - Red flags (outdated packages, missing configs, etc.)
 */

const fs = require("fs");
const path = require("path");

function main() {
  const projectPath = process.argv[2];

  if (!projectPath) {
    console.error("Usage: node analyze-project.js /path/to/project");
    process.exit(1);
  }

  const resolvedPath = path.resolve(projectPath);

  if (!fs.existsSync(resolvedPath)) {
    console.error(`Error: Directory not found: ${resolvedPath}`);
    process.exit(1);
  }

  const report = [];
  report.push("# Project Metadata Report\n");
  report.push(`**Analyzed:** ${resolvedPath}`);
  report.push(`**Date:** ${new Date().toISOString().split("T")[0]}\n`);

  // Detect project type and read manifest
  const manifests = detectManifests(resolvedPath);

  if (manifests.length === 0) {
    report.push(
      "⚠️ No recognized project manifest found (package.json, requirements.txt, etc.)\n"
    );
    console.log(report.join("\n"));
    return;
  }

  for (const manifest of manifests) {
    report.push(`## ${manifest.type}: ${manifest.filename}\n`);
    report.push(...analyzeManifest(manifest));
    report.push("");
  }

  // Detect tooling configuration
  report.push("## Tooling Configuration\n");
  report.push(...detectTooling(resolvedPath));

  // Detect CI/CD
  report.push("\n## CI/CD Configuration\n");
  report.push(...detectCI(resolvedPath));

  console.log(report.join("\n"));
}

function detectManifests(projectPath) {
  const manifests = [];
  const checks = [
    { file: "package.json", type: "Node.js" },
    { file: "requirements.txt", type: "Python (pip)" },
    { file: "pyproject.toml", type: "Python (modern)" },
    { file: "setup.py", type: "Python (setuptools)" },
    { file: "Cargo.toml", type: "Rust" },
    { file: "go.mod", type: "Go" },
    { file: "Gemfile", type: "Ruby" },
    { file: "pom.xml", type: "Java (Maven)" },
    { file: "build.gradle", type: "Java (Gradle)" },
    { file: "composer.json", type: "PHP" },
  ];

  for (const check of checks) {
    const filePath = path.join(projectPath, check.file);
    if (fs.existsSync(filePath)) {
      manifests.push({
        type: check.type,
        filename: check.file,
        path: filePath,
        content: fs.readFileSync(filePath, "utf-8"),
      });
    }
  }

  return manifests;
}

function analyzeManifest(manifest) {
  const lines = [];

  if (manifest.type === "Node.js") {
    try {
      const pkg = JSON.parse(manifest.content);

      lines.push("### Project Identity");
      lines.push(`- **Name:** ${pkg.name || "unnamed"}`);
      lines.push(`- **Version:** ${pkg.version || "unversioned"}`);
      lines.push(`- **Description:** ${pkg.description || "none"}`);
      lines.push(`- **License:** ${pkg.license || "none specified"}`);
      lines.push("");

      // Detect framework
      const allDeps = {
        ...(pkg.dependencies || {}),
        ...(pkg.devDependencies || {}),
      };
      const frameworks = [];
      if (allDeps.react) frameworks.push(`React ${allDeps.react}`);
      if (allDeps.vue) frameworks.push(`Vue ${allDeps.vue}`);
      if (allDeps.angular) frameworks.push(`Angular ${allDeps.angular}`);
      if (allDeps["@angular/core"])
        frameworks.push(`Angular ${allDeps["@angular/core"]}`);
      if (allDeps.svelte) frameworks.push(`Svelte ${allDeps.svelte}`);
      if (allDeps.next) frameworks.push(`Next.js ${allDeps.next}`);
      if (allDeps.nuxt) frameworks.push(`Nuxt ${allDeps.nuxt}`);
      if (allDeps.express) frameworks.push(`Express ${allDeps.express}`);
      if (allDeps.fastify) frameworks.push(`Fastify ${allDeps.fastify}`);
      if (allDeps.nest) frameworks.push(`NestJS ${allDeps.nest}`);

      if (frameworks.length > 0) {
        lines.push(
          `### Framework: ${frameworks.join(", ")}`
        );
      }

      // Language detection
      if (allDeps.typescript || fs.existsSync(path.join(path.dirname(manifest.path), "tsconfig.json"))) {
        lines.push(
          `### Language: TypeScript ${allDeps.typescript || "(version in tsconfig)"}`
        );
      } else {
        lines.push("### Language: JavaScript");
      }
      lines.push("");

      // Dependencies
      const prodDeps = Object.keys(pkg.dependencies || {});
      const devDeps = Object.keys(pkg.devDependencies || {});
      lines.push("### Dependencies");
      lines.push(`- **Production:** ${prodDeps.length} packages`);
      lines.push(`- **Development:** ${devDeps.length} packages`);
      lines.push(`- **Total:** ${prodDeps.length + devDeps.length} packages`);
      lines.push("");

      if (prodDeps.length > 0) {
        lines.push("**Production dependencies:**");
        for (const dep of prodDeps.sort()) {
          lines.push(`- ${dep}: ${pkg.dependencies[dep]}`);
        }
        lines.push("");
      }

      if (devDeps.length > 0) {
        lines.push("**Dev dependencies:**");
        for (const dep of devDeps.sort()) {
          lines.push(`- ${dep}: ${pkg.devDependencies[dep]}`);
        }
        lines.push("");
      }

      // Scripts
      if (pkg.scripts) {
        lines.push("### Scripts");
        for (const [name, cmd] of Object.entries(pkg.scripts)) {
          lines.push(`- \`${name}\`: \`${cmd}\``);
        }
        lines.push("");
      }

      // Engines
      if (pkg.engines) {
        lines.push("### Engine Requirements");
        for (const [engine, version] of Object.entries(pkg.engines)) {
          lines.push(`- ${engine}: ${version}`);
        }
        lines.push("");
      }
    } catch (e) {
      lines.push(`⚠️ Failed to parse package.json: ${e.message}`);
    }
  } else {
    // For non-Node projects, output the raw content with basic analysis
    lines.push("### Raw Content");
    lines.push("```");
    lines.push(manifest.content.trim());
    lines.push("```");
    lines.push("");
    lines.push(
      "*Detailed parsing for this project type is not yet implemented. The raw content above can be analyzed manually or with an AI prompt.*"
    );
  }

  return lines;
}

function detectTooling(projectPath) {
  const lines = [];
  const tools = [
    { files: [".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", "eslint.config.js", "eslint.config.mjs"], name: "ESLint" },
    { files: [".prettierrc", ".prettierrc.js", ".prettierrc.json", "prettier.config.js"], name: "Prettier" },
    { files: ["tsconfig.json"], name: "TypeScript" },
    { files: [".babelrc", "babel.config.js", "babel.config.json"], name: "Babel" },
    { files: ["webpack.config.js", "webpack.config.ts"], name: "Webpack" },
    { files: ["vite.config.js", "vite.config.ts"], name: "Vite" },
    { files: ["rollup.config.js", "rollup.config.ts"], name: "Rollup" },
    { files: ["jest.config.js", "jest.config.ts", "jest.config.json"], name: "Jest" },
    { files: ["vitest.config.js", "vitest.config.ts"], name: "Vitest" },
    { files: [".stylelintrc", "stylelint.config.js"], name: "Stylelint" },
    { files: ["tailwind.config.js", "tailwind.config.ts"], name: "Tailwind CSS" },
    { files: [".husky"], name: "Husky (git hooks)" },
    { files: [".lintstagedrc", "lint-staged.config.js"], name: "lint-staged" },
    { files: ["docker-compose.yml", "docker-compose.yaml", "Dockerfile"], name: "Docker" },
    { files: ["Makefile"], name: "Make" },
  ];

  const found = [];
  for (const tool of tools) {
    for (const file of tool.files) {
      if (fs.existsSync(path.join(projectPath, file))) {
        found.push(`- **${tool.name}** — \`${file}\``);
        break;
      }
    }
  }

  if (found.length > 0) {
    lines.push(...found);
  } else {
    lines.push("No recognized tooling configuration files found.");
  }

  return lines;
}

function detectCI(projectPath) {
  const lines = [];
  const ciConfigs = [
    { path: ".github/workflows", name: "GitHub Actions" },
    { path: ".gitlab-ci.yml", name: "GitLab CI" },
    { path: ".circleci", name: "CircleCI" },
    { path: "Jenkinsfile", name: "Jenkins" },
    { path: ".travis.yml", name: "Travis CI" },
    { path: "azure-pipelines.yml", name: "Azure Pipelines" },
    { path: "bitbucket-pipelines.yml", name: "Bitbucket Pipelines" },
    { path: ".buildkite", name: "Buildkite" },
  ];

  const found = [];
  for (const ci of ciConfigs) {
    if (fs.existsSync(path.join(projectPath, ci.path))) {
      found.push(`- **${ci.name}** — \`${ci.path}\``);
    }
  }

  if (found.length > 0) {
    lines.push(...found);
  } else {
    lines.push("No recognized CI/CD configuration found.");
  }

  return lines;
}

main();
