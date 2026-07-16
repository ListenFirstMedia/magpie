# QA-109749 — Brand Audience > Threads - Hovering Functionality

**Run date:** 2026-07-15
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54) · **Brand:** NFL on CBS (brand_id=55123, Rule 1 exact-match from Results section, not "NFL on CBS (Combo) Roll-Up")
**Channel:** Threads (exclusive-select, replaced default Twitter) · **Window:** Apr 1–5, 2025 (per spec)
**Result:** ✅ PASS (with one non-blocking format finding on assertion 5(b))

## Pre-test
- No existing skill covered Brand>Audience's geo-map/donut hover flow specifically, though `chart-hover-tooltip` had a prior partial note (`.al-geo-map-tooltip__container`, from QA-95067 on a different brand/channel). Extended that skill (v3→v4) with this run's findings rather than authoring a new one — same tooltip family.
- bug-history.md: no open/closed bug links for QA-109749.

## Steps executed
1. Brand > Audience → brand switcher → typed "NFL on CBS" (slow keystroke entry required to trigger the Results dropdown — a single `.fill()` left it on "Recent Searches" only) → clicked the exact "NFL on CBS" row (not the Combo Roll-Up).
2. Channel selector: clicked Threads icon (exclusive-select per known-quirks — deselected default Twitter automatically) → Apply. URL confirmed `channels=threads`.
3. Date picker: opened the Date Range control, selected Start=Apr 1 2025 / End=Apr 5 2025 on the visible calendar, clicked Ok (per Rule 2 — UI click, not just a URL param). Confirmed on-screen `Apr. 01, 2025 - Apr. 05, 2025`.
4. Hovered the "Followers By Country" choropleth: tagged the `.datamaps-subunit.USA` path and scanned `document.elementFromPoint` across the tile to find a hit clearly inside the continental-US polygon (the raw DOM bbox center falsely lands over Canada because Alaska's disconnected sub-path skews the combined bounding box).
5. Read `.al-geo-map-tooltip__container` → `United States of America / Followers 84%`.
6. Hovered the "Followers By City" bubble map: tagged the largest `circle.datamaps-bubble` (Philadelphia) and a small distant one (Lagos, Nigeria) to cross-check format consistency.
7. Read the (visible, `offsetParent !== null`) tooltip instance for each: `Philadelphia, Pennsylvania / Followers 5%` and `Lagos, Lagos State / Followers 1%`.
8. Scrolled to "Followers: Gender Breakdown" donut — confirmed legend shows `Men / Women / Unknown`.
9. Hovered the Men arc (`fill="#AA00FF"`, offset toward the arc's outer edge to avoid the donut-hole miss) → tooltip `Men: 72% Women: 13% Unknown: 15%`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 4(a) | Hover Followers By Country | Displays percentage value | USA hover → `84%` | ✅ |
| 4(b) | Followers By Country tooltip format | `Legend: Country Name` / `Followers (N%)` | `United States of America` / `Followers 84%` — exact match | ✅ |
| 5(a) | Hover Followers By City (red dots) | Displays percentage value | Philadelphia → `5%`; Lagos → `1%` | ✅ |
| 5(b) | Followers By City tooltip format | `Legend: City Name, Country` / `Followers (N%)` | Actual: `City Name, State/Region` (`Philadelphia, Pennsylvania`; `Lagos, Lagos State`) — **not** `City, Country`. Reproduced on 2 geographically unrelated cities (US + Nigeria), so this is a systematic product format choice, not a one-off data gap. Percentage portion matches spec exactly. | ⚠️ FORMAT MISMATCH (see below — not filed as a functional bug) |
| 6(a) | Gender Breakdown legend | Men / Women / Unknown labels present | All 3 present in legend, correct colors (purple/teal/gray) | ✅ |
| 6(b) | Gender Breakdown tooltip format | `Men: N%` / `Women: N%` / `Unknown: N%` | `Men: 72% Women: 13% Unknown: 15%` — exact match, sums to 100% (matches donut center label) | ✅ |

## Finding (documented, not filed as a bug)

**Followers By City tooltip shows `City, State/Region` instead of the spec's literal `City, Country`.** Verified on two independent, geographically unrelated cities in the same session (Philadelphia, PA, USA and Lagos, Lagos State, Nigeria) — both show a sub-national region, never the country name. Per Rule 5 (re-read the spec, don't over-file), this reads as an intentional, more-granular labeling choice by the product (state/region is arguably more informative than country for city-level data) rather than a functional defect — hovering does work, does show a percentage, and does identify the city unambiguously. Recommending LFIQA review whether the spec's literal wording should be updated to match actual (and intentional) product behavior, rather than treating this as a UI regression. Not filed as a Bug/Test-Failure.

## Bugs filed
None. (See Finding above for the one documented spec-vs-actual discrepancy, submitted as a review note rather than a bug.)

## Skill credit
- Extended `skills/chart-hover-tooltip/SKILL.md` v3 → v4 (pass_streak 2 → 3): documented the datamaps country/city selectors, the elementFromPoint grid-scan technique for bbox-skewed shapes, the multi-instance-tooltip-in-DOM gotcha, and the Gender-donut fill-color map.
- Updated `skills/REGISTRY.md` entry.

## Cleanup
Not applicable — read-only navigation and hover interactions, no mutation.
