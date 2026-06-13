# Manual QA Test Run — Batch 2 — Dev — Jun 10, 2026

**Tester:** Claude (Kratika's LFIQA Chrome profile) · **User:** LFQA · Accounts used: Adam Orfei, Michael Kors, Disney Entertainment Television, Hulu

## Summary

| # | Case | Title | Result |
|---|------|-------|--------|
| 1 | QA-16775 | Dashboard - Short Link | ✅ PASS |
| 2 | QA-84202 | Dashboards - Order modal | ✅ PASS (naming drift noted) |
| 3 | QA-115037 | Brand > Channels - Dashboard functionality | ✅ PASS (1 observation) |
| 4 | QA-63553 | Settings > Tags > Content Tagged | ✅ PASS |
| 5 | QA-82626 | Data Studio - Short Link & URL loads | ✅ PASS |
| 6 | QA-115715 | Brand > Insights - Total Followers Export CSV | ✅ PASS |
| 7 | QA-5503 | Brand Insights - YouTube Basic View | ✅ PASS |
| 8 | QA-111132 | TWC - IG Views metrics + CSV | ✅ PASS (1 transient) |
| 9 | QA-49908 | Follower Demographics - historical data | ✅ PASS (1 transient) |
| 10 | QA-4915 | FullStory - User Properties | 🚫 BLOCKED (FullStory dashboard login needed) |
| 11 | QA-450 | Action Alerts Email overview | 🚫 BLOCKED (needs the received email — mailbox access) |

**9/9 executable cases passed. No hard product failures in batch 2.**

## Transient bugs (recurring family — recommend a perf/stability ticket)
1. **TWC story stuck on "Loading…" >30 s until manual reload** (QA-111132, story 154363). Same family as batch-1's table/page load failures.
2. **Follower Demographics builder renders blank after SPA hash-navigation from a story URL; hard reload fixes** (QA-49908). Related history: APPS-50145/APPS-53697.
3. Count across both batches: 5 occurrences of load-then-recover on first render. Dev env stability issue (cf. APPS-55565 "Dev environment performance issue").

## Observations (test-case maintenance)
- **QA-84202:** steps reference a "Follower Growth" tile; on Adam Orfei the tile is **"Fan Growth Rate"** (Follower Growth exists on the Michael Kors account). Used Fan Growth Rate + Video Views; all assertions passed. Suggest updating the test to account-agnostic tile names.
- **QA-115037:** "Insights | Content | Remove From Dashboard button displays **right side** of the tile" — actual renders **below** the tile (bottom-left). Cosmetic wording fix.
- **Data Last Updated divergence:** during the run app.lfmdev.in showed 09:24 AM PT while app-reporting.lfmdev.in still showed 04:24 AM PT — timestamp caching inconsistency between subdomains worth a look.

## Key evidence
- **QA-16775:** "Dashboard Test" created (URL had `create=success`); pin icon produced `…/#s/AKrANjc`; opening it resolved to the exact dashboard URL **without** `create=success` ✓; same page rendered.
- **QA-84202:** Edit modal headers **Order/Tile** ✓; drag row 1 → row 2 swapped (Video Views ↔ Fan Growth Rate) ✓; OK persisted order on dashboard ✓; re-drag + Cancel left order unchanged ✓.
- **QA-115037:** Insights/Content/Save under every Channels tile ✓; Create Dashboard in dropdown ✓; created entry checked + label "(1)" ✓; dashboard tile header "Michael Kors (Brand: Channels)" link + "Authorized Data" + identical data ✓; delete popup text exact ('Are you absolutely sure you want to delete your "Channels Test 0610" dashboard? Click "Ok" to continue.') ✓; tile count cleared after delete ✓.
- **QA-63553:** Filter → Tag → 'nba' → Apply chip ✓ (1 row, Content Tagged=519); Text & Tag Name tooltips via `title` ✓; bottom-scroll fired `page=2&per_page=200` content request ✓; brand click → Brand Content with only that brand (NBA, brand_id 7911) ✓.
- **QA-82626:** report 295528 (Star Wars Public + MTV Authorized; FB Total Fans + TW Total Followers); short link `#s/AsSfowY` → same URL/report ✓; config restored, **Go disabled** ✓; trash Twitter metric → **Go enabled** ✓; Go → new report 295530 ✓.
- **QA-115715:** header "Total Followers: 42.7M (-<1%)" ✓; legend FB,TW,IG,TikTok ✓; **CSV captured in-page**: filename `Michael Kors-Insights-Total Followers-2026-06-03-2026-06-09.csv` ✓, headers Brand Name/Channel/Total Followers ✓, values match donut (18,700,807 / 2,896,832 / 18,974,944 / 2,100,000) ✓; Data View: Share → donut % (44/7/44) ✓; TikTok unselect → 40.6M, legend w/o TikTok ✓.
- **QA-5503:** YT-only via channel selector (radio behavior) ✓; rows: [Total Subscribers 11.2M, New Subscribers 0, New Posts 13] / [Likes, Comments] / [Video Views] / BPC last ✓; Total Subscribers tile = Save-to-Dashboard only (no graph dropdown) ✓; **no Export on big-number tiles** (Export only on BPC) ✓; Sort options Video Views (default)/Likes/Comments ✓; Sort=Comments → Comments value highlighted **yellow** on all 5 BPC posts ✓.
- **QA-111132:** timestamp visible/correct/non-clickable (DIV) ✓; Channel Breakdown contains the 4 IG datapoints ✓; By Channel → Instagram (4/99) selected ✓; report shows data for all 4 metrics (Jun 09 "–" = freshness) ✓; **CSV matches page** (13,744,372 / 910,034 / 26,541,584 / 32,559 …) ✓; CSV includes `"Display Name","Key"` section (Show Metrics) e.g. `instagram.page_insight.views_authorized` ✓; **no timestamp in CSV** ✓.
- **QA-49908:** historical story 131961 loads ✓ (Feb 5 2020, People Pattern: Twitter Men .2592/Women .7408/Orgs blank); new report 154364 (Jun 6 2026, Audiense: Men .1942/Women .4856/Orgs .3201) — **data does not match** ✓.

## Cleanup
- Deleted test dashboards: "Dashboard Test" (6260), "Order Test 0610" (6261), "Channels Test 0610" (6262, deleted in-test). No tags added. "LFQA Edit Test 0610" custom data set from batch 1 still exists — delete when convenient.

## Blocked handoffs
- **QA-4915:** sign in at app.fullstory.com and I can drive the user-properties filter steps (same as QA-4922).
- **QA-450:** open the latest Action Alerts email (Gmail/Outlook in this profile or forward me a saved copy) and I'll verify every layout/link assertion.

## New technique worth a skill (used in batch 2)
In-page CSV capture without Downloads access: hook `URL.createObjectURL` (read blob via FileReader) + `HTMLAnchorElement.prototype.click` (capture `download` filename). Proved on three different exports (Insights tile CSV, TWC CSV, Follower Demographics CSV).
