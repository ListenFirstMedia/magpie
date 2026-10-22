# QA-100878 — Brand > Content - Threads Only: Insights Data Set - Basic View

**Verdict: PASS**

- Run: 2026-10-22, unattended headless (`claude -p`, Playwright MCP), env `app.lfmdev.in`
- Case file: `cases/QA-100878.md` (Test Set QA-21686 "Daily Data Testing -3")
- Skill used: `brand-content-grid-math` (data-set dropdown + Table View mechanics) and the date-picker notes from `brand-content-native-post-check`; `switch-account` mechanics for the account precondition. No skill maintenance (deferred to harvest.sh).

## Preconditions
- Logged in via Cognito "With existing account" (`config/.env`). The session landed on account **SPOTIFY** (account_id=1030), so the account was switched via profile menu → Search Account → real mouse click on the `Results` row → `ACCOUNT: HBO MAX` (account_id=657) confirmed in the breadcrumb.

## Steps executed
1. Hovered **Brand** in the top nav and clicked **Content**. Landed on `#explore/brand/content?brand_id=155614&account_id=657` (default week Oct 14–20, 2026, Public data set). Screenshot: `.playwright-out/QA-100878/step1-brand-content.png`.
2. Clicked the **Brand dropdown** (chevron beside the brand name). Panel opened with a "Search for a Brand" box and Recent Searches. Screenshot: `step2-brand-dropdown-open.png`.
3. Typed `HBO Max`. The first attempt showed only Recent Searches, so I retyped the last character (documented nudge). The typeahead then listed the exact entry **"HBO Max"** (plus regional variants). Clicked the exact "HBO Max" option with a real mouse click. Brand name shows "HBO Max", `brand_id=155614` (Rule 1 satisfied, no substitute). Screenshot: `step3-brand-selected.png`.
   - Date range: opened the date picker, set START DATE = Jun 01, 2025 and END DATE = Jun 07, 2025 via the datepicker UI (not URL), and verified the fields read `Jun 01, 2025 → Jun 07, 2025` before **Ok**. URL then showed `from=2025-06-01&to=2025-06-07`. Screenshot: `step3-dates-set.png`.
4. Opened the **Data Set** dropdown (visible `.lfm-dropdown-select-box`) and selected **Threads Only: Insights**. The select box then read "Threads Only: Insights"; URL `table_data_set=threads_only%3A_insights`; the channel filter auto-narrowed to Threads only (`channels=threads`); the grid rendered **Posts (21)**. Screenshots: `step4-dataset-dropdown.png`, `step4-threads-insights.png`.

View toggle was left on the default **Authorized data** (the URL carried `perspective=extended`); the case does not name a perspective, so the default was kept.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Metric **Engagements** displayed | Summary header "ENGAGEMENTS" Sum 3,020 / Avg 144; Table View column "Engagements"; post #1 card shows `Engagements 807` | PASS |
| A2 | 4 | Metric **Likes** displayed | Summary "LIKES" Sum 2,754 / Avg 131; column "Likes"; post #1 `Likes 751` | PASS |
| A3 | 4 | Metric **Replies** displayed | Summary "REPLIES" Sum 39 / Avg 2; column "Replies"; post #1 `Replies 8` | PASS |
| A4 | 4 | Metric **Quotes** displayed | Summary "QUOTES" Sum 20 / Avg 1; column "Quotes"; post #1 `Quotes 1` | PASS |
| A5 | 4 | Metric **Reposts** displayed | Summary "REPOSTS" Sum 105 / Avg 5; column "Reposts"; post #1 `Reposts 16` | PASS |
| A6 | 4 | Metric **Views** displayed | Summary "VIEWS" Sum 481,672 / Avg 22,937; column "Views"; post #1 `Views 192,401` | PASS |

## Evidence
- Table View (`table.lfm-table`) headers: `Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Likes, Replies, Quotes, Reposts, Shares, Views, Actions`. 22 `tbody` rows (21 posts + the Sum/Average row).
- Aggregate row: Engagements 3,020 | Likes 2,754 | Replies 39 | Quotes 20 | Reposts 105 | Shares 102 | Views 481,672.
- The dataset also shows a **Shares** metric beyond the six the spec lists. The assertion only requires the six named metrics to be present, so this does not affect the verdict.
- Screenshots: `.playwright-out/QA-100878/` (`step1-…`, `step2-…`, `step3-…`, `step4-…`).
- Environment noise: the browser console logged many errors on this dev site; none affected the page render, and no 4xx/5xx was investigated since all assertions rendered.
- A "Facebook Posts Insights Disruption" status banner was visible; it concerns Facebook only and is irrelevant to this Threads-only case.

## Known bugs checked
- Case file "Open linked bugs": **None open** (Rule 7 screen passed, so the case was run).
- `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-100878 (pre-fetched).
- During the run nothing reproduced that interferes with the assertions.

## Bugs filed
None.
