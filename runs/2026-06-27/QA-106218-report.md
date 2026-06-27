# QA-106218 — Settings > Custom Data Sets: Create a New Custom Data Set

- **Run date:** 2026-06-27
- **Branch / track:** `feature/playwright-mcp` (Playwright MCP, real Chrome, programmatic Cognito login)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106218
- **Priority:** Blocker (P1)
- **Skill reused:** `settings-custom-data-sets` v2 (create flow + v2 delete-flow for cleanup)
- **Account:** Adam Orfei (account_id=54)
- **Result:** **PASS — 14/14 assertions** (A3/A14 timestamp carries a known, non-blocking format variance)

---

## Pre-flight

| Check | Result |
|-------|--------|
| App reachable | ✅ `https://app.lfmdev.in` redirected to Cognito hosted UI |
| Login (existing-account form, `lfiqa@…`) | ✅ oauth_callback → `#home`, title "Home - ListenFirst" |
| Dashboard renders | ✅ Home rendered, "Data Last Updated (PT): 06-27-2026 05:05 AM" |
| Account precondition (Adam Orfei) | ⚠️→✅ Home showed Adam Orfei, but the **Custom Data Sets page loaded under "Account: Hulu"**. Switched to Adam Orfei via the user (LFQA) menu → Search Account → typed "Adam Orfei" → clicked the exact **Results** match (not Recent Searches), per the switch-account discipline. Re-verified breadcrumb "Account: Adam Orfei" before proceeding. |

---

## Steps executed

| # | Step | Action taken | Outcome |
|---|------|--------------|---------|
| 1 | Hover 'Settings' top nav | Hovered Settings; dropdown opened (hover-triggered) | ✅ dropdown shown |
| 2 | Click 'Custom Data Sets' | Clicked `a[href="#custom-data-sets"]` | ✅ navigated to `/#custom-data-sets` |
| — | (account correction) | Switched account Hulu → Adam Orfei (see pre-flight) | ✅ |
| 3 | Click 'Create a Custom Data Set' | Clicked the (now-enabled) yellow button | ✅ `/#custom-data-sets/create` |
| 4 | Review the page | Captured breadcrumb, header, timestamp, name box, metric-group order | ✅ see A1–A5 |
| 5 | Type a unique name | Typed `QA-106218-20260627-183914` into Data Set Name | ✅ |
| 6 | Public node → Engagements, Reactions, Response Rate | Clicked 3 checkboxes (Public group already expanded) | ✅ all checked, Selected Metrics (3) |
| 7 | Engagements Breakdown → Comments, Shares; Impressions → Engagement Rate, Impressions | Expanded each node, clicked the 4 checkboxes | ✅ all checked, Selected Metrics (7) |
| 8 | Click 'Create' | Clicked Create | ✅ navigated to listing |
| 9 | Review new row | Inspected listing row for name, date, creator, metrics, timestamp | ✅ see A12–A14 |
| — | **Post-test cleanup (not in spec)** | Actions → Delete → confirmation modal → Ok | ✅ row removed (avoids 10-CDS-cap residue) |

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Breadcrumb "Account: Adam Orfei \| Settings > Custom Data Sets > New Custom Data Set" | "Account: Adam Orfei \| Settings > Custom Data Sets > New Custom Data Set" | ✅ PASS |
| A2 | 4 | Header "Create Custom Data Set" below breadcrumb | `<h1>Create Custom Data Set</h1>` rendered below breadcrumb | ✅ PASS |
| A3 | 4 | "Data Last Updated" timestamp `MM-DD-YYYY \| HH:MM AM/PM PT`, non-clickable | "Data Last Updated (PT): 06-27-2026 05:05 AM" — plain `<div>`, not a/​button, cursor:auto (non-clickable) | ✅ PASS (format variance — see note) |
| A4 | 4 | "Data Set Name" box, placeholder "Enter your data set's name", under header | textbox present, placeholder = "Enter your data set's name" | ✅ PASS |
| A5 | 4 | Metric order: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest | Groups rendered in exactly that order (12 groups) | ✅ PASS |
| A6 | 6 | Selected metrics checked + appear in 'Selected Metrics' table | Engagements/Reactions/Response Rate aria-checked=true (fa-check-square); all 3 listed in Selected Metrics table | ✅ PASS |
| A7 | 7 | "Comments, Shares, Engagement Rate, Impressions" have lock icon after name | All 4 rows carry `fas fa-lock` (+ fa-trash remove) in Selected Metrics table | ✅ PASS |
| A8 | 7 | "Engagements, Reactions, Response Rate" have no icons after name | These 3 rows carry only `fas fa-trash` (remove) — no lock icon | ✅ PASS |
| A9 | 7a | Selected Metrics header updates to "Selected Metrics (7)" | Header read "Selected Metrics (7)" | ✅ PASS |
| A10 | 7b | "Data Last Updated" timestamp remains visible while selecting | Timestamp "…06-27-2026 05:05 AM" remained visible throughout selection | ✅ PASS |
| A11 | 8 | Page navigates to Custom Data Set listing table | URL → `/#custom-data-sets`, listing table rendered | ✅ PASS |
| A12 | 8a | Newly created CDS displays in listing | Row "QA-106218-20260627-183914" present | ✅ PASS |
| A13 | 9 | Metrics display in the added order | "Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions" — exact add order | ✅ PASS |
| A14 | 9a | "Data Last Updated" timestamp visible, non-clickable, consistent format | "Data Last Updated (PT): 06-27-2026 05:05 AM" — present, non-clickable, same format as A3 | ✅ PASS (same format variance) |

---

## Evidence (exact numbers / text)

- **Breadcrumb (A1):** `Account: Adam Orfei | Settings > Custom Data Sets > New Custom Data Set`
- **Header (A2):** `Create Custom Data Set`
- **Timestamp (A3/A10/A14):** `Data Last Updated (PT): 06-27-2026 05:05 AM` (DIV, `closest('a,button')` = false, `cursor: auto`)
- **Name box (A4):** placeholder `Enter your data set's name`
- **Metric group order (A5):** Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest
- **Selected Metrics table rows + DCR keys (A6/A7/A8/A9):**
  | Metric | DCR key | Icons |
  |--------|---------|-------|
  | Engagements | `lfm.content.responses_mixed` | fa-trash (no lock) |
  | Reactions | `lfm.content.reactions_mixed` | fa-trash (no lock) |
  | Response Rate | `lfm.content.response_rate_mixed` | fa-trash (no lock) |
  | Comments | `lfm.content.replies_v7_v2` | **fa-lock** + fa-trash |
  | Shares | `lfm.content.reshares_v7` | **fa-lock** + fa-trash |
  | Engagement Rate | `lfm.content.content_engagement_rate_mixed` | **fa-lock** + fa-trash |
  | Impressions | `lfm.content.impressions_v7_v2` | **fa-lock** + fa-trash |
  - Header: `Selected Metrics (7)`
- **Listing row (A12/A13):** `QA-106218-20260627-183914 | Jun. 27, 2026 | LFQA Testing | Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions`
- **Delete confirmation (cleanup):** `Are you absolutely sure you want to delete your data set "QA-106218-20260627-183914"? Click "Ok" to continue.` — buttons Cancel + Ok; row removed after Ok.

### Screenshots (under `.playwright-out/` / repo root)
- `QA-106218-01-create-7-metrics.png` — Create page with all 7 metrics selected (lock icons + "Selected Metrics (7)")
- `QA-106218-02-listing-new-row.png` — Listing table showing the newly created row
- Playwright session snapshots: `.playwright-out/page-2026-06-27T13-*.yml`

---

## Notes / Observations

- **Timestamp format variance (A3, A14) — non-blocking, already documented.** Spec writes `MM-DD-YYYY | HH:MM AM/PM PT` (pipe separator). UI renders `Data Last Updated (PT): 06-27-2026 05:05 AM` — `(PT):` prefix + space separator, PT not trailing. Date portion `MM-DD-YYYY` and time `HH:MM AM` are correct. Same variance recorded in the skill (QA-106218 v1) and in this skill's failure-signature table; functional behavior matches, so assertions are scored PASS.
- **Account drift on Settings surface.** Home loaded under Adam Orfei but the Custom Data Sets page initially loaded under "Account: Hulu" without any account switch on my part. Corrected via the user-menu account search (Results, not Recent Searches). Worth flagging that the Settings > Custom Data Sets entry point did not inherit the home account context — see Bugs filed.
- **No "Success" toast/modal observed on Create.** The skill v1 notes a `Custom data set successfully created!` Ok modal; on this run, clicking Create navigated straight to the listing without a visible success modal. Not a spec assertion (A11 only requires navigation, which occurred) — noted for skill accuracy.
- **Checkbox interaction:** the `controlled-check-box` widgets accepted Playwright's (trusted) clicks directly — no focus+Space workaround needed (that workaround was a Chrome-MCP-synthetic-event limitation; Playwright dispatches real input events).
- **Mutation:** test created 1 CDS and then deleted it (post-test cleanup). Net state change = none; account CDS count returned to pre-run value.

---

## Bugs filed

> Markdown only — no Jira tickets created.

1. **[Minor / candidate] Settings > Custom Data Sets does not inherit the active account context.**
   - **Observed:** With Adam Orfei active on `#home`, navigating Settings → Custom Data Sets rendered the page under "Account: Hulu" (a different account in Recent Searches). Required a manual account switch to reach the spec-required Adam Orfei context.
   - **Impact:** A user who set their account on Home could unknowingly create/view Custom Data Sets under the wrong account. For automated regression, it forced an account-correction step before the precondition was met.
   - **Repro:** Set account = Adam Orfei on Home → hover Settings → click Custom Data Sets → observe breadcrumb account.
   - **Severity:** Minor/UX — needs product confirmation on whether Settings surfaces are intentionally account-independent or should follow the global account selection.

2. **[Doc/spec drift, non-blocking] "Data Last Updated" timestamp format.** Spec `MM-DD-YYYY | HH:MM AM/PM PT` vs UI `Data Last Updated (PT): 06-27-2026 05:05 AM`. Already tracked as a known minor variance in `settings-custom-data-sets`; recommend reconciling spec wording to the shipped format (or vice-versa). Not blocking.

No functional defects found in the Create flow itself — all 14 spec assertions pass.
