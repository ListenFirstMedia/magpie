# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (all 3 assertions hold with formula 1, Engagements / Video Views)

- Run: 2026-10-30 (Friday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: Friday row of the Description table. Account **Hulu**, Brand **Hulu** (first Friday entry, consistent with earlier runs that used the first entry of the day's row). The case Notes line says "Fri Hulu/Ralph Lauren"; that is stale, since Ralph Lauren is a Thursday brand. The Description table is authoritative.
- Skill used: `brand-content-grid-math` plus shared helpers `devprod-helpers.js` (login, account switch, navigation, brand typeahead, channel and data-set setters, Table View scrape). The prod tab was not used. No skill/REGISTRY edits (deferred to harvest.sh).
- Rule 7 screen: case file "Open linked bugs" = None open, so the case was run.
- Date range: default 2026-10-22 to 2026-10-28 (the app default; the spec sets no range).

## Steps executed
1. Logged in with the Cognito "existing account" form, then switched account to **Hulu** (header read `ACCOUNT: HULU`). Hovered **Brand** in the top nav and clicked **Content** -> `#explore/brand/content`.
2. Step 2 (Add a Brand / public data set): the page opened on Hulu. I still re-selected the brand through the typeahead (exact option **Hulu**, `brand_id=5670`, header reads "Hulu") and chose the **Public** option in the data-set dropdown (`table_data_set=public`). Posts (210) across all channels.
3. Step 3: clicked **Filter**, opened **Content Type**, selected **Video**, clicked **Apply**. URL carries `content_types ... values ["Video"]`. Posts (170) across all channels (`f-02-filter-open.png`, `f-03-contenttype.png`).
4. Step 4: **Facebook only** (clicked the Facebook ghost on, all others off, **Apply**). Enabled-channel check: `["facebook"]`. Posts (50).
5. Step 5: Table View, 50 posts. Read the Sum row, then clicked the Sum/Average toggle (`#aggregate_row`, checkbox state verified) and read the Average row.
6. Step 6: **Twitter only**. Enabled-channel check: `["twitter"]`. Posts (29).
7. Step 7: Table View, 29 posts. Read Sum and Average rows.
8. Step 8: **TikTok only**. Enabled-channel check: `["tiktok"]`. Posts (48). It rendered in about 31 s with no hang, no "failed to load" and no reload needed.
9. Step 9: Table View, 48 posts. Read Sum and Average rows.

## Assertions
Formula 1 (Engagements / Video Views) works, so formula 2 was not needed. The Sum row shows "N/A" for Video Response Rate by design; the rate is shown in the Average row.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Sum Engagements 104,357 / Sum Video Views 3,152,176 = 3.3106%. Average row Video Response Rate = **3.31%** | PASS |
| A7 | 7 (Twitter only) | same | Sum Engagements 2,468 / Sum Video Views 262,849 = 0.9389%. Average row Video Response Rate = **0.94%** | PASS |
| A9 | 9 (TikTok only) | same | Sum Engagements 279,323 / Sum Video Views 14,518,051 = 1.9240%. Average row Video Response Rate = **1.92%** | PASS |

## Evidence
- Facebook: Average row Engagements 2,087, Response Rate 0.04%, Video Views 63,043, Video Response Rate 3.31%. Posts in Table View: 50. 49 of 50 carried a per-post Video Response Rate; 1 post has no video views.
- Twitter: Average row Engagements 85, Response Rate <0.01%, Video Views 9,063, Video Response Rate 0.94%. Posts: 29 (27 with a per-post rate).
- TikTok: Average row Engagements 5,819, Response Rate 0.09%, Video Views 302,459, Video Response Rate 1.92%. Posts: 48 (all 48 with a per-post rate, none with "–" views). TikTok views are rounded in the grid (3,000,000; 1,700,000; 7,800,000 ...), which does not affect the Sum-row ratio.
- Sum row values were read directly from the page, not derived. Ratios computed from the displayed Sum values, matching the displayed rate to 2 decimals on all three channels.
- Side observation (not an assertion): the mean of the per-post rates (formula 2) is not the same number as the Average-row rate: Facebook 1.80%, Twitter 2.43%, TikTok 4.18%. The Average row therefore uses Sum / Sum (formula 1), which is what the spec lists first. No discrepancy against the spec.
- Screenshots (`.playwright-out/QA-79142/`): `f-00-login.png`, `f-01-content.png`, `f-02-filter-open.png`, `f-03-contenttype.png`, `f-04-facebook.png`, `f-05-facebook-avg.png`, `f-06-twitter-avg.png`, `f-07-tiktok-state.png`, `f-08-tiktok-avg.png`. Files with other prefixes in that folder are from earlier runs.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md: no entries for QA-79142 (pre-fetched).
- known-quirks.md: the earlier "QA-79142 still hangs on its TikTok leg" note concerns other weekday brands on earlier days. It did not reproduce on Hulu: TikTok loaded in about 31 s on the first attempt. The "Dev render hangs" quirk did not interfere with any step.
- No linked or related bug applies, and none was observed during the run.

## Bugs filed
None.
