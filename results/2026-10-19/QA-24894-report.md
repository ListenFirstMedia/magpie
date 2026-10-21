# QA-24894 — Reporting - Data QA - Social Recap Date - Date

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Sephora (655) · Reporting → Social Recap → brand **Sephora** (typeahead, exact match), **Authorized** perspective (toggle `0-perspective-toggle` checked=true), all 7 channels on, default week → story **161365** "Weekly Social Recap (Oct 12, 2026 – Oct 18, 2026)"
**Verdict: PASS (4/4) at display precision — every channel-table sum reconciles with its donut big number (147M / 49M / 596K / 22K). Caveat: the donut `data-tooltip` could not be read — `.al-donut__tooltip` stays empty under headless Chrome on real and synthetic hover — so the comparison is against the abbreviated big number, not an exact tooltip value**

## Section 2 — Social Activity, Oct 12 – Oct 18, 2026
| ID | Spec sum | Table values (channel rows) | Sum | Donut big number | Status |
|----|----------|------------------------------|-----|------------------|--------|
| A7 | FB + TW + IG + YT + TikTok Paid + LinkedIn Impressions | FB 111,429,542 · FB Paid 0 · TW 0 (Organic/Paid –) · IG 25,330,749 · YT – · TikTok Paid 10,664,961 · LinkedIn – · Threads 0 | **147,425,252** | **147M** | ✅ |
| A9 | FB (Organic + Paid) + IG + TW + YT + TikTok + LinkedIn Video Views (exclude TikTok Paid) | FB 6,945,714 (= Organic 373,745 + Paid 6,571,969 ✓) · TW 0 · IG 25,330,749 · YT 694,621 · TikTok 16,384,909 · LinkedIn – | **49,355,993** | **49M** | ✅ (adding TikTok Paid 10,519,048 would give 59.9M ≠ 49M, confirming the spec's exclusion) |
| A11 | FB + IG + TW + YT + TikTok + LinkedIn Engagements | 8,504 + 0 + 435,842 + 16,631 + 134,777 + – (+ Threads 0) | **595,754** | **596K** | ✅ |
| A13 | New Followers, positives only | FB −11,747 (skip) · TW −734 (skip) · IG 9,240 · YT 0 · TikTok 0 · LinkedIn 12,480 | **21,720** | **22K** | ✅ |

Share columns cross-check: Instagram Video Views 25,330,749 ÷ 49,355,993 = 51% ✓ (table shows 51%); Facebook Impressions 111,429,542 ÷ 147,425,252 = 76% ✓.

## Mechanics (for the skill)
- Builder: `input.al-typeahead__text-input` real keystrokes → option "Sephora" (dispatched click; the list shows no "Results" header here) → brand row shows `View: Public Data | Authorized Data` with `input#0-perspective-toggle`; Run Report → "Building Your Story" → **View Now**.
- Report DOM: four `svg.donut` charts (center `text.graphic__text` = abbreviated value, label, %YOY) with `path[data-datapoint=…]` segments, each followed by a `Channel | <Metric> | Share` table. Tooltip containers `.al-donut__tooltip` exist (position updates on hover) but render no text headless.

## Evidence
`.playwright-out/QA-24894/01-social-recap-builder.png` … `07-donut-tables.png`

## Known bugs checked
- LFMP-32081 (Open, "Social Recap – Negative Engagements" on Sephora) — **not reproduced**: Engagements 596K positive, all channel rows ≥ 0.
- LFMP-31925 (%YOY missing in Video Views donut) — not reproduced: Video Views shows "36% YOY".

## Bugs filed
None. · **Cleanup:** none (report 161365 persists like any manual run).
