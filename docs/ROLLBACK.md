# Rollback Strategy

## Feature flags
- Use `/flags` endpoint to toggle features without shipping new builds.
- Default flags are stored in `backend/src/feature-flags/feature-flags.service.ts`.
- Client reads flags at startup and on a timer (see `FeatureFlagsService`).

## Phased rollout
- Roll out to 5% → 25% → 50% → 100% using store dashboards.
- Monitor crash rate, auth errors, and API latency between phases.

## Kill switches
- Disable risky UI features via flags:
  - `projects.create`
  - `push.enable`
  - `offline.sync`

## Hotfix path
1. Disable feature flag in backend.
2. If needed, publish a patch build with flag defaults off.
3. Pause or rollback store release if stability metrics degrade.
