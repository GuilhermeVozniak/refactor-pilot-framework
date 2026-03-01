#!/usr/bin/env bash
# =============================================================================
# run-tests.sh — Test suite for Refactor Pilot scripts
#
# Usage: ./tests/run-tests.sh
#
# Runs all tests and reports pass/fail for each assertion.
# Exit code 0 = all tests passed, 1 = at least one failure.
# =============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FIXTURES="$SCRIPT_DIR/fixtures"

NODE_FIXTURE="$FIXTURES/sample-node-project"
PYTHON_FIXTURE="$FIXTURES/sample-python-project"
EMPTY_FIXTURE="$FIXTURES/empty-project"

passed=0
failed=0
total=0

# --- Helpers ----------------------------------------------------------------

pass() {
  local msg="$1"
  total=$((total + 1))
  passed=$((passed + 1))
  echo "  ✅ $msg"
}

fail() {
  local msg="$1"
  total=$((total + 1))
  failed=$((failed + 1))
  echo "  ❌ $msg"
}

assert_contains() {
  local output="$1"
  local pattern="$2"
  local label="$3"
  if echo "$output" | grep -qE "$pattern"; then
    pass "$label"
  else
    fail "$label (expected pattern: $pattern)"
  fi
}

assert_not_contains() {
  local output="$1"
  local pattern="$2"
  local label="$3"
  if echo "$output" | grep -qE "$pattern"; then
    fail "$label (should NOT contain: $pattern)"
  else
    pass "$label"
  fi
}

assert_exit_code() {
  local actual="$1"
  local expected="$2"
  local label="$3"
  if [[ "$actual" -eq "$expected" ]]; then
    pass "$label"
  else
    fail "$label (expected exit $expected, got $actual)"
  fi
}

assert_file_exists() {
  local filepath="$1"
  local label="$2"
  if [[ -f "$filepath" ]] || [[ -d "$filepath" ]]; then
    pass "$label"
  else
    fail "$label (not found: $filepath)"
  fi
}

assert_line_count_gte() {
  local output="$1"
  local min="$2"
  local label="$3"
  local count
  count=$(echo "$output" | wc -l | tr -d ' ')
  if [[ "$count" -ge "$min" ]]; then
    pass "$label (got $count lines)"
  else
    fail "$label (expected >= $min lines, got $count)"
  fi
}

# =============================================================================
#  TEST SUITE: analyze-project.sh
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  analyze-project.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# --- No arguments ---
echo ""
echo "  [no arguments]"
output=$("$PROJECT_ROOT/scripts/analyze-project.sh" 2>&1 || true)
exit_code=$?
# The script should print usage to stderr and exit non-zero
assert_contains "$output" "Usage" "prints usage message"

# --- Non-existent directory ---
echo ""
echo "  [non-existent directory]"
output=$("$PROJECT_ROOT/scripts/analyze-project.sh" /tmp/does-not-exist-12345 2>&1 || true)
assert_contains "$output" "[Ee]rror|not found" "prints error for missing directory"

# --- Empty project (no manifest) ---
echo ""
echo "  [empty project]"
output=$("$PROJECT_ROOT/scripts/analyze-project.sh" "$EMPTY_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully for empty project"
assert_contains "$output" "No recognized project manifest" "detects missing manifest"
assert_contains "$output" "# Project Metadata Report" "outputs markdown heading"
assert_contains "$output" "Tooling Configuration" "includes tooling section"
assert_contains "$output" "CI/CD Configuration" "includes CI/CD section"

# --- Node.js project ---
echo ""
echo "  [Node.js project]"
output=$("$PROJECT_ROOT/scripts/analyze-project.sh" "$NODE_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully"
assert_contains "$output" "# Project Metadata Report" "outputs markdown heading"
assert_contains "$output" "sample-dashboard" "detects project name"
assert_contains "$output" "2\.1\.0" "detects project version"
assert_contains "$output" "MIT" "detects license"
assert_contains "$output" "Production.*5 packages" "counts production dependencies"
assert_contains "$output" "Development.*5 packages" "counts dev dependencies"
assert_contains "$output" "react" "lists react dependency"
assert_contains "$output" "axios" "lists axios dependency"
assert_contains "$output" "typescript" "lists typescript dependency"
assert_contains "$output" "build.*vite build" "detects build script"
assert_contains "$output" "test.*vitest run" "detects test script"
assert_contains "$output" "React" "detects React framework"
assert_contains "$output" "TypeScript" "detects TypeScript"
assert_contains "$output" "Vite" "detects Vite tooling (from vite.config.ts)"
assert_contains "$output" "GitHub Actions" "detects GitHub Actions CI"

# --- Python project ---
echo ""
echo "  [Python project]"
output=$("$PROJECT_ROOT/scripts/analyze-project.sh" "$PYTHON_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully"
assert_contains "$output" "Python" "detects Python project type"
assert_contains "$output" "flask" "lists flask dependency"
assert_contains "$output" "sqlalchemy" "lists sqlalchemy dependency"
assert_contains "$output" "Packages.*4" "counts packages"

# =============================================================================
#  TEST SUITE: map-file-structure.sh
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  map-file-structure.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# --- No arguments ---
echo ""
echo "  [no arguments]"
output=$("$PROJECT_ROOT/scripts/map-file-structure.sh" 2>&1 || true)
assert_contains "$output" "Usage" "prints usage message"

# --- Non-existent directory ---
echo ""
echo "  [non-existent directory]"
output=$("$PROJECT_ROOT/scripts/map-file-structure.sh" /tmp/does-not-exist-12345 2>&1 || true)
assert_contains "$output" "[Ee]rror|not found" "prints error for missing directory"

# --- Empty project ---
echo ""
echo "  [empty project]"
output=$("$PROJECT_ROOT/scripts/map-file-structure.sh" "$EMPTY_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully for empty project"
assert_contains "$output" "# File Structure Report" "outputs markdown heading"
assert_contains "$output" "Total files.*0" "reports 0 files"

# --- Node.js project ---
echo ""
echo "  [Node.js project]"
output=$("$PROJECT_ROOT/scripts/map-file-structure.sh" "$NODE_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully"
assert_contains "$output" "# File Structure Report" "outputs markdown heading"
assert_contains "$output" "Total files" "reports total file count"
assert_contains "$output" "## Summary" "includes summary table"
assert_contains "$output" "## File Types" "includes file type breakdown"

# Category detection
assert_contains "$output" "Components" "detects components category"
assert_contains "$output" "Utilities" "detects utilities category"
assert_contains "$output" "Services" "detects services category"
assert_contains "$output" "Types" "detects types category"
assert_contains "$output" "Styles" "detects styles category"
assert_contains "$output" "Tests" "detects tests category"
assert_contains "$output" "Configuration" "detects configuration category"

# Specific files categorized correctly
assert_contains "$output" "src/components/UserCard.tsx" "lists UserCard.tsx"
assert_contains "$output" "src/utils/validate.ts" "lists validate.ts"
assert_contains "$output" "src/services/api.ts" "lists api.ts"
assert_contains "$output" "src/styles/main.css" "lists main.css"

# File type breakdown
assert_contains "$output" "\.tsx" "reports .tsx extension"
assert_contains "$output" "\.ts" "reports .ts extension"
assert_contains "$output" "\.css" "reports .css extension"

# =============================================================================
#  TEST SUITE: generate-file-summaries.sh
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  generate-file-summaries.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# --- No arguments ---
echo ""
echo "  [no arguments]"
output=$("$PROJECT_ROOT/scripts/generate-file-summaries.sh" 2>&1 || true)
assert_contains "$output" "Usage" "prints usage message"

# --- Non-existent directory ---
echo ""
echo "  [non-existent directory]"
output=$("$PROJECT_ROOT/scripts/generate-file-summaries.sh" /tmp/does-not-exist-12345 2>&1 || true)
assert_contains "$output" "[Ee]rror|not found" "prints error for missing directory"

# --- Empty project ---
echo ""
echo "  [empty project]"
output=$("$PROJECT_ROOT/scripts/generate-file-summaries.sh" "$EMPTY_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully for empty project"
assert_contains "$output" "Found 0 source files" "reports 0 files found"

# --- Node.js project ---
echo ""
echo "  [Node.js project]"

# Clean up any previous output
rm -rf "$NODE_FIXTURE/refactor-notes" 2>/dev/null || true

output=$("$PROJECT_ROOT/scripts/generate-file-summaries.sh" "$NODE_FIXTURE" 2>&1)
exit_code=$?
assert_exit_code "$exit_code" 0 "exits successfully"

# Check output messages
assert_contains "$output" "Found [0-9]+ source files" "reports files found"
assert_contains "$output" "Generated [0-9]+ analysis prompts" "reports generated count"
assert_contains "$output" "Output directory" "shows output directory"
assert_not_contains "$output" "UserCard.test" "excludes test files from analysis"

# Check generated files exist
OUTPUT_DIR="$NODE_FIXTURE/refactor-notes/file-analysis"
assert_file_exists "$OUTPUT_DIR" "creates output directory"

# Check that analysis files were generated for key source files
# (filenames have / replaced with __ and . replaced with -)
found_any=false
for f in "$OUTPUT_DIR"/*.md; do
  if [[ -f "$f" ]]; then
    found_any=true
    break
  fi
done
if [[ "$found_any" == "true" ]]; then
  pass "generates .md analysis files"
else
  fail "generates .md analysis files (no .md files found in $OUTPUT_DIR)"
fi

# Check content of a generated analysis file
if [[ "$found_any" == "true" ]]; then
  sample_file=$(ls "$OUTPUT_DIR"/*.md | head -1)
  sample_content=$(cat "$sample_file")
  assert_contains "$sample_content" "# File Analysis" "analysis file has correct heading"
  assert_contains "$sample_content" "Purpose" "analysis file includes Purpose section"
  assert_contains "$sample_content" "Exports" "analysis file includes Exports section"
  assert_contains "$sample_content" "Imports" "analysis file includes Imports section"
  assert_contains "$sample_content" "Complexity" "analysis file includes Complexity section"
  assert_contains "$sample_content" "Code Smells" "analysis file includes Code Smells section"
  assert_contains "$sample_content" "Data Flow" "analysis file includes Data Flow section"
  assert_contains "$sample_content" "Refactoring" "analysis file includes Refactoring section"
  assert_contains "$sample_content" "Source Code" "analysis file includes source code block"
  assert_contains "$sample_content" "Lines:" "analysis file includes line count"
fi

# --- Custom extensions filter ---
echo ""
echo "  [custom extensions filter]"
rm -rf "$NODE_FIXTURE/refactor-notes" 2>/dev/null || true

output=$("$PROJECT_ROOT/scripts/generate-file-summaries.sh" "$NODE_FIXTURE" "tsx" 2>&1)
assert_contains "$output" "Generated" "runs with custom extension filter"

# Count .tsx files only (UserCard.tsx and Dashboard.tsx, not test files)
generated_count=$(echo "$output" | grep -oE 'Generated [0-9]+' | grep -oE '[0-9]+')
if [[ "$generated_count" -eq 2 ]]; then
  pass "filters to only .tsx files (found 2)"
else
  fail "filters to only .tsx files (expected 2, got ${generated_count:-0})"
fi

# Clean up generated files from fixtures
rm -rf "$NODE_FIXTURE/refactor-notes" 2>/dev/null || true

# =============================================================================
#  TEST SUITE: Cross-script consistency
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Cross-script consistency"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# All scripts should produce valid markdown
for script in analyze-project.sh map-file-structure.sh; do
  output=$("$PROJECT_ROOT/scripts/$script" "$NODE_FIXTURE" 2>&1)
  assert_contains "$output" "^#" "$script outputs markdown with headings"
done

# All scripts should include a date
for script in analyze-project.sh map-file-structure.sh; do
  output=$("$PROJECT_ROOT/scripts/$script" "$NODE_FIXTURE" 2>&1)
  assert_contains "$output" "Date.*[0-9]{4}-[0-9]{2}-[0-9]{2}" "$script includes date"
done

# All scripts should be executable
for script in analyze-project.sh map-file-structure.sh generate-file-summaries.sh; do
  if [[ -x "$PROJECT_ROOT/scripts/$script" ]]; then
    pass "$script is executable"
  else
    fail "$script is executable"
  fi
done

# All scripts should have a shebang
for script in analyze-project.sh map-file-structure.sh generate-file-summaries.sh; do
  first_line=$(head -1 "$PROJECT_ROOT/scripts/$script")
  if echo "$first_line" | grep -q "^#!/"; then
    pass "$script has shebang line"
  else
    fail "$script has shebang line"
  fi
done

# =============================================================================
#  RESULTS
# =============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  RESULTS: $passed/$total passed, $failed failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [[ "$failed" -gt 0 ]]; then
  exit 1
else
  echo "All tests passed."
  exit 0
fi
