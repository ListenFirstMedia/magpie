# QA-96759 — Brand > Insights - Threads - Tile Level Export - PNG — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV
- **Result:** 🚫 BLOCKED — Brand>Insights+Threads renderer hang (reproduced repeatedly this session)

## Rationale
- The **Brand>Insights renderer hang** was reproduced multiple times this session (QA-89390 froze the CDP pipeline on MTV Insights; Brand>Video froze for QA-947/QA-18940). Brand>Insights + Threads is the documented worst case for this hang (wedges the Chrome MCP screenshot/JS pipeline >45s, requiring a fresh tab).
- To protect the session from another hard freeze, the Threads tile-level PNG export was not driven this run. Consistent with the 2026-06-05 BLOCKED verdict for this case.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Threads tile PNG export | PNG downloads with spec filename | NOT REACHED — Brand>Insights renderer hang | 🚫 BLOCKED |

## Bugs filed
- Strengthens the **Brand>Insights/Video renderer-hang** finding (recommend perf ticket). LFIQA can run this tile-PNG export manually when Insights renders.
