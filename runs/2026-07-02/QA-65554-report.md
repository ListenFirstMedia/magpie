# QA-65554 — Settings > Tags - Export Functionality - GS (Google Sheets)

- **Run date:** 2026-07-03 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-65554 · Priority: Minor
- **Result:** **PASS (in-app scope)** — Settings > Tags → Export → **Google Sheets** option present and initiates the GS export. Google-Sheet content assertions (filename, GS headers, page↔GS data-match) are **OUT OF SCOPE** (external Google Sheet behind Google OAuth).
- **App:** `app.lfmdev.in` · **Account:** Adam Orfei (account_id=54) · **User:** lfiqa (current session)
- **Skills:** switch-account (account precondition), (Tags-export in-app flow)

## Linked bug scan
No **open** linked bugs — [[open-bug-auto-fail]] N/A. APPS-58462 "Exported Tags sequence not matching page sequence" (Bug, Minor) is **Closed**; APPS-40042 (Story) and APPS-44217 (QA Task) also Closed. Not reproduced (sequence not evaluated — that's a GS-content concern, OOS here).

## Precondition handling
- Case precondition: "logged in as Adam Orfei." **Adam Orfei is an ACCOUNT** (appears in the account switcher's Recent Searches alongside Hulu/Viacom/Michael Kors), not a user login. Per [[account-precondition]] I switched the active account to **Adam Orfei** via the LFQA menu → account typeahead → Results "Adam Orfei" (account_id=54). Ran as the current lfiqa user (cross-user login is OOS, and the precondition is account-scoped).

## Steps executed
1. Hover **Settings** in the top nav. ✅
2. Click **Tags** → `#tags` (Settings Tags page). ✅ (Switched account to Adam Orfei, reloaded Tags for account 54.)
3. Click **Export** dropdown → options **CSV** and **Google Sheets**; selected **Google Sheets**. ✅ → opened a **Google Accounts sign-in tab** (GS export authorizes sheet creation in Google Drive).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A3 columns (in-app) | 'Tag', 'Date Created', 'Creator', 'Content Tagged' | Tags table shows exactly **Tag / Date Created / Creator / Content Tagged** (+ Actions) — matches | ✅ PASS |
| A3 GS trigger | Export → Google Sheets works | 'Google Sheets' option present in the Export menu; selecting it initiates the export (redirects to Google sign-in to create the sheet) | ✅ PASS |
| A3 filename `Account Name-Tags` | GS file named `Adam Orfei-Tags` | Requires opening the created Google Sheet (behind Google OAuth) | ⏭ OOS (external GS) |
| A3 GS columns | GS has Tag / Date Created / Creator / Content Tagged | Requires the external Google Sheet | ⏭ OOS (external GS) |
| A3 data-match | Page data == GS data | Requires the external Google Sheet | ⏭ OOS (external GS) |

## Evidence
- `qa65554-tags-adamorfei-loaded.png` — Adam Orfei Tags page (40 rows): columns Tag / Date Created / Creator / Content Tagged / Actions; rows e.g. `tag-2`, `tag-1`, `autotag_1783045113700`, `tag-789--988`, `cat`, `style`, `transition`, `test-B`, `tag-1677-1782979401647-251` (Creators: Taruna Kumari, LFQA Testing, Kumar Keshav Kashyap).
- `qa65554-export-open.png` / DOM capture — Export menu with **CSV** and **Google Sheets** options.
- `qa65554-tags-hulu.png` — earlier Hulu Tags view (same column set) captured before the account switch.
- On selecting Google Sheets, a second tab opened at `accounts.google.com/.../signin` (Google OAuth) — closed without authenticating (external/cross-service, OOS).

## Notes / findings
- **GS export = external boundary.** Unlike CSV (in-app direct download) and emailed exports, the Tags "Google Sheets" export hands off to **Google OAuth** to create the sheet in the user's Drive. Verifying the resulting sheet's name/columns/data requires Google authentication + Drive access — out of scope per the emailed/GS-export rule ([[email-export-scope]]) and the external-tool boundary. In-app trigger verified; sheet content not.
- **Account precondition nuance:** "logged in as <PersonName>" in these Tags/Settings cases refers to the **account**, resolved via the account switcher, not a distinct platform user login.

## Bugs filed
None. In-app export flow works; GS-content assertions deferred as OOS.
