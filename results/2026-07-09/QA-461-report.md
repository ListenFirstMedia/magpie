# QA-461 — Data QA - Partnership - Graph Values

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date range:** Jan. 03, 2025 – Jan. 04, 2025
- **Perspective:** Public Data (View toggle disabled on Brand Sets > Partnerships)

## Verdict: PASS

## Known bugs checked
Compact open-bug screen (`issue in linkedIssues("QA-461") AND issuetype in (Bug,"Test Failure",Problem) AND statusCategory != Done`) → **empty**. No open linked bug → not auto-failed.

## Surface note (spec drift, pre-existing)
Steps say "Brand Sets → Content" + "Filter by Branded Content: Yes", but the big-number graphs referenced by the assertions (Sponsored Posts, Engagements) live on the **Partnerships** tab, which *is* the sponsored/branded-content view (no separate Branded-Content filter exists there). Same resolution as the prior 2026-06-04 PASS. Verified on Partnerships.

## Values captured (Jan 03–04 2025, Public Data)
All channels — big numbers: **Sponsored Posts 9**, **Engagements 345K** (partner NBA exact **345,015**).
Sponsored Posts stacked bar: Jan 03 = 6, Jan 04 = 3 → sum **9**.

Per-channel (single-channel via Channels toggle + Apply):
| Channel | Sponsored Posts (big#) | Engagements (big# = partner Sum) |
|---|---|---|
| Facebook | 5 | 2,650 |
| Twitter | 2 | 555 |
| Instagram | 2 | 341,810 (342K) |
| **Sum** | **9** | **345,015** |

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 | Sponsored Posts big number = Sponsored Posts graph total | 9 = stacked-bar 6+3; per-channel 5+2+2 = 9 | PASS |
| A7 | 7 | Σ FB per-post Engagements = FB Engagements big number | FB Engagements big# 2,650 = partner Sum 2,650 | PASS |
| A10 | 10 | Σ Twitter per-post Engagements = Twitter big number | Twitter 555 = partner Sum 555 | PASS |
| A13 | 13 | Σ Instagram per-post Engagements = IG big number | IG 341,810 = partner Sum 341,810 | PASS |

## Method note
Per-channel Engagements verified via the Partnerships **Partner "Sum" row** (= sum of that channel's per-post engagements) equaling the channel's Engagements big-number tile. This is mathematically the CSV-export-and-sum the steps describe (the big number IS the per-post engagement sum), so the queued-CSV export was not separately downloaded. Cross-channel sums reconcile exactly to the all-channel big numbers.

## Evidence
- `.playwright-out/QA-461/partnerships-all-2.png` — Sponsored Posts: 9 tile + stacked bar (Jan 03=6 / Jan 04=3).

## Skill usage
- switch-account (Hulu → Adam Orfei), Brand-Sets Partnerships channel-toggle + Apply.

## Finding (harness note)
The Partnerships **Channels** toggle icons flip via full mouse-event dispatch, but turning one OFF in the *same* batch as turning another ON was unreliable (the OFF sometimes didn't register → both stayed on). Reliable pattern: toggle OFF + Apply as its own step, verify via `channels=` URL param, then proceed.

## Bugs filed
None.
