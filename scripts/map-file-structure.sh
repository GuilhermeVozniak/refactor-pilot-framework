#!/usr/bin/env bash
# =============================================================================
# map-file-structure.sh — Categorize project files by type and purpose
#
# Usage: ./map-file-structure.sh /path/to/project
#
# Outputs a categorized file manifest to stdout.
# Excludes node_modules, .git, dist, build, coverage, and other generated dirs.
# =============================================================================

set -euo pipefail

PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "Usage: ./map-file-structure.sh /path/to/project" >&2
  exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "Error: Directory not found: $PROJECT_PATH" >&2
  exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

# ---------------------------------------------------------------------------
# Collect all files (excluding ignored directories)
# ---------------------------------------------------------------------------

IGNORE_PATTERN='node_modules|\.git/|dist/|build/|coverage/|\.next/|\.nuxt/|__pycache__|\.venv|venv/|\.tox|\.mypy_cache|\.pytest_cache|target/|vendor/|\.cache/|\.turbo|\.parcel-cache'

all_files=$(find "$PROJECT_PATH" -type f 2>/dev/null \
  | grep -vE "$IGNORE_PATTERN" 2>/dev/null \
  | sed "s|^$PROJECT_PATH/||" \
  | sort) || true

if [[ -z "$all_files" ]]; then
  total_count=0
else
  total_count=$(echo "$all_files" | wc -l | tr -d ' ')
fi

echo "# File Structure Report"
echo ""
echo "**Project:** $PROJECT_PATH"
echo "**Total files:** $total_count"
echo "**Date:** $(date +%Y-%m-%d)"
echo ""

# ---------------------------------------------------------------------------
# Categorize files
# ---------------------------------------------------------------------------

categorize_file() {
  local file="$1"

  # Tests (check first — test files can be in any directory)
  if echo "$file" | grep -qE '\.test\.|\.spec\.|__tests__/|/tests?/.*\.(ts|js|py|rs|go)$|\.stories\.'; then
    echo "tests"
    return
  fi

  # Types / Interfaces
  if echo "$file" | grep -qE '\.d\.ts$|/types?/|/interfaces?/|/models?/|/schemas?/'; then
    echo "types"
    return
  fi

  # Styles
  if echo "$file" | grep -qE '\.(css|scss|sass|less|styl)$|/styles?/|/css/|/themes?/'; then
    echo "styles"
    return
  fi

  # Configuration
  if echo "$file" | grep -qE '\.config\.|\.rc$|\.env|/config/|\.eslintrc|\.prettierrc|tsconfig|webpack|vite\.config|jest\.config|Dockerfile|docker-compose|Makefile|\.yml$|\.yaml$'; then
    echo "config"
    return
  fi

  # Documentation
  if echo "$file" | grep -qE '\.(md|mdx|txt|rst)$|/docs?/|/documentation/'; then
    echo "docs"
    return
  fi

  # Components / UI
  if echo "$file" | grep -qE '/components?/|/views?/|/pages?/|/layouts?/|/screens?/|/widgets?/'; then
    echo "components"
    return
  fi

  # Services / API
  if echo "$file" | grep -qE '/services?/|/api/|/clients?/|/fetchers?/|/hooks?/'; then
    echo "services"
    return
  fi

  # State Management
  if echo "$file" | grep -qE '/stores?/|/reducers?/|/actions?/|/slices?/|/contexts?/|/state/'; then
    echo "state"
    return
  fi

  # Utilities / Helpers
  if echo "$file" | grep -qE '/utils?/|/helpers?/|/lib/|/shared/|/common/'; then
    echo "utilities"
    return
  fi

  # Data files
  if echo "$file" | grep -qE '\.json$|/constants?/|/fixtures?/|/data/|/i18n/|/locales?/|/mocks?/'; then
    echo "data"
    return
  fi

  echo "uncategorized"
}

# Categorize all files into temp files
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

categories=(components utilities services state types styles tests config data docs uncategorized)
for cat in "${categories[@]}"; do
  touch "$tmpdir/$cat"
done

while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  cat=$(categorize_file "$file")
  echo "$file" >> "$tmpdir/$cat"
done <<< "$all_files"

# ---------------------------------------------------------------------------
# Output summary table
# ---------------------------------------------------------------------------

echo "## Summary"
echo ""
echo "| Category | Count |"
echo "|----------|-------|"

declare -A LABELS=(
  ["components"]="Components / UI"
  ["utilities"]="Utilities / Helpers"
  ["services"]="Services / API"
  ["state"]="State Management"
  ["types"]="Types / Interfaces"
  ["styles"]="Styles"
  ["tests"]="Tests"
  ["config"]="Configuration"
  ["data"]="Data / Constants"
  ["docs"]="Documentation"
  ["uncategorized"]="Uncategorized"
)

for cat in "${categories[@]}"; do
  count=$(wc -l < "$tmpdir/$cat" | tr -d ' ')
  if [[ "$count" -gt 0 ]]; then
    echo "| ${LABELS[$cat]} | $count |"
  fi
done
echo ""

# ---------------------------------------------------------------------------
# File type breakdown
# ---------------------------------------------------------------------------

echo "## File Types"
echo ""
echo "| Extension | Count |"
echo "|-----------|-------|"

echo "$all_files" | while IFS= read -r file; do
  ext="${file##*.}"
  if [[ "$ext" == "$file" ]]; then
    echo "(no extension)"
  else
    echo ".$ext"
  fi
done | sort | uniq -c | sort -rn | while read -r count ext; do
  echo "| $ext | $count |"
done
echo ""

# ---------------------------------------------------------------------------
# Detailed file lists per category
# ---------------------------------------------------------------------------

for cat in "${categories[@]}"; do
  count=$(wc -l < "$tmpdir/$cat" | tr -d ' ')
  if [[ "$count" -gt 0 ]]; then
    echo "## ${LABELS[$cat]} ($count files)"
    echo ""
    while IFS= read -r file; do
      echo "- $file"
    done < "$tmpdir/$cat"
    echo ""
  fi
done
