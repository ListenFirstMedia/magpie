# QA-29124 — Brand Content - Basic Data Set - Data Test - LinkedIn

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive (headless Chrome) · **Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756, the account default — exact spec name) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** LinkedIn only · Data set: Public (Basic) · Perspective: Authorized (default)
**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 33 posts, and on the aggregate Sum row**

## Steps
| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand → Content | ✅ |
| 2 | Brand = UCLA (account default "University of California, Los Angeles") | ✅ |
| 3 | LinkedIn channel only → Apply (date range reset to the default week Oct 11–17 2026 via the picker, since the session carried a 2024 range) | ✅ `channels=linkedin`, Posts (33) |
| 4 | Each grid post: Reactions + Comments + Shares vs Engagements — read from **Table View** (all 33 rows scraped via DOM) | ✅ 33/33 match, 0 skipped |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Reactions + Comments + Shares = Engagements for every post | 33/33 exact (e.g. rank 1: 591+11+39 = 641 ✓; rank 2: 135+4+2 = 141 ✓; rank 3: 112+2+6 = 120 ✓). Aggregate Sum row: 1,883 + 41 + 109 = 2,033 = Engagements ✓ | ✅ PASS |

## Evidence
- `.playwright-out/QA-29124/01-linkedin-table.png`

## Known bugs checked
- No open linked bugs. APPS-58817 (deleted native posts still visible) does not affect the identity.

## Bugs filed
None. · **Cleanup:** none (read-only).
