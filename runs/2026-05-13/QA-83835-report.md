# QA-83835 — Reporting > Data Studio - Historical limit

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-83835
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id 54)
- **Brand:** MTV
- **Metric:** Facebook Total Fans
- **Result:** ✅ **3/3 PASS**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3) | End date auto-adjusts based on start date, max 365 days | Start = Mar 1, 2025 → right calendar jumped to Mar 2026 and end auto-set to Mar 1, 2026 (= exactly 365 days) | ✅ |
| A2 (4) | Start date auto-adjusts based on end date, max 365 days | End changed to May 15, 2026 → left calendar jumped to May 2025 and start auto-set to May 15, 2025 (= exactly 365 days) | ✅ |
| A3 (10) | Data displays for selected range | Report `report_id=290892` loaded; Facebook Total Fans chart shows ~45M flat line for MTV from ~May 15, 2025 to May 15, 2026 with x-axis showing May, Jun, Jul, … Apr, May labels | ✅ |

## Proof — A1 (start drives end)

Selected start = March 1, 2025. Before click, end was May 17, 2026 (~440 days). After click:
- Right (end) calendar advanced from May 2026 → March 2026.
- End date was set to **March 1, 2026** (highlighted) — exactly start + 365.

## Proof — A2 (end drives start)

Selected end = May 15, 2026. Before click, start was March 1, 2025 (~440 days). After click:
- Left (start) calendar advanced from March 2025 → May 2025.
- Start date was set to **May 15, 2025** (highlighted) — exactly end − 365.

## Proof — A3

After committing the 365-day range (May 15, 2025 → May 15, 2026), adding MTV Authorized + selecting Followers → Total Followers → Facebook Total Fans, and clicking Go, the report rendered with a Line chart titled "Facebook Total Fans" for the MTV brand across the full year. URL: `…/data_studio?account_id=54&report_id=290892`.

## Skill use
- Reused `data-studio-post-level-run` skill primitives for navigation. Added a new mini-pattern for the Custom date constraint (documented in `data-studio-historical-limit` skill below).

## Bugs filed
None.
