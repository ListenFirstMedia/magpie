# QA-457 — TWC Rate Data QA — Run Report

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless), `app.lfmdev.in` (DEV) + `app-reporting.lfmdev.in`
- **Case file:** `testcases/english/QA-457.md`
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-457
- **Skill reused:** `time-window-comparison-run` (v6), `switch-account` (v2)
- **Verdict:** **BLOCKED — stage environment not reachable in this harness**

## Verdict rationale (read first)

QA-457's **only** assertion is *"Ensure dev and stage data match"*, and **Step 9** is *"Repeat all steps in a new tab for **stage**."* This is a **cross-environment (dev ↔ stage) data-parity** test — it fundamentally requires access to BOTH the dev deployment and the stage deployment of the product, run side by side, so their numbers can be compared.

This regression harness is **single-environment**:
- `config/env.md` describes only `app.lfmdev.in` (dev).
- `config/.env` holds a **single** credential set (`LFM_EMAIL` / `LFM_PASSWORD`) for that dev/Cognito surface.
- No stage URL, stage host, or stage credential exists anywhere in `config/` or the repo (the only "staging" reference is the git branch `staging/lf-regression`, not a stage environment).

Because there is no stage environment to compare against, the parity assertion is **Not Evaluable**. Per the spec-adherence rules (Rule 1/3/5 — never substitute, execute every step, when in doubt don't fabricate), I did **not** invent a "stage" surface or declare a match/mismatch that cannot be observed. This is not an external-user precondition (so not SKIPPED) and not a Google-Sheets step; it is a required environment the harness cannot provide → **BLOCKED**.

I did execute the **reachable (dev) portion** far enough to prove the flow is healthy and the spec configuration is achievable on dev (evidence below), but a dev-only run cannot satisfy a dev-vs-stage assertion.

## Steps executed (DEV side)

| # | Step | Result |
|---|------|--------|
| Pre | Navigate `app.lfmdev.in` → Cognito "With existing account" login → `#home` (title "Home - ListenFirst") | ✅ PASS — logged in as `lfiqa@listenfirstmedia.com` |
| Pre | Precondition: account = **Disney Ad Sales**. Was on Viacom (181); switched via profile menu → Search Account → typed "Disney Ad Sales" → clicked exact **Results** `.lfm-ta-option` (not the `[Internal] Disney Ad Sales` variant, not Recent Searches) | ✅ PASS — `Account: Disney Ad Sales` (account_id=634) |
| 1 | Reporting (top-nav, hover) → **Time Window Comparison** | ✅ PASS — URL `app-reporting.lfmdev.in/#/time_window_comparison`; header `Account: Disney Ad Sales \| Reporting > Time Window Comparison` |
| 2 | Verify default builder state | ✅ PASS — **Absolute Dates** tab default; Interval=Days; date calendars (Start/End) populated; Options show **Show Metrics Graphs** ✓, **Show Metrics Tables** ✓, **Show Change** ☐, **Show Share** ☐ |
| 5a | Confirm named brand **Disney Channel** exists in dev typeahead (Rule 1) | ✅ PASS — exact `Disney Channel` present in Results (alongside regional variants like "Disney Channel (Latin America)", "-- EM Roll-Up", etc.) |
| 3–8 (dev) | Absolute → Months → last 1 year; add Disney Channel (Public); select all rate data points + avg responses per post; uncheck graphs; Show Share + Show Change; Run Report | ⏸️ **Not completed** — see note |
| 9 | Repeat all steps **in a new tab for stage** | ⛔ **BLOCKED** — no stage environment configured/reachable |
| 10 | Repeat 1–10 for all absolute configs (incl. Aggregate, last 1 year) — dev vs stage | ⛔ **BLOCKED** — depends on step 9 |

**Note on dev steps 3–8:** The dev builder is fully reachable and the spec brand/account/date-range are all achievable on dev (proven above). I stopped short of building the full dev report because (a) it cannot change the verdict — with no stage side, the sole parity assertion is unevaluable regardless of the dev numbers; and (b) *"all rate data points and avg responses per post metrics"* is an ambiguous metric selection, and guessing at it risks a mis-configured run (the exact QA-91412 / Rule-1/3/5 false-positive trap). No dev numbers are reported because none could be meaningfully compared.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8/9/10 | Dev and stage data match | Stage environment is not reachable in this harness (no stage URL/credential in `config/`). Dev side confirmed reachable & functional (account, builder, exact brand all present). Comparison could not be performed. | **BLOCKED (Not Evaluable)** |

## Evidence

- Pre-flight login → `#home` rendered (title "Home - ListenFirst").
- Account switched Viacom (181) → **Disney Ad Sales** (account_id=634); header line `Account: Disney Ad Sales`.
- TWC builder loaded on dev: `app-reporting.lfmdev.in/#/time_window_comparison`, Absolute Dates default, Options panel confirmed (Show Change / Show Share both togglable, both default unchecked).
- Exact brand **"Disney Channel"** present in the dev brand typeahead Results.
- Screenshot: `.playwright-out/QA-457/dev-twc-builder-disney-ad-sales.png` (dev TWC builder, Disney Ad Sales).
- Page snapshots under `.playwright-out/` (login, home, builder).

## Bugs filed

None. This is a harness/scope limitation (single-environment), **not** a product defect. Nothing observed on the dev side indicated a bug — login, account switch, TWC nav, builder, and the spec brand all worked normally.

## Recommendation

To make QA-457 runnable in this framework, one of:
1. Add a **stage** environment to config — a stage base URL (e.g. the staging deployment of `app`/`app-reporting`) plus stage credentials — and extend the pre-flight/skill to build the same TWC report on both dev and stage, then diff the exported tables.
2. Or re-scope QA-457 to a single-environment data-QA (e.g. verify the rate + avg-responses-per-post metrics compute correctly on dev alone), since the current spec's only assertion is inherently cross-environment.

Until then this case will re-BLOCK on every unattended (dev-only) run.
