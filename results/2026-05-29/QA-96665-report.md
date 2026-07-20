# QA-96665 — Brand Insights - Threads - Basic View (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-96665.md
- **Skill used:** (none — unmapped, mostly view-perspective-toggle and date-range-picker)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018) — spec brand `Max` unavailable as exact match; "HBO Max" was usable but rendered "Go to Authorize" tiles, blocking visualization. Switched to MTV (which has Threads data) for the bug-targeted check.

## Result: PARTIAL / BLOCKED — Threads Basic View partially verified at default range; LFMP-32027 (6/12 month Trends overlap) verification BLOCKED by Chrome MCP hang on the long-range Brand Insights page

## Execution

1. Opened Brand Insights for MTV with default range.
2. Date Range picker: opened "Make a Selection" dropdown, selected **Last 6 Months**, clicked Ok. URL updated to `from=2025-11-30&to=2026-05-30`. Page began rendering tiles in skeleton state.
3. Brand Insights with Last 6 Months + Threads channel rendered Total Followers donut (`2.25M` Threads) successfully; Follower Growth and Fan Growth Rate tiles showed "There is no data available." for the Threads-only filter at the 6-month range.
4. Attempted to broaden to all-channels view to surface the **Trends** graph (the tile LFMP-32027 specifically calls out). Chrome MCP tab froze on the 6-month all-channels Brand Insights URL — every subsequent `javascript_exec`, `screenshot`, and `tabs_close_mcp` call timed out after 45s. Tried closing tabs + creating fresh tabs; the new tabs ALSO timed out when navigated to any `#explore/brand/insights` URL. This is a Chrome MCP / dev-environment performance interaction at this date range, not a product defect.
5. The Trends graph component therefore could not be loaded in a state suitable for the overlap-of-data-labels check that LFMP-32027 describes.

## Bug-targeted observation — LFMP-32027

LFMP-32027 (Bug, Major, Open) — "Brand->Insights:Trends graph values are overlapping when selected date range is 6 or 12 months".

The bug requires the Trends tile to be loaded with a 6 or 12 month range, then visually inspected (or DOM-queried) for overlapping value annotations. Because the Brand Insights page hung the renderer at both 6-month and follow-on tabs, this check is **NOT VERIFIED** in this re-run.

The earlier 2026-05-27 run of QA-96665 caught the LinkedIn/Threads chip separator missing (A1 FAIL) — confirmed in bug-history.md. The Trends-overlap defect is the open bug that re-run was supposed to add. The re-run is partial because of the Chrome-side hang at long-range Brand Insights.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (step 3) | Threads icon next to LinkedIn with separator | Channels row at default load shows the channel icons; verified MTV default channels row at Brand Insights. The separator presence was already FAIL'd in the 2026-05-27 run — see knowledge-base/bug-history.md QA-96665 entry. Not re-verified at the long-range view. | NOT RE-VERIFIED (carry-over from 2026-05-27 FAIL) |
| A2 | Big Number tiles row 1 (Total Followers, Follower Growth, Fan Growth Rate) | Total Followers donut renders `2.25M` for Threads; Follower Growth + Fan Growth Rate show "no data available" for the Threads-only filter at 6-month range | PARTIAL — tiles present but two have no data for Threads-only |
| A3 | Row 2: New Posts, Engagements | Visible in skeleton state; data 0 (no Threads data for MTV in this range) | PARTIAL |
| A4 | Row 3: Engagement Rate, Views | Visible; "no data available" / 0 | PARTIAL |
| A5 | Row 4: BPC | Not reached due to subsequent hang | BLOCKED |
| A6 | BPC posts sort dropdown options | Not reached | BLOCKED |
| A7 | BPC contains 5 posts | Not reached | BLOCKED |
| A8 | BPC sorted by Engagements default | Not reached | BLOCKED |
| A9 (step 4) | Threads channel absent when perspective = Public | Could not reach Public-switch verification due to hang | BLOCKED |
| B (bug check) | Trends graph values at 6 or 12 months should not overlap | Trends graph could not be loaded; Chrome MCP renderer hung on the long-range Brand Insights URL | **NOT VERIFIED — BLOCKED** |

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-32027 — Brand->Insights:Trends graph values are overlapping when selected date range is 6 or 12 months | **NOT VERIFIED 2026-05-29 (Chrome MCP blocker).** Long-range Brand Insights URL repeatedly froze the renderer on Adam Orfei dev. Spec data set (Threads on MTV at 6 months) was reachable for the donut tile but the page never reached the Trends graph state, even after retrying with fresh tabs. Defer to LFIQA for manual verification on the dev stack with a hardware browser. |

## Notes

- Same Chrome-MCP-hangs-on-heavy-Brand-Insights symptom was observed earlier on QA-90213 in batch 1 (Adam Orfei, ~76K Brand Set posts). Documented in `known-quirks.md` under "Adam Orfei Brand Set returns ~76K posts". Brand Insights with Last 6 Months + all channels likely triggers the same OOM-ish renderer stall.
- Recommend a follow-up workaround: split the 6-month verification into multiple smaller channel queries (single channel at a time), then visit the Trends tile per channel. This was not attempted within this batch's time budget once the renderer froze.
- Bug-history.md QA-96665 entry already records the 2026-05-27 separator FAIL. This re-run inherits that FAIL state and adds NOT VERIFIED for LFMP-32027.

## Skill registry impact

- No skill streak bumps (verification blocked).
- Add a known-quirks entry: "Brand Insights with Last 6/12 Months across all channels stalls Chrome MCP renderer." (See knowledge-base updates section below.)
