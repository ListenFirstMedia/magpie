# QA-134586 — Brand > Channel > Instagram > Public Data

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134586
- **Account:** Adam Orfei (precondition: logged in as Adam Orfei — met)
- **Brand:** MTV (`brand_id=4018` Authorized / `brand_id=10765` Public entity after toggle)
- **Date range:** Jul. 04, 2026 – Jul. 10, 2026 (app default, held constant across all 3 surfaces)
- **Perspective:** Public Data
- **Skills reused:** `view-perspective-toggle` (v2, Public/Authorized flip via `label[for=perspective]`), `brand-channels-threads` (channel-tile structure + `Insights|Content|Save to Dashboard` action row pattern)

## Verdict: **PASS** (10/10 assertions)

---

## Steps executed

1. **Brand dropdown → Channels** — hovered the top-nav *Brand* dropdown, clicked *Channels*. Landed on `#explore/brand/channels`.
2. **Select MTV** — page loaded with MTV pre-selected as the default/favorite brand (`brand_id=4018`); exact spec-name "MTV" confirmed in the header (Rule 1 satisfied — no substitution).
3. **Change to Public Perspective** — the page opened with the toggle in **Authorized Data** (`input#perspective` `checked:true`) despite URL `perspective=extended` (Rule 2 trap: URL param ≠ visual state). Clicked the toggle label; view flipped to **Public Data** (`checked:false`, URL → `brand_id=10765&perspective=standard`, entity-swap expected per skill).
4. **Review IG Channel tile** — read the Instagram tile metric set + action row under Public Data.
5. **IG Insights button** — clicked *Insights* below the IG tile → navigated to `#explore/brand/insights?...&channels=instagram&perspective=standard` (JS button navigates same tab; new-tab open not supported by the control — noted, not blocking).
6. **Review Channel + Insight pages** — cross-checked IG tile values vs the Brand Insights IG summary tiles; confirmed identical date range.
7. **IG Content button** — returned to the channel page, clicked *Content* below the IG tile → `#explore/brand/content?...&channels=instagram&perspective=standard&table_data_set=public`.
8. **Review Channel + Content pages** — confirmed Instagram-only channel filter + Public perspective + identical date range on the Content page.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 3 | Change perspective | Perspective changed successfully | Toggle flipped Authorized→Public; `input#perspective` `checked:true`→`false`; URL `perspective=standard`, brand entity 4018→10765 (expected swap) | **PASS** |
| 4(a) | Review IG tile | Insights, Content, Save to Dashboard present below tile | All three present in the IG tile action row (`Insights | Content | Save to Dashboard`) | **PASS** |
| 4(b) | Review IG tile | Metrics: Total Followers, New Followers, Fan Growth Rate, New Posts, Engagements, Organic Response Rate, Video Views | All 7 present, in that order: TF 21,090,917 · NF -9,123 · FGR -0.04% · NP 20 · Eng 395,799 · ORR 0.09% · VV 5,850,502 | **PASS** |
| 4(c) | Review IG tile | Video Views displayed just below Organic Response Rate | Order confirmed: …Organic Response Rate 0.09% → Video Views 5,850,502 (last metric) | **PASS** |
| 4(d) | Review IG tile | Metrics show values with percentages (e.g., New Posts: 28 (+40%)) | Value + delta pattern shown, e.g. Total Followers 21,090,917 (-<1%), Engagements 395,799 (-21%), Fan Growth Rate -0.04% (+12%). New Posts 20 (–): en-dash delta = no comparison value that period (valid no-data delta, format intact) | **PASS** |
| 4(e) | Review IG tile | Impressions does NOT display in IG tile under Public data | Under Authorized the IG tile listed Impressions (8,984,741); after switching to Public, Impressions is **absent** (`impressionsInTile:false`) | **PASS** |
| 6(a) | Channel vs Insight | IG tile metric values match Brand Insights page | All 7 match at display precision (see cross-check table below) | **PASS** |
| 6(b) | Channel vs Insight | Same start & end date on both pages | Both **Jul. 04, 2026 – Jul. 10, 2026** | **PASS** |
| 8(a) | Channel vs Content | Only Instagram channel + Public data perspective selected | Content page: channel selector shows only **Instagram** `enabled` (purple rgb(131,58,180)); FB/Twitter/TikTok/YouTube `disabled`/greyed. `perspective=standard`+`table_data_set=public`, `input#perspective` `checked:false`. URL `channels=instagram` | **PASS** |
| 8(b) | Channel vs Content | Same start & end date on both pages | Both **Jul. 04, 2026 – Jul. 10, 2026** | **PASS** |

---

## Evidence

### IG Channel tile — Public Data (Jul 04–10 2026)
```
Instagram
Total Followers        21,090,917   (-<1%)
New Followers          -9,123       (+12%)
Fan Growth Rate        -0.04%       (+12%)
New Posts              20           (–)
Engagements            395,799      (-21%)
Organic Response Rate  0.09%        (-21%)
Video Views            5,850,502    (-1%)
[Insights | Content | Save to Dashboard]
```

### IG Channel tile — Authorized Data (before Step 3, for 4e contrast)
Under Authorized the tile carried **Impressions 8,984,741 (-10%)** and **Engagement Rate 4.41%** in place of Organic Response Rate. Both authorized-only metrics vanish under Public — confirming 4(e).

### 6(a) cross-check — IG Channel tile vs Brand Insights page
| Metric | Channel tile | Insights page | Match |
|--------|-------------|---------------|-------|
| Total Followers | 21,090,917 (-<1%) | 21.1M (-<1%) | ✓ |
| New Followers | -9,123 (+12%) | Follower Growth -9,123 (+12%) | ✓ |
| Fan Growth Rate | -0.04% (+12%) | -0.04% (+12%) | ✓ |
| New Posts | 20 (–) | 20 (–) | ✓ |
| Engagements | 395,799 (-21%) | 396K (-21%) | ✓ |
| Organic Response Rate | 0.09% (-21%) | Response Rate 0.09% (-21%) | ✓ |
| Video Views | 5,850,502 (-1%) | Public Video Views 5.85M (-1%) | ✓ |

(Insights tiles display rounded values; all reconcile to the channel-tile exact figures. Content-page `Posts(20)` also matches the IG tile's New Posts = 20.)

### Screenshots (`.playwright-out/QA-134586/`)
- `01-home.png` — Home, Account: Adam Orfei
- `02-channels-initial.png` — Brand Channels loading
- `03-channels-loaded-perspective.png` — tiles loaded, Authorized (pre-toggle)
- `04-public-data-tiles.png` — tiles under Public Data
- `05-insights-ig-public.png` — Brand Insights, IG, Public (full page)
- `06-content-ig-public.png` — Brand Content, IG, Public
- `07-content-channel-selector.png` — Content channel selector

---

## Known bugs checked

- **Case file "## Open linked bugs" section:** not present (ticket was ingested without it). Screened `knowledge-base/bug-history.md` for `QA-134586` → no linked/related bug for this flow.
- **Brand>Insights renderer hang** (known quirk, historically MTV-specific under Chrome MCP): **did NOT reproduce** — the IG Insights page rendered fully within budget under Playwright, consistent with the 2026-06-28 re-characterization.
- **Rule 2 (URL vs toggle):** actively guarded — initial state was Authorized despite `perspective=extended`; verdict depended on explicitly toggling to Public, which was done and confirmed via `input#perspective` state + Impressions disappearance.

## Bugs filed

None.
