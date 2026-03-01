#!/usr/bin/env bash
# =============================================================================
# capture-baselines.sh — Capture performance and quality baselines before refactoring
#
# Usage: ./capture-baselines.sh /path/to/project
#
# Captures:
#   - Test suite results (pass/fail counts)
#   - Code coverage (if test runner supports it)
#   - Build output size (dist/build directory)
#   - Build time
#   - Line counts by file type
#   - Linter warning counts
#
# Output: Creates refactor-notes/baselines.md with all measurements.
# =============================================================================

set -uo pipefail

PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "Usage: ./capture-baselines.sh /path/to/project" >&2
  exit 1
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "Error: Directory not found: $PROJECT_PATH" >&2
  exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

OUTPUT_DIR="$PROJECT_PATH/refactor-notes"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/baselines.md"

echo "# Performance & Quality Baselines" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Project:** $PROJECT_PATH" >> "$OUTPUT_FILE"
echo "**Captured:** $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "These baselines were captured before refactoring. Compare against" >> "$OUTPUT_FILE"
echo "post-refactoring measurements to detect regressions." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Codebase size
# ---------------------------------------------------------------------------

echo "## Codebase Size" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Metric | Value |" >> "$OUTPUT_FILE"
echo "|--------|-------|" >> "$OUTPUT_FILE"

# Count files by extension
IGNORE='node_modules|\.git/|dist/|build/|coverage/|\.next/|__pycache__|\.venv|venv/|target/'

total_files=$(find "$PROJECT_PATH" -type f 2>/dev/null | grep -vE "$IGNORE" | wc -l | tr -d ' ')
echo "| Total files | $total_files |" >> "$OUTPUT_FILE"

# Count lines of code by type
for ext in ts tsx js jsx py rs go rb java css scss; do
  count=$(find "$PROJECT_PATH" -name "*.$ext" -type f 2>/dev/null \
    | grep -vE "$IGNORE" \
    | xargs wc -l 2>/dev/null \
    | tail -1 \
    | awk '{print $1}') || true
  if [[ -n "$count" && "$count" != "0" ]]; then
    echo "| Lines of .$ext | $count |" >> "$OUTPUT_FILE"
  fi
done
echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Build output size (if dist/build exists)
# ---------------------------------------------------------------------------

echo "## Build Output" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

build_found=false
for dir in dist build out .next; do
  full_path="$PROJECT_PATH/$dir"
  if [[ -d "$full_path" ]]; then
    build_found=true
    size=$(du -sh "$full_path" 2>/dev/null | cut -f1)
    file_count=$(find "$full_path" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "| \`$dir/\` size | $size |" >> "$OUTPUT_FILE"
    echo "| \`$dir/\` files | $file_count |" >> "$OUTPUT_FILE"
  fi
done

if [[ "$build_found" == "false" ]]; then
  echo "No build output directory found (dist/, build/, out/, .next/)." >> "$OUTPUT_FILE"
  echo "Run the build command first to capture build size baselines." >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Package / dependency count
# ---------------------------------------------------------------------------

echo "## Dependencies" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [[ -f "$PROJECT_PATH/package.json" ]]; then
  prod=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(len(d.get('dependencies',{})))" 2>/dev/null || echo "?")
  dev=$(python3 -c "import json; d=json.load(open('$PROJECT_PATH/package.json')); print(len(d.get('devDependencies',{})))" 2>/dev/null || echo "?")
  echo "| Production dependencies | $prod |" >> "$OUTPUT_FILE"
  echo "| Dev dependencies | $dev |" >> "$OUTPUT_FILE"
elif [[ -f "$PROJECT_PATH/requirements.txt" ]]; then
  pkg_count=$(grep -cE '^[a-zA-Z]' "$PROJECT_PATH/requirements.txt" 2>/dev/null || echo "?")
  echo "| Python packages | $pkg_count |" >> "$OUTPUT_FILE"
else
  echo "No recognized package manifest found." >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Test suite (attempt to detect and run)
# ---------------------------------------------------------------------------

echo "## Test Suite" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

test_found=false

# Count test files
test_file_count=$(find "$PROJECT_PATH" -type f \( -name "*.test.*" -o -name "*.spec.*" -o -path "*__tests__*" -o -path "*/tests/test_*" \) 2>/dev/null \
  | grep -vE "$IGNORE" \
  | wc -l | tr -d ' ')
echo "| Test files found | $test_file_count |" >> "$OUTPUT_FILE"

if [[ "$test_file_count" -gt 0 ]]; then
  test_found=true
fi

if [[ "$test_found" == "false" ]]; then
  echo "" >> "$OUTPUT_FILE"
  echo "No test files detected. Test coverage baseline cannot be captured." >> "$OUTPUT_FILE"
  echo "Consider generating tests in Phase 2 before refactoring." >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Linter warnings (attempt to detect)
# ---------------------------------------------------------------------------

echo "## Code Quality Indicators" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Count TODO/FIXME/HACK comments
todo_count=$(grep -rE '(TODO|FIXME|HACK|XXX|WORKAROUND)' "$PROJECT_PATH" \
  --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
  --include="*.py" --include="*.rs" --include="*.go" \
  2>/dev/null | grep -vE "$IGNORE" | wc -l | tr -d ' ') || true
echo "| TODO/FIXME/HACK comments | ${todo_count:-0} |" >> "$OUTPUT_FILE"

# Count !important in CSS
important_count=$(grep -r '!important' "$PROJECT_PATH" \
  --include="*.css" --include="*.scss" --include="*.less" \
  2>/dev/null | grep -vE "$IGNORE" | wc -l | tr -d ' ') || true
echo "| CSS !important count | ${important_count:-0} |" >> "$OUTPUT_FILE"

# Count console.log statements
console_count=$(grep -rE 'console\.(log|warn|error|debug)' "$PROJECT_PATH" \
  --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
  2>/dev/null | grep -vE "$IGNORE" | wc -l | tr -d ' ') || true
echo "| console.* statements | ${console_count:-0} |" >> "$OUTPUT_FILE"

# Count 'any' type usage in TypeScript
any_count=$(grep -rE ': any\b|<any>|as any' "$PROJECT_PATH" \
  --include="*.ts" --include="*.tsx" \
  2>/dev/null | grep -vE "$IGNORE" | wc -l | tr -d ' ') || true
if [[ "${any_count:-0}" -gt 0 ]]; then
  echo "| TypeScript \`any\` usage | $any_count |" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "## Notes" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "To capture additional baselines:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- **Build time:** Run \`time npm run build\` and record the duration" >> "$OUTPUT_FILE"
echo "- **Test duration:** Run \`time npm test\` and record the duration" >> "$OUTPUT_FILE"
echo "- **Coverage:** Run \`npx jest --coverage\` or equivalent" >> "$OUTPUT_FILE"
echo "- **Bundle analysis:** Run \`npx webpack-bundle-analyzer\` or \`npx vite-bundle-visualizer\`" >> "$OUTPUT_FILE"
echo "- **Lighthouse score:** Run Lighthouse in Chrome DevTools for web projects" >> "$OUTPUT_FILE"

echo ""
echo "Baselines captured: $OUTPUT_FILE"
