# Run Environment

## Browser

- **Mode:** attach-to-existing (Chrome MCP, working in the user's already-open Chrome)
- **Profile:** user's default profile
- **Viewport:** whatever the user has — captured per run
- **Network:** real, no throttling

## Capture defaults

- **Console:** captured for the duration of every case (errors/warnings flagged)
- **Network:** captured for the duration of every case (4xx/5xx surfaced)
- **Screenshots:** only on assertion failure or bug; one full-page + one element crop
- **DOM snippets:** captured for failing elements at point of failure

## Pre-flight (run at start of every regression run)

1. Confirm app is reachable (HEAD on base URL → 2xx/3xx)
2. Log in as the primary test user
3. Confirm dashboard renders (one canonical assertion)
4. If any step fails: abort the run, emit a smoke-failure report, do not run remaining cases

## Run cadence

_To be decided — currently manual on-demand._
