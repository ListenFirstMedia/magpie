# QA-100878 — Brand > Content - Threads Only: Insights Data Set - Basic View

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-data-set-selector` (stable) · **Account:** HBO Max (header "ACCOUNT: HBO MAX", already the post-login account) · **Brand:** HBO Max (brand_id 155614; exact typeahead match, first result) · **Date range:** Jun. 01, 2025 – Jun. 07, 2025 (START/END picker read back "Jun 01, 2025 / Jun 07, 2025"; URL `from=2025-06-01&to=2025-06-07`) · **Data set:** Threads Only: Insights (`table_data_set=threads_only:_insights`) · **View:** default perspective (`perspective=extended`; the spec gives none) · **Layout:** default grid, plus Table View for cross-check.

**Verdict: PASS** — all six required metrics (Engagements, Likes, Replies, Quotes, Reposts, Views) display for the Threads Only: Insights data set, in both the grid and Table View. The data set also shows a seventh metric, **Shares**, which the spec does not list. It does not contradict the assertion and is noted below.

## Steps executed
1. Logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com). Account header read **HBO MAX**. Brand > Content was reached via the top nav (hover **Brand** → click **Content**). Landing: HBO Max, 208 posts, default data set Public.
2. Clicked the Brand dropdown (`.brand-selector-name-container`) and typed "HBO Max" into the search box.
3. Selected the exact "HBO Max" result (index 0; the others were "HBO Max (ANZ)", "HBO Max (APAC)", …). The brand selector read "HBO Max". Opened the date picker, set START Jun 01, 2025 and END Jun 07, 2025, clicked Ok. Posts re-rendered (155).
4. Opened the Data Set dropdown (30 options listed, including `Threads Only: Insights`) and clicked **Threads Only: Insights**. The trigger label changed to "Threads Only: Insights" and the app auto-limited channels to Threads (`channels=threads`). Result: **Posts (21)**.
5. Read the metric columns from the grid (aggregate row + post cards), then switched to Table View (`[title="Table View"]`) and read the headers and all 21 rows from the DOM.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4-1 | 4 | "Engagements" displayed | Grid aggregate header ENGAGEMENTS (Sum 3,020 / Avg 144); post cards show "Engagements"; Table View column "Engagements" | PASS |
| A4-2 | 4 | "Likes" displayed | Grid LIKES (Sum 2,754 / Avg 131); Table View column "Likes" | PASS |
| A4-3 | 4 | "Replies" displayed | Grid REPLIES (Sum 39 / Avg 2); Table View column "Replies" | PASS |
| A4-4 | 4 | "Quotes" displayed | Grid QUOTES (Sum 20 / Avg 1); Table View column "Quotes" | PASS |
| A4-5 | 4 | "Reposts" displayed | Grid REPOSTS (Sum 105 / Avg 5); Table View column "Reposts" | PASS |
| A4-6 | 4 | "Views" displayed | Grid VIEWS (Sum 481,672 / Avg 22,937); Table View column "Views" | PASS |

## Evidence
- Grid aggregate header (exact text): `ENGAGEMENTS  LIKES  REPLIES  QUOTES  REPOSTS  SHARES  VIEWS`. Sum row: `3,020 | 2,754 | 39 | 20 | 105 | 102 | 481,672`. Average row: `144 | 131 | 2 | 1 | 5 | 5 | 22,937`.
- Table View headers: `Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Likes, Replies, Quotes, Reposts, Shares, Views, Actions`. It has 21 post rows plus the Sum/Average row.
- Sanity check: the independent sum of the 21 per-post Engagements values is 3,020, which equals the Sum row.
- Top post (#1, SAT JUN. 07, 2025 10:00 AM PDT, "She has a type."): Engagements 807, Likes 751, Replies 8, Quotes 1, Reposts 16, Shares 31, Views 192,401. No post cards show "–" for the required metrics on the top posts (not exhaustively checked for all 21).
- Screenshots in `.playwright-out/QA-100878/`: `01-content-landing.png`, `02-brand-typeahead.png`, `03-datepicker.png`, `04-dataset-dropdown.png`, `05-threads-insights.png`, `06-table-view.png`.

## Notes
- **Shares:** the data set renders a seventh metric, "Shares", between Reposts and Views. The assertion lists six metrics ("ensure the following metrics are displaying"), and all six are present, so this is treated as additive rather than a failure. If the product intent is "exactly these six", the ticket needs a decision. Not filed as a bug.
- **Environment slowness:** at the start of the run the dev app sat on "Loading..." for ~3 minutes because the 4 MB `explorer-vendors` bundle served very slowly (curl took >90 s). It then redirected to the login page and everything ran normally. The Cognito login, account, nav and data loads all worked once the bundle arrived. No step exceeded the 5-minute budget.
- Browser console showed many errors throughout the dev session; none related to this surface were investigated, and none affected the assertions.
- **Perspective toggle:** the spec does not specify Public vs Authorized, so the default (`perspective=extended`) was left as is. The six metrics are the data set's own columns.

## Known bugs checked
The case file's "Open linked bugs" section reads "None open" (Rule 7 screen passed). The pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-100878 had no matches. No known bug interfered with the steps or assertions.

## Bugs filed
None. Cleanup: none (read-only case).

**Verdict: PASS**
