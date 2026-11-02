# QA-29116 — Brand Content > Basic Data Set > Past date range data test - TikTok

**Run date:** 2026-10-30 (Friday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Account:** HULU (account_id=336) · **Brand:** Hulu (brand_id=5670, exact spec brand) · **Date range:** Jan. 01, 2025 – Oct. 01, 2025 · **Channel:** TikTok only · **Data set:** Public (Basic) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements holds on all 1,066 TikTok posts and on the aggregate Sum row.**

## Pre-screen (Rule 7)
The case file's "Open linked bugs" section says "None open". The pre-fetched bug-history and known-quirks greps for QA-29116 returned nothing. The screen passed and the case was run.

## Interpretation notes
- **Date range:** the ticket says "date range as per the given date range in the description", but the description has no date range (only the weekday account/brand table). I used Jan. 01, 2025 – Oct. 01, 2025, the same range as earlier QA-29116 runs (2026-10-20, 26, 27, 28, 29) and sibling case QA-29115. Flagged for the case owner to confirm.
- **Weekday rotation:** 2026-10-30 is a Friday. The Description table's Friday row lists accounts Hulu / Robinhood / PlayOn! Sports, but only one brand: "Hulu" (the second brand cell is blank). I ran the only named brand, Hulu, on the Hulu account. I did not invent brands for Robinhood or PlayOn! Sports. The case Notes line ("Fri Hulu/Ralph Lauren") disagrees with the Description table; I followed the table.
- **Skill:** `brand-content-grid-math` (Table View DOM scrape) with the shared Playwright helpers (`devprod-helpers.js`). No skill was pre-resolved; the REGISTRY row was used from the case Notes.
- **Coverage method:** the Table View renders at most 200 rows and has no pagination, and the range holds 1,066 posts. I covered all of them as follows:
  1. The spec range sorted by Engagements descending (ranks 1–200).
  2. The spec range sorted by Engagements ascending (ranks 1,066 down to 867).
  3. Nine supplementary month windows (each at most 151 posts, so fully rendered) that together cover every post in the spec range.

  The supplementary windows are an extra check on top of the spec range, not a replacement for it.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", `config/.env`) | OK, landed on `#home`. The account defaulted to VIACOM. |
| P | Precondition: switch account through the account menu to Hulu | OK — `ACCOUNT: HULU` (account_id=336) |
| 1 | Hover Brand in the top nav, click Content | OK — `#explore/brand/content`, brand selector shows "Hulu" (brand_id=5670). It was already the exact brand, so no brand change was needed. |
| 2 | Add the Brand | OK — brand "Hulu" is the exact spec name |
| 3 | Date range via the START DATE / END DATE picker, then Ok | OK — `Jan. 01, 2025 - Oct. 01, 2025`, URL `from=2025-01-01&to=2025-10-01` |
| 4 | Enable TikTok only (other channels off, TikTok on, Apply) | OK — enabled ghosts `["tiktok"]`, URL `channels=tiktok`, Posts (1,066). All rows link to tiktok.com and carry brand "Hulu". |
| 5 | Table View; per post Reactions + Comments + Shares vs Engagements (DOM scrape of `table.lfm-table`, evaluated in page JS) | See assertions |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5-desc | 5 | Reactions + Comments + Shares = Engagements for each post | Spec range sorted by Engagements descending: 200/200 rows match, 0 mismatches. Rank 1: 1,405,540 = 1,390,292 + 2,517 + 12,731. Rank 2: 1,189,998 = 1,173,163 + 3,127 + 13,708. Rank 3: 1,128,227 = 1,104,006 + 4,179 + 20,042. No "–" values in this slice. | PASS |
| A5-asc | 5 | Same identity | Spec range sorted by Engagements ascending: 200/200 rows match (ranks 1,066 to 867), 0 mismatches. Rank 1,066: Engagements 0 = Reactions "–" (treated as 0) + Comments 0 + Shares "–" (treated as 0). Rank 867: 236 = 221 + 7 + 8. 22 "–" component cells in this slice, all treated as 0. | PASS |
| A5-all | 5 | Same identity for every post | 9 month windows (Jan 43, Feb 84, Mar 125, Apr 127, May 131, Jun 146, Jul 145, Aug 151, Sep 1–Oct 1 114 posts). They total 1,066 posts and 1,066 unique post keys, which equals Posts (1,066) in the spec range. 1,066/1,066 match, 0 mismatches. A "–" component (23 cells across the windows) is treated as 0. | PASS |
| A5-agg | 5 | Aggregate Sum row obeys the same identity | Spec range Sum row (1,066 posts): 36,207,949 + 245,728 + 1,832,255 = 38,285,932 = Engagements 38,285,932. Each month window's Sum row also matched (Engagements Sums: 2,535,248 / 2,598,816 / 2,223,246 / 2,095,057 / 5,058,731 / 4,714,653 / 5,617,393 / 9,001,317 / 4,441,471, which add up to 38,285,932). | PASS |

## Evidence
- Screenshots in `.playwright-out/QA-29116/`: `1030-00-home.png`, `1030-05-table-desc.png`, `1030-06-table-asc.png`. The screenshot calls for account/content/dates/TikTok (`1030-01` to `1030-04`) were not saved: the first timed out waiting for fonts, and in the next step I used a bounded screenshot wrapper that never wrote them. The state for those steps was confirmed from the DOM and URL instead: account HULU, brand Hulu, `from=2025-01-01&to=2025-10-01`, `channels=tiktok`, enabled ghosts `["tiktok"]`.
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views, …) and the identity was evaluated in page JS.
- Console log: `.playwright-out/console-2026-10-30T06-02-04-851Z.log` (dev-app console errors are routine here and did not affect the table).

## Known bugs checked
- The case file lists no open linked bugs, and bug-history has no QA-29116 entry. No bug reproduced or interfered.
- Sibling APPS-61116 (Twitter-only Reactions + Comments + Shares ≠ Engagements, seen on QA-29111) does not touch TikTok. TikTok sums were exact on every post.
- A "–" in a component cell on posts with zero activity (for example Reactions "–" and Shares "–" on a post with Engagements 0) is the accepted structurally-absent rendering documented in the `brand-content-grid-math` skill, not a defect.

## Bugs filed
None. · **Cleanup:** none (read-only).

## Follow-ups for the case owner
1. Add the explicit date range to the ticket description. Runs currently borrow Jan 01 – Oct 01, 2025 from QA-29115.
2. The Friday row of the Description table names only the brand "Hulu" for three accounts (Hulu / Robinhood / PlayOn! Sports). Confirm the intended brands for Robinhood and PlayOn! Sports. The case Notes line ("Fri Hulu/Ralph Lauren") is stale versus the table.
3. The Table View caps at 200 rows with no pagination, so a 1,066-post range cannot be checked on screen in one view. Suggest narrowing the range in the ticket, or adding pagination or a row-count control.
