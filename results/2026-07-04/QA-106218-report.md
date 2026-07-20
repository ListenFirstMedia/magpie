# QA-106218 — Settings > Custom Data Sets: Create a New Custom Data Set

- **Run:** 2026-07-04 (headless, unattended, Playwright MCP track / `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106218
- **Priority:** Blocker (P1)
- **Skill used:** `settings-custom-data-sets` (v3, stable) — Create flow + v2 Delete flow (self-clean)
- **Account:** Adam Orfei (account_id=54) — switched via user-menu → Search Account → Results row (Settings surface loaded under "Sony Pictures"; see known-quirks 2026-06-27)
- **Open-bug screen:** "None open. Screen only — run normally." → ran normally
- **VERDICT: PASS (14/14)** — with the long-documented A3/A14 timestamp-format minor variance (non-blocking)

## Steps executed

| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito existing-account form, lfiqa) → `#home` "Home - ListenFirst" | OK |
| pre | Switch account to Adam Orfei (breadcrumb was "Sony Pictures" on the Settings surface) | OK, breadcrumb → "Account: Adam Orfei" |
| 1 | Hover 'Settings' in top nav | Dropdown opened (14 items incl. Custom Data Sets) |
| 2 | Click 'Custom Data Sets' | Loaded `#custom-data-sets` listing (5 existing CDS, limit 10) |
| 3 | Click 'Create a Custom Data Set' | Loaded `#custom-data-sets/create`; Create button disabled |
| 4 | Review the page | A1–A5 verified (see table) |
| 5 | Type unique Data Set Name | Entered `QA-106218-run-2026-07-04` |
| 6 | Public node → Engagements, Reactions, Response Rate | 3 checked → Selected Metrics (3) |
| 7 | Engagements Breakdown → Comments, Shares; Impressions → Engagement Rate, Impressions | 7 total → Selected Metrics (7) |
| 8 | Click 'Create' | Navigated to `#custom-data-sets` listing |
| 9 | Review newly created row | A12–A14 verified |
| post | Self-clean: Actions → Delete → Ok | Row removed; listing back to 5 (matches QA-106218 self-clean pattern) |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Breadcrumb "Account: Adam Orfei \| Settings > Custom Data Sets > New Custom Data Set" | "Account: Adam Orfei \| Settings > Custom Data Sets > New Custom Data Set" | PASS |
| A2 | 4 | Header "Create Custom Data Set" below breadcrumb | `<h1>Create Custom Data Set` present | PASS |
| A3 | 4 | "Data Last Updated" timestamp, format "MM-DD-YYYY \| HH:MM AM/PM PT", non-clickable | "Data Last Updated (PT): 07-03-2026 04:29 PM" — non-clickable (`closest('a,button')`=null) | PASS* |
| A4 | 4 | "Data Set Name" box, placeholder "Enter your data set's name" | Textbox with that exact placeholder | PASS |
| A5 | 4 | Metrics order: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest | Exact same 12 nodes in that order | PASS |
| A6 | 6 | Selected metrics checked + appear in 'Selected Metrics' table | Engagements/Reactions/Response Rate all `[checked]`; Selected Metrics (3) rows 1–3 | PASS |
| A7 | 7 | "Comments, Shares, Engagement Rate, Impressions" have lock icon after name | All four carry `<i class="fas fa-lock">` (DOM probe) | PASS |
| A8 | 7 | "Engagements, Reactions, Response Rate" have no icons after name | All three: `icons: []` (DOM probe) | PASS |
| A9 | 7a | Selected Metrics header → "Selected Metrics (7)" | Header reads "Selected Metrics (7)" | PASS |
| A10 | 7b | "Data Last Updated" timestamp remains visible while selecting | Still present ("Data Last Updated (PT): 07-03-2026 04:29 PM") | PASS |
| A11 | 8 | Page navigates to Custom Data Set listing table | URL → `#custom-data-sets`, listing table rendered | PASS |
| A12 | 8a | Newly created data set displays in listing | Row "QA-106218-run-2026-07-04", Jul. 04, 2026, LFQA Testing present | PASS |
| A13 | 9 | Metrics displaying in the added order | "Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions" (exact add order) | PASS |
| A14 | 9a | "Data Last Updated" timestamp remains visible, non-clickable, consistent format | Same timestamp, non-clickable, consistent | PASS* |

\* **A3/A14 minor variance (non-blocking, pre-documented):** spec writes the pipe form `MM-DD-YYYY | HH:MM AM/PM PT`; the UI renders `Data Last Updated (PT): 07-03-2026 04:29 PM` (space separator, `(PT):` prefix). Functional behavior — timestamp present, correct MM-DD-YYYY + HH:MM AM/PM PT parts, non-clickable — matches. Same variance noted in `settings-custom-data-sets` failure-signature table and prior QA-106218 runs.

## Evidence

- **Metrics build (Selected Metrics 7 + lock icons):** `.playwright-out/QA-106218/07-metrics-selected.png`
- **Listing with new row:** `.playwright-out/QA-106218/09-listing-new-row.png`
- **A7/A8 lock-icon DOM probe** (per-row):
  - 1 Engagements — no icons; 2 Reactions — no icons; 3 Response Rate — no icons
  - 4 Comments — `fas fa-lock`; 5 Shares — `fas fa-lock`; 6 Engagement Rate — `fas fa-lock`; 7 Impressions — `fas fa-lock`
- **DCR keys captured** (Selected Metrics table): Engagements `lfm.content.responses_mixed`, Reactions `lfm.content.reactions_mixed`, Response Rate `lfm.content.response_rate_mixed`, Comments `lfm.content.replies_v7_v2`, Shares `lfm.content.reshares_v7`, Engagement Rate `lfm.content.content_engagement_rate_mixed`, Impressions `lfm.content.impressions_v7_v2`
- **Delete confirmation modal (verbatim):** `Are you absolutely sure you want to delete your data set "QA-106218-run-2026-07-04"? Click "Ok" to continue.` — Cancel + Ok. Post-Ok: row removed, listing back to 5 rows.
- **Actions menu order:** Edit / Delete / Duplicate (matches skill).
- **No success toast/modal on Create** — navigation to the listing is the only confirmation (consistent with the v3 skill note; non-blocking, A11 is nav-only).

## Notes

- Mutating test: created CDS `QA-106218-run-2026-07-04` then deleted it (self-clean). No net change to Adam Orfei's Custom Data Sets (5 rows before and after).
- Account context did not inherit from `#home`; Custom Data Sets loaded under "Sony Pictures" and required an explicit switch to Adam Orfei — reconfirms the 2026-06-27 known-quirk. Treated as a precondition step, not a failure.
- Console showed errors/warnings during SPA navigation (unrelated app/telemetry noise); no functional impact on the flow.

## Bugs filed

None. All in-scope assertions passed. The A3/A14 pipe-vs-space timestamp difference is a pre-documented cosmetic spec-vs-UI variance, not a defect (see `settings-custom-data-sets` failure-signature table). No new bugs to file.
