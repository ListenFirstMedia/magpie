# QA-109920 — Brand > Content - Sentiment Comments limit - Positive Classification Donut - CSV

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109920
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Account:** Amazon Prime Video (account_id=342)
- **Brand:** Amazon Prime Video (brand_id=25864, Authorized perspective)
- **Date Range:** Apr 1, 2025 – Apr 7, 2025
- **Priority:** Critical (P2)
- **Result:** ⏸ **PARTIAL — A1/A2 inconclusive (Recharts donut hover popup with Read link cannot be reliably triggered via Chrome MCP synthetic pointer events; tooltip flashes briefly under JS-dispatched mouseover but the actionable "Read" popup variant did not stay open). A3 deferred — CSV export not reached because Read popup never opened. Manual LFIQA pass needed for this Critical-priority test.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Amazon Prime Video via Yash picker | ✓ |
| 1 | Hover Brand → Content | ✓ — URL `/#explore/brand/content` |
| 2 | Brand picker → typed `Amazon Prime Video` → clicked exact-match from live Results (Rule 1) | ✓ — brand_id=25864 |
| 3 | Set date range to Apr 1-7, 2025 (via URL) | ✓ — URL `from=2025-04-01&to=2025-04-07` |
| 4 | Click Sentiment button | ✓ — "Sentiment Export" button appeared, Classification donut + Classification (Daily) area chart rendered |
| 5 | Hover on Positive classification (green segment) in Classification donut | ⚠ Hover via Chrome MCP `hover` action didn't trigger Recharts tooltip; JS-dispatched `pointerover`/`mouseover` produced a flash tooltip ("Positive Classification: 50%") at the bottom of the donut but the actionable "Read" popup variant did not display |
| 6 | Click Read in pop-up | ⏸ Popup not reachable |
| 7-8 | Export CSV + Ok | ⏸ Deferred |

## Observed page state at the donut

- **Classification donut:** Positive 50% (green), Neutral 36% (gray), Negative 14% (red) — labels visible
- **Classification (Daily) area chart:** Positive trending around 50%, Neutral around 30-35%, Negative around 10-15% across Apr 1-7
- **Emotion donut** (below): Love 13%, Joy 29%, Surprise small, Neutral 38%

## Why the Read popup didn't open

Recharts tooltips/popups respond to *trusted* pointer events from the OS. Chrome MCP's synthetic `hover` action and JS-dispatched `MouseEvent`/`PointerEvent` sequences flip the tooltip on momentarily but Recharts re-evaluates `isTooltipActive` on each frame and drops it without sustained trusted pointer movement. This is the same class of issue as the `controlled-check-box` and `React typeahead` quirks already documented in `known-quirks.md`.

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Pop-up opens | Brief flash of a Recharts tooltip ("Positive Classification: 50%") appeared but the actionable popup with Read link did not stay open with synthetic events | ⏸ INCONCLUSIVE |
| A2 | Message displays: "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000" | Could not verify — popup didn't stay open | ⏸ DEFERRED |
| A3 | CSV export has more than 2000 comments | CSV export never triggered (Read button not clickable without popup) | ⏸ DEFERRED |

## Recommended next step
- LFIQA: manually hover Positive on the Classification donut, click Read, click Export → CSV → Ok. Then upload the CSV (or grant Downloads folder mount and I'll read it directly) for A2/A3 verification.

## Skill registry impact
- Adding `recharts-pointer-hover` to `known-quirks.md` proposed: Recharts donut tooltips/popups (especially those with action links like "Read") respond only to trusted OS-originated pointer events. Chrome MCP synthetic hover/click and JS-dispatched MouseEvent/PointerEvent flash the tooltip momentarily but cannot keep it open for click follow-up. Workaround: defer to LFIQA manual run.
- `switch-account` v2 — pass_streak +1 (separate-day, Adam Orfei → Amazon Prime Video switch worked first try)

## Sources
- [QA-109920 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-109920)
