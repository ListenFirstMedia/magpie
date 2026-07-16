# QA-110071 — Brand > Audience - Threads - Metrics

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-110071
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Skill used:** `audience-metrics-export` (v2, untrusted) — this run supersedes its Chrome-MCP-era mechanics with Playwright equivalents (see Skill updates below)

## Steps executed

1. Brand (top nav) → Audience. Landed on `#explore/brand/audience?brand_id=4018` (MTV carried over from session context).
2. Brand switcher: opened the in-page "Search for a Brand" textbox, typed `MTV`, selected the exact `MTV` entry from the results list (not a variant like `MTV (Argentina)`/`MTV (FB)` — Rule 1 honored). brand_id stayed 4018.
3. Channel selection: clicked the `Threads` channel-ghost, then the `Facebook` channel-ghost. **Finding:** the channel selector is exclusive-select, not multi-toggle — clicking one channel-ghost switches to that channel only and clears the rest (see Skill updates). Confirmed final state via DOM: `threads channel-ghost enabled`, all others `disabled`. Clicked **Apply** → URL updated to `channels=threads`.
4. Date range: opened the Date Range picker, navigated the Start calendar back 15 months (Jun 2026 → Mar 2025) and the End calendar back to Mar 2025, clicked day 16 (start) and day 22 (end), clicked **Ok**. URL confirmed `from=2025-03-16&to=2025-03-22`.
5. Clicked **Export** → dropdown showed `CSV`, `Google Sheets`, `Metrics`. Clicked **Metrics**.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Exported filename is `Brand-Audience-Metrics` (+ extension) | No `download` event fired, no `a[download]` anchor observed in the DOM post-click, no new file appeared in `~/Downloads` or `.playwright-out/`. The underlying data call (`GET data-api.lfmdev.in/audience/metrics_export?brand_id=4018&channel=threads&from_date=2025-03-16&to_date=2025-03-22`, 200 OK, `content-type: text/plain`) has no `Content-Disposition` header, so the actual filename can't be captured from network evidence, and per Rule 6 a missing DOM/network signal is not itself proof of a broken download. | **INCONCLUSIVE** (Rule 6 — needs manual Downloads-folder confirmation) |
| A2 | 4 | Export contains columns `Display Name` and `Key` | Fetched the export response body directly: first line is exactly `Display Name,Key`, followed by 8 data rows (Facebook Fans, Twitter Audience Distribution, Instagram Followers, YouTube Views ×2, YouTube Watch, LinkedIn Followers, Threads Followers). | **PASS** |

## Evidence

Export response body (verbatim):
```
Display Name,Key
Facebook Fans,facebook.page.followers_m
Twitter Audience Distribution,people_pattern.audience.distribution
Instagram Followers,instagram.page.followers_m
YouTube Views,youtube.video.estimated_views
YouTube Views,youtube.video.views
YouTube Watch,youtube.video.watch_time
LinkedIn Followers,linkedin.page.followers_m
Threads Followers,threads.page.followers_m
```
Note: this catalog is channel-agnostic metadata (lists metrics for all channels the brand collects, not just Threads) — matches the "metadata catalog, not per-channel data" behavior documented in the skill.

## Problems encountered

1. **Channel selector is exclusive-select, not additive.** Clicking a second channel-ghost (e.g. Facebook after Threads) silently deselects the first instead of adding to the selection. This contradicts the original skill's Chrome-MCP note that channels toggle independently — needs re-verification on other Audience/Paid/Content surfaces (not re-tested this run).
2. **`.channel-ghost` icon (`<i>`) does not respond to a direct Playwright click** — clicking the icon element registers no state change; the click must target the parent `.channel-ghost` div. Trusted `browser_click` on the wrong node is a silent no-op (no error), which could mask a real regression if not double-checked via DOM class inspection.
3. **Metrics export produces no observable download under Playwright** (Rule 6 gap carried over from the original Chrome-MCP run of this exact ticket). The export endpoint returns plain text with no `Content-Disposition`; whatever client-side code turns this into a saved file leaves no `a[download]`, no blob URL, and fires no `page.on('download')` event. This could genuinely be no-file-saved (bug) or a save mechanism outside Playwright's download-event surface — cannot distinguish without a real user click in a non-automated browser.
4. Duplicate hidden `<table>` calendars (20 `th.prev` matches for what should be 2 visible calendars) required scoping DOM queries to the specific Start/End table elements — consistent with the known "duplicate hidden datepicker" quirk from the TWC builder, now also confirmed present in Brand>Audience.

## Skill updates

`audience-metrics-export` — see `skills/audience-metrics-export/SKILL.md` for the v3 entry documenting:
- Channel-ghost click target must be the parent `.channel-ghost` div, not the inner icon.
- Channel selection on Brand>Audience is exclusive-select (radio-like), not additive — contradicts the v1 assumption ("toggle each channel independently"). Needs a follow-up run on Brand>Paid/Content to confirm whether this is Audience-specific or platform-wide.
- Metrics-export download-capture problem is confirmed unresolved under Playwright (`page.on('download')` never fires); Rule 6 verification remains blocked pending a real-browser check.

## Bugs filed

None. A1 is INCONCLUSIVE per Rule 6, not a confirmed defect — needs a human to click Export → Metrics in a real browser and confirm the Downloads folder outcome before this can be escalated.
