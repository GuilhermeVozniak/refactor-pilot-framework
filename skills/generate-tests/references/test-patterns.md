# Test Generation Patterns

## Safety Net Test Principles

Safety net tests exist to lock down existing behavior, not to validate correctness.
They should pass against the current code exactly as it exists today, even if the
current behavior has bugs. The bugs can be fixed during refactoring — the tests
just ensure you know when behavior changes.

## Pattern: Behavior-First Testing

```
GOOD: "renders a disabled button when isLoading is true"
BAD:  "sets state.isDisabled to true when loading prop changes"
```

Test what the user/consumer observes, not internal implementation.

## Pattern: Boundary Value Testing

For every function parameter, test:
- Normal values (happy path)
- Empty values (empty string, empty array, zero)
- Null and undefined
- Boundary values (max int, very long string, deeply nested object)
- Type mismatches (number where string expected, if dynamically typed)

## Pattern: Integration Point Mocking

Mock external dependencies at the boundary:
- API calls: mock fetch/axios responses
- Storage: mock localStorage/cookies
- Time: mock Date.now() and timers
- Randomness: mock Math.random()
- Environment: mock process.env

## Pattern: Snapshot Avoidance

Instead of snapshots, assert on specific properties:
```
// BAD - breaks when any attribute changes
expect(component).toMatchSnapshot()

// GOOD - tests specific behavior
expect(screen.getByRole('button')).toBeDisabled()
expect(screen.getByText('Loading...')).toBeInTheDocument()
```

## Test Framework Detection

| Config File | Framework |
|---|---|
| jest.config.* | Jest |
| vitest.config.* | Vitest |
| pytest.ini / conftest.py | pytest |
| .mocharc.* | Mocha |
| karma.conf.* | Karma |
| cypress.config.* | Cypress (E2E) |
| playwright.config.* | Playwright (E2E) |
