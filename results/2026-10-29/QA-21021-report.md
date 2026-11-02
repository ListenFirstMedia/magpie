# QA-21021 — Brand Content > Dev vs Prod > Video Views Data Set > LinkedIn Channel

**Run date:** 2026-10-29 (Thursday → rotation rows: Spotify / Spotify News, Sony Pictures / Sony Pictures Television, Ralph Lauren / Ralph Lauren)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account / Brand tried:** Sony Pictures / Sony Pictures Television (brand_id=129863) and Ralph Lauren / Ralph Lauren (brand_id=7000) · Date range: default week (Oct. 21, 2026 – Oct. 27, 2026 on both) · Data set: Video Views · Channel(s): linkedin
**Verdict: BLOCKED — no LinkedIn posts in the default week for any Thursday-rotation brand on dev or prod: Sony Pictures Television Posts (0), Ralph Lauren Posts (0) ("There is no data available"); the row-1 brand "Spotify News" does not exist on the Spotify account (verified 2026-10-22 on dev and prod)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Sony Pictures Television → data set **Video Views** | ✅ |
| 4 | Dev: LinkedIn only → Apply | ⛔ Posts (0) |
| 6–9 | Prod: same selections | ⛔ Posts (0) |
| fallback | Ralph Lauren / Ralph Lauren, same selections | ⛔ Posts (0) on dev and prod (both pages rendered normally today) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A11 | Dev post metrics match Prod | Not evaluable — no LinkedIn posts for the rotation brands | ⛔ BLOCKED |

## Evidence
- `compareOnce` output "table missing" with LinkedIn Posts (0) on both tabs for both brands.

## Known bugs checked
- None open.

## Bugs filed
None (test-data gap: the rotation's Thursday brands do not post on LinkedIn).

## Cleanup
None (read-only).
