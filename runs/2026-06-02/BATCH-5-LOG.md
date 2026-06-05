# QA-4325 Batch 5 — Run Log (2026-06-04)

Members 16-20 of QA-4325.

## Per-ticket result

| # | QA-ID | Title | Result | Notes |
|---|---|---|---|---|
| 16 | QA-52778 | Brand definition update - Include URL Manager | PARTIAL (A1 PASS, A2 **FAIL FINDING**, A3 PASS, A4-A7 NOT VERIFIED) | NEW bug BC-5: Include URL Managers checkbox has no effect on Fetch xlsx (40-col schema identical with/without the option, no `url managers` column). MUTATING Patch+Apply withheld per `mutating: POTENTIALLY` precaution. |
| 17 | QA-54202 | Brand Listing Radaac Report with Filter options | PASS (4/4) | Title Category dropdown enumerates 50 active categories; Automotive filter produces 1,279 single-category rows; filename pattern `brands_YYYYMMDD-HHMM.tsv` matches; columns brand_id/brand_name/created_at/updated_at/tc_title/tc_display verbatim. |
| 18 | QA-72455 | Brand>Paid Unauthorized Spend Metrics — Twitter | BLOCKED | Requires login as External account `testing@drylogics.com` (Analyst No Spend role); Cowork prohibits assistant password entry. Documented BLOCKED with credentials-blocked carry-forward. |
| 19 | QA-81494 | Data Studio Report Table PNG Export | PASS (8/8) | Food Network + Disney Channel, Fan Growth Rate + FB/YT Engagements, Days interval; PNG saved as `Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png` (101,392 bytes) and verified end-to-end on disk for filename + LISTENFIRST header + Fan Growth Rate title + Legend (Food Network + Disney Channel) + footer + X-axis dates + Y-axis rate values. |
| 20 | QA-83928 | Brand>Paid CSV Select Channels & Data Sets Export notification view | PARTIAL | Steps 1-5 executed (Modal Export Select Data Sets opened, Facebook Engagements/Rates/Video Views/Cost/Delivery all checked, CSV view, Ok clicked). Steps 6-9 BLOCKED on Brand>Paid tile-fetch + Export queue degradation (all 12 tiles "failed to load", Export button stuck in spinner, fresh Michael Kors notification never landed). Notification format shape verified by analogy against the prior `All Data Sets Export` notification visible in Recent Activity panel. |

## New bugs / findings (filed in this batch's reports)

| Source | Bug | Severity | Status |
|---|---|---|---|
| QA-52778 A2 | BC-5: `Include URL Managers` checkbox has no effect on Fetch xlsx output (40-col schema unchanged) | Critical (matches QA-52778 priority) | Filed in QA-52778 report; recommend LFMP defect |
| QA-83928 carry-forward | Brand>Paid Michael Kors tile fetch + Export queue stuck on Adam Orfei dev today 2026-06-04 — all 12 tiles render "This tile failed to load. Please try again."; Export button spinner persists 35+ sec without surfacing error toast or notification | Major | Carry-forward finding; appears server-side flaky/degraded today |

## Chrome state for batch 6

- Active browser: "Work Browser" (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5)
- Latest tab in MCP tab group: 1804438020 (last URL: `radaac.lfmdev.in/`)
- Account: Adam Orfei (account_id=54), user yash.sharma@listenfirstmedia.com
- Tab group rotated mid-batch due to a frozen-Brand-Insights tab from the session start; recommend fresh tab close + create at start of batch 6
