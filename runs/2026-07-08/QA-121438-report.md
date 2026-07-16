# QA-121438 — Brand > Paid - Group Table by Selection - Delivery Type - Instagram

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [brand-content-table-view](../../skills/brand-content-table-view/SKILL.md) (`[title="Table View"]` layout selector pattern, reused cross-surface from Brand>Content to Brand>Paid) — no new skill needed
**Account:** Amazon Prime Video (account_id=342), brand = Amazon Prime Video (brand_id=25864)
**Precondition match:** Spec says "logged in as Amazon Prime Video" — switched via profile menu → Search Account → Results row (Rule 1). Brand also exact match "Amazon Prime Video" as the account's default/favorite brand.

## Steps executed

1. Navigated to Brand > Paid (auto-landed on brand_id=25864 "Amazon Prime Video", channel defaulted to Facebook).
2. Clicked the Instagram `channel-ghost` icon → **confirmed Brand>Paid channel selection is exclusive-select** (same as documented for Brand>Audience): enabling Instagram automatically disabled Facebook without a separate deselect click. Clicked "Apply" (`[data-ui-name="channel_selector_apply_cta"]`) → URL updated to `channels=instagram`.
3. Clicked the `[title="Table View"]` layout icon → switched from card/grid layout to table layout (Ads (244) list).
4. Clicked the "Group Table by:" dropdown (`[data-ui-name="group_table_by"]`, was "None") → selected "Delivery Type" from the option list (None / Delivery Type / Ads Account ID / Ads Account / Ad Type / Ad Set / Campaign / Campaign Objective).
5. Clicked the expanded "Dark (145 Ads)" group-summary row → individual Dark ads (Rank 1-8+ visible) rendered beneath it.
6. Clicked the same "Dark (145 Ads)" row again → group collapsed back to summary-only.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | Post table updates grouped by Delivery Type | Table replaced its per-ad row list with 2 group-summary rows (`Dark (145 Ads)`, `Promoted (99 Ads)`), each carrying aggregate Spend/Paid Actions/Clicks/Outbound Clicks/Inline Clicks | PASS |
| A2 | 5b | Ads grouped as Dark and Promoted | Group labels exactly `Dark (145 Ads)` and `Promoted (99 Ads)` — 145 + 99 = 244, matching the ungrouped `Ads (244)` header count | PASS |
| A3 | 6 | Groups collapse when expanded row clicked | Clicking `Dark (145 Ads)` while collapsed expanded it (individual ad rows appeared); clicking again collapsed it back to the 2-row summary view | PASS |

**Result: PASS 3/3**

## Evidence

- Screenshot: `.playwright-out/qa121438-01-paid-loaded.png` (default state, Facebook channel, card layout)
- Screenshot: `.playwright-out/qa121438-02-instagram-applied.png` (Instagram-only channel state, 244 Active Ads)
- Screenshot: `.playwright-out/qa121438-04-table-view-scrolled.png` (Table View, Group Table by = None)
- Screenshot: `.playwright-out/qa121438-05-grouped-delivery-type.png` (grouped: Dark (145 Ads) / Promoted (99 Ads), collapsed)
- Screenshot: `.playwright-out/qa121438-06-dark-expanded.png` (Dark group expanded, individual ad rows visible)
- Screenshot: `.playwright-out/qa121438-07-dark-collapsed.png` (re-collapsed, back to 2-row summary)

## Findings (not filed as bugs — documented for KB)

- **Brand>Paid channel selector is exclusive-select**, matching the previously-documented Brand>Audience behavior (`audience-metrics-export` skill v3) — clicking a second channel-ghost deselects the first rather than adding to the selection. This extends that finding from Audience to Paid; worth checking Brand>Content next.
- Clicking a group-summary row's underlying post card (during expand) can incidentally trigger the post-detail hover-preview popup (Instagram embed) — `Escape` dismisses it cleanly and doesn't interfere with the group expand/collapse state.

## Cleanup

None required — read-only test (channel/layout/grouping are transient page state, not persisted mutations).

## Bugs filed

None.
