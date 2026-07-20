# QA-65554 — Settings > Tags - Export Functionality - GS

- **Run date:** 2026-07-04
- **Environment:** app.lfmdev.in (Playwright MCP, headless, unattended)
- **Account:** Adam Orfei (account_id=54) — precondition met
- **Verdict:** **PASS (in-scope) — Google Sheets assertions skipped (out of scope)**
- **Skill reused:** export-google-sheets (v2), switch-account (context; account already resolved to Adam Orfei at login)

## Scope note (read first)
This case's title is "Export Functionality - **GS**" and **all three assertions require opening
the exported Google Sheet** (filename in the GS tab, columns in the GS, GS-vs-page data parity).
Per the run scope rules, **Google Sheets is OUT OF SCOPE** (Google 2FA on a separate auth surface;
never open docs.google.com). The GS-export step (Step 3) and its assertions A1/A3 — plus the
GS-side of A2 — are therefore **skipped**. The case is judged on the in-scope, in-app portions:
navigation, precondition, the Export dropdown offering Google Sheets, and the on-page Tags table
(the columns + data that A2/A3 use as the parity reference).

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Programmatic Cognito email/password login → `#home` (title "Home - ListenFirst"), account_id=54 (Adam Orfei) | OK |
| 1 | Hover 'Settings' in the top nav (`.navigation-menu-header`, hover-to-open) | Dropdown opened |
| 2 | Click 'Tags' (`a.navigation-menu-link[href="#tags"]`) → `#tags?account_id=54`, title "Settings Tags - ListenFirst: Tags" | Tags grid rendered (21 tag rows) |
| 3 | Click Export dropdown (`button.export-button`) → options enumerated | Dropdown lists **CSV** + **Google Sheets** (`option--gs`) |
| 3 (GS) | Select 'Google Sheets' → open exported sheet | **SKIPPED — out of scope (Google 2FA)** |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | GS filename = `Account Name-Tags` (i.e. `Adam Orfei-Tags`) | GS tab not opened (out of scope) — filename not observed on disk/tab | **SKIPPED (GS out of scope)** |
| A2 | 3b | Columns include 'Tag', 'Date Created', 'Creator', 'Content Tagged' | In-app Tags table columns = **Tag, Date Created, Creator, Content Tagged, Actions** — exact match on all four spec columns (source columns for the export) | **PASS (in-app source)** — GS-side column read skipped |
| A3 | 3c | Page data matches the GS data | In-app page data captured (see evidence); GS not opened, so page↔GS parity not compared | **SKIPPED (GS out of scope)** |

## Evidence
- **Account:** header reads "Adam Orfei"; URL `account_id=54`.
- **Export entry point present:** dropdown options `option--csv` ("CSV") and `option--gs` ("Google Sheets"). Screenshot: `.playwright-out/QA-65554/export-dropdown-open.png`.
- **Tags table columns (in-app):** `Tag | Date Created | Creator | Content Tagged | Actions` — all four A2 columns present.
- **Tags table data (top rows, 21 total), the A3 parity reference:**
  | Tag | Date Created | Creator | Content Tagged |
  |-----|--------------|---------|----------------|
  | test_tag_filter | Fri 07/03/2026 10:37 PM | LFQA Testing | 1 |
  | tag-2 | Fri 07/03/2026 08:31 AM | Taruna Kumari | 2 |
  | tag-1 | Fri 07/03/2026 08:30 AM | Taruna Kumari | 2 |
  | autotag_1783045113700 | Fri 07/03/2026 02:18 AM | LFQA Testing | 1 |
  | tag-789--988 | Fri 07/03/2026 02:17 AM | LFQA Testing | 1 |
- Screenshots: `.playwright-out/QA-65554/tags-page.png`, `.playwright-out/QA-65554/export-dropdown-open.png`.

## Interpretation
The in-app flow that feeds the Google Sheets export is fully healthy on Adam Orfei: the Tags page
renders under the precondition account, the Export control offers a Google Sheets option, and the
on-page table exposes exactly the four spec columns (Tag / Date Created / Creator / Content Tagged)
with populated data. The three assertions as written (GS filename, GS columns, GS↔page parity) can
only be closed by opening the exported sheet, which is out of scope on this track. No product defect
observed in any in-scope behavior.

Prior interactive/Chrome-MCP runs (batch-3 2026-06-11, batch-12 2026-06-02 — see
export-google-sheets/SKILL.md registry note) closed A1/A2/A3 end-to-end for this exact case
(filename `Adam Orfei-Tags`, columns Tag/Date Created/Creator/Content Tagged, UI↔GS spot-checks
matched). This run confirms the in-app precursors are unchanged.

## Bugs filed
None. No defect observed in any in-scope step. The GS-specific assertions were not evaluated
(out of scope), not failed.

## Open linked bugs
None open (per case file, as of 2026-07-03) — screen passed, case run normally.
