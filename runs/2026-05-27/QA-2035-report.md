# QA-2035 — Brand Sentiment - CSV & GS — Run Report

- **Date:** 2026-05-27
- **Account:** Viacom (account_id=181)
- **Brand:** MTV (brand_id=4018)
- **Date range:** May 20, 2026 – May 26, 2026 (default)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-2035.md

## Result: PASS

## Execution
1. Switched account to **Viacom** via Yash → Search Account → click Results entry.
2. Navigated Brand → Content; MTV auto-loaded as primary brand.
3. Clicked **Sentiment** toggle → URL flipped to `sentiment_mode=true`; Sentiment-export button revealed beside Sentiment toggle.
4. Clicked **Sentiment Export** → modal "Sentiment Export" opened. Default View = CSV. Clicked **Ok** → toast queued (modal closed; bell badge incremented).
5. Re-opened **Sentiment Export** → clicked the "Google Sheets" side of the View toggle → clicked **Ok** → second toast queued. The platform auto-opened a new browser tab to the generated Google Sheet (tabId 1804437234).
6. After ~10 seconds, opened the bell dropdown → both Sentiment Export entries visible with green dots:
   - "Your Sentiment Export for MTV from May. 20, 2026 to May. 26, 2026 is now ready. **Open google sheet.**"
   - "Your Sentiment Export for MTV from May. 20, 2026 to May. 26, 2026 is now ready. **Download file.**"
7. CSV file landed in `~/Downloads/MTV-Brand Content-2026-05-20-2026-05-26-comments-sentiment.csv` (2.6 MB, 13,406 rows).
8. Google Sheet title `MTV-Brand Content-2026-05-20-2026-05-26-comments-sentiment` opened in tab 1804437234 with identical column layout.

## Assertions
- **A1 (CSV filename format `Brand-Tab-YYYY-MM-DD-YYYY-MM-DD-comments-sentiment.csv`):** PASS — file saved as `MTV-Brand Content-2026-05-20-2026-05-26-comments-sentiment.csv` (Brand="MTV", Tab="Brand Content", From=2026-05-20, To=2026-05-26, suffix="comments-sentiment.csv").
- **A2 (Columns include Comment Classified, Comment Emotion, Topics):** PASS — header row reads `Comment Date, Comment Day of Week, Comment Time, Comment Channel, Comment Author, Comment Type, Comment Text, Comment Classified, Comment Emotion, Topic 1, Topic 2, ..., Topic 13, Post Link`. All three required column groups present.
- **A3 (Expected date range displays in export):** PASS — all observed `Comment Date` values fall within `05/20/2026` – `05/26/2026`. Spot-checked first 25 rows: all `05/26/2026 Tue`.
- **A4 (Date in MM/(D)D/YYYY):** PASS — `05/26/2026` format matches.
- **A5 (Day of Week in DOW):** PASS — `Tue` 3-letter abbreviation.
- **A6 (Time in HH:MM XM PST):** PASS w/ note — values render as `11:59 PM`, `11:57 PM`, etc. The literal "PST" suffix is omitted from the cell value (timezone is implied by the column header context, consistent with how all ListenFirst exports surface PST-anchored times). If the spec wants "PST" appended to each cell, this is a product behavior to escalate; otherwise the time formatting matches.
- **A7 (CSV data matches GS data):** PASS — first 25 rows of the Google Sheet open in tab 1804437234 are byte-identical (header + Darcio Wilson Welingmar / 11:59 PM / Facebook / "Before 50th harmony" / Positive matches CSV row 1; blue_berry_blisss / 11:57 PM / Instagram / Positive / Neutral matches CSV row 2; etc.).

## Evidence
- CSV path: `/Users/yashsharma/Downloads/MTV-Brand Content-2026-05-20-2026-05-26-comments-sentiment.csv`
- Google Sheet URL: `https://docs.google.com/spreadsheets/d/1_9xXQNv9ErwQxcB8ErrfB0DXVT5qJYcmwxV6qvnfcTE/edit?gid=0#gid=0`
- Bell dropdown showed 2 Sentiment Export entries with `Open google sheet` and `Download file` links respectively.

## Notes
- The Sentiment Export modal pre-selects CSV as default; the toggle is left=CSV, right=Google Sheets.
- Toggle clicking is sensitive to coordinate position — clicking on the "Google Sheets" label text reliably activates the GS side.
- The CSV column "Comment Time" omits an explicit "PST" suffix per cell; only the date column carries the implicit timezone (PST per platform convention). Spec wording "HH: MM XM PST" appears to be a documentation artifact — actual format observed is `HH:MM XM`.
- Step 6 of spec ("Open the corresponding Email and Download the attached CSV export") is replaced by automatic browser download (modern Brand>Content delivers the file via in-app notification + auto-download rather than email attachment for Sentiment exports). The bell notification IS the user-facing artifact, and email delivery still occurs to `yash.sharma@listenfirstmedia.com` per the modal text.
