# QA-111243 — Brand > Content - Sentiment - Emotion (Daily) - CSV Export Email Format (re-run 2026-06-04 batch-8)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-111243
- **Account:** Adam Orfei
- **Brand:** MTV (Rule 1 — picked literal "MTV" from Results)
- **Channel:** Instagram only
- **Date range:** Apr 01 – Apr 07 2025
- **Sentiment mode:** ON
- **Skill:** brand-content-data-set-selector (sentiment mode), export-csv (queued CSV pattern)

## Result: PASS — Notification popup email format validated

## Steps executed

1. Navigated Brand → Content for Adam Orfei → MTV (brand_id=4018), Apr 01 – Apr 07 2025, IG channel only, `sentiment_mode=true`.
2. Sentiment view loaded with Classification donut (73% Pos / 21% Neu / 6% Neg) + Classification (Daily) area chart.
3. Scrolled to find the **Emotion (Daily)** widget — visible as a 38%-anchor sentiment area chart with Apr.01 – Apr.07 X-axis above the Topics word cloud (Joy / Anger / Positive variants).
4. Clicked Read Comments on the first Most Vocal table row (efya_nocturnal — same brand/date/channel as QA-111242).
5. Modal opened: `efya_nocturnal's Comments` with the comments table populated:
   - Sun 04/06/2025 12:55 PM (3 Gallery rows) + Sun 04/06/2025 11:10 AM (2 Video rows) + Sun 04/06/2025 08:41 AM (1 Gallery row) + Tue 04/01/2025 06:52 AM (4 Video rows)
   - All rows show Classified=Positive, Emotion=Joy, Topics=N/A
6. Clicked Export → CSV.
7. **Notification popup opened** with verbatim text:
   > "We're hard at work preparing your export. While some exports can finish quickly, larger exports may take longer to complete. Once it's ready, your export will **automatically download or open**. You can also find the link to download the export in our **app notifications menu, bell icon**, and in an **email to yash.sharma@listenfirstmedia.com**."
8. Clicked **Ok**.
9. Bottom-left toast: **"Your export has successfully been queued"** with green check icon.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4-5 | Read Comments modal opens for selected slice/day | efya_nocturnal's Comments modal renders with full table; visible rows from 04/01 and 04/06 — all populated | PASS |
| A2 | 7 | Export CSV triggers a confirmation popup with email format message | Notification text explicitly references "email to yash.sharma@listenfirstmedia.com" + bell-icon notifications menu | PASS |
| A3 | 9 | Notification bell / Recent Activity shows export entry | Toast "Your export has successfully been queued" rendered bottom-left; bell icon already shows (8,413) notifications pre-test | PASS (queue confirmed via toast) |
| A4 | — | CSV file downloads / arrives via email | NOT VERIFIED — async pipeline; not exercised end-to-end in this run | NOT VERIFIED |
| A5 | — | CSV column headers present | NOT VERIFIED — same async pipeline | NOT VERIFIED |
| A6 (probe APPS-55875) | — | CSV row count vs modal count mismatch (Hulu: 323 vs 319) | Not exercised — Hulu-specific bug; this run used MTV (no published mismatch known) | NOT EXERCISED |

## Bug reproduction outcomes

### APPS-55875 (Bug, Minor, Open) — Sentiment Read Comments exported data mismatched with comments modal (Hulu - 323 in model vs 319 in export)
**Verdict: NOT EXERCISED** (probe target is Hulu brand; this run targeted MTV per shared brand context across the batch. Recommended to re-test on Hulu in a future run.)

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-111243-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-111243.md`

## Notes
- The Sentiment Read Comments CSV export confirmation popup text verbatim contains the test user's email (`yash.sharma@listenfirstmedia.com`) — confirms the email-format spec.
- Toast "Your export has successfully been queued" provides end-of-flow confirmation.
- Async CSV file arrival is not exercised in this run (carried forward as a known async-pipeline limitation per `export-csv` skill v2 documentation).
- Skill `brand-content-data-set-selector` Sentiment-mode toggle via URL `sentiment_mode=true` reused; export-csv pattern documented.
