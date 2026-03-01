# Prompt: Generate Verification Checklist

> **Phase:** 4 — Verify & Deploy
> **Purpose:** Produce a tailored checklist for verifying that the refactoring is complete, correct, and safe to deploy.
> **Input:** Refactor plan + list of changed files + deployment environment details

## The Prompt

```
Generate a verification checklist for the refactoring described below.
The checklist should be specific to THIS refactoring, not generic.

Include the following sections:

1. **Functional Verification**
   For each changed file, list the specific behaviors to verify:
   - [ ] [Component/Function] still [does X] when [condition Y]
   - [ ] [Component/Function] still [handles Z] correctly

2. **Test Results**
   - [ ] All pre-existing tests pass without modification
   - [ ] All new tests from Phase 2 pass
   - [ ] Type checking passes (zero new errors)
   - [ ] Linting passes (zero new warnings)
   - [ ] No new console warnings or errors at runtime

3. **Performance Checks**
   Based on the specific changes made:
   - [ ] Bundle size is within ±5% of the pre-refactor baseline
   - [ ] [Specific component] renders in [X]ms or less
   - [ ] No new unnecessary re-renders introduced
   - [ ] Memory usage is stable (no leaks introduced)
   - [ ] API call count is unchanged

4. **Integration Checks**
   For each integration point affected by the refactoring:
   - [ ] [Consumer A] still works with refactored [Module B]
   - [ ] [API endpoint] still receives correct payload
   - [ ] [Shared state] is still updated correctly

5. **Visual Regression**
   If UI components were changed:
   - [ ] [Component] looks identical in [browser/viewport]
   - [ ] [Component] responsive behavior is unchanged
   - [ ] [Component] animations and transitions work
   - [ ] [Component] accessibility (keyboard nav, screen reader) is intact

6. **Deployment Readiness**
   - [ ] Feature flag is configured (if using feature flags)
   - [ ] Rollback plan is documented
   - [ ] Monitoring dashboards are set up for the affected area
   - [ ] Team is notified of the deployment
   - [ ] Release notes are written

7. **Post-Deployment Monitoring**
   - [ ] Error rates monitored for 72 hours
   - [ ] Performance metrics monitored for 72 hours
   - [ ] User behavior metrics checked (conversion, engagement)
   - [ ] Support ticket volume is normal

Mark each item with the appropriate priority:
🔴 Must pass before deployment
🟡 Should pass, monitor if not
🟢 Nice to verify, low risk

---

REFACTOR PLAN:
[Paste the refactor plan from Phase 2]

FILES CHANGED:
[List all files that were modified, created, or deleted]

DEPLOYMENT ENVIRONMENT:
[Describe your deployment setup: CI/CD, staging environments,
feature flag system, monitoring tools, etc.
Or write "Standard web deployment with CI/CD."]
```

## Usage Notes

- Customize the checklist for your specific project and deployment setup.
- Use this as a PR review template — paste it into the PR description with checkboxes.
- Work through the checklist systematically. Don't skip items even if they seem redundant.
- If any red (🔴) items fail, do not deploy. Go back to Phase 3 and fix the issue.
- Save the completed checklist as documentation for the refactoring.
