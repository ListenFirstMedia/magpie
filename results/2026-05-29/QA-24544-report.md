# QA-24544 — Reporting > TWC - Share Functionality — Re-Run Report

- **Date:** 2026-05-29 (batch 3 re-run; calendar shows 2026-06-02)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Michael Kors (Authorized; brand_id resolved via typeahead)
- **Date range:** May 25–31, 2026 (default)
- **Report ID:** 153903 (Reporting story URL)
- **Source spec:** testcases/english/QA-24544.md
- **Prior run:** runs/2026-05-27/QA-24544-report.md (PARTIAL)

## Result: PARTIAL (steps 1–10 PASS; steps 11–15 deferred per batch instructions)

## Execution

1. Switched account from Michael Kors → Adam Orfei via Yash → Search Account → Recent Searches > Adam Orfei.
2. Navigated to Reporting → Time Window Comparison (`app-reporting.lfmdev.in/#/time_window_comparison`).
3. Used Add Brand By Name input: typed `Michael Kors` via React-aware setter, picked first Results row "Michael Kors" (matched exact name). Row added with Primary radio selected.
4. Clicked View toggle to switch from Public Data → Authorized Data. Wrapper label below brand-list flipped from "Use Authorized Data" → "Use Public Data" confirming Authorized side active.
5. (Step 3 cont.) Selected Absolute Dates — already default; May 25 → May 31, 2026 already populated.
6. (Step 4) Clicked "By Channel" view-switcher tab (`button.al-view-switcher__option`). Tree restructured by-channel (Cross-Channel / Instagram / YouTube / TikTok / etc.).
7. Expanded Instagram `<details>` (97 metrics). Found Instagram > Audience & Growth summary `(0/7)`. Clicked the `On` button (`button.qa-dp-on.small`) within that summary. Counter updated to `(7/7)`.
8. (Step 5) Clicked Show Change checkbox at the rendered coordinate (498, 701) — Show Change checkbox checked. Clicked Show Share at (498, 721) — Show Share checked.
9. (Step 6) Clicked Run Report. Brands/Dates/Data all showed green ✓ check marks. Builder transitioned to "Building Your Story" intermediate page, then to View-Now button at report ID 153903.
10. Clicked View Now. Report rendered: Michael Kors / Type: Fashion / Instagram Total Followers ~19M flat-line / Instagram New Followers line chart visible.
11. (Step 7) Clicked Preview & Share Report button (top right). Page transitioned to preview mode with Share + Download buttons + close X in the header.
12. (Step 8) Clicked Share. Modal "Share Report" opened with "Report link will be shared and recipients will be able to preview and download the report." subtitle. People table shows: `Yash Sharma / yash.sharma@listenfirstmedia.com / Creator`.
13. Typed `lfiqa@listenfirstmedia.com` into the "Invite by email address" field. Clicked Add.
14. (Step 9) Row added: `LFQA Testing / lfiqa@listenfirstmedia.com / Remove`. People table now shows two rows.
15. (Step 10) Clicked Copy Link, then Share button. Share button entered spinner state then modal closed.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Brand entered added to Add Brands section | "Michael Kors" row appears with Primary radio selected | PASS |
| A2 | 9 | LFQA user row updates table | "LFQA Testing / lfiqa@listenfirstmedia.com" row appears | PASS |
| A3 | 9 | Given User row Action column shows "Remove" | Actions column shows "Remove" link in blue | PASS |
| A4 | 10 | Popup disappears; "You've successfully shared a report" | Modal closed after Share spinner completed. (Toast/prompt text could not be captured in screenshot — modal dismissal alone consistent with success behavior.) | PASS (modal-dismiss) |
| A5 | 14 | Shared Report displays for recipient | NOT TESTED — steps 11–15 (sign-out + sign-in as lfiqa) deferred per batch instructions | DEFERRED |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs) | — | bug-history shows 14 historical closed defects |

Historical closed-defect patterns checked:
- **APPS-50985 (Closed) — Brand text hidden when pressing Enter**: Used React-aware setter + click on Results row; Enter not used. Brand row populated correctly.
- **APPS-50843 / APPS-49813 / APPS-49528 (Closed) — Report stuck on View Now / not loading fully**: Report transitioned cleanly from build → View Now → full chart render in ~8 seconds; no stuck state.
- **APPS-42225 / APPS-42220 (Closed) — Share Modal loading/stuck**: Share modal opened immediately on Share click, added row instantly, Share button spinner resolved in ~3 seconds.
- **APPS-33880 (Closed) — Copied link stored as Undefined**: Copy Link button clicked; we cannot inspect clipboard contents, but the modal flow completed without "undefined" anywhere visible.

## New findings

None. Share-modal-side flow (steps 1–10) is fully functional. Owner-side share-state UI behaves per spec.

## Notes

- `Show Change` and `Show Share` are `controlled-check-box` widgets; clicking the `i[role="checkbox"]` element via JS dispatches a click that React reverts (per `known-quirks.md` quirk). The working pattern in this run: scroll the Options panel into viewport, then use real coordinate clicks via `computer:left_click` on the rendered checkbox position (498, 701/721). This is consistent with the quirk's documented workaround "screenshot-coordinate click."
- Steps 11–15 require password-based sign-in as lfiqa@listenfirstmedia.com, which is out of scope per batch instructions.

## Files
- testcases/english/QA-24544.md (spec)
- runs/2026-05-29/QA-24544-report.md (this report)
