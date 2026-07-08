# QA-929 — Pinterest Content - Embedded Post Tooltip

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-929 · Priority: Minor
- **Result:** **PASS** — all assertions (A1–A6) verified. One documented finding per the case NOTE (empty tooltip for posts whose external Pinterest pin is unavailable).
- **Account:** Sephora (account_id=655) · **Brand:** Sephora (brand_id=7159) · **Channel:** Pinterest only · **Dates:** Jun 01–10, 2026 · **View:** Table
- **Skills:** brand-content-table-view (nav/table), brand-content-data-set-selector (channel/date mechanics), embedded-post-tooltip (NEW — created from this run)

## Known bugs checked (pre-run)
All linked issues are **Closed**. Watched for symptoms of:
- **LFMP-31385** (Closed) — "Brand > Content - Empty Embedded Post Tooltip is displaying while hovering". **Symptom re-observed** on posts whose external pin no longer exists (see Finding).
- **APPS-56800** (Closed) — "Pinterest post table isn't loading". Not reproduced — table loaded 30 posts.
- **APPS-48807** (Closed) — post-table vertical scrollbar in Table View. Not reproduced/not relevant.

## Steps executed
1. Switched account to **Sephora** (account_id=655) via LFIQA user menu. ✅
2. Brand > Content → brand = **Sephora** (brand_id=7159, default for the account). ✅
3. Channels → **Pinterest only** (opened `.channel-list-toolbar-selector`, solo-selected Pinterest, Apply → `channels=pinterest`). ✅
4. Date range → **Jun 01 → Jun 10, 2026** via the calendar (Start June-1, End calendar back to June, day 10, Ok). ✅
5. Layout → **Table View** (`i.lf-table-view`). ✅ (30 posts)
6. Hovered post-type links in the **Type** column (`div.label-blob[data-ui-name="type_column"] > a`). ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Post tooltip displays when hovering the Type-column post-type link | Hover renders `div.embedded-post-tooltip` (z-999) with the embedded Pinterest pin (image + caption) | ✅ PASS |
| A2 | User can view only one tooltip | Exactly one `.embedded-post-tooltip` present at any time | ✅ PASS |
| A3 | Tooltip closes on 'X' (upper right) or clicking elsewhere | X (`i.close-embed`) closes it; clicking a neutral cell also closes it | ✅ PASS |
| A4 | Hovering another post-type link does not open additional tooltips | Hovering row 3 replaced row 1's tooltip — never stacked (single container) | ✅ PASS |
| A5 | Clicking the post type opens the correct channel post in a new tab, matching the tooltip | Row 1 link → new tab `pinterest.com/pin/98938523061952385/` titled "Sephora Major Summer Deals" (matches the tooltip pin) | ✅ PASS |
| A6 | Post image and text match the tooltip | Row 1 tooltip = "Save big on top beauty…" pin; Row 3 tooltip text = "Finally, a Detox that doesn't suck. OUAI's best-selling clarifying shampoo…" — both match the row's Text column | ✅ PASS |

## Finding (per case NOTE: "check … no external pin; if any, raise a bug")
**Empty embedded post tooltip on posts whose external Pinterest pin is unavailable.**
- The embedded tooltip is built from Pinterest's live embed widget (`<a data-pin-do="embedPin" href="…/pin/<id>">` inside `.embedded-post-tooltip-body`). When the referenced pin no longer exists on Pinterest, the widget never renders and an **empty ~370×350 white tooltip box** (with only the X) is shown.
- Reproduced on **row 17** (pin `…959176`) and **row 20** (pin `…959187`) — both empty-caption posts. Opening either pin URL redirects to `pinterest.com/ideas/`, confirming the external pin is gone.
- Valid pins render correctly (row 1 pin `…385` resolves to a real pin; tooltip renders fully).
- Matches the closed bug **LFMP-31385** ("Empty Embedded Post Tooltip is displaying while hovering"). Likely either a regression of that fix (no empty-state/fallback when the external pin is unavailable) OR a dev-data artifact (seeded pin IDs that don't map to live pins). Recommend product/QA confirm whether an unavailable-pin fallback is expected. Note the embed id carries a suspicious `-undefined` suffix (`embedded-post-<hash>-undefined`).

## Evidence
- `qa929-hover1.png` — row 1 tooltip (SEPHORA Major Summer video pin).
- `qa929-hover2.png` — row 3 tooltip (OUAI clarifying shampoo pin).
- `qa929-empty-hover.png` — empty tooltip box on an unavailable-pin post.

## Bugs filed
None auto-created (per policy, bugs go to reports only). Finding above documented for triage against LFMP-31385.
