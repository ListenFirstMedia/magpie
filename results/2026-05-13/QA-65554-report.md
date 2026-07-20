# QA-65554 — Settings > Tags - Export Functionality - GS

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-65554
- **Run date:** 2026-05-20
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Priority:** P4 (Minor)
- **Result:** ✅ **UI verified 3/3 PASS in dev; file content deferred to LFIQA** (per Rule 6)

## Steps executed
| Step | Action | State |
|---|---|---|
| 1 | Hover Settings (top nav) | ✓ |
| 2 | Click 'Tags' from Settings dropdown | ✓ — URL `/#tags?account_id=54` |
| 3 | Click Export dropdown → Select "Google Sheets" | ✓ — export fired, opens in user's main Chrome window (outside MCP tab group, per `export-google-sheets` skill v2) |

## Assertion results (UI side, dev)

| ID | Step | Expected | Actual (UI) | Status |
|---|---|---|---|---|
| A1 | 3a | Filename = `Account Name-Tags` | Expected `Adam Orfei-Tags` (Account header = "Adam Orfei") — actual filename in opened GS tab not visible from MCP; **defer to LFIQA** | ⏸ DEFERRED |
| A2 | 3b | Columns: 'Tag', 'Date Created', 'Creator', 'Content Tagged' | All 4 columns confirmed in UI: Tag, Date Created, Creator, Content Tagged (Actions column also present in UI but not part of export spec) | ✅ PASS (UI) |
| A3 | 3c | Page data matches GS data | Sample rows visible in UI: `tag-63558-29 \| Wed 05/20/2026 12:02 PM \| LFQA Testing \| 1`; `zz-inspect-c-62178 \| Wed 05/20/2026 11:54 AM \| LFQA Testing \| 1`; `workout \| Wed 05/20/2026 11:48 AM \| Sasikumar Drylogics \| 1`; `tag-1436-752 \| Wed 05/20/2026 05:47 AM \| LFQA Testing \| 2`. **GS comparison deferred to LFIQA** | ⏸ DEFERRED |

## UI snapshot of first 10 tags (for cross-check vs GS)

| Tag | Date Created | Creator | Content Tagged |
|---|---|---|---|
| tag-63558-29 | Wed 05/20/2026 12:02 PM | LFQA Testing | 1 |
| zz-inspect-c-62178 | Wed 05/20/2026 11:54 AM | LFQA Testing | 1 |
| zz-inspect-b-62178 | Wed 05/20/2026 11:54 AM | LFQA Testing | 1 |
| zz-inspect-a-62178 | Wed 05/20/2026 11:54 AM | LFQA Testing | 1 |
| workout | Wed 05/20/2026 11:48 AM | Sasikumar Drylogics | 1 |
| inspect-tag-4454 | Wed 05/20/2026 10:43 AM | LFQA Testing | 1 |
| tag-63558-398 | Wed 05/20/2026 06:25 AM | LFQA Testing | 1 |
| qa_11605_testing_2026-05-18 | Wed 05/20/2026 06:24 AM | LFQA Testing | 1 |
| tag-63558-885 | Wed 05/20/2026 06:06 AM | LFQA Testing | 1 |
| tag-1436-752 | Wed 05/20/2026 05:47 AM | LFQA Testing | 2 |

## LFIQA follow-up requested
Please check the Google Sheets tab that opened. Verify:
1. **Filename** is exactly `Adam Orfei-Tags`
2. **Header row** contains: Tag, Date Created, Creator, Content Tagged (any order)
3. **First few rows** match the table above

## Skill use
- `export-google-sheets` v2 — confirms cross-tab caveat: GS opens in user's main Chrome window, not MCP tab group

## Bugs filed
None.
