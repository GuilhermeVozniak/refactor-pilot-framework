# Phase 4: Verify & Deploy

The final phase ensures that refactored code is correct, performant, and safely deployed. This is where you run the safety nets from Phase 2 and confirm nothing broke.

## Why This Phase Matters

AI-generated code can be subtly wrong. Tests might pass while performance degrades. Types might be correct while bundle size doubles. This phase catches those issues before they reach users.

## The Workflow

```
Refactored Code
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Run Test   │────▶│  Benchmark   │────▶│   Deploy     │
│   Suite      │     │  & Compare   │     │   Safely     │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                     │
       ▼                    ▼                     ▼
  All tests pass       Performance          Feature flags
  Type checking OK     baselines met        Gradual rollout
  Linting clean        Bundle size OK       Monitoring
```

## Step 1: Run the Full Test Suite

Run every test from Phase 2, plus any existing project tests.

**Verification checklist:**
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Type checking passes with no new errors (`tsc --noEmit`, `mypy`, etc.)
- [ ] Linting passes with no new warnings (`eslint`, `ruff`, `clippy`)
- [ ] No new runtime warnings in the console
- [ ] End-to-end tests pass (if available)

**If tests fail:**
1. Read the failure message carefully
2. Determine if the test or the code is wrong
3. If the code is wrong, go back to Phase 3 and provide AI with the error output
4. If the test is wrong (testing implementation details that correctly changed), update the test

**Using AI to fix failures:**
```
Here's my refactored code: [paste code]
Here's the test that's failing: [paste test]
Here's the error: [paste error output]

The refactored code should preserve the same behavior as the original.
Fix the code (not the test) to make this pass.
```

## Step 2: Benchmark and Compare

Compare the refactored code against the original on key metrics.

**Metrics to compare:**

| Metric | How to Measure | Acceptable Threshold |
|---|---|---|
| Bundle size | `webpack-bundle-analyzer`, `rollup-plugin-visualizer` | ±5% of original |
| Load time | Lighthouse, WebPageTest | No regression |
| Runtime performance | Browser profiler, benchmark.js | ±10% of original |
| Memory usage | Chrome DevTools Memory tab | No leaks, ±10% |
| Build time | CI pipeline timing | No significant increase |
| Test execution time | Test runner timing | No significant increase |

**If performance regresses:**
1. Profile to identify the bottleneck
2. Ask AI to optimize the specific area:
   ```
   This function is 30% slower after refactoring.
   Original: [paste original]
   Refactored: [paste refactored]
   Profile shows the bottleneck is [specific area].
   Optimize the refactored version to match or beat the original's performance.
   ```

## Step 3: Deploy Safely

Use progressive deployment techniques to minimize risk.

**Deployment strategies:**

### Feature Flags
Wrap refactored code behind a feature flag so you can toggle between old and new implementations:
```javascript
if (featureFlags.useRefactoredUserProfile) {
  return <UserProfileV2 {...props} />;
} else {
  return <UserProfile {...props} />;
}
```

Roll out gradually: 1% → 5% → 25% → 50% → 100%.

### Canary Deployment
Deploy the refactored code to a small percentage of servers or users first. Monitor error rates, latency, and user behavior before expanding.

### Blue-Green Deployment
Run old and new versions simultaneously. Route traffic to the new version only after verification passes.

### Shadow Mode
Run refactored code in parallel with the original without serving its output to users. Compare results to detect behavioral differences.

## Post-Deployment Monitoring

After deployment, watch these signals for 24-72 hours:

- **Error rates:** Any new exceptions or error types?
- **Performance metrics:** P50, P95, P99 response times stable?
- **User behavior:** Any changes in user flows, drop-off rates, or support tickets?
- **Resource usage:** CPU, memory, database queries within normal ranges?

## The Verification Prompt

Use `prompts/09-verify-checklist.md` to have AI help you build a custom verification checklist based on your specific refactor. Provide it with:
- The refactor plan from Phase 2
- The list of changed files
- Your deployment environment details

AI will produce a tailored checklist covering the specific risks of your refactoring changes.

## Tips for Phase 4

**Don't skip benchmarking.** "It works" is not the same as "it works well." Refactored code can be correct but slow if AI chose a less efficient pattern.

**Monitor longer than you think.** Some regressions only show up under production load or after caches expire. Give it at least 72 hours before removing the feature flag.

**Keep the old code accessible.** Don't delete the original files immediately. Keep them in a `deprecated/` directory or on a git branch for at least one release cycle.

**Document what changed.** Write a brief summary of the refactoring for your team — what was changed, why, and how to roll back if needed. The refactor plan from Phase 2 is a good starting point.

**Celebrate.** Seriously. Paying down technical debt is thankless work. Your codebase is now cleaner, more maintainable, and easier for the next developer to understand. That matters.
