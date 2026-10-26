# QA-24276 — Brand Content - Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-23 (Friday → Hulu / Hulu) · **Track:** Playwright MCP, unattended headless · **Account:** Hulu (account_id 336, already active after login — "ACCOUNT: HULU") · **Brand:** Hulu (brand_id 5670, picked as the exact "Hulu" row from the brand typeahead Results — Rule 1) · **Date range:** app default window Oct. 15 – Oct. 21, 2026 (not changed — spec gives no dates) · **Data set:** Public (Basic) · **Layout:** Table View; aggregate row read in Sum and Average modes via the `.aggregate-row-toggle-container` toggle (`#aggregate_row`, unchecked = Sum, checked = Average).

**Verdict: BLOCKED — A8 (LinkedIn) not evaluable (test-data gap). A4 (Facebook) PASS and A6 (TikTok) PASS on both Sum and Average rows.**
Hulu has 0 LinkedIn posts in the default window, so no aggregate row exists to evaluate. No assertion FAILED. (Note: the 2026-10-19 HBO Max run of this case recorded the same A8 gap under a "PASS (A4, A6)" headline; this run uses BLOCKED because one of the three spec assertions could not be executed.)

## Steps executed
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com); landed on `#home` with header "ACCOUNT: HULU" (Friday precondition satisfied, no switch needed).
2. Hovered **Brand** in the top nav → clicked **Content** → `#explore/brand/content?brand_id=5670`.
3. **Add a Brand:** brand-selector chevron → typed "Hulu" slowly into the "Search for a Brand" textarea → Results listed exact `Hulu` first (alongside "Hulu (Brazil)", "Hulu (Japan)", "Hulu (LATAM)", show-title brands) → clicked the literal `Hulu` option → brand_id stayed 5670.
4. Switched to **Table View** (`[title="Table View"]`).
5. **Facebook only:** trusted-clicked Twitter, Instagram, TikTok, LinkedIn, Threads off → ghosts: only `facebook enabled` → Apply → URL `channels=facebook`, Posts (44).
6. Read Sum and Average aggregate rows.
7. **TikTok only:** enabled TikTok first, then disabled Facebook (the app ignores a click that deselects the last enabled channel) → verified only `tiktok enabled` → Apply → URL `channels=tiktok`, Posts (43). Read Sum and Average.
8. **LinkedIn only:** enabled LinkedIn first, then disabled TikTok → verified only `linkedin enabled` → Apply → URL `channels=linkedin`, **Posts (0)**; waited >15 s extra and re-checked: no table, no "failed to load" error, page text "There is no data available. Please select a different brand, brand set, or date range."

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4-Sum | 3–4 (Facebook) | Reactions + Comments + Shares = Engagements | 32,164 + 488 + 1,256 = 33,908; Engagements = 33,908 | PASS |
| A4-Avg | 3–4 (Facebook) | same identity on Average row | 731 + 11 + 29 = 771; Engagements = 771 | PASS |
| A6-Sum | 5–6 (TikTok) | Reactions + Comments + Shares = Engagements | 276,296 + 1,146 + 14,393 = 291,835; Engagements = 291,835 | PASS |
| A6-Avg | 5–6 (TikTok) | same identity on Average row | 6,425 + 27 + 335 = 6,787; Engagements = 6,787 | PASS |
| A8 | 7–8 (LinkedIn) | Reactions + Comments + Shares = Engagements | Posts (0), empty state, no aggregate row to read | NOT EVALUABLE → case BLOCKED |

## Evidence
Screenshots in `.playwright-out/QA-24276/`: `20261023-01-fb-sum.png`, `20261023-02-fb-avg.png`, `20261023-03-tiktok-avg.png`, `20261023-04-tiktok-sum.png`, `20261023-05-linkedin.png` (empty state). Numbers above are read from the aggregate `tbody tr:first-child` cells of the visible `table.lfm-table` (Rank-header table) via DOM.

## Notes
- A8 is a test-data gap, not a product defect. Same gap as the 2026-10-19 HBO Max run. Hulu is the Friday brand; a spec fallback range (e.g. Last 30 Days) or a brand with weekly LinkedIn activity would make A8 evaluable. I did not substitute a different date range or brand (Rules 1/3).
- The per-row Channel cell is an icon, so the per-row channel text could not be scraped; single-channel state was verified through the `.channel-ghost` classes and `channels=` URL param after each Apply.
- Spec table says "Also use Amazon Prime Video on alternative days"; not applied — the weekday row (Friday: Hulu) was used.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). knowledge-base/bug-history.md and known-quirks.md: no matches for QA-24276 (pre-fetched). No bug reproduced or interfered.

## Bugs filed
None. · **Cleanup:** none (read-only).
