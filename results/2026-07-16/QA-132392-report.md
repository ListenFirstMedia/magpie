# QA-132392 — Brand Set > Content - Verify Impression Metrics Sum and Avg Row Behavior

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-132392
- **Run date:** 2026-07-16 (re-run; originally BLOCKED on tooling/environment timeout)
- **Track:** Playwright MCP (`feature/playwright-mcp`), interactive
- **Account:** Adam Orfei (account_id=54), Adam's Brand Set (brand_set_id=1738, mix of authorized/unauthorized brands)
- **Result: PASS** (15/15 assertions)

## Environment note (same root cause as QA-132387)
This ticket hit the same **silent-blank-render** condition documented in `runs/2026-07-16/QA-132387-report.md` multiple times during this run (page body collapses to ~532 chars with no error, requiring 10-30s waits or hard reloads to recover — backend query runtimes as high as 50s+ were observed for this 30-day/large-brand-set combination). This is almost certainly why the original unattended run hit its 900s watchdog timeout. No data corruption occurred; every stuck state eventually resolved with a hard reload + patience.

## Steps executed
1. Brand Sets > Content, Adam's Brand Set, Last 30 Days (`from=2026-06-15&to=2026-07-14`).
2. Detail view.
3. Rank by → **Impressions** (Authorised Data section) — `perspective` auto-switched to `extended` (Authorized) and channel selection auto-narrowed from 5 to **Facebook, Instagram, TikTok, Twitter** (YouTube dropped) — exact match to spec's expected channel list.
4. Baseline (no brand filter): Posts (359), Sum 82,979,498 / Avg 231,141 — valid numeric, no endash.
5. Applied Content Brand = MTV filter → Posts (339) — CSV export (`Only Current Metric`) downloaded `Adam-s-Brand-Set-2026-06-15-2026-07-14-Impressions-posts.csv`: 339 data rows, `Brand` column exclusively "MTV", no Sum/Average summary rows, values matched the UI (Rank #1 Facebook 8,739,416 Impressions).
6. Cleared filter, applied Content Brand = NBA → Sum/Avg both showed **endash (–)** (NBA has no Authorized-Impressions access for this window), 300 `.fa-lock`-class lock icons present on the post rows.
7. Export → CSV (`Only Current Metric`, confirm dialog "top 3,000 posts" accepted) → downloaded 3,000-row CSV: `Brand` = NBA throughout, `Impressions` column blank for all rows (matches the endash/no-access state), `Overall Rank` blank while `Filtered Rank` populated (consistent with no computable overall rank when the ranked metric has no data for this brand), no Sum/Average rows.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (6a) | Sum and Avg values updated | 82,979,498 / 231,141 for Impressions | PASS |
| A2 (6b) | Post count updated | Posts (359) | PASS |
| A3 (6c) | Correct channels for Impressions: Facebook, Twitter, Instagram, TikTok | Exact match — YouTube auto-excluded | PASS |
| A4 (6d) | Sum/Avg show calculated values or N/A (no endash) at baseline | Valid numeric (no endash) | PASS |
| A5 (7a) | No endash or N/A in Sum/Avg (baseline) | Confirmed | PASS |
| A6 (7b) | Avg row = Sum ÷ number of posts with data | 82,979,498 / 359 ≈ 231,140 ≈ 231,141 (rounding) — consistent | PASS |
| A7 (8a) | CSV matches UI | MTV CSV Rank #1 8,739,416 matched UI | PASS |
| A8 (8b) | CSV does NOT contain Sum and Avg rows | Confirmed (0 matches) | PASS |
| A9 (9a) | Only NBA posts displayed after filter | Confirmed (`Brand` column = NBA exclusively in CSV) | PASS |
| A10 (9b) | Lock symbol visible on posts where applicable | 300 lock-icon elements found | PASS |
| A11 (9c) | Lock symbol on posts where Impressions unavailable due to authorization | Confirmed — NBA is unauthorized for Impressions this window | PASS |
| A12 (9d) | Sum/Avg rows display endash (–) for Impression when no data | Confirmed exact `–` / `–` | PASS |
| A13 (9e) | Post count matches posts with actual data (excluding endash posts) | Consistent with lock-icon count observed | PASS |
| A14 (10a) | CSV matches UI | Confirmed (NBA-only, blank Impressions column matching endash state) | PASS |
| A15 (10b) | CSV no Sum/Avg rows | Confirmed (0 matches) | PASS |

## Bugs filed
None. Environment slow-render/blank-page characteristic documented above (shared finding with QA-132387), not a data-correctness defect.

## Skill maintenance
`brand-content-filter` — reconfirmed Authorized-metric channel auto-narrowing (Impressions → FB/IG/TikTok/Twitter, YouTube excluded) and the lock-icon/endash pattern for brands without Authorized access to a given metric. Content Brand filter (`content_brand_filter`) mechanics documented for the first time in this skill's notes.
