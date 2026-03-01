---
name: verify-changes
description: >
  Use this skill whenever the user wants to verify refactored code, run a verification
  checklist, check that refactoring didn't break anything, validate changes before deployment,
  or assess the quality of a completed refactoring. Triggers include: "verify the refactoring",
  "check if everything works", "run the verification", "is the refactor safe to deploy",
  "validate the changes", "compare before and after", "check performance", or any request
  to ensure refactored code is correct and deployable.
  Do NOT use for writing refactored code — use refactor-code for that.
---

# Verify Changes Skill

You are performing Phase 4 (Verify & Deploy) of the Refactor Pilot framework. Your job is
to ensure that refactored code is correct, performant, and safe to deploy.

## Quick Decision Tree

```
Do baselines exist (refactor-notes/baselines.md)?
├── NO → Run capture-baselines.sh first for comparison data
└── YES → Compare against baselines

Are all tests passing?
├── NO → Identify: is the test wrong or the code wrong?
│   ├── Test was testing implementation details → Update test
│   └── Code has a regression → Fix the code
└── YES → Continue to benchmarking

Is the refactored code deployed behind a feature flag?
├── YES → Recommend canary deployment with monitoring
└── NO → Recommend adding feature flag for gradual rollout
    └── Low-risk change? → Standard deployment may be fine
```

## Workflow

### Step 1: Run Full Test Suite

Execute all tests:
- Unit tests
- Integration tests
- Type checking (`tsc --noEmit`, `mypy`, `cargo check`, etc.)
- Linting (`eslint`, `ruff`, `clippy`, etc.)

Report results clearly:
- Total tests: X passed, Y failed, Z skipped
- Type errors: count and description
- Lint warnings: count and severity

If any tests fail:
1. Identify whether the test or the code is wrong
2. If the code is wrong, propose a fix
3. If the test was testing implementation details that correctly changed, note it for update

### Step 2: Benchmark Comparison

Compare refactored code against baselines from `refactor-notes/baselines.md`:

| Metric | Before | After | Difference | Status |
|--------|--------|-------|------------|--------|
| Bundle size | | | | |
| Build time | | | | |
| Test suite time | | | | |
| Line count | | | | |
| TODO/FIXME count | | | | |
| TypeScript `any` count | | | | |

Flag any metric that regressed by more than 10%.

### Step 3: Generate Verification Checklist

Based on the specific changes made, generate a tailored checklist covering:

- **Functional verification** — specific behaviors to test for each changed file
- **Integration checks** — consumer compatibility, API payloads, shared state
- **Visual regression** — UI appearance, responsiveness, accessibility
- **Deployment readiness** — feature flags, rollback plan, monitoring

Mark each item with priority:
- 🔴 Must pass before deployment
- 🟡 Should pass, monitor if not
- 🟢 Nice to verify, low risk

### Step 4: Deployment Recommendations

Based on the verification results, recommend a deployment strategy:

- **Green light** — All checks pass, safe for standard deployment
- **Cautious** — Minor concerns, recommend feature flag or canary deployment
- **Hold** — Issues found, needs fixes before deployment

See `references/deployment-strategies.md` for detailed deployment playbooks.

## Output

Present a verification report with:
1. Test results summary
2. Performance comparison table (against baselines)
3. Verification checklist with status
4. Deployment recommendation
5. Any remaining action items

Save as `refactor-notes/07-verification-report.md`.

## Important Notes

- Be thorough. Missing a subtle regression is worse than being overly cautious.
- If benchmarking tools aren't available, provide instructions for manual benchmarking.
- The verification report is a valuable artifact — encourage saving it with the PR.
- Recommend 72-hour monitoring period after deployment.
