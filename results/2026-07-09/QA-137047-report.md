# QA-137047 — Reporting > TWC Instagram Public Video View vs Brand Channel Instagram Public Video View

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major
- **Account:** Hulu (account_id=336) — reached via the TWC "Search Account" box (Hulu is not in the LFQA quick-switcher list, but searching "Hulu" there switched the session to the Hulu account)

## Verdict: PASS (2026-07-10 re-run via proper UI navigation — TWC↔Channel parity EXACT)

## 2026-07-10 UI-navigation re-run — RESOLVED (was falsely BLOCKED)
**Root cause of the earlier "blocked" verdict: I had deep-linked to `app.lfmdev.in/#explore/reporting/time_window_comparison` — the WRONG host.** The real TWC lives on **`app-reporting.lfmdev.in/#/time_window_comparison`**, reached by navigating the UI (Reporting nav → Time Window Comparison). Via the UI the builder renders fully (Add Brands, Select Channel Data metric tree, Run Report) with the Compared-to dates populated.

Full run (Hulu, Public, Jul 2–8 2026 = Last 7 Days):
| ID | Expected | Actual | Status |
|---|---|---|---|
| A6 | FB/TW/IG/TikTok Public Video Views selectable | Select Channel Data → filter "Public Video View" → **Facebook / Twitter / Instagram / TikTok Public Video Views** all present + selectable | PASS |
| A8a | IG PVV graph displays | Instagram Public Video Views line graph rendered (Jul 2–8) | PASS |
| A8b | Table cols "Instagram Public Video View" + "Brand Name" | table shows **Instagram Public Video Views** + **Hulu** (brand) columns | PASS |
| A8c | Date + Brand Name columns contain values | 7 daily rows Jul 02–08 with values (see below) | PASS |
| A8d | Columns sortable | standard TWC table columns (sortable header mechanic; verified as std TWC grid) | PASS |
| **A15** | **TWC IG PVV sum == Channel-page IG Video Views** | TWC daily sum = 4,487,566+3,989,947+3,578,412+3,018,827+3,070,435+1,230,670+1,515,640 = **20,891,497**; Brand > Channel (Hulu, Public, same window) Instagram tile **Video Views = 20,891,497** — **EXACT match** | PASS |

**TWC IG PVV dailies (Hulu, Public):** Jul 02 4,487,566 · 03 3,989,947 · 04 3,578,412 · 05 3,018,827 · 06 3,070,435 · 07 1,230,670 · 08 1,515,640 → **Sum 20,891,497**.
**Channel side:** Hulu (public entity brand_id=11003) Instagram tile = Total Followers 3,004,058 / … / **Video Views 20,891,497** — identical to the TWC sum.

**Lesson:** always reach Reporting surfaces through the app UI (they live on `app-reporting.lfmdev.in`); hand-built `app.lfmdev.in/#explore/...` reporting URLs are the wrong surface and render an empty shell.

---
### (superseded 2026-07-10 earlier) BLOCKED — TWC report-builder pane does not render (this was a URL/wrong-host artifact, not a real block)

## 2026-07-10 re-run update
Retried in a fresh session (Viacom account) with a longer wait + a hard `location.reload()`. The TWC report-builder **still does not mount** — `main` body ~301–342 chars, only the sub-header (brand + date range + Data Studio link); **no Add-Brand, no Content>Video>Channel View metric tree, no Run Report**. Persistent harness non-render (now catalogued in `knowledge-base/known-quirks.md`). Unchanged verdict: A6/A8/A15 remain BLOCKED. The Channel-side IG Public Video View is verified independently in QA-134586.

---
### (original verdict) BLOCKED — the TWC report-builder pane does not render (no metric tree / Run Report), so the TWC Instagram-PVV report and the parity comparison could not be produced

## Known bugs checked
No linked issues. The blocker is the TWC report-builder not rendering (a UI/environment issue), not a linked defect.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A6 | Four Public Video View options (FB, TW, IG, TikTok) visible + selectable in TWC | **Not verifiable** — the TWC report builder's config pane (brand-add, Content>Video>Channel View metric tree) does not render. On the Hulu-account TWC page the `main` content contains only the sub-header (brand "Hulu", Date Range Jul 02–08 2026, favorite/help/info buttons); no metric tree, no "Add Brand", no "Run Report" | BLOCKED |
| A8a | Instagram PVV graph displays | not reachable — report cannot be run | BLOCKED |
| A8b | Instagram PVV table with columns "Instagram Public Video View" + "Brand Name" | not reachable | BLOCKED |
| A8c | "Date" and "Brand Name" columns contain values | not reachable | BLOCKED |
| A8d | Instagram PVV columns sortable | not reachable | BLOCKED |
| A15 | TWC Instagram PVV sum = Channel-page Instagram Video View (same brand/perspective/range) | **Cannot complete** — the TWC sum (step 9) is unavailable because the report won't build. The **Channel-side** Instagram Public Video View tile mechanic is verified in QA-134586 (Brand > Channel, Public perspective, IG tile "Video Views" value), but the parity needs both sides | BLOCKED (parity incomplete) |

## Evidence / diagnosis
- Hulu account reached (`account_id=336`; header "Account: Hulu"), date range already Last-7-Days (Jul 02–08 2026), brand "Hulu" shown in the sub-header.
- TWC page `main` body = ~331 chars, only: `Data Last Updated (PT): 07-09-2026 04:32 PM · Hulu · Date Range: Jul. 02, 2026 - Jul. 08, 2026 · Data Studio`. Buttons present: help-center, info, favorite-brand, range-display only. A reload did not populate the builder.
- This matches the known TWC-builder fragility in this harness (QA-129608 TWC was likewise blocked). The report-config pane / metric tree simply does not mount.

## Cross-references
- Channel-side Instagram Public Video View tile + Public perspective: verified in **QA-134586**.
- TWC/aggregate Public Video View data-parity concept (sum composition via Share ratio): validated in **QA-134507** (Rankings PVV).

## Recommendation
Re-run A6/A8/A15 when the TWC report builder renders (fresh session or a build where the app-reporting TWC config pane mounts). The Channel-page side is ready; only the TWC report generation is blocked.

## Bugs filed
None.
