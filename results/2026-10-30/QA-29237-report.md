# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: PASS for the one leg that is fully specified (Hulu / Hulu). Legs 2 and 3 (Robinhood, PlayOn! Sports) are BLOCKED (test-data gap: the Description table gives no brand for them).** Overall: PASS (1 of 3 legs), same partial-leg convention as the 2026-10-27 and 2026-10-29 runs. No assertion failed on any evaluated post.

- Run: 2026-10-30 (Friday), unattended headless (Playwright MCP), dev `app.lfmdev.in`, user `lfiqa@listenfirstmedia.com` (Cognito "With existing account").
- Weekday row (Description table, authoritative): Friday = Accounts **Hulu / Robinhood / PlayOn! Sports**, Brands **Hulu / (blank) / (blank)**. The case `## Notes` line ("Fri Hulu/Ralph Lauren") disagrees with the table; the table was used.
- Skill: `brand-content-grid-math` (Table View DOM scrape through `_shared/playwright-helpers/devprod-helpers.js`). Open-bug screen (Rule 7): case says "None open", so it ran normally.
- Perspective: Hulu landed on "Authorized data" (`perspective=extended`). The spec does not name a perspective, so it was left at the app default.

| Leg | Account | Brand | Result |
|---|---|---|---|
| 1 | Hulu (account_id 336) | Hulu (brand_id 5670) | PASS (200 of 567 TikTok posts evaluated) |
| 2 | Robinhood | none given in spec | BLOCKED (test-data gap) |
| 3 | PlayOn! Sports (account_id 3582) | none given in spec | BLOCKED (test-data gap) |

## Steps executed
Leg 1, via the UI: logged in through the Cognito form; account menu > Search Account > clicked the exact `Results` entry "HULU"; hovered **Brand** > **Content**; the brand selector already showed the exact name "Hulu" (brand_id 5670); **Data Set** dropdown (visible one) > **Impressions** (`table_data_set=impressions`); date picker START DATE = Jan 01, 2023, END DATE = Dec 31, 2023 (read back from `.date-range-fields`; URL `from=2023-01-01&to=2023-12-31`); clicked every other `.channel-ghost` off, TikTok on, verified `.channel-ghost.enabled` = `["tiktok"]`, clicked **Apply** (URL `channels=tiktok`); header showed `Posts (567)`; **Table View** DOM scrape (200 rows rendered, plus the Sum row).

1. **Leg 1 (Hulu).** All of steps 1–7 executed on the exact spec configuration. Screenshots `L1-01` … `L1-04`.
2. **Legs 2–3 (Robinhood, PlayOn! Sports).** Both accounts exist on dev and can be selected. The Friday row of the Description table lists only one brand ("Hulu"); the Brand column is blank for the other two accounts. Rule 1: no brand is named, so none may be chosen, and steps 2–7 are not executable. Informational only: Robinhood opens on "Vladimir Tenev" and PlayOn! Sports on "Around The Horn" (default brands, not spec brands). No data set, date range or channel was applied on either. Screenshot `L23-01`.

## Assertions
The ticket numbers two of them "5": A5a = "impression metric displays the value", A5b = "En-dash for both Organic and Paid Impressions", A6 = "Organic Reach + Paid Reach = Reach", A7 = "Engagement Rate = Engagement / Impression × 100".

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a-Hulu | 5 | Impressions displays a value | 200/200 posts show a number (top post 4,947,577). Sum row 1,153,240,088 | PASS |
| A5b-Hulu | 5 | "–" for Organic and Paid Impressions | Organic Impressions "–" on 200/200, Paid Impressions "–" on 200/200 (Sum row "–" / "–") | PASS |
| A6-Hulu | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach and Paid Reach are all "–" on 200/200 posts (Sum row "N/A" for all three). No number exists to sum, so the identity holds vacuously; 200 skipped as "no data", 0 failures | PASS (vacuous) |
| A7-Hulu | 7 | Engagement Rate = Engagements / Impressions × 100 | 200/200 posts within ±0.011 pp of the recomputed value (e.g. 781,527 / 4,947,577 = 15.80%, displayed 15.80%; 726,694 / 12,679,817 = 5.73%, displayed 5.73%; 667,438 / 17,370,309 = 3.84%, displayed 3.84%). 0 failures, 0 skipped | PASS |
| A5a/A5b/A6/A7-Robinhood | 2–7 | as above | Spec gives no brand; nothing can be tested without substituting one (Rule 1) | BLOCKED (test-data gap) |
| A5a/A5b/A6/A7-PlayOn | 2–7 | as above | Same | BLOCKED (test-data gap) |

## Evidence
- Hulu Sum row: Engagements 15,896,393 | Engagement Rate N/A | Impressions 1,153,240,088 | Organic Impressions – | Paid Impressions – | Reach / Organic Reach / Paid Reach N/A | Engaged User Rate N/A.
- Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions. The Channel cell is icon-only (empty text), so "TikTok only" rests on `channels=tiktok` in the URL and `.channel-ghost.enabled` = `["tiktok"]`.
- Top three posts: #1 Tue Aug. 08, 2023, 781,527 engagements / 4,947,577 impressions / 15.80%; #2 Mon Sep. 25, 2023, 726,694 / 12,679,817 / 5.73%; #3 Sun Nov. 19, 2023, 667,438 / 17,370,309 / 3.84%.
- Scope limit: the Table View renders 200 posts per page with no pagination control, so the 367 lowest-ranked of the 567 TikTok posts were not evaluated per post. The Sum row covers the full set.
- Screenshots in `.playwright-out/QA-29237/`: `L1-01-hulu-content.png`, `L1-02-dates.png`, `L1-03-tiktok-grid.png`, `L1-04-tiktok-table.png`, `L23-01-playon-default-brand.png`. None was opened for viewing; the checks went through DOM text, class and URL values.
- Console log: `.playwright-out/console-2026-10-30T06-35-49-033Z.log` (heavy pre-existing dev console-error noise, none relevant to the assertions).

## Known bugs checked
- Case file "Open linked bugs": None open. Pre-fetched `bug-history.md` greps for QA-29237: none. `known-quirks.md`: the Wednesday-only NBCU / Apple Music data-floor quirks do not apply on Friday; no Friday-specific quirk was listed.
- QA-29278 (TikTok "–" Total Impressions) did not reproduce on Hulu: Impressions is populated on 200/200 TikTok posts.
- No render hang occurred: `Posts (567)` rendered, and the Table View scrape succeeded on the first try.
- No known bug changed any verdict, and nothing observed is a regression.

## Bugs filed
None (markdown-only policy).

## Notes for harvest / spec owner
- The Friday row of the Description table names a brand only for Hulu. Robinhood and PlayOn! Sports need a brand each (or should be trimmed from the rotation).
- The case `## Notes` weekday line (Fri Hulu/Ralph Lauren) disagrees with the Description table; the table was followed.
- A6 can never be a non-vacuous check on TikTok: Reach, Organic Reach and Paid Reach are "–" for every TikTok post.
- The Table View cap of 200 rows means channels with more than 200 posts in a year are only partially evaluated per post.
