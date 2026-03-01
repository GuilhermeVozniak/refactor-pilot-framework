# Deployment Strategies for Refactored Code

## Feature Flag Rollout

The safest approach for significant refactors. Deploy the new code behind a flag
and gradually increase the percentage of users who see it.

```
Day 1: 1% of traffic → monitor errors and performance
Day 2: 10% of traffic → check for edge cases
Day 3: 50% of traffic → validate at scale
Day 5: 100% of traffic → full rollout
Day 7: Remove feature flag → cleanup
```

Tools: LaunchDarkly, Unleash, Flagsmith, or a simple environment variable.

## Canary Deployment

Deploy to a small subset of servers first. If metrics stay healthy, proceed
to full deployment.

Monitor these signals during canary:
- Error rate (should not increase)
- Response latency (p50, p95, p99)
- Memory usage and CPU
- Business metrics (conversion rate, etc.)

## Blue-Green Deployment

Run old and new versions side by side. Route traffic to the new version.
If problems arise, instantly switch back to the old version.

Requirements: two identical environments, a load balancer or router.

## Rollback Plan

Before deploying, document:
1. How to roll back (git revert, feature flag toggle, blue-green switch)
2. Who has permission to roll back
3. What monitoring alerts should trigger a rollback
4. Maximum acceptable rollback time

## Post-Deployment Monitoring Checklist

- [ ] Error rate is at or below pre-deployment levels
- [ ] Response times are within acceptable range
- [ ] No new error types in logs
- [ ] Business metrics are stable
- [ ] No user-reported issues
- [ ] Memory/CPU usage is stable
- [ ] 72-hour monitoring period completed
