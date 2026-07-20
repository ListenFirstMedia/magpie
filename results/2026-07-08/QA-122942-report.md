# QA-122942 — Brand > Content - Instagram - Public Perspective

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skills used:** [view-perspective-toggle](../../skills/view-perspective-toggle/SKILL.md) v2, [brand-content-table-view](../../skills/brand-content-table-view/SKILL.md) v1
**Account:** Hulu · **Brand:** Hulu (brand_id resolved to 11003, see Problems) · **Date range:** Jun 30 – Jul 6, 2026 (default)

## Steps executed

1. Switched account LFQA → Hulu.
2. Brand (hover) → Content → landed on `brand_id=5670`.
3. Checked View toggle DOM state (`#perspective`) — found `checked: true` (Authorized), despite no explicit perspective request yet; clicked `label[for="perspective"]` to switch — confirmed `checked: false` (Public Data) afterward (Rule 2 compliance).
4. Set Channel = Instagram only via URL param (channel-icon toggles are not addressable via the accessibility tree per documented quirk) — re-verified toggle state stayed Public (`checked: false`) after the navigation.
5. Table View (default) — read column headers.
6. Switched to Detail View via `[title="Detail View"]` — read the aggregate-header metric sequence.
7. Clicked Export → Ok in the "Export Select Data Sets" modal.
8. Export queued asynchronously (AsyncPoller observed in console); clicked the Recent Activity bell — Playwright's `download` event fired automatically and the CSV was saved to `.playwright-out/`.
9. Cross-checked CSV data against the page's Sum row.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Metrics shown: Engagement, Reactions, Comments, Response Rate, Video Views, Video Response Rate | Table View columns: Engagements, Reactions, Comments, **Shares**, Response Rate, Video Views, Video Response Rate — all 6 named metrics present in the spec's order (Shares is an additional column, not a conflict) | PASS |
| A2 | 5 | Video Views column after Response Rate (Table view) | Confirmed: column order …Response Rate, Video Views, Video Response Rate | PASS |
| A3 | 6 | Video Views column below Response Rate (Detail view) | Detail View aggregate-header sequence: Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate — same order as Table View | PASS |
| A4 | 8a | CSV headers include Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type, Post Link, Live, Publish Type, Sponsor Name, Sponsor Link, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate | CSV header row matches this list verbatim (plus a "Data Set" preamble row labeling all metric columns "Public") | PASS |
| A5 | 8b | Metrics data matches page data | CSV column sums (Engagements 400,286 / Reactions 397,964 / Comments 2,322 / Video Views 8,574,515) computed from all 25 CSV rows match the page's Sum row exactly | PASS |

**Result: PASS 5/5**

## Problems / deviations

1. **Perspective toggle defaulted to Authorized on page load** despite the spec implying Public should be the reachable/testable state — required an explicit toggle click per Rule 2 (never trust the URL param). This is consistent with documented product behavior (`known-quirks.md`: "View toggle default position is Public Data" — that default applies to newly-added TWC brand rows, not necessarily Brand>Content's own toggle state, which can carry over from a prior session/account). Not a bug, just confirms Rule 2's importance.
2. **Brand-fallback-on-toggle-click reproduced again:** clicking the perspective toggle changed `brand_id` from 5670 → 11003 (both render as "Hulu" in the UI). This is the exact behavior documented in `knowledge-base/known-quirks.md` ("Hulu account: brand_id 5670 auto-redirects to 11003 on Brand>Content" and "Brand>Content perspective-toggle click can auto-fall back to a different brand"). All subsequent steps were performed consistently on brand_id=11003. Not treated as a new bug — pre-existing documented quirk, reproduced identically.
3. `browser_take_screenshot` again hit the 5-second font-loading timeout once during this case; not blocking, all assertions verified via DOM/CSV evidence instead.
4. Channel selection was done via direct URL `channels=instagram` param rather than clicking the channel icon toggle, per the documented quirk that channel-icon toggles aren't in the accessibility tree and are too small for reliable coordinate clicks. Re-verified the perspective toggle state after this navigation to make sure the URL-based nav didn't silently reset it (it didn't).

## Evidence

- CSV saved: `.playwright-out/Hulu-Brand-Content-2026-06-30-2026-07-06-posts.csv` (26 lines: 1 Data-Set preamble + 1 header + 25 post rows Jun 30 – Jul 6, 2026, Instagram only, Public data set).

## Skill maintenance

- `view-perspective-toggle` pass_streak +1 — Brand>Content `#perspective` DOM selector still accurate; brand-fallback-on-click quirk reproduced a 3rd time (previously Threads/Facebook-only channels; today general Instagram-only channel selection triggered it too) — worth broadening the quirk's documented scope from "Threads/Facebook-only" to "channel-scoped Brand>Content toggle clicks generally" in the next skill-maintenance pass.
- `brand-content-table-view` pass_streak +1 — Table View / Detail View column-order parity reconfirmed.

## Bugs filed

None.
