# Prompt: Analyze Code Coverage

> **Phase:** 1 — Gather Insights
> **Purpose:** Assess existing test coverage to identify untested areas and prioritize safety net generation.
> **Input:** Code coverage report output (from Istanbul/nyc, coverage.py, lcov, etc.)

## The Prompt

```
Analyze this code coverage report and produce an assessment for a refactoring effort.

1. **Coverage Summary**
   - Overall line coverage percentage
   - Overall branch coverage percentage
   - Overall function coverage percentage

2. **Well-Tested Areas** (>80% coverage)
   List files/modules with high coverage. These are safer to refactor because
   existing tests will catch regressions.

3. **Undertested Areas** (<50% coverage)
   List files/modules with low coverage. These need safety net tests
   (Phase 2) before refactoring.

4. **Untested Files** (0% coverage)
   List files with no test coverage at all. Flag as HIGH RISK for refactoring.

5. **Coverage Gaps by Type**
   - Untested error handling paths
   - Untested edge cases (empty inputs, boundary values)
   - Untested integration points (API calls, event handlers)
   - Untested conditional branches

6. **Refactoring Risk Assessment**
   Based on coverage data, rank the refactoring targets by risk:
   - LOW RISK: High coverage, tests will catch regressions
   - MEDIUM RISK: Partial coverage, some test generation needed
   - HIGH RISK: Low/no coverage, extensive test generation needed

7. **Recommended Testing Priority**
   Which files should get safety-net tests first? Order by:
   - Importance to the refactoring effort
   - Current coverage gap (lowest coverage = highest priority)
   - Complexity of the code (more complex = more tests needed)

---

COVERAGE REPORT:

[Paste your coverage report output here]

If you don't have a coverage report, generate one with:
  JavaScript: npx nyc --reporter=text npm test
  Python:     pytest --cov=src --cov-report=term-missing
  Go:         go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out
```

## How to Generate Coverage Reports

```bash
# JavaScript/TypeScript (Jest)
npx jest --coverage --coverageReporters=text

# JavaScript/TypeScript (Vitest)
npx vitest --coverage

# Python
pytest --cov=src --cov-report=term-missing

# Go
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
```
