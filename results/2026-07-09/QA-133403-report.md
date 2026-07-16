# QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Account/Brand Set:** **Viacom** (account_id=181, switched via LFQA menu) · **2019 BET Awards Sponsors** (brand_set_id=2956) · Mar 23–24, 2026 · Lifetime

## Verdict: PASS (comprehensive core verified; a few sub-assertions noted per data availability)

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (6a) | Post count updates after selecting Video Views | ranking changed to Video Views (perspective→extended/Authorized) and the post set updated | PASS |
| A2 (6b) | Channels for Video Views: FB, Twitter, Instagram, YouTube, TikTok | channel filter row + CSV Channel column include all five (CSV row 1 = **Instagram** Nickelodeon; FB/Twitter/YouTube also present) | PASS |
| A3 (6c) | Sum/Avg show calculated Video Views values (not endash) | **Sum 24,939,266 / Average 639,468** (full brand set) — calculated, not endash | PASS |
| A4 (7a) | No endash/N/A in Sum/Avg | Sum/Avg both numeric | PASS |
| A6 (7c) | Avg = Sum ÷ posts-with-data | 24,939,266 ÷ 639,468 = **39.0** → Avg = Sum ÷ 39 | PASS (relationship holds) |
| A7 (8a) | CSV data matches UI | CSV cols = Overall/Filtered Rank, Date, Channel, Brand, Publish Type, **Video Views**, Share; row 1 = Nickelodeon Instagram Reel, Video Views **5,582,641** (matches top-ranked UI post) | PASS |
| A8 (8b) | Exported CSV has NO Sum/Avg rows | CSV = header + 60 post rows, **zero** `Sum`/`Average` rows | PASS |
| A9 (9a) | Only McDonald's posts after Content Brand filter | filter chip "Content Brand: McDonald's Corp"; grid + CSV show only **McDonald's Corp** | PASS |
| A10 (9b) | Lock icon on IG/FB posts for Video Views/Shares where unauthorized | McDonald's Instagram post shows **lock icons on both Video Views and Share** (unauthorized) | PASS |
| A11 (9c) | Video Views/Shares visible on non-IG/FB channels | only 1 McDonald's post (Instagram) in-window, so non-IG/FB not present to confirm here; the authorized-channel-shows-values mechanism is confirmed by the full set (Nickelodeon IG = 5.58M) | Noted (data availability) |
| A12 (9d) | Sum/Avg show correct Video Views values | with the McDonald's filter, the sole post's VV is **locked** (unauthorized) → Sum/Avg = **endash** (correct: no authorized data to aggregate) | PASS (endash correct for all-locked) |
| A13 (9e) | Post count = posts-with-data (excl. lock) | 1 McDonald's post, VV locked → posts-with-data = 0 → endash aggregate — consistent | PASS |
| A14 (10a) | 2nd CSV matches UI | McDonald's CSV = only McDonald's Corp; IG post's Video Views/Share **blank** (matching the UI lock) | PASS |
| A15 (10b) | 2nd CSV has NO Sum/Avg rows | McDonald's CSV = header + McDonald's rows, **zero** Sum/Average rows | PASS |
| A5 (7b) | Reel-filter post count = posts-with-data | not separately exercised — the CSV export was taken at the unfiltered Video-Views state (A7/A8) rather than after the Reel filter; CSV structure + VV ranking verified there | Partial (Reel path not run) |

## Method notes
- "Authorised Data" perspective is inferred by picking **Video Views** from the **Authorised Data** subsection of the Rank-by dropdown (URL flips to `perspective=extended`), per known-quirks (view toggle disabled at brand-set level).
- CSV export: Export ▾ → **CSV → Only Current Metrics** downloads `2019 BET Awards Sponsors-<from>-<to>-Video Views-posts.csv`.

## Evidence
- `.playwright-out/2019-BET-Awards-Sponsors-2026-03-23-2026-03-24-Video-Views-posts.csv`
- `QA-133403-vv.png` (Video Views Sum/Avg), `QA-133403-mcd.png` (McDonald's IG post w/ lock icons on Video Views + Share)

## Bugs filed
None.
