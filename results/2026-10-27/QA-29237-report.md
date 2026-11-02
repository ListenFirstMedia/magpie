# QA-29237 — Brand Content > Impressions Data Set > Past date range data test - TikTok

**Verdict: PASS** for the two Tuesday legs that could be run (UCLA, Viacom/MTV). The third Tuesday leg (Wasserman / Gatorade) is **BLOCKED (test-data)** because the account's data floor is Oct 25, 2023, so the spec start date Jan 01, 2023 cannot be selected. See "Per-leg verdicts" and "Judgement call" below.

- Run: 2026-10-27 (Tuesday), headless unattended, Playwright MCP, app.lfmdev.in (dev), user LFQA (config/.env)
- Skills used: `brand-content-grid-math` (Table View scrape), `brand-content-native-post-check` / dev-vs-prod helper library (date picker mechanics via `m.setDates`), `switch-account` mechanics (`m.switchAccount`). The REGISTRY grep was not needed (pre-resolved skill `brand-content-grid-math`).
- Open linked bugs screen (Rule 7): case file says "None open", so the case ran. No bug history entries for QA-29237.

## Setup / precondition
- Weekday rotation: the Description table is authoritative. **Tuesday = Accounts UCLA / Viacom / Wasserman**, Brands *University of California, Los Angeles* / *MTV* / *Gatorade* (positional pairing). The case "Notes" line (Tue UCLA/Sony Pictures) conflicts with the Description table; I did not follow it (same call as the 2026-10-20 run of this case and QA-29234/29235).
- Unlike the 2026-10-20 run, which only ran the first pair, this run executed all three Tuesday pairs because the spec lists all three.
- Login: Cognito "With existing account" form, `app.lfmdev.in/#home` rendered (account_id=54 initially).
- Each leg: switched account through the profile menu "Search Account" → Results item (real mouse click), confirmed `ACCOUNT: <name>` in the breadcrumb.

## Steps executed (per leg)
1. Hovered Brand in the top nav and clicked Content (`#explore/brand/content`).
2. Brand: confirmed the exact spec brand name in the brand selector (it was already the account's selected brand for UCLA and Viacom, so no typeahead substitution was needed; Rule 1). Data Set dropdown (visible) → **Impressions** (URL `table_data_set=impressions`).
3. Channels: clicked TikTok ghost on and every other channel ghost off, Apply. URL `channels=tiktok`; only `tiktok` enabled.
4. Date range: START Jan 01, 2023 / END Dec 31, 2023 via the picker, Ok. Field read back "Jan 01, 2023 / Dec 31, 2023", URL `from=2023-01-01&to=2023-12-31`.
5. Switched to Table View, scraped all rendered rows via DOM, evaluated A5/A5b/A6/A7 per post in page JS.

## Per-leg verdicts
| Leg | Account | Brand | Result |
|---|---|---|---|
| 1 | UCLA (account_id=799) | University of California, Los Angeles (brand_id=127756) | PASS |
| 2 | Viacom (account_id=181) | MTV (brand_id=4018) | PASS |
| 3 | Wasserman (account_id=863) | Gatorade (brand_id=3580) | BLOCKED (test-data), date floor |

## Assertions
Leg 1 — UCLA / University of California, Los Angeles, TikTok, Jan 01 – Dec 31 2023. Posts (134), all 134 rendered and scraped.

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | Impressions metric displays a value | 134/134 posts show a numeric Impressions value (0 dashes, 0 zeros). Sum row 30,872,864; independent per-post sum 30,872,864 (match). | PASS |
| A2 | 5 | En-dash for Organic and Paid Impressions | 134/134 posts show "–" for both Organic Impressions and Paid Impressions; Sum row and Average row also "–". | PASS |
| A3 | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach and Paid Reach are "–" on 134/134 posts (Sum row "N/A"). No number exists to sum, so the identity is vacuous; there is no post where the components disagree with the total. | PASS (vacuous) |
| A4 | 7 | Engagement Rate = Engagement / Impressions * 100 | 134/134 posts within ±0.01 pp of the displayed 2-decimal value. Rank 1: 139,458 / 2,695,051 = 5.17% (shown 5.17%). Rank 2: 115,267 / 3,958,203 = 2.91% (shown 2.91%). Average row ER 2.36%; derived 729,286 / 30,872,864 = 2.362%. Sum row ER shows "N/A" by design. | PASS |

Leg 2 — Viacom / MTV, TikTok, Jan 01 – Dec 31 2023. Header "Posts (1,027)"; the Table View renders only the top 200 posts (no pager; documented app behavior), so per-post checks cover those 200.

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | Impressions metric displays a value | 200/200 rendered posts numeric (e.g. 12,900,000; 6,000,000). Sum row (all 1,027 posts) 423,051,583. | PASS |
| A2 | 5 | En-dash for Organic and Paid Impressions | 200/200 "–" for both; Sum row "–". | PASS |
| A3 | 6 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach and Paid Reach all "–" on 200/200 posts (Sum row "N/A"). Vacuous, same as leg 1. | PASS (vacuous) |
| A4 | 7 | Engagement Rate = Engagement / Impressions * 100 | 200/200 within ±0.01 pp. Rank 1: 1,627,054 / 12,900,000 = 12.61% (shown 12.61%). Rank 2: 1,456,200 / 6,000,000 = 24.27% (shown 24.27%). | PASS |

Leg 3 — Wasserman / Gatorade.

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1–A4 | 3–7 | As above | Not evaluable. Step 3 (date range Jan 01, 2023 – Dec 31, 2023) cannot be performed: the picker advertises "Historical data is available back to Oct. 25, 2023"; in the 2023 month view Jan–Sep are `disabled` and only Oct/Nov/Dec are selectable, and the year "prev" arrow is `disabled`. Account WASSERMAN and brand Gatorade were confirmed in the breadcrumb/selector. No substitute date range was used (Rule 3, known-quirks "rolling retention floor" entry). | BLOCKED (test-data) |

## Evidence
- UCLA: `.playwright-out/QA-29237/ucla-01-content-landing.png`, `ucla-02-grid-impressions-tiktok.png` (tile grid: Impressions data set, TikTok only, Posts (134), Sum 729,286 / N/A / 30,872,864 / – / –, Average 5,442 / 2.36% / 230,395 / – / –, Reach columns N/A), `ucla-03-table-view.png`.
- MTV: `.playwright-out/QA-29237/mtv-02-grid-impressions-tiktok.png`, `mtv-03-table-view.png`. Sum row: Engagements 37,303,442; Impressions 423,051,583; Organic/Paid Impressions "–"; Reach columns N/A.
- Gatorade block: `.playwright-out/QA-29237/gatorade-debug-datepicker.png` (picker showing the Oct 25, 2023 notice with only Oct/Nov/Dec enabled in 2023).
- Table columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

## Known bugs checked
- Case file "Open linked bugs": None open. `knowledge-base/bug-history.md` has no QA-29237 entry. Nothing to attribute.
- A3 being vacuous is expected TikTok behavior (the platform exposes no Reach or Organic/Paid split for TikTok), consistent with the 2026-10-20 run. It is not treated as a bug.
- The Gatorade block matches the known-quirks "rolling ~3-year retention floor" pattern (floor Oct 25, 2023 on run date 2026-10-27). UCLA and Viacom have older history (Jan 2023 selectable), so the floor is account-specific. Not filed as a product bug.

## Judgement call (please review)
- The headline verdict is PASS because both runnable legs pass every assertion and the sibling runs (2026-10-20 run of this case, QA-29234/29235) only ever exercised the first pair. If the Wasserman leg is required to count, the strict verdict is BLOCKED (test-data) until the spec date range is updated or Wasserman's retention is extended.
- Numbers moved slightly since 2026-10-20 (UCLA Engagements 729,214 → 729,286; Impressions 30,870,131 → 30,872,864) as TikTok stats refreshed. Identities still hold.

## Bugs filed
None. (Spec-drift note only: the Tuesday Wasserman/Gatorade leg needs a date range at or after the account's retention floor, or the case should drop that pair.)
