# QA-134271 — Brand Navigation — Data Last Updated: Timestamp — 2026-07-16

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134271
- **Env:** Dev (`app.lfmdev.in`), Playwright MCP track (`feature/playwright-mcp`), headless/unattended
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018), cross-brand check on Michael Kors (brand_id=3801)
- **Skill used:** [`brand-navigation-timestamp`](../../skills/brand-navigation-timestamp/SKILL.md) (v1, untrusted, pass_streak 2 going in)
- **Result:** ✅ **PASS** (10/10 assertions)

## Steps executed (in order, per spec)

1. **Pre-flight:** `browser_navigate` → `https://app.lfmdev.in` → redirected to Cognito hosted UI (`auth.lfmdev.in`). Filled the **"With existing account"** form (Email + Password from `config/.env`) and clicked *that* form's Sign in button (ref `f10e100`, distinct from the Corporate-email form's Sign in button `f10e36`). Landed on `#home?account_id=54`, title "Home - ListenFirst: Home". Pre-flight PASS.
2. **Home:** Read `Data Last Updated (PT): …` header. Captured `T0 = 07-15-2026 04:27 PM`.
3. **Brand sub-tab sweep** (MTV, brand_id=4018, account_id=54, `from=2026-07-08&to=2026-07-14&compare_from=2026-07-01&compare_to=2026-07-07`) — navigated to each of the 6 named surfaces in the spec, in order, and screenshotted the header each time:
   - Brand > Insights
   - Brand > Audience
   - Brand > Content
   - Brand > Channels
   - Brand > Stories
   - Brand > Optimization
4. **F5 refresh:** pressed `F5` on Brand > Optimization (MTV), waited for the header to re-render, re-captured the timestamp.
5. **Brand switch:** clicked the brand-name/chevron control (ref `f24e242`) to open the brand picker, typed "Michael Kors" into the **Search for a Brand** textbox (ref `f24e2776`), and — per Rule 1 — selected the exact-match row from the live **Results** list (`span.option-label` under `.real-list-body`, tagged and clicked via a trusted Playwright click), explicitly avoiding the **Recent Searches** section per the documented quirk. URL changed to `brand_id=3801` (Michael Kors), same `account_id=54`. Re-captured the timestamp.

No steps were skipped; every navigation was a real `browser_navigate`/`browser_click`, not just a URL-param assumption (Rule 3).

## Crash-risk note (known-quirks.md)

The KB flags Brand>Insights/Audience/Video as a Playwright-MCP-server-crash risk (connection drops, all `mcp__playwright__*` tools disappear). This run visited Insights and Audience directly and used only `browser_navigate` + `browser_take_screenshot`/`browser_snapshot` (no `browser_evaluate` immediately after those navigations, per the documented trigger pattern). **No crash occurred** this run — all 6 sub-tab navigations, the F5, and the brand switch completed cleanly.

## Format finding (not a new bug)

The observed string is `Data Last Updated (PT): 07-15-2026 04:27 PM` — **no trailing " PT" suffix** after "PM". Older reports (2026-06-02 through 2026-06-08) recorded a trailing suffix (e.g. `06-04-2026 05:06 AM PT`), but this has already been documented as the established app-wide format since at least **2026-06-30** — see `runs/2026-07-08/QA-111132-report.md` A1 ("'PT' in the label prefix rather than a trailing pipe-separated suffix (established app-wide format, not unique to this page)") and matching captures in `runs/2026-07-01/scratch-snap.md` (06-30) and `runs/2026-07-07/QA-106221-report.md` (07-06). Treated as conforming per that precedent, not filed as a new format regression.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A0 | Pre-flight | Login succeeds, `#home` renders | Logged in, `#home?account_id=54`, title "Home - ListenFirst: Home" | ✅ |
| A1 | 1 — Home | `Data Last Updated (PT): …` header visible | `Data Last Updated (PT): 07-15-2026 04:27 PM` | ✅ |
| A2 | 2 — Brand > Insights | Same value as Home | `07-15-2026 04:27 PM` | ✅ |
| A3 | 3 — Brand > Audience | Same value | `07-15-2026 04:27 PM` | ✅ |
| A4 | 3 — Brand > Content | Same value | `07-15-2026 04:27 PM` | ✅ |
| A5 | 3 — Brand > Channels | Same value | `07-15-2026 04:27 PM` | ✅ |
| A6 | 3 — Brand > Stories | Same value | `07-15-2026 04:27 PM` | ✅ |
| A7 | 3 — Brand > Optimization | Same value | `07-15-2026 04:27 PM` | ✅ |
| A8 | 5 — Brand switch (MTV → Michael Kors) | Value unchanged (account-wide signal, not brand-specific) | `07-15-2026 04:27 PM` (brand_id 4018→3801, account_id=54 unchanged) | ✅ |
| A9 | 4 — F5 refresh | Value persists after reload | `07-15-2026 04:27 PM` unchanged after `F5` on Brand > Optimization | ✅ |
| A10 | Format | `MM-DD-YYYY HH:MM AM/PM` after `(PT):` | `07-15-2026 04:27 PM` matches `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM\|PM)` — see Format finding above re: trailing-PT precedent | ✅ |

## Evidence

Screenshots (full-page header visible, 1600×900 viewport after initial resize) saved under `.playwright-out/QA-134271/`:

- `01-home.png` / `01b-home-wide.png` — Home, `T0 = 07-15-2026 04:27 PM`
- `01-home-snapshot.yml` — accessibility snapshot confirming header node text
- `02-insights.png` — Brand > Insights, matches T0
- `03-audience.png` — Brand > Audience, matches T0
- `04-content.png` — Brand > Content, matches T0
- `05-channels.png` — Brand > Channels, matches T0
- `06-stories.png` — Brand > Stories, matches T0
- `07-optimization.png` — Brand > Optimization, matches T0
- `08-optimization-f5.png` — Brand > Optimization after F5, matches T0
- `09-before-brand-switch-snapshot.yml`, `10-brand-dropdown.png`, `11-brand-search-open.yml`, `12-brand-search-results.yml`, `12b-brand-search-results.png` — brand-picker flow (typed "Michael Kors", Results list surfaced above Recent Searches)
- `13-michael-kors.png` — Michael Kors (brand_id=3801), matches T0

## Bugs filed

_None._ No defects found. The trailing-PT format difference discussed above was investigated and matched existing precedent from `runs/2026-07-08/QA-111132-report.md` (established app-wide format since ~2026-06-30) rather than a new regression — not filed.

## Skill / registry maintenance

- `skills/brand-navigation-timestamp/SKILL.md`: +1 pass (2026-07-16, Playwright MCP), pass_streak 2→3, `last_verified`/`last_passed_run` → 2026-07-16.
- `skills/REGISTRY.md`: row updated with this run's credit.

## Files

- `runs/2026-07-16/QA-134271-report.md` (this report)
- Screenshots/snapshots: `.playwright-out/QA-134271/*`
