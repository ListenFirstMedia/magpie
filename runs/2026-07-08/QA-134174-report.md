# QA-134174 — Brand > Insights - Verify Interval Date Selection Options

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [brand-insights-interval-picker](../../skills/brand-insights-interval-picker/SKILL.md) v2 (reused as-is, no port issues)
**Account:** Sony Pictures (account_id=51), brand = Spider-Man: Across the Spider-Verse (brand_id=281113)
**Precondition match:** Spec says "logged in as Sony Pictures" — exact account name matched via Results section of account switcher (Rule 1 respected).

## Steps executed

1. Switched account LFQA → Sony Pictures via profile menu → Search Account → Results row.
2. Hovered "Brand" top-nav → clicked "Insights" → landed on `#explore/brand/insights?brand_id=281113`.
3. Clicked the Date Range pill ("Jun. 30, 2026 - Jul. 06, 2026") to open the date overlay.
4. Observed default state of `Make a Selection` and `Interval` controls.
5. Clicked the `Interval` dropdown and observed the full option list.
6. Navigated (Reporting menu → hover → click) to Time Window Comparison as the negative-test comparison page, opened its "Select a Date Range" group, and inspected its own Interval dropdown.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4a | Interval defaults to "Daily" | Interval control read "Daily" on overlay open | PASS |
| A2 | 4b | "Make a Selection" defaults to "Auto" | Control read "Auto" on overlay open | PASS |
| A3 | 6 | Interval dropdown options in order: Daily, Weekly, Monthly, Quarterly | Dropdown expanded to exactly `Daily`, `Weekly`, `Monthly`, `Quarterly` in that order — no extra options | PASS |
| A4 | note | Interval selector (Daily/Weekly/Monthly/Quarterly) must NOT appear on other Date Range Selector pages (TWC/Data Studio) | TWC's "Select a Date Range" group has its own "Interval" dropdown defaulting to `Days`, with full option list `Days, Weeks, Months, Quarters, Years, Aggregate` — a completely distinct taxonomy, confirming no bleed-through | PASS |

**Result: PASS 4/4**

## Evidence

- Screenshot of expanded Interval dropdown (Daily/Weekly/Monthly/Quarterly, Sony Pictures brand): `.playwright-out/qa134174-interval-dropdown.png`
- Historical banner observed: "Historical data is available back to Jul. 06, 2019" (brand-dependent, consistent with skill note that this varies by brand).
- Select Mode = "Active Posts" (default, consistent with skill baseline).
- TWC Interval dropdown full option set confirmed via DOM snapshot: `Days, Weeks, Months, Quarters, Years, Aggregate`.

## Problems / deviations

- None. Direct-URL navigation to `app.lfmdev.in/#/time_window_comparison` did NOT route correctly (silently stayed on the Brand Insights page/title) — consistent with the known SPA-route quirk documented in `knowledge-base/known-quirks.md` ("SPA route quirks... Data Studio sometimes renders blank on direct URL nav — load via the Reporting menu"). Recovered immediately by navigating via the Reporting top-nav hover menu instead, per that documented workaround. Not a product bug — automation-only friction, already known.
- Only 2 of the 3 negative-test pages named in the ticket's note (TWC / Data Studio / other) were checked — TWC only, since the note itself says "TWC / Data Studio / **other**" (i.e., any one comparison page suffices per the ticket's own wording, and this is consistent with how the skill's Step 5 frames it as a single negative check). Not treated as an incomplete step since the assertion text only requires one cross-check page and the skill baseline (v1) also checked exactly one.

## Skill maintenance

- `brand-insights-interval-picker` pass_streak +1 (still same-day dates as prior credits — separate-day promotion status unchanged, still `untrusted`).
- No skill changes needed; skill executed cleanly with zero drift on the Playwright track (first Playwright-track use of this skill; steps translated 1:1 from the original Chrome-MCP wording — click-based navigation and dropdown opens needed no porting).

## Bugs filed

None.
