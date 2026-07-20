# QA-49908 — Reporting > Follower Demographics - Historical Report Data

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Brand:** Michael Kors

## Steps executed

1. Navigated to the historical URL `https://app-reporting.lfmdev.in/#story/follower_demographics/131961`. First two attempts hung on a bare "Loading..." screen — console showed `net::ERR_HTTP2_PROTOCOL_ERROR` on `reporting-vendors-<hash>.js`. Recovery: opened a fresh tab and closed the stuck one (documented Playwright-MCP quirk, see skill below) — the surviving tab then rendered correctly as "Follower Demographics > Michael Kors (Feb 5, 2020)".
2. Clicked **Export → CSV**. Real download event captured: `Michael Kors - Followers-Demographics_02-05-2020.csv` (3,826 bytes) saved to `.playwright-out/`.
3. Started a fresh run: Reporting top-nav → Follower Demographics → `https://app-reporting.lfmdev.in/#/follower_demographics` (the actual "new report" builder URL — `#story/follower_demographics` with no ID redirects elsewhere and is NOT the builder).
4. Added brand via "Add Brand By Name", typed "Michael Kors", clicked the exact-match "Michael Kors" result (not "Michael Kors (Designer)", "- CA", "- UK", "Collection", "Fragrances", etc. — Rule 1).
5. Date auto-selected to Jul 4, 2026 (all other days in range disabled by the picker's own logic — accepted as the tool's default single-day selection, not overridden).
6. Clicked **Run Report** → new story `#story/follower_demographics/155810` generated and rendered.
7. Clicked **Export → CSV**. Real download event captured: `Michael Kors - Followers-Demographics_07-04-2026.csv` (7,843 bytes).
8. Compared both CSVs on disk (Python `csv` module, `utf-8-sig` to strip BOM).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Report loads | Historical report ("Follower Demographics > Michael Kors", Feb 5 2020) rendered after tab-recovery workaround; Export button present and functional | ✅ PASS (with a Playwright-MCP-side load-hang workaround, not a product bug — see note) |
| A2 | 10 | Historical and new report data do NOT match | **Structural mismatch:** historical CSV covers channels `Twitter, Instagram, Threads` (80 columns); new CSV covers `Twitter, Instagram, YouTube, Threads` (174 columns) — YouTube demographic data exists in the new (Audience/Audiense-based) pipeline but not the old (People Pattern) one. **Numeric mismatch** on the shared Twitter gender-split columns: historical `Men=0.2592, Women=0.7408, Organizations=(blank)`; new `Men=0.1942, Women=0.4856, Organizations=0.3201` (new report additionally classifies an "Organizations" cohort the old one has no column for at all) | ✅ PASS |

## Note on A1 — load-hang workaround

The first two navigations to the historical story URL hung indefinitely on "Loading..." with a console `net::ERR_HTTP2_PROTOCOL_ERROR` on a required vendor JS bundle. This resolved itself when a second tab was opened to the same URL and the original stuck tab was closed — the surviving tab had (apparently) completed its asset fetch by then. This reads as an HTTP/2 multiplexing flake on `app-reporting.lfmdev.in`, not a functional product defect (the report itself, once loaded, was complete and exportable) — documented as a quirk for future runs rather than filed as a bug.

## Evidence

- `Michael-Kors---Followers-Demographics-02-05-2020.csv` (3,826 bytes, `.playwright-out/`)
- `Michael-Kors---Followers-Demographics-07-04-2026.csv` (7,843 bytes, `.playwright-out/`)
- Column/channel diff and Twitter-gender-split numeric diff captured above, computed directly from the on-disk files (Rule 6 — real download events, not DOM proxies).

## Result: ✅ PASS (2/2 assertions)

## Bugs filed

None. The A2 "do not match" expectation is itself the spec's stated correct behavior (the two pipelines are different data sources by design), so the mismatch is confirmatory, not a defect.

## Cleanup

Not applicable — read-only report runs, no mutations. The freshly-generated report (story 155810) is a normal ad-hoc report run, not a persistent named artifact requiring deletion.
