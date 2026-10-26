# QA-22108 — Brand Content > LFM vs Native > LinkedIn Channel

**Run date:** 2026-10-23 (Friday) — case is fixed to UCLA / University of California, Los Angeles (not the weekday rotation)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no LinkedIn login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: LinkedIn only · Date range: Jan. 01, 2024 – Dec. 31, 2024 · Data set: Public
**Verdict: FAIL — open linked bug LFMP-32113 (Open) ⇒ FAILED per policy. Execution outcome: first post (Mon Sep 23 2024, "UCLA has been ranked the nation's #1 public university…") LFM Reactions 8,992 vs native 9,918 likes (+10%), Comments 213 vs native 228 (+7%) — moderate drift, native HIGHER than LFM (opposite direction to LFMP-32113)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Switch account → UCLA (LFIQA menu), Brand > Content | ✅ `account_id=799`, brand already University of California, Los Angeles |
| 2 | Date range Jan 01 – Dec 31 2024 | ✅ `from=2024-01-01&to=2024-12-31` (START/END "Jan 01, 2024 / Dec 31, 2024") |
| 3 | LinkedIn only → Apply | ✅ Posts (795) |
| 4 | First post metrics (grid card) | ✅ Engagements 10,164 · Reactions 8,992 · Comments 213 · Shares 959 · Response Rate 1.11% |
| 5 | Click image → native tab | ✅ https://www.linkedin.com/feed/update/urn:li:share:7244170903343796225/ (logged-out public view) |
| 6 | Note native Likes / Comments | ✅ reaction count **9,918**, "**228** Comments" (page title "#1ucla \| UCLA \| 228 comments") |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions/Comments ≈ native Likes/Comments (no big variation) | 8,992 vs 9,918 (+10.3%); 213 vs 228 (+7.0%) | ❌ FAIL (policy: open bug LFMP-32113; execution: ~10% drift on a 2-year-old post, likely late reactions not re-collected) |

## Evidence
- Session result `ctx._nat.q22108` (card text, LFM metrics, native body text "9,918 | 228 Comments").

## Known bugs checked
- **LFMP-32113 (Open)** "Brand Content > LFM vs Native - Past Date - native data is lower than LFM" — open ⇒ FAILED per the 2026-10-22 directive. Today's drift is in the opposite direction (native higher), worth noting on the bug.

## Bugs filed
None (existing bug).

## Cleanup
Native tab closed.
