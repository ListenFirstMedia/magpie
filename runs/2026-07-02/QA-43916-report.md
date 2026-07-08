# QA-43916 — Not Configured Radaac Report

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-43916 · Priority: Minor
- **Result:** **PASS** — TSV downloaded with the correct filename pattern and exact column set. (Filename-separator note below was later found to be a download-tool artifact — no real discrepancy; see QA-51425.)
- **App:** Dev Radaac (`radaac.lfmdev.in`) · **Account:** Michael Kors

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Setup note (NEW — Radaac access)
Radaac is a **separate OAuth client** (`client_id=6ep4l754u2dglosjdqggbt2mjr`) on the same Cognito realm (`auth.lfmdev.in`); the LFM-app session does NOT SSO into it — navigating to `radaac.lfmdev.in` redirects to the hosted sign-in. Logged in with the configured `LFM_EMAIL`/`LFM_PASSWORD` (`lfiqa@listenfirstmedia.com`) via the **"With existing account"** form (fields `input[name=username]` + `input[name=password]`, then that form's Sign in). Session then holds for Radaac.

## Steps executed
1. Radaac report list → located **Not Configured** (report #14). ✅
2. Clicked it → modal "Not Configured". ✅
3–4. **Account Name** `<select>` (152 options) → selected **Michael Kors**. ✅
5. **Submit** → navigated to `/not_configured?account_name=Michael+Kors` and downloaded the TSV. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5-download | TSV file downloads after a few seconds | `20260703NotConfigured-72519b.tsv` downloaded to `.playwright-out/` | ✅ PASS |
| A5-filename | `YYYYMMDDNotConfigured_<hash>.tsv` | Server filename `20260703NotConfigured_72519b.tsv` (date + `NotConfigured` + **underscore** + hash `72519b` + `.tsv`) ✓ — saved locally as `...-72519b.tsv` (Playwright sanitizes `_`→`-`). Matches spec. | ✅ PASS |
| A5-columns | subscriber_id, subscriber_name, brand_id, brand_name, data_profile_dcs_uid, data_profile_channel_type, data_profile_source_type, data_profile_display_name, data_profile_url, authorized_accounts, total_authorized_accounts | Header has **all 11 columns in that exact order** | ✅ PASS |

## Evidence
- `.playwright-out/20260703NotConfigured-72519b.tsv` — header matches; sample row: `328  Michael Kors  427807  Chiara King  a5c53da1…  facebook  page  Chiara King: …  https://www.facebook.com/MissChiaraKing  (blank)  0`.
- `qa43916-radaac.png` (report list), `qa43916-ncform.png` (Not Configured modal with Account Name select).

## Notes / findings
- **Filename separator (CORRECTED via QA-51425):** the Radaac **server** filename uses an **underscore** (`NotConfigured_72519b.tsv`), matching the spec. The hyphen seen in `.playwright-out/` (`...-72519b.tsv`) is the Playwright MCP **sanitizing `_`→`-` in the saved local path** — a download-tool artifact, NOT app behavior. No real discrepancy; full PASS.
- Radaac login procedure documented above (candidate for a `radaac-login` / `radaac-report` skill if more Radaac cases are run — e.g. QA-51425).

## Bugs filed
None. Assertions passed (filename-separator nuance noted).
