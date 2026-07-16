# QA-112583 — Reporting > Follower Demographics Vs Threads Audience - Export - Data QA

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-112583
- **Priority:** Blocker
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** Adam Orfei (account_id=54) — Max brand (brand_id=412264)

## Steps executed

1. Reporting (top nav, hover) → Follower Demographics → loaded `app-reporting.lfmdev.in/#/follower_demographics` (required a fresh `#home` reload first — direct nav to the builder hung on "Loading..." for >15s; re-navigating via the Reporting menu link resolved it, consistent with the known SPA stale-route friction).
2. Typed "Max" in Add Brand By Name → selected the exact-match **"Max"** entry (Rule 1 — first/top result, not a "Max ___ Person" variant).
3. Date range: navigated the single calendar back from Jul 2026 → May 2025 using the `th.prev`/`th.next` JS-fallback with a 200ms inter-click delay (rapid unthrottled clicks did not advance the month — reconfirms the documented rapid-click-loop quirk). Clicked day **5** once — the widget selected `range-start` = `range-end` = May 5, 2025 (single-day range) in one click.
4. Channel Data: unchecked Twitter, Instagram, YouTube (leaving only **Threads** checked) via direct DOM `.click()` on the `controlled-check-box__icon` elements — Playwright's `browser_click` timed out because the checkboxes were horizontally scrolled out of the viewport; the JS click was verified to persist (no React revert) after an 800ms wait.
5. Run Report → story `156034` ("Max — Follower Demographics (May 5, 2025)") rendered.
6. Export → CSV → downloaded `Max---Followers-Demographics-05-05-2025.csv` (native Playwright download, saved to `.playwright-out/`).
7. Brand (top nav) → Audience → in-page brand picker → typed "Max" → selected exact-match **"Max"** result (brand_id=412264 confirmed in URL).
8. Attempted to load `#explore/brand/audience?brand_id=412264` (with `from=2025-05-05&to=2025-05-05`) — **the SPA router silently redirected the URL to `#explore/brand/insights?brand_id=412264`** every time (reproduced twice). The Brand sub-nav tab list for Max is: Insights, Channels, Content, Video, Optimization, Partnerships, Conversation — **no Audience tab, no Stories tab, no Paid tab**.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| — | 6 | Follower Demographics CSV exports Threads gender-breakdown values for Max, May 5 2025 | CSV downloaded successfully with header row `Channel,Threads×6 / Data Point,Men/Women/Unknown Followers + Share` — but the single data row (`Max - DAR`) is **entirely blank** for all 6 columns | data-empty, see below |
| 14 | 8-14 | Brand > Audience > Followers: Gender Breakdown tile CSV values match the Follower Demographics report values (after % ↔ float conversion) | **BLOCKED** — Max (brand_id=412264) has **no Brand > Audience page at all**; the URL is silently rewritten to Brand > Insights and no Audience tab exists in the sub-nav | BLOCKED |

## CSV contents (Follower Demographics export)

```
"Channel","Threads","Threads","Threads","Threads","Threads","Threads"
"Data Point","Men Followers","Women Followers","Unknown Followers","Men Followers Share","Women Followers Share","Unknown Followers Share"
"Max - DAR","","","","","",""
```

All 6 Threads demographic values are blank for Max on May 5, 2025 — i.e., there is no follower-demographics data for this brand/channel/date combination in the Follower Demographics report either.

## Root-cause analysis (Rule 5 — re-read before filing)

Two independent test-data gaps compound to make this assertion unverifiable as specified:
1. Max's Threads follower-demographics data is empty for the single day May 5, 2025 in the Follower Demographics reporting tool.
2. Max (brand_id=412264) has no Brand > Audience surface at all — extending the existing known-quirk (`known-quirks.md`, 2026-06-27 "Max brand has no Threads channel") from Brand>Content/Brand>Channels to **Brand>Audience being entirely absent** for this brand.

Per Rule 1, no brand substitution was made. Per Rule 5, this is a test-data/product-surface gap, not a functional defect in the export or the comparison logic — there is nothing to compare because one side of the comparison (Brand > Audience) doesn't exist for this brand, and the other side (Follower Demographics) has no data for the specified single-day window.

## Status: **BLOCKED** (test-data gap, Blocker-priority ticket — recommend LFIQA/product review)

- The Follower Demographics → CSV export mechanic itself works end-to-end (Rule 6 satisfied — real download observed, file read from disk).
- Assertion 14 cannot be evaluated as written because Max has no Audience page. Recommend either (a) product confirms Max is not intended to have Brand > Audience and the spec brand should be updated to a brand that does, or (b) a wider date range is used so Threads demographic data exists for the Follower Demographics side.
- **No bug filed** — per spec-adherence Rule 1/5, this is documented as a test-data gap, not a substituted-brand false positive.

## Cleanup
Non-mutating test — no cleanup required.
