# QA-109920 — Brand > Content - Sentiment Comments limit - Positive Classification Donut - CSV (Batch 8 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109920
- **Run date:** 2026-06-02 (batch 8 re-run)
- **Account:** Amazon Prime Video (account_id=342)
- **Brand:** Amazon Prime Video (brand_id=25864, Public Data perspective)
- **Date range:** Apr. 01, 2025 – Apr. 07, 2025
- **Priority:** Critical (P2)
- **Result:** PASS 2/3 + Reload-needed finding. CSV downloaded end-to-end (6,160 Positive comments). A2 ("2,000 Sample Comments..." message) NOT VERIFIED because Sample Comments tile failed to load — see Finding.

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Brand → Content | OK |
| 2 | Brand picker → typed `Amazon Prime Video` → clicked exact `Amazon Prime Video` from Results (Rule 1) | brand_id=25864 |
| 3 | Date range Apr 01 2025 – Apr 07 2025 | URL `from=2025-04-01&to=2025-04-07` |
| 4 | Sentiment button clicked | `sentiment_mode=true`; Classification donut rendered: Positive 50%, Neutral 36%, Negative 14% |
| 5 | Hover Positive segment of Classification donut | Tooltip popup appeared: "Positive Classification: 50% / Total Comments: 6,233 / Read" |
| 6 | Click Read link | Popup opened titled "Positive Classification: 50%". Sample Comments tile loaded "Loading..." for ~20s then displayed "This tile failed to load. Please try again." Reload retry also failed. |
| 7 | Click Export → CSV | "Sentiment Export Request" modal appeared |
| 8 | Click Ok | Export queued; bell badge 511 → 512 |
| 9 | Bell → "Download file" link in Sentiment Export notification (Jun 02 03:39 am) | CSV downloaded |

## CSV verification

**Filename:** `Amazon Prime Video-Brand Content-2025-04-01-2025-04-07-comments-sentiment.csv` (1,200,885 bytes)

**Total rows:** 6,160 (excluding header)

**All rows classified as Positive:** True (Counter: `{'Positive': 6160}`)

**Column headers:** Comment Date, Comment Day of Week, Comment Time, Comment Channel, Comment Author, Comment Type, Comment Text, Comment Classified, Comment Emotion, Topic 1..Topic 6, Post Link, then per-tag columns (bosch legacy, elle, holland, overcompensating - key art, the bondsman, wheel of time)

**First data row example:** 02/15/2026 Sun 09:38 AM, Instagram, `stereoklasa`, Comment, "I love her", Positive, Love, …, `https://www.instagram.com/reel/DIE8-6RzHCp/`

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Pop-up opens after clicking Read in donut tooltip | Popup with title "Positive Classification: 50%" opened. Donut tooltip itself rendered the Read button after a sustained hover and the click succeeded — a breakthrough vs the previous PARTIAL result. | PASS |
| A2 | Message displays: "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000" | Sample Comments content tile inside the popup remained in Loading state ~20s then rendered "This tile failed to load. Please try again." Reload retry also failed. The spec message did not appear during this run. Not a Recharts-tooltip quirk this time — the popup opened successfully but its inner data-load failed. NOT VERIFIED in this run. | NOT VERIFIED (Reload failure) |
| A3 | CSV export has more than 2000 comments | CSV downloaded 6,160 rows, all classified Positive. 6,160 > 2,000. | PASS |

## Bugs filed
None new. Possible product/data finding (NOT filed as bug yet pending Reload retry on subsequent days): the sample-comments tile inside the donut Read popup fails to load on Amazon Prime Video Apr 01–07 2025 with a "This tile failed to load. Please try again." state that does not recover after Reload. The CSV export pipeline serves the same data (6,160 rows) successfully, suggesting the issue is specific to the in-popup sample-fetch endpoint, not the backend aggregation.

## Skill registry impact
- `chart-hover-tooltip` — PARTIAL → PASS upgrade: the Recharts donut Read-button click is now reachable. Document the fix: sustained hover over the segment center makes the popup appear with a clickable Read button, which opens the modal. The previously documented "Recharts donut tooltips/popups need trusted pointer events" quirk no longer blocks the Read click. Streak +1.
- `brand-content-data-set-selector` — pass_streak +1 (Sentiment-mode donut & CSV export verified)
- `export-csv` v2 — pass_streak +1 (Sentiment Comments export queued + CDN downloaded; filename pattern `Brand-Tab-Start-End-comments-sentiment.csv` documented)

## Sources
- [QA-109920 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-109920)
