# QA-136364 — Brand Content > Impressions data set - Facebook Gallery Posts Reels Association Removal (No Duplication of Reel Posts) Data QA

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** HBO Max (account_id=657), Brand: HBO Max (brand_id=155614), Data Set: Impressions, Facebook channel only, Content Type: Gallery filter, Apr 11–15, 2026
**Status:** ❌ FAIL — blocked by a reproducible "table failed to load" error; steps 7–11 (Gallery/Video dedup comparison) could not be executed

## Steps executed
1. HBO Max brand confirmed (carried over from QA-136357, same account/brand).
2. Cleared the prior Publish Type: Reel filter (Clear All).
3. Set date range to Apr 11, 2026 – Apr 15, 2026.
4. Data Set already "Impressions" (carried over).
5. Filter → Content Type → Gallery → Apply Filter. Filter pill rendered correctly: "Content Type: Gallery [Include]".
6. Post count header updated correctly: **Posts (3)** — count itself loads fine.
7. The post grid/table underneath consistently renders **"This table failed to load. Please try again."** with a Reload button.

## Recovery attempts (all failed, same error each time)
1. Clicked the in-page "Reload" button — failed again.
2. Clicked "Reload" a second time — failed again.
3. Full page hard reload (`location.reload()`) — filter pill persisted correctly (Content Type: Gallery), but the table still failed to load.
4. Switched layout from Grid View to Table View — same "table failed to load" error (rules out a grid-card-specific rendering bug; this is a data-fetch failure, not a layout rendering issue).

**5 consecutive reproductions**, deterministic — not a one-off flake.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (6a) | Page refreshes, post count updates on Gallery filter apply | Posts (3) count did update correctly | ✅ PASS |
| A2 (6b) | Only Gallery posts displayed | **Could not verify** — table never renders any post content | 🚫 BLOCKED |
| A3 (7a) | Identify a Gallery post containing multiple Reels | **Could not verify** — no post content rendered to inspect | 🚫 BLOCKED |
| A4 (10a/10b) | Video-filtered results in a second tab show correct count/only-Video posts | Not attempted — the first tab's blocking failure made the cross-tab Gallery→Video Reel-dedup comparison meaningless without a known Gallery post to check against | 🚫 BLOCKED |
| A5 (11a) | Reels contained in the Gallery post do not reappear under Content Type: Video | Not evaluated | 🚫 BLOCKED |

## Bugs filed

**Recommend filing:** "Brand > Content, Impressions data set, Facebook channel, Content Type: Gallery filter renders 'This table failed to load. Please try again.' — reproducible 5/5 attempts (in-page Reload ×2, full page reload, Grid→Table layout switch) on HBO Max, Apr 11–15 2026. The post-count header (Posts (3)) fetches successfully, but the post list/table body never renders — indicates the count-query and post-list-query are separate backend calls, and only the latter is failing for this filter+dataset+channel combination." This blocks any test that needs to inspect Gallery-post content under the Impressions data set for this brand/window.

## Cleanup
None — read-only verification attempted, no mutation occurred (blocked before any state-changing step).

## Note
Per `skills/brand-content-filter/SKILL.md` failure signatures, `"Table failed to load"` errors have previously self-resolved after ~3 reloads in other contexts (backend query timeout). That did not hold here — same failure held after 5 distinct reload/reload-mechanism attempts across ~2 minutes, suggesting this may be a genuine defect (or persistent backend outage) rather than a transient timeout, unlike the previously-documented milder cases.
