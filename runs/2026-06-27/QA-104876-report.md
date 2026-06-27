# QA-104876 — Settings > Custom Data Sets - Delete Functionality

- **Run date:** 2026-06-27
- **Environment:** app.lfmdev.in (dev), Playwright MCP / real Chrome, headless unattended
- **Branch:** feature/playwright-mcp
- **Account context:** Amazon Prime Video (account_id=342). The test case names no specific account/brand, so no account switch was required (per account-precondition rule).
- **Skill reused:** `settings-custom-data-sets` v2 (untrusted) — Delete flow + mutating create+delete cycle pattern.
- **Result:** **PASS** (3/3 assertions). No bugs.

## Pre-flight

| Check | Result |
|---|---|
| app.lfmdev.in reachable | OK — redirected to Cognito hosted UI |
| Login via "With existing account" form (lfiqa@listenfirstmedia.com) | OK — clicked the existing-account Sign in (not Corporate/SSO) |
| Home renders | OK — `app.lfmdev.in/#home`, title "Home - ListenFirst" |

## Approach (mutating create+delete cycle — safe testing)

The case requires a deletable Custom Data Set. The account already contained one real CDS — **"Amazon Reporting"** (created by Miranda McWeeney) — which was **not touched**. Per the skill's safe pattern, a uniquely-named throwaway CDS was created, then deleted, leaving the account in its original state (N=1 pre-existing CDS).

## Steps executed

1. Navigated to **Settings > Custom Data Sets** (`/#custom-data-sets`). Listing rendered with columns `Data Set | Created Date | Creator | Metrics | Actions`. One pre-existing row: "Amazon Reporting".
2. **Created** the test CDS: clicked "Create a Custom Data Set" → entered name `QA-104876-test-20260627`, selected metric **Engagements** (Public group) → Create button enabled → clicked Create. Redirected to listing; new row present: `QA-104876-test-20260627 | Jun. 27, 2026 | LFQA Testing | Engagements`. (Evidence: `01-listing-with-test-row.png`)
3. **Identified the target row** (`QA-104876-test-20260627`) and opened its **Actions ellipsis menu**. Menu options rendered in order **Edit / Delete / Duplicate** (matches documented order).
4. Clicked **Delete**. (Step 3-4 of spec)
5. **Confirmation modal** appeared. (Step 5; evidence: `02-delete-confirm-modal.png`)
6. Clicked **Ok**. Row immediately removed from listing — verified via DOM (`testRowPresent: false`; only "Amazon Reporting" CDS row remained). (Step 6)
7. **Hard reload** (`location.reload()`) of `/#custom-data-sets`. Test row still absent — only "Amazon Reporting" present. Deletion is refresh-persistent. (Step 7; evidence: `03-after-delete-refresh.png`)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Delete confirmation modal appears with proper messaging | Modal title **"Delete"**; body verbatim: `Are you absolutely sure you want to delete your data set "QA-104876-test-20260627"?` + `Click "Ok" to continue.`; buttons **Cancel** + **Ok** | PASS |
| A2 | 6 | After confirm, row is removed from table | After Ok, row removed in <2s; DOM confirms only "Amazon Reporting" CDS row remains (`testRowPresent: false`) | PASS |
| A3 | 7 | Refresh-persistent | After hard reload, `QA-104876-test-20260627` still absent; only "Amazon Reporting" listed | PASS |

### Supporting observations (not spec assertions, captured for regression value)

- Actions menu order = **Edit / Delete / Duplicate** (consistent with skill v2 documentation; no regression).
- Confirmation-modal text is **verbatim-consistent** with prior QA-104876 run (2026-06-08) and with the shared Settings-entity confirmation pattern (Custom Metrics QA-135430, Brand Sets QA-110083).
- Create flow: Create button correctly **disabled** until both a name and ≥1 metric are present (re-confirmed; not the focus of this case).

## Evidence

- `.playwright-out/QA-104876-01-listing-with-test-row.png` — listing with the freshly-created test CDS row.
- `.playwright-out/QA-104876-02-delete-confirm-modal.png` — Delete confirmation modal with verbatim messaging.
- `.playwright-out/QA-104876-03-after-delete-refresh.png` — listing after delete + hard reload (test row gone, only "Amazon Reporting").
- Exact post-delete DOM read: `{"cdsRows":["Amazon Reporting Jan. 08, 2026 Miranda McWeeney Engagements, Video Views, Impressions, Comments"],"testRowPresent":false}` (both immediately after Ok and after reload).

## Spec-adherence notes

- **Rule 1 (no brand substitution):** N/A — no brand involved; the throwaway CDS was created by the test, not substituted for a spec-named entity.
- **Rule 2/3 (explicit UI clicks, every step in order):** All steps performed via real UI interaction (menu click, Delete, Ok), not URL params. Persistence verified by an actual `location.reload()`, not by trusting in-memory state.
- **Rule 6 (no proxy claims):** Row removal verified by reading the live DOM after the action and again after a hard reload — not inferred from a network response alone.
- Cleanup: account returned to its original state (1 pre-existing CDS, "Amazon Reporting" untouched). No residual test data.

## Bugs filed

None. All assertions passed; behavior matches spec. (Markdown only — no Jira ticket created.)
