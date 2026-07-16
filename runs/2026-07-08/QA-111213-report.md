# QA-111213 — Reporting > Data Studio - IG Views & Story Views Metrics Data verification

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [data-studio-post-level-run](../../skills/data-studio-post-level-run/SKILL.md) (stable) — Page Level + Post Level flow, metric-tree search pattern
**Account:** Hulu (account_id=336), brand = Hulu (brand_id=5670)
**Precondition match:** Spec says "Hulu" — session already active as Hulu.
**Reports:** `report_id=301395` (Page Level), `report_id=301397` (Post Level)

## Steps executed

1. Reporting menu (hover) → Data Studio link → builder loaded clean (no leftover brand/metric state — first Data Studio nav this session).
2. "Page Level" tab confirmed active (default). Typed "Hulu" into "Search for a Brand" → clicked exact "Hulu" listitem.
3. Clicked the Public/Authorized toggle switch (`.al-toggle__switch label.label` — the visually-clickable label, not the hidden `input`) → confirmed `checked=true` via DOM.
4. Clicked "Select Metrics" → typed "Instagram Views" into "Search for a Metric" → confirmed tree path **Engagements → Impressions → Instagram Views** (exact match to spec step 5 wording) → clicked the leaf checkbox, confirmed `aria-checked=true`. Metric appeared in the "Page Level Metrics" selected-metrics table.
5. Clicked "Go" → report built (`report_id=301395`) → Instagram Views chart + table rendered with full 7-day data.
6. Clicked "Show Configuration" → clicked "Post Level" tab (Post Level Metrics section came up empty — no carryover of the Page Level metric selection).
7. Clicked "Select Metrics" (Post Level) → typed "Instagram Post Impressions" → confirmed tree path **Impressions → Impressions → Instagram Post Impressions** (matches spec step 8 wording) → clicked the leaf checkbox, confirmed `aria-checked=true` and NOT disabled (Hulu row was already Authorized from step 3, satisfying the documented In-Window+Authorized precondition for Post Level Impressions metrics).
8. Clicked "Go" → report built (`report_id=301397`) → Instagram Post Impressions chart + table rendered with full 7-day data.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Selected IG metrics displayed under nodes | After checking the leaf, "Page Level Metrics" table showed a new row "Instagram Views" (with Remove All) — confirmed via DOM text before clicking Go | PASS |
| A2 | 6 | Report loads, data displays for selected IG metrics | `report_id=301395` rendered chart + table: Sum 51,051,166 / Average 7,293,024, daily values Jun 30-Jul 6 all populated, no em-dash gaps. Cross-validated against QA-111132's TWC export for the same brand/dates — identical per-day numbers (10,012,508 / 9,174,282 / 7,331,894 / 6,520,663 / 5,582,039 / 9,845,080 / 2,584,700) | PASS |
| A3 | 9 | Report loads with Instagram Post Impressions data on post level | `report_id=301397` rendered chart + table: Sum 7,750,328 / Average 1,107,190, all 7 days populated | PASS |

**Result: PASS 3/3**

## Evidence

- Page Level report text extract (report 301395): `Instagram Views	Hulu	51,051,166	7,293,024	10,012,508	9,174,282	7,331,894	6,520,663	5,582,039	9,845,080	2,584,700`
- Post Level report text extract (report 301397): `Instagram Post Impressions	Hulu	7,750,328	1,107,190	1,624,128	1,956,972	2,237,522	1,380,368	281,958	169,848	99,532`
- Metric-tree path confirmations captured via `browser_evaluate` text dump before each Go click (see steps 4 and 7 above).

## Findings (documented for KB, not filed as bugs)

- **Public/Authorized toggle's real click target is `.al-toggle__switch label.label`**, not the underlying (hidden, `offsetWidth`-zero) `input.al-toggle__checkbox` — a direct Playwright click on the checkbox input times out ("element is not visible"). This refines the general `.al-toggle__checkbox` guidance already in `spec-adherence-rules.md` Rule 2 with the concrete clickable wrapper for the Data Studio brand-row toggle.
- **Switching Page Level → Post Level does NOT carry over the previously selected metric** — the Post Level Metrics table started empty, unlike the cross-page-navigation persistence noted for Data Studio in `known-quirks.md` (which applies to brand/date selections, not metric selection across the two Level tabs). Worth a note for future multi-part DS tickets: only brand/date state persists, metric selection resets per Level tab.
- Confirmed the Post Level Impressions precondition (In-Window + Authorized) from the 2026-06-13 known-quirks entry: since Authorized was already set from the Page Level portion of this same ticket, the Instagram Post Impressions checkbox was enabled and selectable without any extra steps.

## Cleanup

None required — read-only test (no dashboard/entity mutation).

## Bugs filed

None.
