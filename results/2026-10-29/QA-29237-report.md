# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: PASS for the two legs that could be run (Sony Pictures Television, Ralph Lauren). Leg 1 (Spotify / Spotify News) is BLOCKED (test-data gap).** Overall: PASS (2 of 3 legs), with the Spotify leg flagged as BLOCKED. This follows the same partial-leg convention as the 2026-10-27 run. No assertion failed on any evaluated post.

- Run: 2026-10-29 (Thursday), unattended headless (Playwright MCP), dev `app.lfmdev.in`, user `lfiqa@listenfirstmedia.com` (Cognito "With existing account").
- Weekday row (Description table, authoritative): Thursday = Accounts **Spotify / Sony Pictures / Ralph Lauren**, Brands **Spotify News / Sony Pictures Television / Ralph Lauren**. The case `## Notes` line ("Thu Spotify/Conde Nast") disagrees with the table; the table was used.
- Skill: `brand-content-grid-math` (Table View DOM scrape via `_shared/playwright-helpers/devprod-helpers.js`). Open-bug screen (Rule 7): case says "None open", so it ran normally.
- Perspective: each brand landed on "Authorized data" (`perspective=extended`). The spec does not name a perspective, so it was left at the app default.

| Leg | Account | Brand | Result |
|---|---|---|---|
| 1 | Spotify (account_id 1030) | Spotify News | BLOCKED (test-data): the spec brand is not findable on dev |
| 2 | Sony Pictures (account_id 51) | Sony Pictures Television (brand_id 129863) | PASS (200 of 207 TikTok posts evaluated) |
| 3 | Ralph Lauren (account_id 732) | Ralph Lauren (brand_id 7000) | PASS (200 of 243 TikTok posts evaluated) |

## Steps executed
Per leg, via the UI: account menu > Search Account > clicked the exact `Results` entry; hovered **Brand** > **Content**; brand typeahead (exact name from the Results); **Data Set** dropdown (visible one) > **Impressions** (`table_data_set=impressions`); date picker START DATE = Jan 01, 2023, END DATE = Dec 31, 2023 (read back from `.date-range-fields`, URL `from=2023-01-01&to=2023-12-31`); channels: clicked every other `.channel-ghost` off, TikTok on, verified `.channel-ghost.enabled` = `["tiktok"]`, clicked **Apply** (URL `channels=tiktok`); **Table View** DOM scrape (200 rows per page, plus the Sum/Average row).

1. **Leg 1 (Spotify).** Account Spotify (1030) landed on brand "Star Wars". Brand typeahead, typed slowly (150 ms/char, up to 24 s wait): `Spotify News` returned 0 results; `Spotify New` returned only "New (Spotify)", "Spotify (Australia/New Zealand)" and "synecdoche new york (Spotify)"; `Spotify` returned 68 Spotify brands (Africa, Arabia, Argentina, Asia, …), none containing "News". Rule 1: no substitute used, steps 2–7 not executable. Screenshots `L1-01`, `L1-02`.
2. **Leg 2 (Sony Pictures Television).** Brand selector showed the exact name "Sony Pictures Television" (brand_id 129863). Impressions data set applied; date range set; the page rendered `Posts (1,024)` with all channels on. TikTok only → `Posts (207)`. Table View: 200 rows rendered (the page cap; the 7 lowest-ranked posts are not rendered) plus the Sum row. Screenshots `L2-01` … `L2-04`.
3. **Leg 3 (Ralph Lauren).** Exact brand "Ralph Lauren" (brand_id 7000) loaded and rendered (the dsp-api hang seen in today's QA-29234 run did not occur). Impressions data set applied; date range set; `Posts (1,648)` with all channels on. TikTok only → `Posts (243)`. Table View: 200 rows rendered plus the Sum row. Screenshots `L3-01` … `L3-03`.

## Assertions
Case assertions (the ticket numbers two of them "5"): A5a = "impression metric displays the value", A5b = "En-dash for both Organic and Paid Impressions", A6 = "Organic Reach + Paid Reach = Reach", A7 = "Engagement Rate = Engagements / Impressions × 100".

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a-Spotify | 2–5 | Impressions displays a value | Brand "Spotify News" does not exist in the brand typeahead (Step 1 above) | BLOCKED (test-data gap) |
| A5b-Spotify | 2–5 | En-dash for Organic and Paid Impressions | Same | BLOCKED (test-data gap) |
| A6-Spotify | 2–6 | Organic Reach + Paid Reach = Reach | Same | BLOCKED (test-data gap) |
| A7-Spotify | 2–7 | Engagement Rate = Engagements / Impressions × 100 | Same | BLOCKED (test-data gap) |
| A5a-Sony | 5 | Impressions displays a value | 200/200 posts show a number (top post 760,247). Sum row 66,973,436 | PASS |
| A5b-Sony | 5 | "–" for Organic and Paid Impressions | Organic Impressions "–" on 200/200, Paid Impressions "–" on 200/200 (Sum row "–" / "–") | PASS |
| A6-Sony | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach, Paid Reach all "–" on 200/200 posts (Sum row "N/A" for all three). No number exists to sum, so the identity holds vacuously; 200 skipped as "no data", 0 failures | PASS (vacuous) |
| A7-Sony | 7 | Engagement Rate = Engagements / Impressions × 100 | 200/200 posts within ±0.011 pp of the recomputed value (e.g. 84,366 / 760,247 = 11.10%, displayed 11.10%; 66,977 / 1,306,299 = 5.13%, displayed 5.13%). 0 failures, 0 skipped | PASS |
| A5a-Ralph | 5 | Impressions displays a value | 200/200 posts show a number (top post 6,300,000). Sum row 52,814,103 | PASS |
| A5b-Ralph | 5 | "–" for Organic and Paid Impressions | Organic Impressions "–" on 200/200, Paid Impressions "–" on 200/200 (Sum row "–" / "–") | PASS |
| A6-Ralph | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach, Paid Reach all "–" on 200/200 posts (Sum row "N/A"). Vacuous, same as Sony; 200 skipped, 0 failures | PASS (vacuous) |
| A7-Ralph | 7 | Engagement Rate = Engagements / Impressions × 100 | 200/200 posts within ±0.011 pp (e.g. 471,310 / 6,300,000 = 7.48%, displayed 7.48%; 100,695 / 536,300 = 18.78%, displayed 18.78%). 0 failures, 0 skipped | PASS |

## Evidence
- Sony Pictures Television Sum row: Engagements 726,107 | Engagement Rate N/A | Impressions 66,973,436 | Organic Impressions – | Paid Impressions – | Reach / Organic Reach / Paid Reach N/A | Engaged User Rate N/A.
- Ralph Lauren Sum row: Engagements 1,547,257 | Engagement Rate N/A | Impressions 52,814,103 | Organic Impressions – | Paid Impressions – | Reach / Organic Reach / Paid Reach N/A | Engaged User Rate N/A.
- Table headers (both legs): Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Scope limit: the Table View renders 200 posts per page with no pagination control, so 7 (Sony) and 43 (Ralph Lauren) of the lowest-ranked TikTok posts were not evaluated. The Sum row covers the full set.
- Screenshots in `.playwright-out/QA-29237/`: `L1-01-spotify-news-typeahead.png`, `L1-02-spotify-typeahead.png`, `L2-01-ds.png`, `L2-02-dates.png` (inspected: Jan. 01, 2023 – Dec. 31, 2023, Impressions, `Posts (1,024)`), `L2-03-tiktok-grid.png`, `L2-04-tiktok-table.png`, `L3-01-ralph-content.png`, `L3-02-tiktok-grid.png`, `L3-03-tiktok-table.png`. Only `L2-02` was viewed; the rest were verified through DOM text, class and URL checks.
- Console log: `.playwright-out/console-2026-10-29T08-46-39-889Z.log` (heavy pre-existing dev console-error noise, none relevant to the assertions).

## Known bugs checked
- Case file "Open linked bugs": None open. Pre-fetched `bug-history.md` greps for QA-29237: none. `known-quirks.md`: the Thursday rotation is not mentioned there; the Wednesday-only NBCU/Apple Music data-floor quirks do not apply to Thursday.
- QA-29278 (TikTok "–" Total Impressions) did not reproduce: Impressions is populated on 200/200 TikTok posts for both brands.
- The Ralph Lauren dsp-api CORS render hang from today's QA-29234 run did not reproduce in this session.
- No known bug changed any verdict, and nothing observed is a regression.

## Bugs filed
None (markdown-only policy).

## Notes for harvest / spec owner
- "Spotify News" does not exist on dev under the only Spotify account (1030); correct the rotation or the brand name (same finding as today's QA-29234 run).
- A6 can never be a non-vacuous check on TikTok: Reach, Organic Reach and Paid Reach are "–" for every TikTok post.
- The case `## Notes` weekday line (Thu Spotify/Conde Nast) disagrees with the Description table; the table was followed.
- The Table View cap of 200 rows means channels with more than 200 posts in a year are only partially evaluated per post.
