# Network Patterns

Known API endpoints the app uses, with healthy-response expectations. Used during execution to:

1. Recognize that an expected backend call happened
2. Catch backend errors that the UI silently swallows
3. Power `cross_source` assertions (UI value vs API truth)

_(Populated during first exploration run.)_

## Endpoint inventory

| Endpoint | Method | Healthy status | Healthy shape (excerpt) | Used by |
|----------|--------|----------------|-------------------------|---------|
| _tbd_ | _tbd_ | _tbd_ | _tbd_ | _tbd_ |

## Failure heuristics

- Any 5xx during a case → BUG (capture URL, response body, request ID header)
- Any 4xx that wasn't expected → BUG (capture URL, response body)
- A POST/PUT that didn't fire when the test action implies it should → BUG (UI broken or backend not wired)
- Slow responses (>5s) → flag as perf signal, not a hard fail unless the case explicitly tests latency
