# QA-24544 — Reporting > TWC - Share Functionality — Run Report

- **Run date:** 2026-07-04 (executed 2026-07-03 21:29–21:39 PT)
- **Environment:** Playwright MCP, headless, real Chrome, `app.lfmdev.in` / `app-reporting.lfmdev.in`
- **Login identity (config/.env):** `lfiqa@listenfirstmedia.com` ("LFQA Testing")
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Michael Kors (exact typeahead Results match, Rule 1)
- **Skill reused:** `time-window-comparison-run` (v6) + `switch-account` (v2) + `view-perspective-toggle` (v2)
- **Report built:** story id **155549** — `#story/time_window_comparison/155549`, window **Jun 26, 2026 – Jul 2, 2026**
- **Open-bug screen (Rule 7):** case file "Open linked bugs" = **None open** → ran normally.

## Verdict

**PASS** — all in-scope evaluable assertions pass (A1, A5).
**A2/A3/A4 are NOT EVALUABLE** because the config/.env login identity (`lfiqa@listenfirstmedia.com`)
**equals** the spec share recipient (step 8) → **self-share**. The platform's duplicate-share guard
("You've already shared this with lfiqa@listenfirstmedia.com") is **correct product behavior**, not a
bug — do not substitute a different recipient (Rule 1/5). This reproduces the documented
2026-06-29 known-quirk for QA-24544 exactly.

## Steps executed (all 15, in order)

| # | Step | Result |
|---|------|--------|
| pre | Login as lfiqa via Cognito "With existing account" form → `#home` | OK (title "Home - ListenFirst") |
| pre | Switch account Viacom → **Adam Orfei** (profile menu → Search Account → Results → `.lfm-ta-option`) | OK (account_id=54) |
| 1 | Reporting (hover) → Time Window Comparison | OK — URL `#/time_window_comparison`, header "Account: Adam Orfei \| Reporting > Time Window Comparison" |
| 2 | Add brand by name → "Michael Kors" → pick exact **Results** match | OK — Michael Kors row added |
| 3 | Change perspective to **Authorized**; Absolute date | OK — clicked toggle switch `label[for="0-perspective-toggle"]`, `checked=false→true`; Absolute Dates tab `--selected` (default) |
| 4 | By Channel → Instagram → **All On** in Audience & Growth | OK — IG Audience & Growth `( 7 / 7 )`, Instagram `( 7 / 99 )` |
| 5 | Select **Show Change**, **Show Share** options | OK — both `aria-checked=true` |
| 6 | Run Report | OK — story 155549, chart + table rendered |
| 7 | Preview & Share Report → Share | OK — Share Report modal opened |
| 8 | Email row → type `lfiqa@listenfirstmedia.com` | OK — typed into "Invite by email address" input |
| 9 | Add | Guard fired: **"You've already shared this with lfiqa@listenfirstmedia.com"**; no new People row (only Creator) |
| 10 | Copy Link + Share | Copy Link captured `https://app-reporting.lfmdev.in/#story/155549`; modal **Share** button `crud-modal-button accept inactive share-button` → click **inert** (modal stayed open, no toast) |
| 11 | Sign out current user | OK — redirected to `auth.lfmdev.in/login` |
| 12 | Sign in as `lfiqa@listenfirstmedia.com` (pwd Testing@123) | OK — oauth_callback → `#home` |
| 13 | Log into Adam Orfei account | OK — re-login landed on Adam Orfei (sticky last-active, account_id=54) |
| 14 | Paste copied URL | OK — `#story/155549` redirected to `#story/time_window_comparison/155549`; **shared report re-rendered** (Michael Kors, Jun 26–Jul 2 2026) |
| 15 | Sign out current user | OK — redirected to `auth.lfmdev.in/login` |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Brand entered is added in "Add Brands" section | "Michael Kors" row present with per-brand View: Public/Authorized toggle | **PASS** |
| A2 | 9 | Given user name + email row updates in the People table | No new row — self-share guard "You've already shared this with lfiqa@…" ; table shows only **Creator** row (LFQA Testing / lfiqa@listenfirstmedia.com) | **NOT EVALUABLE** (recipient == logged-in creator) |
| A3 | 9 | Given user row Action column displays "Remove" | No recipient row exists; Creator row Action = "Creator" | **NOT EVALUABLE** (depends on A2) |
| A4 | 10 | Pop-up disappears; "You've successfully shared a report" | Modal **Share** button is `inactive`; click inert → modal stayed open, no success toast | **NOT EVALUABLE** (self-share; button inactive) |
| A5 | 14 | Shared Report displays | Copied link re-rendered the TWC report post-auth (Michael Kors, same window, chart + table) | **PASS** (caveat: viewer == creator, so does not prove cross-user access) |

## Evidence

- Numbers/text captured:
  - Report window: `Time Window Comparison (Jun 26, 2026 - Jul 2, 2026)`; brand "Michael Kors", Type: Fashion; Instagram Total Followers ~19M line.
  - Perspective toggle `#0-perspective-toggle` flipped `false → true` (Authorized) via switch label click (Rule 2 — not URL).
  - Step 9 guard banner (verbatim): **"You've already shared this with lfiqa@listenfirstmedia.com"**.
  - Step 10 copied link (via `navigator.clipboard.writeText` hook): `https://app-reporting.lfmdev.in/#story/155549`.
  - Modal Share button class at step 10: `crud-modal-button accept inactive share-button`.
- Screenshots (`.playwright-out/QA-24544/`):
  - `step3-authorized-toggle.png` — Authorized perspective set on Michael Kors row.
  - `step6-report-built.png` — built TWC report (story 155549).
  - `step7-preview-share.png` — Preview view with Share/Download.
  - `step8-share-modal.png` — Share Report modal, People table shows only Creator row.
  - `step9-already-shared-guard.png` — duplicate-share guard banner; only Creator row.
  - `step14-shared-report-rendered.png` — shared link re-rendered report after sign-out/sign-in.

## Scope / rule notes

- **Rule 1 (brand):** used exact "Michael Kors" typeahead Results option (not a family variant).
- **Rule 2/3 (toggle):** perspective set by clicking the actual switch and confirming `checked=true`; no URL params.
- **Rule 6:** no download/export claims made (share flow only).
- **Self-share (known-quirk 2026-06-29):** config/.env login `lfiqa@…` == spec recipient → A2/A3/A4 not evaluable by design. This run executed the full 15-step end-to-end path (incl. sign-out → sign-in → re-nav), so **A5 passes literally**; the cross-user access aspect remains unverifiable on this identity.

## Bugs filed

None. The step-9 duplicate/self-share guard and the inactive Share button are correct product
behavior for a self-share (recipient == creator), consistent with the documented 2026-06-29
known-quirk. No product defect observed.
