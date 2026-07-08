# QA-43916 — Not Configured Radaac Report — RUN REPORT

- **Run date:** 2026-07-04 (machine clock UTC 2026-07-03; report cache stamped 20260703)
- **Verdict:** **PASS (3/3 in-scope assertions)**
- **Environment:** Playwright MCP (real Chrome), headless/unattended, `feature/playwright-mcp`
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-43916
- **Skill used:** `radaac-report-runner` (v1)
- **Open-bug screen (Rule 7):** "None open" → ran normally.

## Pre-flight
- Logged in via Cognito "With existing account" form (`lfiqa@listenfirstmedia.com` from `config/.env`).
- `app.lfmdev.in/#home` rendered, title "Home - ListenFirst" (account_id=54). PASS.
- `radaac.lfmdev.in` loaded directly, authenticated as `lfiqa@listenfirstmedia.com`, 20-report list — no SSO loop.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Search Radaac for report "Not Configured" | Filter narrowed to 1/20 rows (ID 14, owner Mike). |
| 2 | Click "Not Configured" | jQuery-UI dialog opened; title "Not Configured", description "Weekly Not Configured Report". |
| 3 | Click Account Name dropdown | `select[name=account_name]` in the active form. |
| 4 | Select "Michael Kors" | Visible `account_name` select = "Michael Kors" (verified via DOM; screenshot 01). |
| 5 | Click Submit | Trusted Playwright click navigated to `/not_configured?account_name=Michael+Kors` → "Fetching report" → "File is Ready". No URL-GET workaround needed (matches 2026-06-28 known-quirk). |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | TSV file downloaded after a few seconds | Playwright `download` event fired ~5s after Submit; file on disk 387 bytes (`.playwright-out/20260703NotConfigured-72519b.tsv`). | **PASS** |
| A2 | 5 | File name displays `YYYYMMDDNotConfigured_da6b7c.tsv` | Server-emitted name `20260703NotConfigured_72519b.tsv` — matches pattern `YYYYMMDDNotConfigured_<6hex>.tsv`. Spec hash `da6b7c` is illustrative; hash varies per run (known-quirk). Date prefix `20260703` = cache-generation date. | **PASS** |
| A3 | 5 | Columns: subscriber_id, subscriber_name, brand_id, brand_name, data_profile_dcs_uid, data_profile_channel_type, data_profile_source_type, data_profile_display_name, data_profile_url, authorized_accounts, total_authorized_accounts | All 11 columns present in exact order (header parsed at 11 fields via `awk -F'\t'`). Spec's `brand_id,, brand_name` double-comma is a spec typo. | **PASS** |

## Evidence
- **On-disk file:** `.playwright-out/20260703NotConfigured-72519b.tsv` (server name `20260703NotConfigured_72519b.tsv`; Playwright slugifies `_`→`-` on disk — automation-only, not a product issue).
- **Delimiter:** genuine tab-separated. `awk -F'\t'` → 11 fields; both rows contain tab chars. The 3 commas in the file are inside the `data_profile_display_name` value ("Chiara King: Singer, Musician, Songwriter, Artist"), not delimiters — no CSV→TSV regression.
- **Header (verbatim):**
  `subscriber_id  subscriber_name  brand_id  brand_name  data_profile_dcs_uid  data_profile_channel_type  data_profile_source_type  data_profile_display_name  data_profile_url  authorized_accounts  total_authorized_accounts`
- **Data row (1 row, Michael Kors scoped):**
  `328 | Michael Kors | 427807 | Chiara King | a5c53da196c9da9686d01f30bd33b012 | facebook | page | Chiara King: Singer, Musician, Songwriter, Artist | https://www.facebook.com/MissChiaraKing | (empty) | 0`
- **Screenshots:**
  - `.playwright-out/QA-43916/01-modal-michael-kors.png` — modal with Michael Kors selected.
  - `.playwright-out/QA-43916/02-file-ready.png` — "File is Ready" page with `/cache/20260703NotConfigured_72519b.tsv` link.

## Notes
- Cache-file race did not require a retry this run — a single ~5s wait sufficed; download event fired on its own (page title flipped "Fetching report" → "File is Ready"). Consistent with the 2026-06-28 quirk (Not Configured is a fast GET report).
- Result set: 1 subscriber-scoped row (Michael Kors, subscriber_id 328) — expected for a per-account "not configured" report; `authorized_accounts` empty and `total_authorized_accounts`=0 for the single returned data profile.

## Bugs filed
None. All in-scope assertions passed; no product defect observed.
