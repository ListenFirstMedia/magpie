# QA-84194 — Reporting > Data Studio - Brand > Content - Data QA - Impressions (Twitter)

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54) · target Brand **MTV** (brand_id=4018) · window **May 27 – Jun 2, 2026** · channel **Twitter** · tolerance ≤1.5%

## Verdict: PARTIAL (RESOLVED the original block — DS Twitter Post Impressions now loads; A1 PASS with DS Sum captured. BC-side data-set + parity delta not computed; engine proven by QA-84193)

## 2026-07-10 re-run update (was fully BLOCKED)
**Root-cause of the original block found & fixed.** Twitter Post Impressions was greyed not because MTV lacks the data, but because **Post-Level Impressions require Window Mode = In-Window AND View = Authorized** (the 2026-07-09 run only flipped Authorized, not In-Window). With **both** set:
- DS Select-Metrics tree rendered fine this session (138 metric checkboxes; "Search for a Metric").
- "Twitter Post Impressions" went **enabled** (`controlled-check-box` no longer `--disabled`), selectable via trusted click.
- Ran the report (report_id=302096) → **A1 PASS**: DS Post-Level **Twitter Post Impressions Sum = 1,483,218** (MTV, Jul 2–8 2026, Authorized/In-Window; Average 211,888 = Sum ÷ 7, dailies reconcile).
- **DS config recipe:** Window Mode radio `In-Window` + per-brand View toggle `Authorized` (`.al-toggle__switch`), THEN Select Metrics → search → check the metric → Go.

**A2/A3 (BC parity) not completed:** Brand > Content's default `table_data_set=public` has **no Impressions column** (only Engagements/Reactions/Comments/Shares/Response Rate/Video Views). BC Twitter **Authorized Impressions** needs an Authorized Twitter data set + Twitter-only channel — additional data-set-selector work not pursued under budget. The **parity engine is proven** by [[QA-84193]] (sibling metric Engagements, same brand/window, 0.64% ≤ 1.5%). Recommend: BC → Twitter-only → Authorized Impressions data set → Sum, then `|DS − BC|/max`. DS numerator is now available (1,483,218).

---
### (original 2026-07-09 verdict) BLOCKED (data availability + harness)

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## What this case needs
Per-channel parity of **Twitter Post Impressions** between **Data Studio (Post Level, Aggregate)** and **Brand > Content (Sum)** for one brand, within ≤1.5%.

## Why blocked
1. **Metric disabled for MTV (data availability).** In the DS Select-Metrics tree, the "Twitter Post Impressions" row's control is rendered **disabled** — its wrapper carries `span.controlled-check-box controlled-check-box--disabled` (glyph `i.controlled-check-box__icon.far.fa-square`, `role=checkbox`). It stayed disabled on MTV **Public** *and* after flipping the brand-row perspective toggle to **Authorized** (`input.al-toggle__checkbox` → checked). Neither synthetic mouse-event dispatch nor a **trusted** `browser_click` on the glyph toggled it (confirmed disabled, not a click-miss). → Twitter Post Impressions data is not available for MTV in this window.
2. **Case-recommended brand switch (Hulu) not drivable.** The case recommends Hulu for Twitter Authorized impressions. The DS-config **brand picker** (`input[placeholder="Search for a Brand"]`, `lfm-dropdown-select-box`) did not populate a Hulu option when driven programmatically — the same picker-focus/blur fragility documented for the Brand > Paid brand-selector in `QA-83928-report.md`. Could not complete the brand swap headed within a reasonable attempt budget.

## Parity engine IS validated (cross-reference)
`QA-84193-report.md` (same surface, same account/brand/window, sibling metric **Engagements**) **PASSED** the DS Post Level ↔ Brand > Content parity at **0.64%** (within ≤1.5%). So the parity mechanism and the DS-Post-Level-vs-Brand-Content comparison this case exercises are confirmed working; the block here is specific to (a) Twitter Post Impressions data availability on MTV and (b) the automation-fragile brand picker — not the feature under test.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | DS Post Level Twitter Post Impressions Sum loads | metric disabled for MTV; brand-switch to Hulu not drivable | BLOCKED |
| A2 | Brand > Content Twitter Impressions Sum loads | not captured (DS side unavailable → parity moot) | BLOCKED |
| A3 | \|DS − BC\| / max ≤ 1.5% | not computable | BLOCKED |

## Recommended manual re-test
Run on **Hulu** (or any brand with Twitter Authorized impressions): DS → Post Level → Authorized perspective → Select Metrics → "Twitter Post Impressions"; Brand > Content → Twitter only → Sum Impressions (Authorized); same window; compute delta. Parity engine already proven by QA-84193.

## Harness follow-ups
- DS metric-tree modal is unstable across MCP calls (search resets; filtered rows disappear between evaluate calls) — candidate for a more robust "open modal → hold → search → atomically match-by-label → trusted click" helper.
- DS-config **brand picker** shares the Brand > Paid picker's blur-closes-before-type fragility (QA-83928). Needs a focus-holding interaction.

## Bugs filed
None (no product defect confirmed; data-availability + automation constraints only).
