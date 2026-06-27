---
name: brand-content-dpa-modal
version: 1
last_verified: 2026-06-27
last_passed_run: 2026-06-27
trust: untrusted
pass_streak: 7
preconditions: [account-context, brand-or-brand-set-selected, posts-loaded]
postconditions: [dpa-modal-rendered, exports-verified]
inputs: [brand_or_brand_set_id, post_index, chart_type, date_window]
outputs: [png_filename, gs_filename, sum_avg_math]
related_pages: ["/#explore/brand/content", "/#explore/competitive/content"]
related_skills: [chart-hover-tooltip, export-csv, export-google-sheets]
---

# Brand > Content / Brand Sets > Content — Daily Post Analysis (DPA) Modal

End-to-end skill for the Daily Post Analysis modal launched from a post row's `Daily Analysis` button. Covers Graph display + behavior (Line/Bar/Area/Pie switch), Table display + behavior (Sum/Average + endash markers), and Export → PNG + Google Sheets pipeline.

Used by:
- **QA-99380** (Brand > Content DPA Graph Display & Behavior) — Adam Orfei brand, IG post, 5-metric line + bar switch — PASS 5/5.
- **QA-99416** (Brand Sets > Content DPA Table Display & Behavior) — Adam's Brand Set, NBA Twitter post — PASS 5/5; endash math verified.
- **QA-100764** (Brand>Content DPA Threads variant) — PASS via `brand-content-data-set-selector` carry.
- **QA-103246** (Brand>Content DPA Export PNG + GS) — MTV TikTok post, 6-metric verified end-to-end on disk; **DATA-12209** REPRODUCED.
- **QA-103248** (Brand Sets > Content DPA Export PNG + GS) — Off Campus (APV) TikTok; previously BLOCKED, unblocked with 7-day default window — PASS 8/8.

## Key UI structure

### Daily Analysis button on each post row
- Selector: `button.daily-analysis-button`.
- Visibility: hover-revealed on some layouts. JS-fallback click on the first matching button works reliably.

### DPA modal
- Container: `.al-daily-post-analysis-modal`.
- Header shows: `Date Range: MMM. DD, YYYY - MMM. DD, YYYY / Mode: In Window / Data Set: Public / Graph Metrics: <N> Metrics / <Post brand>`.
  - Default Mode = `In Window` (not Lifetime).
  - Date Range auto-extends from post publish date forward (typically +4 or +5 days).
- Chart-type dropdown labelled with current chart name (e.g. `Line`), exposes options: **Line / Area / Bar / Pie**.
- Below the chart: a Table with columns `Metric | Sum | Average | <date 1> | <date 2> | ... | <date N>`.
- Export dropdown top-right of modal: **PNG / CSV / Google Sheets**.
- Close: × button top-right.

## Steps

### Step 1 — Navigate to Brand > Content or Brand Sets > Content
- Brand: `/#explore/brand/content?brand_id={brand_id}&account_id={account_id}` (Public default).
- Brand Set: `/#explore/competitive/content?brand_set_id={brand_set_id}&account_id={account_id}` (default Rank = Engagements, Mode = In Window).
- **Assertion:** Posts table renders with `Posts (N)` count.

### Step 2 — Click Daily Analysis on the target post row
- **Action:** JS-fallback `document.querySelectorAll('button.daily-analysis-button')[0].click()` for the top-ranked post.
- **Assertion:** Modal `.al-daily-post-analysis-modal` appears with header showing post + date range.

### Step 3 — Verify Graph rendering
- **Default chart:** Line.
- **Selectors:**
  - Line stroke paths: `path.recharts-line-curve`.
  - Data point circles: `circle.recharts-dot`.
  - Axis labels (X = `MMM. DD`, Y = numeric ticks).
- **Tooltip pattern** (reuses `chart-hover-tooltip` skill): hover near a circle →
  - `.chart-tooltip__header` shows `MMM. DD, YYYY`.
  - `.chart-tooltip__row` shows `<MetricName>: <value>`.

### Step 4 — Switch chart type
- **Action:** click chart-type dropdown (label = current chart name) → click `Bar` (or other option).
- **Assertion:** chart re-renders as bars (`rect.recharts-rectangle` count = N_days × N_metrics). Axis labels persist. Tooltip mechanism continues to work.

### Step 5 — Verify Table beneath chart
- **Assertion:** Columns = `Metric | Sum | Average | <date 1> | … | <date N>`.
- **Sum/Average math:** Sum should equal the row sum of the per-day cells (treating `–` endash as 0). Average = Sum / N_days, including any endash days in the denominator.
- **Example endash math from QA-99416:** NBA Twitter Engagements 949,199 + 0 (May 31 endash) + 72,952 + 16,262 = 1,038,413 (matches Sum). Average = 1,038,413 / 4 = 259,603 (matches displayed `259,603`).

### Step 6 — DATA-12209 probe (TikTok on May 16 2026)
When the post is a **TikTok** row and the date range covers **May 16, 2026**:
- **Probe:** read the May 16 column for all metrics.
- **Expected (DATA-12209 REPRODUCED):** ALL metrics show endash `–` for May 16 only, while May 15 and May 17 show real numerics. Confirms DATA-12209 still open.
- **Verdict:** if May 16 has real numerics, DATA-12209 has been fixed (verify in the bug history).

### Step 7 — Export → PNG
- **Action:** Click Export dropdown → click `PNG`.
- **Expected filename:** `<Brand>-Daily Content Analysis-<ChartType>-YYYY-MM-DD-YYYY-MM-DD.png`.
  - Example: `MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png`.
  - Example: `Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png`.
- **Verification:** read file on disk via `~/Downloads/<filename>` (`audience-metrics-export` PNG-tile pipeline pattern). Confirm:
  - LISTENFIRST logo + wordmark top-left.
  - Brand title line.
  - Legend chips (one per metric).
  - Chart matches modal (X-axis dates, bar heights, line shape).
  - Footer: `Daily Content Analysis` + `Date: MMM. DD, YYYY-MMM. DD, YYYY`.

### Step 8 — Export → Google Sheets
- **Action:** Click Export dropdown → click `Google Sheets`. Capture the opened tab via `window.open` hook (per `export-google-sheets` skill).
- **Expected sheet title** (without `- Google Sheets`):
  `<Brand>-<PublishDate>-<PublishTime PST/PDT>-<Channel>-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD`.
  - Example: `Off Campus (APV)-May 28 2026-08-01 AM PDT-TikTok-Daily Content Analysis-2026-05-28-2026-05-31`.
  - **PST↔PDT note:** spec says `PST` but UI/file render `PDT` when the publish date is in DST. Conceptual match — both reference Pacific Time.
- **Sheet contents:**
  - A1: post URL.
  - Row 2 headers: `Date | Text | <metric 1> | <metric 2> | ...`.
  - Row 3: `SUM | – | <values>`.
  - Row 4: `AVG | – | <values>`.
  - Rows 5+: per-day data, with `YYYY-MM-DD` date format; blank metric cell for days that display as endash in the modal.

### Step 9 — Close modal
- **Action:** Click the × close icon.
- **Assertion:** Modal dismissed; underlying Brand>Content (or Brand Sets>Content) grid is restored.

## Brand Sets DPA workaround — the 7-day window unblock

QA-103248 was BLOCKED on 2026-05-27 because Adam's Brand Set with 76K+ posts hung the modal data-load on the long window. Workaround:
- Pick a 7-day default window (e.g., Last 7 Days) BEFORE opening the modal — Posts(~28K) loads in ~10s, modal opens cleanly.
- Adam's Brand Set + the long window pattern is the known-quirk trigger; LF // TV // Episodic with a 7-day window does NOT hang.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Daily Analysis button not visible | Layout requires hover-reveal | JS-fallback `.click()` on the first matching `button.daily-analysis-button` |
| Modal opens but chart area empty | Backend data-fetch error | Check console for 5xx; reload |
| Tooltip not rendering on hover | Recharts event-binding broken | Verify `.recharts-dot` count > 0; try `computer.hover` (see `chart-hover-tooltip`) |
| TikTok May 16 2026 column shows endash for all metrics | DATA-12209 REPRODUCED | File against the known bug |
| PNG filename missing `Daily Content Analysis` substring | Filename schema regression | File bug |
| GS sheet title shows `PST` even when publish date is in DST | Cosmetic timezone-label drift (spec says PST but actual is PDT in DST) | Not a bug — both reference Pacific Time |
| Brand Sets DPA modal hangs >40s on data-load | Long-window + large-brand-set known-quirk | Switch to 7-day window before opening modal |
| Modal Close × not clickable via coordinate | `<i class="fa-times close-icon">` not a `<button>` | JS-fallback `document.querySelector('.al-daily-post-analysis-modal i.fa-times').click()` |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../post_daily_analysis` | GET | 200 | Modal data source; 5xx indicates long-window/large-brand-set quirk |

## Known bug history

See `knowledge-base/bug-history.md`. Highest-priority open bugs currently tied to this skill's flows:

- DATA-12209 (Major) — Brand > Content Daily Post Analysis: TikTok endash on May 16, 2026 across all metrics.     [from QA-103246]

## Changelog

- **v1 reconfirm** (2026-06-27): QA-103246 (Brand>Content MTV TikTok PNG export, DATA-12209 reproduced) + QA-103248 (Brand Sets>Content Love Island USA TikTok PNG export, 8/8) both PASS on the PNG path; Google Sheets steps OUT OF SCOPE on the Playwright MCP track (Google 2FA — see `config/env.md`), so A5/A6/A7 are not-tested rather than failed. QA-100764 (Threads variant) BLOCKED on a test-data gap (Max has no Threads channel), not skill drift. pass_streak 5→7. **REGISTRY.md row added during the 2026-06-27 harvest — this skill had no registry entry before.**
- **v1** (2026-06-08): Initial draft from QA-99380 (Graph) + QA-99416 (Table + endash math) + QA-100764 (Threads variant) + QA-103246 (PNG+GS export with DATA-12209) + QA-103248 (Brand Sets variant with 7-day workaround). Documents filename schemas, PST↔PDT timezone-label drift, the Adam's Brand Set 76K-post hang workaround, and the endash-in-denominator average math.
