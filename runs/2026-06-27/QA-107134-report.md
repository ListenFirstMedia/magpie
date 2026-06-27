# QA-107134 — Settings > Audit - Deep Linking

- **Run date:** 2026-06-27
- **Environment:** Playwright MCP (real Chrome), `feature/playwright-mcp`, headless/unattended
- **App:** https://app.lfmdev.in
- **Account:** Adam Orfei (`account_id=54`) — default account on login; spec preconditions only require "user logged in", so no switch needed
- **Skill reused:** `settings-audit-logs` v2 (untrusted) — Deep Linking section (QA-107134) + APPS-54603 same-tab-replace failure signature
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-107134
- **Verdict:** **PASS** (A1, A2 pass; A3 probe reproduces APPS-54603 as expected)

---

## Pre-flight

| Check | Result |
|-------|--------|
| App reachable | ✅ `app.lfmdev.in` redirected to Cognito hosted UI |
| Programmatic login | ✅ Filled "With existing account" form (Email + Password from `config/.env`), clicked that form's Sign in button |
| Dashboard renders | ✅ Landed on `app.lfmdev.in/#home`, title "Home - ListenFirst: Home" (not stuck on `auth.lfmdev.in`) |

---

## Steps executed

All five spec steps performed in order via real UI interaction (Rule 3). Navigation to Audit was done through the **Settings dropdown → Audit** menu link, not a hand-built URL (Rule 2 / UI-navigation discipline). The filter was applied by clicking the actual filter control and value checkbox, not by URL injection.

### Step 1 — Settings → Audit
- Clicked top-nav **Settings** → **Audit**. URL resolved to `#audit` then auto-populated a default date window: `from=2026-06-21&to=2026-06-27&compare_from=2026-06-14&compare_to=2026-06-20`.
- Title became "Settings Audit - ListenFirst: Audit". Table loaded with 348 visible activity rows (unfiltered).

### Step 2 — Apply a filter, then capture the full URL
- Opened the **Filter** dropdown (`.tag-filter-dropdown`), chose **Activity**, checked **Brand Set Created** (state confirmed via `i.fa-check-square`), clicked **Apply Filter**.
- Table re-fetched → **17 rows, all `Brand Set Created`**. Filter pill rendered as `Activity: Brand Set Created`.
- **Captured URL (origin):**
  ```
  https://app.lfmdev.in/#audit?account_id=54&from=2026-06-21&to=2026-06-27&compare_from=2026-06-14&compare_to=2026-06-20&filters=%257B%2522activity%2522%253A%255B%257B%2522values%2522%253A%255B%2522Brand%2520Set%2520Created%2522%255D%252C%2522not%2522%253Afalse%252C%2522operator%2522%253A%2522or%2522%257D%255D%257D
  ```
  Decoded `filters`: `{"activity":[{"values":["Brand Set Created"],"not":false,"operator":"or"}]}`
- Evidence: `.playwright-out/QA-107134-01-origin-filtered.png`

### Step 3 — Open the captured URL in a NEW tab
- Opened tab index 1 with the exact captured URL; waited for full load (~240 console init entries = fresh page bootstrap).

### Step 4 — Verify fresh-tab state matches captured state
- Account: **Adam Orfei** (`account_id=54`) ✅
- Date Range chip: **Jun. 21, 2026 - Jun. 27, 2026** ✅ (matches origin)
- Filter pill: **Activity: Brand Set Created** ✅
- Decoded `filters` param: identical to origin ✅
- Rows: **17, all `Brand Set Created`**, first/last rows identical to origin (e.g. `Thu Jun. 25, 2026 04:22 PM PDT … Brand Set qa_new 68998 06/25/22/16 was created.`) ✅
- Evidence: `.playwright-out/QA-107134-02-freshtab-deeplink.png`

### Step 5 — Replace URL in the SAME tab (APPS-54603 probe)
- In the **same** tab (index 1, already-loaded app context), navigated to a URL with **both** a different date range and a different filter:
  ```
  …#audit?account_id=54&from=2026-06-01&to=2026-06-10&compare_from=2026-05-22&compare_to=2026-05-31&filters=<User Created>
  ```
  Decoded `filters`: `{"activity":[{"values":["User Created"],"not":false,"operator":"or"}]}`
- Hash-only change was handled **in place** by the SPA router (only ~8 new console entries, no full bootstrap) — exactly the same-tab-replace condition the bug describes.
- **Observed: UI did NOT update.** URL bar showed the new params, but:
  - Date Range chip still **Jun. 21, 2026 - Jun. 27, 2026** (old)
  - Filter pill still **Activity: Brand Set Created** (old)
  - Rows still **17 × Brand Set Created**, newest Jun 25 / oldest Jun 22 = still the old window (new window Jun 1–10 would have returned different data)
- Evidence: `.playwright-out/QA-107134-03-sametab-replace-stuck.png`

### Step 5 control — same new URL in a FRESH tab (proves URL validity)
- Opened tab index 2 with the **same** new URL used in the same-tab replace.
- Loaded correctly: Date Range **Jun. 01, 2026 - Jun. 10, 2026**, filter **Activity: User Created**, **38 rows all `User Created`** (e.g. `Tue Jun. 09, 2026 04:02 PM PDT … User Steven Arellanes was created.`), dates Jun 1–9.
- Confirms the URL itself is valid; only the **same-tab replace** path fails to re-apply state. Reproduction of APPS-54603 is airtight.
- Evidence: `.playwright-out/QA-107134-04-freshtab-newparams-control.png`

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3–4 | Deep-link URL in fresh tab loads Audit page with same date range / filters | Fresh tab loaded with Date Range Jun 21–27 2026 + filter `Activity: Brand Set Created` + 17 matching rows — identical to origin | **PASS** |
| A2 | 3–4 | All deep-link parameters (account, date range, filters) preserved | `account_id=54` (Adam Orfei), date range chip, and decoded `filters` JSON all preserved verbatim in fresh tab | **PASS** |
| A3 (probe) | 5 | APPS-54603 — when replacing URL in same tab, parameters may not be applied | Same-tab URL replace left UI stuck on the **old** date range AND old filter; URL bar updated but neither date range nor filter took effect. Same URL works in a fresh tab. | **APPS-54603 REPRODUCED** (broader scope — see Bugs) |

---

## Evidence summary

- **Origin (filtered):** date range `Jun. 21, 2026 - Jun. 27, 2026`, filter `Activity: Brand Set Created`, 17 rows.
- **Fresh-tab deep link:** byte-identical URL → identical chip/pill/rows (A1, A2).
- **Same-tab replace:** URL → `from=2026-06-01&to=2026-06-10` + `User Created`; UI remained `Jun 21–27` + `Brand Set Created` + 17 rows (A3).
- **Fresh-tab control of new URL:** `Jun. 01, 2026 - Jun. 10, 2026` + `User Created` + 38 rows — proves URL validity.
- Screenshots (under `.playwright-out/`):
  - `QA-107134-01-origin-filtered.png`
  - `QA-107134-02-freshtab-deeplink.png`
  - `QA-107134-03-sametab-replace-stuck.png`
  - `QA-107134-04-freshtab-newparams-control.png`

---

## Spec-adherence notes

- **Rule 1 (no brand substitution):** N/A — this is a Settings>Audit deep-linking test, no brand typeahead involved.
- **Rule 2 (explicit UI interaction, not URL params):** Audit reached via Settings menu link; filter applied by clicking the value checkbox + Apply Filter, confirmed via screenshot and DOM state (`fa-check-square`). URL params were used only where the spec explicitly requires it — i.e. the deep-link paste in Steps 3 & 5.
- **Rule 3 (every step in order):** all 5 steps executed; baseline captured before each assertion.
- **Rule 6 (no download/export claims):** N/A — no export in this flow.

---

## Bugs filed

> Markdown only — no Jira tickets created.

### APPS-54603 (existing, Minor) — REPRODUCED, broader scope than ticket text
- **Original description:** "Global Deep Linking issue when replacing URL on current page; pasted URL not updated with selected parameters **except date range**."
- **Observed this run (2026-06-27):** Replacing the Audit URL in the **same tab** updated neither the **filter** nor the **date range** — both stayed pinned to the pre-replace state (`Jun 21–27` + `Brand Set Created`), despite the address bar showing `from=2026-06-01&to=2026-06-10` + `User Created`. This is **broader** than the ticket, which implies the date range still updates. Matches the `settings-audit-logs` v2 finding (2026-06-04) that "both filters AND date range fail."
- **Control:** The identical replacement URL loads correctly in a **fresh tab** (38 `User Created` rows, `Jun 1–10` window), so the deep-link parser and the URL are valid — the defect is specifically in the in-place (same-tab) re-route not re-reading params.
- **Recommendation:** Update APPS-54603 to note the date-range param is also affected on same-tab replace; the SPA route handler should re-apply `from`/`to`/`compare_*`/`filters` on hash change, not just on initial page bootstrap.

### No new defects
- Fresh-tab deep linking (the primary feature under test) works correctly for both filter and date range params. A1/A2 pass cleanly; no new bug to file.

---

## Notes for KB / registry

- Consistent with the 2026-06-13 known-quirk that the Audit deep-link entity link opens a new tab; that is a separate concern from APPS-54603 and was not exercised here.
- `settings-audit-logs` v2 Deep Linking section held up exactly: fresh-tab deep link preserves Date Range + Activity pill; same-tab replace reproduces APPS-54603. Eligible for a pass-streak bump (separate-day pass: prior 2026-06-08 / 2026-06-04, now 2026-06-27).
