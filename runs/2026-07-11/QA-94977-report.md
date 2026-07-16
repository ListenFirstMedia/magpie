# QA-94977 — Brand > Audience - LinkedIn - Metric Export Functionality

- **Run:** 2026-07-11 · unattended/headless (Playwright MCP, `feature/playwright-mcp`)
- **Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756)
- **Surface:** Brand > Audience · **Channel:** LinkedIn only · **Perspective:** Authorized (locked)
- **Window:** 2025-01-01 → 2025-12-31
- **Skill(s) reused:** audience-metrics-export (v2), switch-account (URL-nav), view-perspective-toggle
- **Verdict:** **PASS** (4/4 in-scope assertions; A5 probe APPS-58574 RE-REPRODUCED — cosmetic, non-interfering)

## Known bugs checked (step 2 / step 5)

- **bug-history.md (QA-94977):** APPS-58574 (Bug, Trivial, In Progress) — "Brand Audience - LinkedIn Channel cards misaligned." Prior runs 2026-06-02 / 2026-06-04 batch-6 both PASS with the bug reproduced. Sweep note: *document layout drift, don't fail on it.*
- **Case Probes section:** APPS-58574 (Trivial, In Progress) — listed as the A5 probe.
- **Determination:** APPS-58574 is a cosmetic first-row card-alignment defect on the same surface. It does **not** touch the export menu, the CSV export, or the file content — so per Rule 7 / open-bug-auto-fail it does **not** block the case. It is the designed A5 probe and is reported as RE-REPRODUCED below.
- No other open linked bug found interfering with the export assertions.

## Steps executed

1. Pre-flight login via Cognito "With existing account" form (config/.env) → `app.lfmdev.in/#home` rendered.
2. Navigated directly to Brand > Audience for UCLA with full params (`brand_id=127756&account_id=799&from=2025-01-01&to=2025-12-31&channels=linkedin&perspective=extended`) — page painted on first load (date params present per the Audience-needs-from/to quirk).
3. Confirmed brand/account via breadcrumb ("Account: UCLA") and channel-ghost DOM: **only `linkedin channel-ghost enabled`**; Facebook/X/Instagram/YouTube/Threads all `disabled`. Perspective `#perspective` = `checked:true, disabled:true` → Authorized locked (UCLA LinkedIn Audience has no Public toggle — matches prior runs).
4. Default Basic view loaded; 8 tiles present (Job Function, Industry, Seniority, Staff Count Range, Followers By Country, Followers By Region, Geo Breakdown By Country, Geo Breakdown By Region).
5. Opened the per-tile Export dropdown on **Followers: Job Function** (`#export-button-ba2e7b37-…`). Enumerated options.
6. Selected **CSV**; captured the download via Playwright `download` event; verified the saved file on disk (header + data row + numeric value).
7. A5 probe: DOM-measured first-row card positions to confirm/refute APPS-58574.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1–4 | Brand > Audience LinkedIn page loads | UCLA / LinkedIn-only / Authorized / 8 tiles rendered, no skeleton hang | PASS |
| A2 | 5 | Per-tile Export menu lists Metrics / CSV / GSheets | Menu lists **PNG, CSV, Google Sheets, Metrics** (all spec options present + PNG) | PASS |
| A3 | 6 | CSV export → saved file with reasonable filename | Server filename `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.csv` — matches `<Brand>-Audience-<Metric>-<from>-<to>.csv` | PASS |
| A4 | 6 | Saved file is a real CSV with header + data row(s) | 944 B; 28-col header (`Date, Brand Name, Channel` + 25 `… Share` cols) + 1 data row (`2025-12-31`, `University of California, Los Angeles`, `LinkedIn`, Business Development 13.16%, Education 11.32%, … Purchasing 0.29%) | PASS |
| A5 (probe) | 7 | APPS-58574 LinkedIn card misalignment re-confirmed/refuted via DOM | **RE-REPRODUCED** — see evidence | REPRODUCED |

### Evidence

- **A2 export options** — `.list-item` values under `#export-button-ba2e7b37-…`: `PNG`, `CSV`, `Google Sheets`, `Metrics`. Screenshot `.playwright-out/QA-94977/02-export-menu-open.png`.
- **A3/A4 CSV on disk** — `.playwright-out/University-of-California-Los-Angeles-Audience-Followers-Job-Function-2025-01-01-2025-12-31.csv` (Playwright slugifies `,` and spaces in the local path; the true server filename is in the download event, above). Header row (28 cols) + 1 data row dated 2025-12-31 (meter = last-day value, consistent with prior audience-metrics-export findings). First value Business Development Share = 13.16%.
- **A5 APPS-58574 DOM measurement** (container width 1280px):
  - Row 1: **Job Function alone** — top≈-61 (scrolled), left=10, w=295, `lfm-col-3`.
  - Row 2 (top=339): Industry (left=20), Seniority (left=335), Staff Count Range (left=650) — all w=295, `lfm-col-3`.
  - Four `lfm-col-3` tiles (4×295 = 1180px) fit inside the 1280px container, yet Job Function sits alone on row 1 with a distinct left offset (10 vs 20). Same **1+3** topology as 2026-06-02 batch-1 and 2026-06-04 batch-6. **APPS-58574 RE-REPRODUCED, unchanged.**
- **Full page** — `.playwright-out/QA-94977/01-linkedin-audience-full.png`.

## Scope notes

- **Google Sheets:** present in the Export menu (A2 satisfied) but the GS export flow is **out of scope** on this track (Google 2FA). Not exercised; does not affect the verdict.
- CSV stayed in scope and was verified end-to-end on disk (Rule 6).

## Bugs filed

- None new. **APPS-58574** (existing, Trivial, In Progress) re-reproduced via DOM probe — reported here only, no Jira ticket created (markdown-only per framework).
