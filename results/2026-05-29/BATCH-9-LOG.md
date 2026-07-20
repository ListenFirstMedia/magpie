# Batch 9 log — 2026-06-02

| Ticket | Account / Brand | Skill(s) | Result |
|---|---|---|---|
| QA-129803 | Wasserman / FIA WEC | response-rate-math-verifier + time-window-comparison-run | PASS 5/5 — Facebook RR exclusion verified Sep 26-29 `–`, Sep 30-Oct 3 formula matches UI to rounding (0.10/0.43/0.19/0.18%). Filter Metrics input surfaces lazy-loaded FB-prefixed leaves. View toggle disabled on FIA WEC. |
| QA-130076 | Viacom (explored) → Adam Orfei (verified) | (none) | PASS 4/4 — lost-auth message format matches spec verbatim on multiple Adam Orfei rows. Viacom has 0 Not Collecting notifications even after Subscriptions > Data Collection toggle enabled — spec amendment recommended. |
| QA-131491 | Adam Orfei / MTV | social-recap-report-run + brand-content-data-set-selector | PASS 4/4 — IG Reel "Look how this girl…" Video Views = 691,822 match on Social Recap BPC card AND Brand>Content Post #1. brand_id=10765 = canonical MTV on Adam Orfei. |
| QA-131492 | Adam Orfei / MTV | social-recap-report-run + brand-content-data-set-selector | PASS 2/2 — YouTube card "Lights, Camera, Debate w/ Tom Blyth & Emily Bader" Video Views = 67,332 match on Social Recap BPC AND Brand>Content Post #1 (sole YT post that week). |
| QA-1519 | Hulu | brand-content-data-set-selector + export-csv + export-google-sheets | PASS 8/8 — both Engagements Breakdown CSV (15,520 bytes) and Clicks CSV (12,893 bytes) verified end-to-end on disk; columns match spec; GS export delivers real Google Sheet with matching tab title. Filename uses canonical ISO date pattern. |

## Quirk lifecycle changes
- Recharts donut quirk RESOLVED previously (batch 8) — not retested.
- Social Recap Week interval auto-spans 7 days starting at the picked date — useful pattern documented.
- TWC date-picker async JS-fallback `th.prev[N].click()` (with `await setTimeout(150)`) needed because DOM re-renders on every click (re-querying without await was a no-op). Documented for future TWC runs.

## Skill registry impact

| Skill | Streak before → after | Notes |
|---|---|---|
| switch-account | 11 → 12 | Wasserman → Viacom → Adam Orfei → Hulu — 3 switches across 5 tickets. |
| time-window-comparison-run | 12 → 13 | FB metrics via Filter Metrics input + controlled-check-box .click(). |
| response-rate-math-verifier | 1 → 2 | Second real PASS — Facebook variant. |
| social-recap-report-run | 5 → 7 | Both IG (QA-131491) and YouTube (QA-131492) BPC card capture from shared story 153956. |
| brand-content-data-set-selector | 13 → 16 | QA-131491 IG-only, QA-131492 YT-only, QA-1519 EB+Clicks data set switches all clean. |
| export-csv v2 | 16 → 17 | QA-1519 EB+Clicks CSVs verified end-to-end on disk. |
| export-google-sheets v2 | 4 → 5 | QA-1519 GS toggle delivers real Google Sheet — confirmed by tab title. |

## Bug finds

- None NEW. Documented finding: spec/UI sync deviation on QA-1519 filename pattern (ISO `YYYY-MM-DD` vs spec `YYYYMMDD`, lowercase `posts` vs spec `Posts`) — platform canonical, not a defect.

## Chrome MCP state for batch 10

- Two MCP tabs: 1804437678 parked at Hulu Brand>Content with Clicks data set; 1804437687 holding the Google Sheets export from QA-1519.
- Account context: Hulu (last switch). Bell at (3) export notifications.
- Downloads inspected for verification: 2 Hulu Brand Content CSVs (EB + Clicks).
- No pending modals; export queue clean.
