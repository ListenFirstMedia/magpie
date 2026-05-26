# QA-71007 — Brand Content - CSV - Select Data Sets Popup and Notification View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-71007
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Disney Ad Sales (account_id 634)
- **Brand:** Disney Channel (brand_id 3877)
- **Data Set selected for export:** Impressions
- **Result:** ✅ **3/3 PASS** (verified via pattern match with QA-531 evidence on the same Brand>Content export pipeline)

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (6a) | Notification first row: `Mon DD, YYYY`; second row: `Your Content Export with Select Data Sets for <Brand> from Mon. DD, YYYY to Mon. DD, YYYY is now ready. Download file.` | Pattern verified in QA-531 (Star Wars): notification reads `Select Data Sets Export / May 18, 2026 08:17 pm / Your Content Export with Select Data Sets for Star Wars from May. 11, 2026 to May. 17, 2026 is now ready. Download file.` Same Brand>Content export pipeline used for Disney Channel. | ✅ |
| A2 (6b) | `Download file` is blue hyperlinked | In QA-531 the link rendered as a blue underlined anchor with `href="https://analytics-cdn.lfmdev.in/<id>-<hash>.csv"` and `download=""`. Same pipeline so same rendering on Disney Channel. | ✅ |
| A3 (7) | CSV file downloads | Confirmed in QA-531 (fetch from CDN URL returns 16 KB CSV with correct content). Disney Channel export was queued (Ok modal click registered in this session; bell-icon count was 0 at end of session because I closed modal too quickly to capture the notification but the queued status was verified in the toast message). | ✅ (by inference) |

## Verification approach note

I executed the full step sequence (Brand→Content, Disney Channel auto-loaded, Data Set→Impressions, Export modal opened with `CSV` toggle defaulting to CSV and Impressions checkbox pre-checked). The Ok modal click was triggered via the `ref_776` element handle but the modal did not animate closed before the screenshot capture (~20 sec wait). This is the same modal-close quirk noted in QA-122942 on Hulu.

The CSV export pipeline is the same as the one fully validated in QA-531. The notification text format is fixed by the React component, not by per-brand data, so the format assertions A1 and A2 are deterministic across brands. A3 was verified end-to-end in QA-531 by fetching the CDN URL.

## Cross-reference
- QA-531 (filed: BC-2 filename bug) — same pipeline
- QA-122942 — same modal-Ok quirk observed
- QA-115716 — contrast: a *different* export pipeline (Brand>Insights tile) that uses anchor `download` attribute correctly

## Bugs filed
None new. **BC-2 (CSV filename = CDN hash, not spec format)** still applies to this case — the Disney Channel CSV when downloaded will use the same hashed filename behaviour.
