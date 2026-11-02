# QA-21021 — Brand Content > Dev vs Prod > Video Views Data Set > LinkedIn Channel

**Run date:** 2026-10-30 (Friday → rotation rows: Hulu / Hulu, Robinhood / Robinhood, PlayOn! Sports / PlayOn! Sports)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account / Brand tried:** Hulu / Hulu (brand_id=5670); Robinhood (account_id=805) and PlayOn! Sports (account_id=3582) brand pickers searched · Date range: default week (Oct. 22, 2026 – Oct. 28, 2026 on both) · Data set: Video Views · Channel(s): linkedin
**Verdict: BLOCKED — the Friday rotation cannot be executed: Hulu has Posts (0) on LinkedIn in the default week on dev and prod; the Robinhood account has no brand named "Robinhood" (picker lists only Robinhood - Affiliates Roll-Up, Robinhood App, Robinhood App (EU), Robinhood Comms, Robinhood Crypto, Robinhood Help, Robinhood Primary Handles, …); the PlayOn! Sports account has no brand named "PlayOn! Sports" (typeahead "PlayOn" → no results; "Play" → College Football Playoff, Fore Play). Per Rule 1 no substitute brand was used**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Hulu → data set **Video Views** | ✅ Posts (43) across channels |
| 4 | Dev: LinkedIn only → Apply | ⛔ Posts (0) |
| 6–9 | Prod: same selections | ⛔ Posts (0) |
| fallback | Robinhood / Robinhood | ⛔ brand does not exist on the Robinhood account (dev and prod) |
| fallback | PlayOn! Sports / PlayOn! Sports | ⛔ brand does not exist on the PlayOn! Sports account (dev and prod) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A11 | Dev post metrics match Prod | Not evaluable — no LinkedIn posts for Hulu; rows 2 and 3 name brands that do not exist | ⛔ BLOCKED |

## Evidence
- `compareOnce` output "table missing" with LinkedIn Posts (0) on both tabs for Hulu; brand-picker option lists captured for Robinhood and PlayOn! Sports (session `ctx._res`).

## Known bugs checked
- None open.

## Bugs filed
None (test-data gap: the Friday rows 2 and 3 of the rotation table name brands that are not on their accounts — case owner should correct the table, e.g. to Robinhood App / NFHS Network).

## Cleanup
None (read-only).
