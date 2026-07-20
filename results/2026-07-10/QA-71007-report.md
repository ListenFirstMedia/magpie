# QA-71007 — Brand Content - CSV - Select Data Sets Popup and Notification View

**Run date:** 2026-07-10
**Account:** Disney Ad Sales (auto-landed on favorite brand Disney Channel, brand_id=3877)
**Result: FAIL** — backend defect blocks the flow before the export/notification assertions can be evaluated.

## Steps executed
1. Logged in (see pre-flight note below — first login attempt hit a transient Cognito `PreAuthentication` 400; retry succeeded).
2. Brand (top nav, hover) → Content. Landed directly on Disney Channel (account favorite), matching precondition.
3. Data Set dropdown → selected **Impressions** (`table_data_set=impressions` confirmed in URL).
4. Content table showed **"This table failed to load. Please try again."** Clicked Reload — same failure persisted.
5. Clicked **Export** → "Export Select Data Sets" modal opened. **CSV** confirmed default in the View toggle (A1 evidence).
6. Checked the **Impressions** checkbox in the data-set list (verified via DOM: icon class flipped `far fa-square` → `fas fa-check-square`) and clicked **Ok**.
7. Export button entered a persistent loading-spinner state (`content-export-loading` class, `fa-spin lf-spinner` child) that **never resolved**, even after a full page reload and ~50s of additional waiting.
8. Opened the Notifications bell repeatedly — no new "Select Data Sets Export ... Disney Channel ... is now ready" entry ever appeared for this request (only stale entries from prior sessions/date ranges were present).

## Root cause found (network evidence)
`GET https://data-api.lfmdev.in/content?...&data_set=DataSetContentLfm...` → **HTTP 500**
```json
{"error_code":500,"details":{"error_type":"BiQuerier::Error::InvalidQuery",
 "error":"ERROR:  permission denied for relation lgcy_movies\n"}}
```
`GET https://data-api.lfmdev.in/content/analysis?...` → **HTTP 422** (same query, same underlying content-fetch path).

This is a **database-permission bug**, not automation/test-data friction: the backend query planner for Brand>Content (Impressions data set, Disney Channel, Jul 02–08 2026, 6-channel selection) attempts to join/read a Postgres relation `lgcy_movies` that the app's DB role does not have permission on. Both the on-page table render and the async CSV export reuse this same content-fetch code path, so both fail identically. The export request appears to be silently dropped server-side after the 500 (no error toast shown to the user, no notification-bell entry, button stuck spinning indefinitely) — that silent-hang UX is itself worth a follow-up ticket even setting aside the underlying permission error.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Select Data Sets Export notification shows date + "is now ready. Download file." text for Disney Channel | Never generated — export request hung server-side (500 on the underlying content query) | **FAIL** |
| A2 | "Download file" text is blue hyperlinked | N/A — no notification ever appeared to inspect | **BLOCKED** (upstream failure) |
| A3 | CSV file is downloaded | No file — Playwright `download` event never fired | **FAIL** |

## Bugs filed
- **NEW (this run):** Brand > Content Impressions data-set query fails with `permission denied for relation lgcy_movies` (Postgres permission error), returning 500/422 from `data-api.lfmdev.in`, for Disney Channel (brand_id=3877) — breaks both the in-page table render and the CSV export pipeline (export hangs indefinitely with no user-facing error and no notification). Recommend filing as a **Major/Critical** backend defect (DB role missing SELECT on `lgcy_movies`) against the dsp-api release deployed 2026-07-10 09:40 (`releases/20260710094058` per the stack trace).

## Notes / quirks observed
- First login attempt of the session failed with a transient Cognito `PreAuthentication` 400 (`Unexpected token '<'... is not valid JSON`) — immediate retry with identical credentials succeeded. Logged as a new known-quirk candidate (see knowledge-base update).
- The "Public Data" toggle click via `getByText('Public Data')` did not change `perspective` in the URL or fire a new content request — the text label is not the actual clickable toggle target; needs the real toggle-switch element (consistent with the `view-perspective-toggle` skill's Rule 2 guidance). Not chased further since it wasn't material to this ticket's assertions.
- Recent Activity notification panel does not appear to refresh live — repeated opens across a 90s+ window and a full page reload all showed the same stale list, consistent with the export never having produced a completion event server-side (rather than a client-side refresh bug).
