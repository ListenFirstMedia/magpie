# QA-21021 — Brand Content > Dev vs Prod > Video Views Data Set > LinkedIn Channel

**Run date:** 2026-10-28 (Wednesday → rotation row: account **Apple Services**, brand **Apple Music**; row 2 NBCU EnterPrises / CNBC, NBC News)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Apple Services (account_id=409) · **Brand:** Apple Music (brand_id=31783) · Date range: default week (Oct. 20, 2026 – Oct. 26, 2026 on both) · Data set: Video Views · Channel(s): linkedin
**Verdict: BLOCKED — Apple Music has 0 LinkedIn posts in the default week on dev and prod ("There is no data available"); the second Wednesday account "NBCU EnterPrises" is not available to the lfiqa user (the account typeahead lists no NBC* account), and CNBC reachable under Apple Services is a public brand with no Video Views data set (data sets offered: Public, Facebook Only: Reactions, Twitter Only: Engagements & Follows, YouTube Only: Basic)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Dev: Brand > Content → Apple Music → data set **Video Views** | ✅ |
| 4 | Dev: LinkedIn only → Apply | ⛔ Posts (0) — no table |
| 6–9 | Prod: same selections | ⛔ Posts (0) |
| fallback | Account switch to NBCU EnterPrises (row 2) | ⛔ not in the lfiqa account list ("NBCU" → no results; "Enter" lists other accounts, so the typeahead works) |
| fallback | CNBC under Apple Services | ⛔ public brand (perspective standard), Video Views data set absent |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A11 | Dev post metrics match Prod | Not evaluable — no LinkedIn posts for the rotation brand; row-2 account not entitled | ⛔ BLOCKED |

## Evidence
- `compareOnce` output "table missing" with LinkedIn Posts (0) on both tabs; account typeahead results captured in session.

## Known bugs checked
- None open.

## Bugs filed
None (test-data / entitlement gap).

## Cleanup
None (read-only).
