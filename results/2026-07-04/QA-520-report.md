# QA-520 — Facebook Content - Table Data Set - Authorized & UnAuthorized

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless, unattended), real Chrome, `app.lfmdev.in`
- **Source case:** testcases/english/QA-520.md (Jira QA-520, Priority: Blocker)
- **Open-bug screen (Rule 7):** "None open" → ran normally.
- **Skills used:** brand-content-data-set-selector (stable), brand-content-table-view, switch-account
- **Verdict:** **PASS** (4/4 assertions)

## Preconditions
- Logged in as `lfiqa@listenfirstmedia.com` (config/.env) → pre-flight `#home` "Home - ListenFirst" rendered.
- Account switched Disney Ad Sales (634) → **Adam Orfei (account_id=54)** via LFQA menu → Search Account → Results `.lfm-ta-option`. ✓

## Steps executed
1. Brand > Content via top-nav (Brand → Content). Landed on default brand Star Wars (brand_id=75007).
2. Opened brand picker (chevron → "Search for a Brand" textarea), typed "Star Wars". Typeahead returned an **exact "Star Wars"** as the first result (among 90+ regional/variant brands) → clicked the exact match (Rule 1). Brand = Star Wars (brand_id=75007).
3. Channel selector: disabled Twitter/Instagram/TikTok/LinkedIn/Threads (trusted clicks), left **Facebook** only → **Apply** → URL `channels=facebook`.
4. Data Set dropdown (`Public`) → trusted click → selected **Impressions** → URL `table_data_set=impressions`.
5. Clicked **Table View** (`[title="Table View"]`) → layout `view-mode` active; aggregate Sum/Average toggle rendered.
6. Reviewed aggregate **Sum** values (toggle unchecked = Sum).
7. Flipped aggregate toggle to **Average** (`.aggregate-row-toggle-container label.toggle-switch-label`, checked=true) and reviewed **Average** values.

## Context
- Star Wars on Facebook is an **unauthorized** brand feed for these metrics — per-post metric cells (except Engagements) render the **lock symbol** (`.fa-lock`); this is the Authorized/UnAuthorized behavior the case validates.
- Date window: default 2026-06-26 → 2026-07-02; Posts(8) Facebook. Perspective `extended`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Only Engagements displays a value; other metrics display the Lock symbol | Per-post data cells: Engagements shows values (2,699 / 2,396 / …); all 8 other metrics (Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate) show `.fa-lock` on **8/8** data rows | **PASS** |
| A5a | 5 | Engagement Rate, Reach, Organic Reach, Paid Reach, Engaged User Rate → **N/A** for aggregate Sum | Engagement Rate=N/A, Reach=N/A, Organic Reach=N/A, Paid Reach=N/A, Engaged User Rate=N/A | **PASS** |
| A5b | 5 | Impressions, Organic Impressions, Paid Impressions → **"0" or "-"** for aggregate Sum | Impressions=–, Organic Impressions=–, Paid Impressions=– | **PASS** |
| A7 | 7 | All metrics display **"-"** for aggregate Avg except Engagements | Engagements=1,156; Engagement Rate/Impressions/Organic Impressions/Paid Impressions/Reach/Organic Reach/Paid Reach/Engaged User Rate = – (all dash) | **PASS** |

## Evidence

**Aggregate Sum row** (`.aggregate-row`):
- Engagements: **9,247**
- Engagement Rate: N/A
- Impressions: – | Organic Impressions: – | Paid Impressions: –
- Reach: N/A | Organic Reach: N/A | Paid Reach: N/A | Engaged User Rate: N/A

**Aggregate Average row** (toggle=Average):
- Engagements: **1,156**
- Engagement Rate: – | Impressions: – | Organic Impressions: – | Paid Impressions: –
- Reach: – | Organic Reach: – | Paid Reach: – | Engaged User Rate: –

**Per-post lock check:** Engagements column = 0 locks (numeric values); each of the 8 other metric columns = 8/8 locked cells.

Screenshots:
- `.playwright-out/QA-520/step5-table-view-sum.png` (Table View, Sum aggregate + per-post locks)
- `.playwright-out/QA-520/step7-aggregate-average.png` (Average aggregate row)

## Scope notes
- No Google Sheets steps in this case (nothing skipped for GS scope).
- No external-user / second-identity precondition.

## Bugs filed
None. Behavior matches spec — unauthorized Facebook metrics correctly show lock symbols per-post, and N/A (rate/reach) vs "–" (impressions) in the aggregate Sum, all "–" in the aggregate Average, with Engagements the only populated metric. Consistent with brand-content-data-set-selector SKILL note (QA-520, 2026-07-02).
