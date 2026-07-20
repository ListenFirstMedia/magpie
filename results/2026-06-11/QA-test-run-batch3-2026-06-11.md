# Manual QA Test Run — Batch 3 — Dev — Jun 11, 2026

**Tester:** Claude (Kratika's LFIQA Chrome profile "magpie") · **User:** LFQA
Accounts used: Adam Orfei, Hulu, Sony Pictures, Disney Entertainment Television, Disney Ad Sales, FX Networks, Amazon Prime Video, UCLA, HBO Max, Wasserman

## Summary — 22 cases

| # | Case | Title | Result |
|---|------|-------|--------|
| 1 | QA-85175 | Dashboards - Drag and Drop Tile Ordering | ❌ FAIL (BUG 1: Remove from Dashboard not persisted) |
| 2 | QA-86318 | Data Studio - Same brand, different perspectives | ✅ PASS |
| 3 | QA-80360 | Data Studio - Adding Page-Level Metrics | ✅ PASS |
| 4 | QA-83835 | Data Studio - Historical limit (365d clamp) | ✅ PASS |
| 5 | QA-531 | Brand Content - Facebook CSV (unauthorized brand) | ✅ PASS (filename assertion needs 2-sec manual check) |
| 6 | QA-116177 | Sentiment Export All Comments | ✅ PASS via notification CSV (email step → you) |
| 7 | QA-1515 | Brand Content toolbar - Basic View | ✅ PASS |
| 8 | QA-111213 | Data Studio - IG Views & Post Impressions | ✅ PASS |
| 9 | QA-122942 | Brand Content - IG Public Perspective + CSV | ✅ PASS |
| 10 | QA-115716 | Brand Insights - Fan Growth Rate CSV | ✅ PASS |
| 11 | QA-134174 | Brand Insights - Interval date options | ✅ PASS |
| 12 | QA-395 | Brand Sets Rankings - Default View | ✅ PASS (2 test-text drift notes) |
| 13 | QA-71007 | Brand Content CSV - Select Data Sets notification | ✅ PASS |
| 14 | QA-91412 | Brand Content - FB Reels public en-dash | ✅ PASS |
| 15 | QA-121304 | Brand Content - IG Collaborator Name filter | ✅ PASS |
| 16 | QA-121438 | Brand Paid - Group by Delivery Type (IG) | ✅ PASS (+1 observation bug) |
| 17 | QA-420 | Brand Sets Content - 100-post infinite scroll | ✅ PASS |
| 18 | QA-95226 | Global/Brand search - two-row display | ✅ PASS |
| 19 | QA-96670 | Brand Insights - Threads hovering | ✅ PASS |
| 20 | QA-129801 | TWC RR excl. no-follower days - IG daily | ✅ PASS (data) / ❌ Google Sheets export hangs (BUG 2) |
| 21 | QA-129802 | TWC RR excl. no-follower days - YT daily | ✅ PASS (data) / same Google Sheets bug |
| 22 | QA-129673 | TWC Aggregate RR - Cross Channel | ✅ PASS (data) / same Google Sheets bug |

**20/22 effectively pass on substance; 2 product bugs found (1 new Major, 1 Critical re-confirmed).**

## Bugs

### BUG 1 (NEW, Major) — QA-85175: tile "Remove from Dashboard" never persists
- Adam Orfei → dashboard "Order3 0611" (3 MTV Insights tiles). Clicking **Remove from Dashboard** under the Engagements tile removes it from the page instantly, but **fires zero API calls** (network shows only Mixpanel/NewRelic). 2/2 repro.
- After reload the tile is back; the Edit (Order) popup never reflects the removal → assertion 11 fails. The Edit popup's tile list and the page contradict each other until reload.
- Everything else in the case passed: drag 2nd→3rd, 2nd→1st, 1st→2nd all reorder correctly and persist on OK; delete dashboard works; popup order matches page order.

### BUG 2 (Critical, re-confirmed from batch 1 / QA-5757) — TWC Export → Google Sheets hangs
- Wasserman, story 154443 (FIAWEC). Export → Google Sheets: button spinner stuck **>60 s**, `window.open` never fires, no Sheet tab. While stuck, the whole Export control is unusable; page reload required.
- Now reproduced on a **second account + report**, so it's systemic, not a one-off. CSV/TSV/XLS exports work fine (CSV verified in all 3 cases).

### Observation-grade bug — Brand > Paid with carried-over date but no compare params
- Navigating to Brand > Paid with `from/to` in URL but no `compare_*` shows **"Compared to: Invalid date - Invalid date"** and ALL tiles fail to load ("This tile failed to load") even after reload. Loading with full params works. (QA-121438 setup)

## Highlight verifications

- **QA-129801 (IG):** Engagements present all 8 days; Total Followers & Organic RR blank Sep 26–29 (no follower data) and present Sep 30–Oct 3. Math exact: 54,826/(1,234,260×3)=1.48% · 69,022/(1,234,991×2)=2.79% · 51,032/(1,235,413×3)=1.38% · 78,698/(1,235,835×4)=1.59%. CSV mirrors UI (raw fractions, blanks for excluded days).
- **QA-129802 (YT):** RR only on subscriber days; Oct 1 (0 posts) correctly "–". 1,767/1,070,000=0.17% · 1,557/1,080,000=0.14% · 772/1,080,000=0.07%. CSV matches.
- **QA-129673 (Aggregate):** RR 0.41%, Engagements 133,538, Posts 39, TF 4,020,499; export raw 0.00408511 ⇒ implied footprint denominator 32,688,963 (NOT simple Engagements/TF=3.3%) — confirms footprint-based formula. *QA-129608 precondition not run separately; footprint sum verified by implication only.*
- **QA-531:** CSV sums = page exactly (Eng 47,914 / Rx 44,806 / Cm 585 / Sh 2,523 / VV 803,985); MM/DD/YYYY, DOW, HH:MM XM ✓; en-dash → blank cells ✓. Note: RR exported as raw fraction with 17-digit precision.
- **QA-116177:** Sentiment Export CSV (via notification link): 2,184 comments, sorted latest→oldest, columns Comment Date/DOW/Time/Channel/Author/Type/Text/Classified/Emotion/Topics 1-20/Post Link + tag columns incl. the just-added `lfqa0611` ✓.
- **QA-420:** Table View rows 100→200→300 per bottom-scroll; Detail View 300→400. ✓
- **QA-95226:** two-row wrap (40px) in global search, brand container, brand-set container; TWC option ellipsis + `title` tooltip with full name. ✓
- **QA-134174:** Insights date popup: Interval default Daily, options Daily/Weekly/Monthly/Quarterly in order, Make a Selection = Auto; Brand Content & Data Studio pickers have no such Interval control. ✓
- **QA-83835:** 365-day clamp both directions (start move → end auto-adjusts, and vice versa); year-long report renders with data. ✓
- **QA-96670:** tooltips — bar "Sep. 12, 2025 / Threads: 1 (0.0%)", area "Threads: 194,857 (+999.0%)", pie "Threads: 70" (each w/ channel icon); all big numbers have graph dropdown + Export + Save to Dashboard. ✓

## Test-case maintenance notes
- **QA-395:** URL is `#explore/competitive/rankings?brand_set_id=…` not "#explorer/brand-set-name/rankings"; Rank-by group labels are "Public Data" + **"Authorized Data"** (test's option list calls it "Extended Data" — options match exactly). Label is "Rank:" not "Rank By".
- **QA-96670:** precondition "Max" — dev account/brand is **"HBO Max"**; current week had 0 Threads posts, used Sep 2025 range.
- **QA-121304:** list shows `amazonmgmstudios` (no leading space as quoted); new "Collaborator Combined Followers" filter sits between Collaborated Total and Collaborator Name.
- **QA-122942/QA-1515:** grid/table also shows a **Shares** column (en-dash for IG public) not in the test's metric list.
- **QA-71007:** notification first row includes time ("Jun 11, 2026 02:24 pm"), not just "Mon DD, YYYY".
- **QA-86318:** step text says add "Michael Kors and MTV" but the assertions clearly intend MTV twice (P + Authorized).
- **QA-531/115716:** rate metrics export as raw fractions (e.g. 0.0016081747…), UI shows %.

## Transients (dev stability family, running count from batches 1-3)
- Brand Sets Rankings/Content & Brand Insights skeleton loads >15 s on first paint (multiple).
- Brand > Paid tiles failed to load w/ Invalid-date compare (see observation bug).
- Dashboard 6295 rendered with zero tiles once after delete/re-add cycle; hard reload recovered.
- Chrome extension dropped twice mid-run (reconnected via switch_browser; not a product issue).

## Cleanup
- Dashboard "Order3 0611" (6295) — **deleted in-test** (QA-85175 step 13). ✓
- Tag **`lfqa0611`** added to MTV post (QA-116177 step) — remove when convenient (I don't hard-delete data).
- TWC stories created: 154443 (IG), 154444 (YT), 154445 (Aggregate); Data Studio reports 295888/295896/295902/295904/295925/295927 — harmless, delete at will.
- Exports generated: Star Wars ×2, Disney Channel ×1, Hulu ×1, MTV sentiment ×1 (notification links).

## Handed off to you
1. **QA-531:** click the latest "Star Wars … Download file" notification and confirm the saved filename is `Star Wars-Brand-Content-20260603-20260609-posts.csv` (CDN serves a hash name; content-disposition not visible to automation).
2. **QA-116177:** open the sentiment export email at lfiqa@listenfirstmedia.com and confirm the attached CSV matches (content already verified via notification copy).
3. **QA-5757/BUG 2:** worth re-checking whether any Google Sheet silently appeared in another window; otherwise please prioritize this — TWC Sheets export is dead on two accounts.

## Automation learnings (for skills)
- Click coordinate space flip-flops between 1:1 CSS and 1.225× screenshot scale mid-session — always derive the factor from the latest screenshot width (1280 ⇒ 1.0, 1568 ⇒ 1.225) before coordinate clicks.
- `Save to Dashboard` / nav dropdown togglers need full `mousedown/mouseup/click` MouseEvent dispatch (bare `.click()` no-ops); dropdown list rows render only while open and live in `.selector-dropdown`.
- Brand-row trash icons are `<button class="… fa-trash button--unset">` — dispatch events on the BUTTON, not the inner `<i>` (i-targeted clicks silently fail).
- TWC/Data Studio date pickers: TWO `.from-calendar` instances exist in DOM; always filter by `offsetParent` — synthetic events on the hidden one "work" but change nothing (cost us 3 false attempts on QA-83835).
- Edit-dashboard modal rows: drag via synthetic `mousedown` + stepped `mousemove` + `mouseup` works reliably (8 steps, ±70-120px).
- `<details>` metric-tree nodes (TWC): only REAL clicks on the summary render children; synthetic dispatch toggles state but children stay unrendered.
- Insights channel ghosts radio-behave on Brand Insights; Brand Paid channel icons are also single-select.
