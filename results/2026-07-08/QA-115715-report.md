# QA-115715 — Brand > Insights - Total Followers - Export CSV

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [audience-metrics-export](../../skills/audience-metrics-export/SKILL.md) (tile Export pattern) + [switch-account](../../skills/switch-account/SKILL.md) — reused as-is
**Account:** Michael Kors (account_id=328), brand = Michael Kors (brand_id=3801)
**Precondition match:** Spec says "logged in as Michael Kors" — switched from Hulu via profile menu → Search Account → Results row (Rule 1 respected; account name matched exactly). Brand also confirmed via explicit "Search for a Brand" typeahead → exact-match "Michael Kors" clicked from the results list (not the auto-landed default, though it resolved to the same brand_id=3801).

## Steps executed

1. Profile menu (LFQA) → Search Account → typed "Michael Kors" → clicked the Results-section entry (not Recent Searches). URL confirmed `account_id=328`, breadcrumb "Account: Michael Kors".
2. Navigated to Brand > Insights (via Home "Brand Insights" suggested view, opened in new tab) → explicitly re-searched and selected "Michael Kors" from the brand typeahead's exact-match Results row.
3. Reviewed the Total Followers tile in default state.
4. Clicked the tile's Export dropdown (PNG/CSV/Google Sheets/Metrics) → clicked CSV. Playwright captured a real `download` event.
5. Clicked the page-level "Data Visualization" dropdown → selected "Data View: Share" (this is the mechanism referred to as "Share" in the spec — the dropdown's actual option label is `Data View: Share`, sibling to `Data View: Count`).
6. Clicked the TikTok `channel-ghost` icon in the Channels row (real Playwright coordinate/DOM click — confirmed class flipped `enabled`→`disabled` before proceeding) → clicked Apply.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Header format `Total Followers: 93.2M (-<1%)` | `Total Followers: 42.7M (+<1%)` — same `<Label>: <value> (<change>)` template | PASS |
| A2 | 3b | Legend order: Facebook, Twitter, Instagram, TikTok | Legend read exactly `Facebook Twitter Instagram TikTok` in that order | PASS |
| A3 | 4a | CSV filename `Brand-Tab-Tile-YYYY-MM-DD(Start)-YYYY-MM-DD(End).csv` | Downloaded `Michael Kors-Insights-Total Followers-2026-06-30-2026-07-06.csv` — matches pattern | PASS |
| A4 | 4b | CSV headers: Brand Name, Channel, Total Followers | Row 1: `"Brand Name","Channel","Total Followers"` exactly | PASS |
| A5 | 5 | Pie chart shows percentages | After Data View: Share, donut segments read `44% / 44% / 7%` with center `100%` (previously absolute `18.7M/2.89M/19M/42.7M`) | PASS |
| A6 | 6 | Pie chart updates; TikTok removed from Legend | Donut recalculated to `47% / 46% / 7%` (3 segments) center still `100%`; Legend now reads `Facebook, Twitter, Instagram` (TikTok gone); big-number header dropped to `Total Followers: 40.6M` (42.7M − 2.1M TikTok) | PASS |

**Result: PASS 6/6**

## Evidence

- Screenshot: `.playwright-out/qa115715-00-check-brand.png` (tile default state, Count mode, all 4 channels)
- Screenshot: `.playwright-out/qa115715-02-brand-typeahead-results.png` (brand search typeahead, exact "Michael Kors" as first result)
- Downloaded file (Rule 6, verified on disk): `.playwright-out/Michael-Kors-Insights-Total-Followers-2026-06-30-2026-07-06.csv`
  ```
  "Brand Name","Channel","Total Followers"
  "Michael Kors","Facebook","18694899"
  "Michael Kors","Twitter","2894163"
  "Michael Kors","Instagram","18980666"
  "Michael Kors","TikTok","2100000"
  ```
- Screenshot: `.playwright-out/qa115715-04-share-mode.png` (Data View: Share — all tiles switched to percentage axes, donut 44/44/7%)
- Screenshot: `.playwright-out/qa115715-06-tiktok-removed-loaded.png` (post-Apply: TikTok gone from channel row, legend, and donut; Total Followers recalculated to 40.6M)

## Findings (not filed as bugs)

- The spec's "Data Visualization dropdown → Share" step maps to the dropdown option literally labeled `Data View: Share` (sibling `Data View: Count`) — naming is slightly different from the spec's shorthand but functionally identical. Documented here for future runs, not a defect.
- Selecting "Share" changed **all tiles on the page** to percentage-based Y-axes (Follower Growth, Fan Growth Rate bars also flipped to 0–100%), not just the Total Followers donut. Spec only asserts the pie tile: consistent product behavior, page-level control — not a bug.

## Cleanup

None required — read-only test (channel deselect + view-mode change are transient page state, not persisted mutations).

## Bugs filed

None.
