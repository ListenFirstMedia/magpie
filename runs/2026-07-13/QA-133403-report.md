# QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior

- **Run:** 2026-07-13 · unattended headless (Playwright MCP) · branch `feature/playwright-mcp`
- **Env:** Dev (`app.lfmdev.in`) · **Account:** Viacom (account_id=181) · **Brand Set:** 2019 BET Awards Sponsors (brand_set_id=2956)
- **Date Range:** Mar 23, 2026 – Mar 24, 2026 · **Mode:** Lifetime · **Perspective:** Authorized (`perspective=extended`, derived from Rank-by "Authorized Data" metric — View toggle disabled at brand-set level per known-quirk)
- **Skill:** reused Rank-by/Authorized mechanic (candidate `brand-sets-content-rank-by`), `brand-content-filter`, `export-csv`
- **Verdict:** ✅ **PASS** (15/15 assertions + data-accuracy)

This is the FIRST run to execute the case on the **exact spec setup** (Viacom + "2019 BET Awards Sponsors" + Mar 23–24 2026). Prior runs (2026-06-04/06-08/06-13) verified the mechanic on a substitute Adam Orfei brand set because Viacom wasn't reachable; this run switched to Viacom via the account typeahead and the spec brand set was the default.

## Steps executed
1. Logged in (Cognito email/password), landed on `#home`.
2. Switched account HBO Max → **Viacom** via user-menu → Search Account → clicked the "Viacom" **Results** row (account_id=181).
3. Navigated **Brand Sets → Content**; brand set defaulted to **2019 BET Awards Sponsors** (spec brand, no substitution).
4. Set **Date Range Mar 23 → Mar 24 2026** via the two-calendar picker (Start cal + End cal navigated independently back to March 2026), clicked **Ok**. Mode confirmed **Lifetime**.
5. Selected **Grid View** icon.
6. Opened **Rank by** dropdown → selected **Video Views** under the **Authorized Data** section (URL flipped to `perspective=extended` + `rank_by_metric=lfm.content.video_views`).
7. Applied Filter **Content Publish Type = Reel** (Include); Apply Filter.
8. **Export → CSV → Only Current Metric** ("with current data sets") — synchronous download to disk.
9. **Clear All** to remove the Reel filter (per quirk: `filters` param persists; only Clear All clears it), then Filter **Content Brand = McDonald's** (exact match — chose "McDonald's" id 18720, NOT "McDonald's Corp"); Apply Filter.
10. **Export → CSV → Only Current Metric** — synchronous download to disk.

## Evidence

### Step 6 — Video Views (Authorized), no filter
- Post count: **88 (Engagements) → 39 (Video Views)** — updates on metric change.
- Channels present: Facebook, Twitter (X), Instagram, YouTube, TikTok.
- Aggregate: **Sum 24,939,751 / Average 639,481** (639,481 ≈ 24,939,751 ÷ 39).

### Step 7 — + Content Publish Type = Reel
- **Posts (3)**; Aggregate **Sum 6,749,419 / Average 2,249,806**.
- 3 posts with data (all Nickelodeon IG Reels): **5,582,641 + 1,056,783 + 109,995 = 6,749,419** (= Sum exact). Avg = 6,749,419 ÷ 3 = 2,249,806.33 ≈ 2,249,806.
- Grid renders all 21 Reel posts; the other 18 (unauthorized brands — Coach, Dove, AT&T, Taco Bell, Ciroc, Amazon Music, Ubisoft, McDonald's…) show blank/locked Video Views. Post counter (3) and Avg denominator (3) both = posts-with-data.

### Step 8 — Reel CSV (`.playwright-out/QA-133403/reel-export.csv`)
- Header + **21 data rows**, NO Sum/Average row.
- Rows 1–3 (Filtered Rank 1–3) = Nickelodeon Reels with VV 5,582,641 / 1,056,783 / 109,995 (match UI exactly); rows 4–21 = blank Video Views/Share (match the UI's blank/locked unauthorized-brand posts).

### Step 9 — Content Brand = McDonald's (5 posts)
- **Posts (3)** (posts-with-data); 5 tiles total. Aggregate **Sum 6,151,745 / Average 2,050,582**.

| Channel | Video Views | Share | State |
|---|---|---|---|
| TikTok | 3,400,000 | 13.63% | value |
| TikTok | 2,400,000 | 9.62% | value |
| Twitter | 351,745 | 1.41% | value |
| Facebook | — | — | **LOCK** (unauthorized) |
| Instagram | — | — | **LOCK** (unauthorized) |

- 3,400,000 + 2,400,000 + 351,745 = **6,151,745** (= Sum exact). Avg = 6,151,745 ÷ 3 = 2,050,581.67 ≈ 2,050,582.

### Step 10 — McDonald's CSV (`.playwright-out/QA-133403/mcdonalds-export.csv`)
- Header + **5 data rows**, NO Sum/Average row.
- TikTok 3,400,000 (0.1363) / TikTok 2,400,000 (0.0962) / Twitter 351,745 (0.0141) match UI (Share serialized as raw fraction = UI %). Facebook + Instagram rows have blank Video Views/Share — corresponds to the UI lock cells.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (6a) | Rank Video Views | Post count updates | 88 → 39 | ✅ PASS |
| A2 (6b) | Rank Video Views | Channels FB/Twitter/IG/YouTube/TikTok | All 5 present in selector | ✅ PASS |
| A3 (6c) | Rank Video Views | Sum/Avg show calculated VV (not endash) or N/A | Sum 24,939,751 / Avg 639,481 | ✅ PASS |
| A4 (7a) | +Reel | No endash/N/A in Sum or Avg | Sum 6,749,419 / Avg 2,249,806 | ✅ PASS |
| A5 (7b) | +Reel | Post count = posts with data (excl endash/lock) | Posts (3) = 3 Nickelodeon posts with VV | ✅ PASS |
| A6 (7c) | +Reel | Avg = Sum ÷ posts with data | 6,749,419 ÷ 3 = 2,249,806.33 ≈ 2,249,806 | ✅ PASS |
| A7 (8a) | Reel CSV | CSV data matches UI | 3 populated VV match rows 1–3; 18 blank = UI blank/locked | ✅ PASS |
| A8 (8b) | Reel CSV | CSV has no Sum/Avg rows | Header + 21 data rows only | ✅ PASS |
| A9 (9a) | McDonald's | Only McDonald's posts | All 5 posts Brand=McDonald's | ✅ PASS |
| A10 (9b) | McDonald's | Lock on IG & FB (unauthorized) for VV/Shares | Facebook + Instagram tiles locked | ✅ PASS |
| A11 (9c) | McDonald's | VV & Shares visible on non-IG/FB channels | TikTok×2 + Twitter show VV + Share | ✅ PASS |
| A12 (9d) | McDonald's | Sum/Avg correct for VV | Sum 6,151,745 / Avg 2,050,582 | ✅ PASS |
| A13 (9e) | McDonald's | Post count = posts with data (excl endash/lock) | Posts (3) = 2 TikTok + 1 Twitter (FB/IG locked, excluded) | ✅ PASS |
| A14 (10a) | McD CSV | CSV data matches UI | TikTok 3.4M/2.4M, Twitter 351,745 match; FB/IG blank=lock; Share raw-fraction=% | ✅ PASS |
| A15 (10b) | McD CSV | CSV has no Sum/Avg rows | Header + 5 data rows only | ✅ PASS |
| Data acc. | both | Sum = total of individual post VV | Reel 6,749,419 exact; McD 6,151,745 exact | ✅ PASS |

## Known bugs checked
- **bug-history.md (QA-133403):** Open bugs **(0)** → Rule 7 screen passed, ran the case normally. No linked bug to reproduce.
- **known-quirks applied (not defects):**
  - Brand Sets > Content **View toggle disabled** at brand-set level; Authorized perspective correctly derived by picking Video Views from the Rank-by "Authorized Data" subsection (`perspective=extended`). Behaved as documented.
  - `filters` URL param **persists across navigation**; used **Clear All** to remove the Reel filter before applying the McDonald's filter. Behaved as documented.
  - Two-calendar date picker (Start/End navigated independently) — clicking the Start day reset the End calendar to default; re-navigated the End calendar separately. No defect.
- No renderer hang; exports were **synchronous** (Playwright `download` event) and verified on disk.

## Bugs filed
_None._
