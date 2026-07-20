# QA-137047 — TWC Instagram Public Video View vs Brand Channel Instagram Video View

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, branch `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-137047
- **Skill reused:** `time-window-comparison-run` (v6) + `view-perspective-toggle` (v2, Channel side)
- **Verdict:** **PASS**

## Summary

Built a Time Window Comparison report for **Hulu**, **Public** perspective, **Last 7 Days**
(Jul 4–10, 2026), metric **Instagram Public Video Views** (under Content > Video > Channel View).
Summed the 7 daily values and compared to the **Instagram** tile's **Video Views** on the
Brand > Channels page for the same brand / perspective / date range. The two match **exactly**
(17,302,328).

The TWC report-builder render-hang recorded on 2026-07-10 (see "Known bugs checked") **did not recur**
in this fresh session — the full builder pane mounted and the report generated normally.

## Environment / preconditions

- Logged in via Cognito email/password (`config/.env`). Session account: **HBO Max** (account_id 657).
- Precondition "logged in as Hulu": satisfied at the **brand** level — the TWC brand typeahead returned
  the exact **Hulu** brand (Rule 1), and the Channel page resolved to Hulu's Public entity
  `brand_id=11003`. No account switch was required for either surface (both are brand-scoped views).

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Reporting (hover) → Time Window Comparison | TWC builder loaded; title "…Time Window Comparison" |
| 2 | Search "Hulu" → add brand | Exact `Hulu` option from typeahead Results added as brand row |
| 3 | Perspective → Public | `#0-perspective-toggle` `checked=false` = Public (default; confirmed via DOM, Rule 2) — no change needed |
| 4 | Date range → Last 7 Days | "Last 7 Days" preset applied → Jul 4–10, 2026 (2 visible calendars, days 4 & 10 active) |
| 5 | Expand Content > Video > Channel View | Filtered metric tree to "Public Video View" |
| 6 | Verify 4 PVV options present + selectable | Facebook / Twitter / Instagram / TikTok Public Video Views all present, `controlled-check-box` enabled (`aria-checked=false`, not disabled) — screenshot `a6-four-pvv-metrics.png` |
| 7 | Select Instagram Public Video View | `#check-box_instagram-page-public-video-views-dp` → `aria-checked=true`; Run Report enabled |
| 8 | Run Report | Story `#story/time_window_comparison/155903` built; chart + table rendered — `a8-twc-report.png` |
| 9 | Sum IG PVV for 7 days | **17,302,328** (see daily table below) |
| 10 | Brand menu → Channels (new tab) | Opened `#explore/brand/channels?brand_id=11003` (Hulu) |
| 11 | Select Hulu brand | Brand context already Hulu (`brand_id=11003`) |
| 12 | Perspective → Public | `#perspective` `checked=false` = Public; URL `perspective=standard` (confirmed via DOM, Rule 2) |
| 13 | Date range → Last 7 Days | `from=2026-07-04&to=2026-07-10` carried over |
| 14 | Note Instagram tile Video View | **17,302,328** (-66%) — screenshot `a15-instagram-tile.png` |
| 15 | Compare Step 9 vs Step 14 | Exact match |

### TWC Instagram Public Video Views — daily values (Jul 4–10, 2026)

| Date | Hulu — Instagram Public Video Views |
|------|-------------------------------------|
| Jul. 04, 2026 | 3,578,412 |
| Jul. 05, 2026 | 3,018,827 |
| Jul. 06, 2026 | 3,070,435 |
| Jul. 07, 2026 | 1,230,670 |
| Jul. 08, 2026 | 1,515,640 |
| Jul. 09, 2026 | 2,338,852 |
| Jul. 10, 2026 | 2,549,492 |
| **Sum** | **17,302,328** |

Cross-check — Brand > Channels page Video Views by channel (Hulu, Public, Jul 4–10):
Facebook 7,990,812 · Twitter 82,973 · **Instagram 17,302,328** · TikTok 19,156,821.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 6 | 6 | All four Public Video View options (Facebook, Twitter, Instagram, TikTok) visible and selectable in TWC | All four present under Content>Video>Channel View; each an enabled `controlled-check-box` (`aria-checked=false`) | PASS |
| 8(a) | 8 | Instagram Public Video View graph displays correctly | Chart rendered (svg / area-chart present) on story 155903 | PASS |
| 8(b) | 8 | Table displays with columns "Instagram Public Video View" and "Brand Name" | Table header cells: `Instagram Public Video Views` (date/metric col) + `Hulu` (brand col) | PASS* |
| 8(c) | 8 | "Date" and "Brand Name" columns contain values | Date col Jul 04–10 populated; Hulu col numerics populated (7 rows) | PASS |
| 8(d) | 8 | Instagram Public Video View columns sortable | Clicking `span.al-table__sortable` on Hulu header re-ordered rows descending (3,578,412 → 1,230,670) | PASS |
| 15 | 15 | TWC IG PVV sum matches Channel page IG Video View for same brand/perspective/date range | TWC sum 17,302,328 == Channel IG tile 17,302,328 | PASS |

\* A8(b) note: the brand-value column is headed by the actual brand name (`Hulu`) rather than the
literal string "Brand Name" — standard TWC single-brand table layout (dates as rows, brand as
column). Not a defect; wording in the spec is descriptive.

## Known bugs checked

- **Rule 7 open-bug screen:** the cached case file has no "## Open linked bugs" section → treated as
  none open. Ran the case normally.
- **`knowledge-base/bug-history.md` grep `137047`:** no prior bug entry (only the render-hang quirk
  below references the QA-ID).
- **`knowledge-base/known-quirks.md` — "TWC report-builder pane fails to render" (first observed
  2026-07-10, QA-137047, Hulu):** the workaround note says to re-run in a fresh session. **Did not
  reproduce this run** — the builder pane (Add Brand, metric tree, perspective toggle, Run Report)
  mounted fully and the report generated. No interference with any assertion. The quirk remains an
  intermittent init race, not a determinstic block; today's session cleared it.

## Bugs filed

None.

## Evidence (screenshots under `.playwright-out/QA-137047/`)

- `a6-four-pvv-metrics.png` — filtered metric tree showing the four Public Video Views options
- `a8-twc-report.png` — built TWC report (chart + 7-row IG PVV table) for Hulu
- `channels-page-full.png` — Brand > Channels page (Hulu, Public, Jul 4–10)
- `a15-instagram-tile.png` — Instagram tile close-up: Video Views 17,302,328 (-66%)
