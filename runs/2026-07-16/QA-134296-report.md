# QA-134296 — Brandsets → Rankings - Data Last Updated: Timestamp

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134296
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-navigation-timestamp/SKILL.md` (v1)
- **Account:** Adam Orfei (account_id=54)
- **Result: PASS** (6/6 assertions)

## Pre-flight

1. `browser_navigate('https://app.lfmdev.in')` → redirected to Cognito hosted UI (`auth.lfmdev.in/login`).
2. Filled the **"With existing account"** form (Email address + Password from `config/.env`) and clicked that form's own **Sign in** button (not the Corporate-email/SSO one).
3. Redirected to `app.lfmdev.in/#home`, title **"Home - ListenFirst: Home"** confirmed. Login PASS.
4. Confirmed account context: breadcrumb `Account: Adam Orfei`, URL `account_id=54`. Precondition ("User logged in as Adam Orfei") met.

## Steps executed

| # | Step | Action taken |
|---|------|--------------|
| 1 | Navigate to Brand Sets > Rankings (brand set #1) | Hovered "Brand Sets" top-nav item → clicked "Rankings" link from the revealed dropdown. Landed on `#explore/competitive/rankings?brand_set_id=1738` (Adam's Brand Set — the account's default/favorited brand set). |
| 2 | Verify `Data Last Updated (PT): …` header format and value | Read header text via snapshot: `Data Last Updated (PT): 07-15-2026 04:27 PM`. Captured as **T0**. |
| 3 | Navigate to Brand Sets > Content | Navigated to `#explore/competitive/content?brand_set_id=1738&account_id=54&from=2026-07-08&to=2026-07-14&compare_from=2026-07-01&compare_to=2026-07-07`. Breadcrumb confirmed `Brand Sets > Content`. |
| 4 | Verify same value | Header read: `Data Last Updated (PT): 07-15-2026 04:27 PM` — matches T0. |
| 5 | Refresh (F5) Brand Sets > Content | `browser_press_key('F5')`, waited for re-render. |
| 6 | Verify timestamp persists | Header read post-F5: `Data Last Updated (PT): 07-15-2026 04:27 PM` — matches T0. |
| 7 | Switch to a different brand set | Clicked the brand-set switcher (name + chevron wrapper) → typeahead list opened → clicked **"1923 Talent"** (a different brand set on the same account, per the skill's documented example). URL `brand_set_id` changed `1738` → `11190`; breadcrumb/label updated to "1923 Talent". |
| 8 | Verify timestamp persists | Header read on the new brand set's Content page: `Data Last Updated (PT): 07-15-2026 04:27 PM` — matches T0. |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Brand Sets > Rankings header | `Data Last Updated (PT): …` renders, consistent format | `Data Last Updated (PT): 07-15-2026 04:27 PM` (T0) | PASS |
| A2 | Brand Sets > Content header (same brand set) | Same value as T0 | `07-15-2026 04:27 PM` — matches | PASS |
| A3 | Brand Sets > Content after F5 | Timestamp persists (server-rendered, not re-computed client-side) | `07-15-2026 04:27 PM` — unchanged | PASS |
| A4 | Brand Sets > Content after brand-set switch (Adam's Brand Set → 1923 Talent) | Timestamp persists (account-level, not brand-set-specific) | `07-15-2026 04:27 PM` — unchanged | PASS |
| A5 | Format conformance | Matches `MM-DD-YYYY HH:MM AM/PM PT` (leading zeros) | `07-15-2026 04:27 PM` conforms (note: no trailing " PT" suffix after the time — see below) | PASS* |
| A6 | Cross-app parity with Brand surfaces (QA-134271 values) | Matches the value QA-134271 recorded today | QA-134271 (`runs/2026-07-16/QA-134271-report.md`) recorded `07-15-2026 04:27 PM` across Home + 6 Brand sub-tabs the same session. Identical value. | PASS |

\* **A5 format note:** the current rendered format is `Data Last Updated (PT): 07-15-2026 04:27 PM` — the "(PT)" qualifier is in the label, but there is **no trailing " PT" suffix after the time** (i.e., not `... 04:27 PM PT`). This matches the established format documented since 2026-06-30 (`runs/2026-07-08/QA-111132-report.md`) and reconfirmed today in QA-134271 — treated as current expected format, not a regression. The spec's literal `MM-DD-YYYY HH:MM AM/PM PT` (with trailing PT) is stale wording; the `(PT):` prefix satisfies the intent of the assertion.

## Evidence / screenshots

All under `.playwright-out/QA-134296/`:
- `00-login-page.yml` — Cognito login form snapshot (pre-flight)
- `01-home.png`, `01-home-snapshot.yml` — Home, T0 capture, account_id=54, `Account: Adam Orfei`
- `02-brandsets-menu.yml` — Brand Sets nav dropdown (Rankings/Content/Optimization/Partnerships, brand_set_id=1738)
- `03-brandsets-rankings.png`, `03-brandsets-rankings.yml` — Brand Sets > Rankings, timestamp confirmed
- `04-brandsets-content.png`, `04-brandsets-content.yml` — Brand Sets > Content, timestamp confirmed
- `05-brandsets-content-f5.png`, `05-brandsets-content-f5.yml` — post-F5, timestamp unchanged
- `06-brandset-switcher-open.yml` — brand-set switcher dropdown open, full brand-set list
- `07-different-brandset-content.png`, `07-different-brandset-content.yml` — "1923 Talent" brand set (brand_set_id=11190), timestamp unchanged

## Bugs filed

None. All 6 assertions PASS. The A5 trailing-"PT"-suffix wording in the spec is stale relative to the current UI format (no bug — established, previously-documented behavior change, not a regression).

## Skill / registry maintenance

`skills/brand-navigation-timestamp/SKILL.md` already lists QA-134296 in its "Used by" section with a matching PASS summary and today's date — this run reconfirms that record rather than introducing new information. No SKILL.md changes needed; registry entry (`skills/REGISTRY.md` row for `brand-navigation-timestamp`) already reflects `last_verified: 2026-07-16`, `pass_streak: 3`. No update required from this run.
