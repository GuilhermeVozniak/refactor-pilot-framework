#!/usr/bin/env bash
# =============================================================================
# analyze-project.sh — Extract metadata from project configuration files
#
# Usage: ./analyze-project.sh /path/to/project
#
# Outputs a structured markdown report covering:
#   - Project identity and tech stack
#   - Dependencies (production vs. dev, key packages)
#   - Build scripts and tooling
#   - CI/CD configuration
# =============================================================================

set -euo pipefail

PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "Usage: ./analyze-project.sh /path/to/project" >&2
  exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "Error: Directory not found: $PROJECT_PATH" >&2
  exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

echo "# Project Metadata Report"
echo ""
echo "**Analyzed:** $PROJECT_PATH"
echo "**Date:** $(date +%Y-%m-%d)"
echo ""

# ---------------------------------------------------------------------------
# Detect and analyze manifest files
# ---------------------------------------------------------------------------

found_manifest=false

# --- package.json (Node.js) ---
if [[ -f "$PROJECT_PATH/package.json" ]]; then
  found_manifest=true
  echo "## Node.js: package.json"
  echo ""

  # Project identity
  echo "### Project Identity"
  name=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(d.get('name','unnamed'))" 2>/dev/null || echo "unnamed")
  version=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(d.get('version','unversioned'))" 2>/dev/null || echo "unversioned")
  desc=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(d.get('description','none'))" 2>/dev/null || echo "none")
  license=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(d.get('license','none specified'))" 2>/dev/null || echo "none specified")
  echo "- **Name:** $name"
  echo "- **Version:** $version"
  echo "- **Description:** $desc"
  echo "- **License:** $license"
  echo ""

  # Dependencies
  echo "### Dependencies"
  prod_count=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(len(d.get('dependencies',{})))" 2>/dev/null || echo "0")
  dev_count=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(len(d.get('devDependencies',{})))" 2>/dev/null || echo "0")
  echo "- **Production:** $prod_count packages"
  echo "- **Development:** $dev_count packages"
  echo "- **Total:** $((prod_count + dev_count)) packages"
  echo ""

  # List production dependencies
  if [[ "$prod_count" -gt 0 ]]; then
    echo "**Production dependencies:**"
    python3 -c "
import json
d = json.load(open('$PROJECT_PATH/package.json'))
for k, v in sorted(d.get('dependencies', {}).items()):
    print(f'- {k}: {v}')
" 2>/dev/null || echo "- (unable to parse)"
    echo ""
  fi

  # List dev dependencies
  if [[ "$dev_count" -gt 0 ]]; then
    echo "**Dev dependencies:**"
    python3 -c "
import json
d = json.load(open('$PROJECT_PATH/package.json'))
for k, v in sorted(d.get('devDependencies', {}).items()):
    print(f'- {k}: {v}')
" 2>/dev/null || echo "- (unable to parse)"
    echo ""
  fi

  # Scripts
  echo "### Scripts"
  python3 -c "
import json
d = json.load(open('$PROJECT_PATH/package.json'))
scripts = d.get('scripts', {})
if scripts:
    for k, v in scripts.items():
        print(f'- \`{k}\`: \`{v}\`')
else:
    print('No scripts defined.')
" 2>/dev/null || echo "- (unable to parse)"
  echo ""

  # Framework detection
  echo "### Detected Frameworks"
  python3 -c "
import json
d = json.load(open('$PROJECT_PATH/package.json'))
all_deps = {**d.get('dependencies', {}), **d.get('devDependencies', {})}
frameworks = {
    'react': 'React', 'vue': 'Vue', 'angular': 'Angular', '@angular/core': 'Angular',
    'svelte': 'Svelte', 'next': 'Next.js', 'nuxt': 'Nuxt', 'express': 'Express',
    'fastify': 'Fastify', '@nestjs/core': 'NestJS', 'gatsby': 'Gatsby',
    'remix': 'Remix', 'astro': 'Astro',
}
found = []
for pkg, name in frameworks.items():
    if pkg in all_deps:
        found.append(f'- **{name}** {all_deps[pkg]}')
if found:
    print('\n'.join(found))
else:
    print('No recognized frameworks detected.')

# TypeScript
if 'typescript' in all_deps:
    print(f'- **TypeScript** {all_deps[\"typescript\"]}')
" 2>/dev/null || echo "- (unable to detect)"
  echo ""
fi

# --- requirements.txt (Python pip) ---
if [[ -f "$PROJECT_PATH/requirements.txt" ]]; then
  found_manifest=true
  echo "## Python: requirements.txt"
  echo ""
  pkg_count=$(grep -cE '^[a-zA-Z]' "$PROJECT_PATH/requirements.txt" 2>/dev/null || echo "0")
  echo "- **Packages:** $pkg_count"
  echo ""
  echo "**Dependencies:**"
  grep -E '^[a-zA-Z]' "$PROJECT_PATH/requirements.txt" 2>/dev/null | while read -r line; do
    echo "- $line"
  done
  echo ""
fi

# --- pyproject.toml (Python modern) ---
if [[ -f "$PROJECT_PATH/pyproject.toml" ]]; then
  found_manifest=true
  echo "## Python: pyproject.toml"
  echo ""
  echo '```toml'
  head -50 "$PROJECT_PATH/pyproject.toml"
  echo '```'
  echo ""
  echo "*Parse the above with your AI tool for detailed analysis.*"
  echo ""
fi

# --- Cargo.toml (Rust) ---
if [[ -f "$PROJECT_PATH/Cargo.toml" ]]; then
  found_manifest=true
  echo "## Rust: Cargo.toml"
  echo ""
  echo '```toml'
  head -50 "$PROJECT_PATH/Cargo.toml"
  echo '```'
  echo ""
fi

# --- go.mod (Go) ---
if [[ -f "$PROJECT_PATH/go.mod" ]]; then
  found_manifest=true
  echo "## Go: go.mod"
  echo ""
  echo '```'
  cat "$PROJECT_PATH/go.mod"
  echo '```'
  echo ""
fi

# --- Gemfile (Ruby) ---
if [[ -f "$PROJECT_PATH/Gemfile" ]]; then
  found_manifest=true
  echo "## Ruby: Gemfile"
  echo ""
  gem_count=$(grep -cE "^\s*gem " "$PROJECT_PATH/Gemfile" 2>/dev/null || echo "0")
  echo "- **Gems:** $gem_count"
  echo ""
fi

if [[ "$found_manifest" == "false" ]]; then
  echo "⚠️ No recognized project manifest found."
  echo ""
fi

# ---------------------------------------------------------------------------
# Detect tooling configuration
# ---------------------------------------------------------------------------

echo "## Tooling Configuration"
echo ""

declare -A TOOLS=(
  ["ESLint"]=".eslintrc .eslintrc.js .eslintrc.json .eslintrc.yml eslint.config.js eslint.config.mjs"
  ["Prettier"]=".prettierrc .prettierrc.js .prettierrc.json prettier.config.js"
  ["TypeScript"]="tsconfig.json"
  ["Babel"]=".babelrc babel.config.js babel.config.json"
  ["Webpack"]="webpack.config.js webpack.config.ts"
  ["Vite"]="vite.config.js vite.config.ts vite.config.mjs"
  ["Rollup"]="rollup.config.js rollup.config.ts"
  ["Jest"]="jest.config.js jest.config.ts jest.config.json"
  ["Vitest"]="vitest.config.js vitest.config.ts"
  ["Tailwind CSS"]="tailwind.config.js tailwind.config.ts"
  ["Docker"]="Dockerfile docker-compose.yml docker-compose.yaml"
  ["Husky"]=".husky"
  ["Makefile"]="Makefile"
)

tool_found=false
for tool in "${!TOOLS[@]}"; do
  for file in ${TOOLS[$tool]}; do
    if [[ -e "$PROJECT_PATH/$file" ]]; then
      echo "- **$tool** — \`$file\`"
      tool_found=true
      break
    fi
  done
done

if [[ "$tool_found" == "false" ]]; then
  echo "No recognized tooling configuration files found."
fi
echo ""

# ---------------------------------------------------------------------------
# Detect CI/CD
# ---------------------------------------------------------------------------

echo "## CI/CD Configuration"
echo ""

ci_found=false
declare -A CI_CONFIGS=(
  ["GitHub Actions"]=".github/workflows"
  ["GitLab CI"]=".gitlab-ci.yml"
  ["CircleCI"]=".circleci"
  ["Jenkins"]="Jenkinsfile"
  ["Travis CI"]=".travis.yml"
  ["Azure Pipelines"]="azure-pipelines.yml"
  ["Bitbucket Pipelines"]="bitbucket-pipelines.yml"
  ["Buildkite"]=".buildkite"
)

for ci in "${!CI_CONFIGS[@]}"; do
  if [[ -e "$PROJECT_PATH/${CI_CONFIGS[$ci]}" ]]; then
    echo "- **$ci** — \`${CI_CONFIGS[$ci]}\`"
    ci_found=true
  fi
done

if [[ "$ci_found" == "false" ]]; then
  echo "No recognized CI/CD configuration found."
fi
