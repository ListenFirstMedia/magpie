# QA-132392 — Brand Set > Content: Impression Metrics Sum/Avg Row Behavior

- **Run:** 2026-07-08 (headless/unattended, Playwright MCP track, `feature/playwright-mcp`)
- **Case:** testcases/english/QA-132392.md
- **Environment:** app.lfmdev.in, logged in as `lfiqa@listenfirstmedia.com` (config/.env)
- **Account:** Adam Orfei (account_id=54) — switched from Viacom via LFQA menu → Search Account → Results
- **Brand Set:** Adam's Brand Set (brand_set_id=1738), Date Range = Last 30 Days (Jun 07 – Jul 06, 2026), Mode = Lifetime
- **Open linked bugs:** None open (screened) — ran normally.
- **Skills used:** switch-account (v2), brand-content-data-set-selector (Brand-Sets>Content variant), brand-content-filter (Content Brand filter), export-csv.

## Verdict: **PASS (15/15 in-scope assertions)**

All CSV exports on Brand Sets > Content were **synchronous downloads to disk** (verified on disk); no Google Sheets steps were involved, so nothing was out of scope.

## Steps executed

1. Switched account to Adam Orfei (LFQA hover menu → Search Account "Adam Orfei" → clicked `.lfm-ta-option` Result). ✅
2. Brand Sets → Content, brand set = **Adam's Brand Set** (brand_set_id=1738). ✅
3. Date Range → "Make a Selection" preset = **Last 30 Days** → `from=2026-06-07&to=2026-07-06`; Mode = Lifetime. ✅
4. Clicked **Detail View** layout icon (`.view-mode[title="Detail View"]` → active). ✅
5. Opened **Rank by** dropdown (`.lfm-dropdown.compact`, was "Engagements"). ✅
6. Selected **Impressions** under the **Authorized Data** group → URL switched to `perspective=extended` (Authorized) and `rank_by_metric=lfm.content.impressions_v7_v2`; channel set auto-reduced to Facebook/Twitter/Instagram/TikTok (YouTube dropped). ✅
7. Filter → **Content Brand = MTV** (content_brand_id=10765) → Apply Filter. ✅
8. Export → **CSV → Only Current Metric** → confirm dialog "…load all 408 posts…" accepted → synchronous download `Adam-s-Brand-Set-2026-06-07-2026-07-06-Impressions-posts.csv`. ✅
9. Clear All → Filter → **Content Brand = NBA** (content_brand_id=21542) → Apply Filter. ✅
   - Note: first NBA attempt mis-selected "Adam Orfei" because the filter value list is a **virtual/recycled list** — a `data-*` tag placed on a row got reused for another entry. Corrected by typing "NBA" into the value-panel Search to narrow the list to a single row, then selecting it. Reapplied cleanly (chip "Content Brand: NBA Include", content_brand_id=21542).
10. Export → **CSV → Only Current Metric** → confirm dialog "…export the top 3,000 posts…" accepted → synchronous download (same brand-set-based filename, overwrote step-8 file which was already fully verified). ✅

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Sum and Avg values updated | Impressions **Sum 123,012,368 / Average 292,887** (full brand set, Authorized) | PASS |
| A2 | 6b | Post count updated | **Posts (420)** | PASS |
| A3 | 6c | Correct channels for Impressions: Facebook, Twitter, Instagram, TikTok | Channel row = FB/Twitter/IG/TikTok; YouTube auto-removed on Impressions | PASS |
| A4 | 6d | Sum/Avg show calculated values or N/A (no endash) | Real numeric Sum/Avg, no endash | PASS |
| A5 | 7a | No endash or N/A in Sum/Avg (MTV) | MTV: **Sum 109,646,569 / Average 268,742** — real values, no endash/NA | PASS |
| A6 | 7b | Avg row = Sum ÷ number of posts with data | 109,646,569 ÷ **408** = 268,742.8 → displayed 268,742; posts-with-data = 408 (CSV: 408 of 411 rows carry an Impressions value) | PASS |
| A7 | 8a | CSV matches UI | MTV CSV: brand=MTV only; Rank 1 FB 8,081,064 / Rank 2 Twitter 5,863,285 (match UI); ΣImpressions=109,646,569 & avg(nonblank)=268,742 = UI aggregate | PASS |
| A8 | 8b | CSV does NOT contain Sum/Avg rows | No `Sum`/`Average` rows in CSV (grep + parse) | PASS |
| A9 | 9a | Only NBA posts displayed | All post rows Brand=NBA; CSV 3,000 rows all Brand=NBA | PASS |
| A10 | 9b | Lock symbol visible on posts where applicable | `far fa-lock` icons on post metric cells (300 across 100 rendered posts) | PASS |
| A11 | 9c | Lock symbol where Impressions unavailable due to authorization | Impressions & Share cells show gold padlock + `title="N/A"` (NBA unauthorized for Impressions) | PASS |
| A12 | 9d | Sum/Avg rows show endash (–) for Impression when no data | Aggregate **Sum – / Average –** | PASS |
| A13 | 9e | Post count matches posts with actual data (excluding endash posts) | 0 NBA posts have Impression data → "Posts" header shows **no count** (blank), CSV has 0 rows with an Impressions value; consistent with 0 posts-with-data | PASS (see note) |
| A14 | 10a | CSV matches UI | NBA CSV: all Brand=NBA, all Impressions **blank** — matches UI (all locked/N-A, aggregate endash) | PASS |
| A15 | 10b | CSV no Sum/Avg rows | No `Sum`/`Average` rows in NBA CSV | PASS |

## Evidence

**Step 6 — full brand set, Impressions (Authorized):**
- Aggregate table text: `Impressions  Sum 123,012,368  Average 292,887`
- Posts (420); channels FB/Twitter/IG/TikTok; perspective=extended (View toggle handle on Authorized side).
- Screenshot: `.playwright-out/QA-132392/07-detail-aggregate.png`

**Step 7 — Content Brand = MTV:**
- Aggregate: `Sum 109,646,569 / Average 268,742`; Posts (408); filter chip "Content Brand: MTV Include".
- Screenshot: `.playwright-out/QA-132392/10-mtv-filtered.png`

**Step 8 — MTV CSV (`Adam-s-Brand-Set-2026-06-07-2026-07-06-Impressions-posts.csv`, synchronous download):**
- 411 data rows; header `Overall Rank, Filtered Rank, Date, Day of Week, Time, Channel, Brand, Company, Sponsor Name, Sponsor Link, Type, Post Link, Live, Publish Type, Text, Impressions, Share, <tag cols>`.
- 408 rows with an Impressions value, 3 blank (Twitter posts at the tail, blank Overall Rank).
- Σ(Impressions) = 109,646,569 (= UI Sum); mean over 408 non-blank = 268,742 (= UI Average).
- No Sum/Average rows present.
- Row 1: `Overall Rank 1, MTV, Facebook, Video, 8,081,064, 0.0640…`; Row 2: `MTV, Twitter, 5,863,285` — match the UI Detail view.

**Step 9 — Content Brand = NBA:**
- Aggregate: `Sum – / Average –`; all posts Brand=NBA (Company "National Basketball Association").
- Impressions + Share cells rendered as gold `far fa-lock` padlocks with `title="N/A"` (NBA has no Authorized Impressions data). "Posts" header shows no numeric count.
- Screenshot: `.playwright-out/QA-132392/16-nba-detail.png`

**Step 10 — NBA CSV (same filename, overwrote step-8 file, synchronous download):**
- 3,000 data rows (confirm dialog capped at "top 3,000 posts"); all Brand=NBA.
- 0 rows with an Impressions value (all blank) — matches the locked/N-A UI.
- No Sum/Average rows.

## Notes / observations (not bugs)

- **Brand Sets > Content CSV export is SYNCHRONOUS on this surface.** "Export → CSV → Only Current Metric" fired a Playwright `download` event straight to disk (with a JS `confirm()` dialog first). This differs from the QA-1519 *Brand > Content* "Export Select Data Sets" pop-up, which is async-by-email. No Google Sheets / email step was in this case, so all export assertions were verifiable on disk (in scope).
- **Filename is keyed to the brand SET + ranked metric, not the Content-Brand filter.** Both the MTV and NBA exports produced `Adam-s-Brand-Set-2026-06-07-2026-07-06-Impressions-posts.csv`, so the NBA export overwrote the MTV file. The MTV CSV was fully parsed/verified before the NBA export ran, so no evidence was lost. (Minor UX note only.)
- **A13 count display:** with a fully-unauthorized brand (NBA), the "Posts (N)" header renders as "Posts" with no count rather than "Posts (0)". Interpreted as consistent with "0 posts with data"; flagging as a possible minor display nuance for product, not a functional defect.
- **UI virtual-list recycling gotcha (automation-only):** the Content-Brand filter value list recycles DOM nodes; tagging a specific row by attribute is unreliable. Reliable path = type the brand name into the value-panel Search to narrow to one row, then click. (Fold into brand-content-filter skill.)
- **Impressions selection side-effects (expected):** choosing Impressions under Authorized Data auto-set `perspective=extended` and dropped YouTube from the channel set (YouTube has no Impressions metric in this context).

## Bugs filed

None. All 15 in-scope assertions passed; observations above are UX nuances / automation notes, not product defects.
