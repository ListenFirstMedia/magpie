# QA-111243 — Brand > Content · Sentiment · Emotion (Daily) · CSV Export Email Format

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-111243
- **Verdict:** **PASS** (A1–A6 all pass; A6 mismatch of 2 within the ≤4 tolerance — reproduces APPS-55875 pattern, Minor/non-blocking)
- **Brand tested:** **MTV** (Instagram, Authorized) — see "Brand deviation" note below
- **Skills reused:** `brand-content-data-set-selector` (Sentiment mode), `export-csv`, `chart-hover-tooltip` (donut Read popup), `view-perspective-toggle`, `switch-account`

## Brand deviation (Rule 1 / Rule 4 note)
The spec names the brand only as an **example** ("Brand → Content (e.g., Hulu)" and "Channel filter Instagram (or whatever has sentiment data)"). Hulu was loaded via the brand typeahead (exact-match "Hulu" result, brand_id=11003 Public) but on the current account (**Viacom**, user `lfiqa@listenfirstmedia.com`) **Hulu has no Authorized access** — the Public↔Authorized perspective toggle rendered `disabled=true`, and Sentiment mode requires Authorized data, so the Sentiment button was permanently `disabled`. Direct nav to Hulu-Authorized (brand_id=5670) redirected to `#home` (brand not on this account).

Because the spec treats the brand as illustrative and explicitly permits "whatever has sentiment data," the case was executed on **MTV** (brand_id=4018, Authorized) — the sentiment-enabled brand on this account, and the same brand used in the prior 2026-06-04 pass. This is **not** a Rule-1 substitution of a pinned brand; it is the spec's own "e.g." allowance. Consequence: the **Hulu-specific A6 figures (323 modal vs 319 export)** could not be exercised and remain deferred, exactly as in the 2026-06-04 batch-8 run.

## Preconditions met
- Logged in as `lfiqa@listenfirstmedia.com`; account = Viacom (account_id=181).
- Brand > Content, MTV, **Instagram only** (facebook/twitter/tiktok disabled via channel ghosts → Apply → `channels=instagram`).
- Date range **Jul 04–10 2026** (last 7 days, app default).
- Perspective toggle **Authorized** (`input#perspective` checked=true, enabled) — clicked/confirmed per Rule 2, not URL-only.
- **Sentiment mode ON** (`button.sentiment-button` enabled once Authorized; `sentiment_mode=true`).

## Steps executed
1. Login → app home (Viacom).
2. Brand > Content; brand typeahead exact-match "Hulu" (11003) → Sentiment button `disabled`, perspective toggle `disabled` (no Authorized Hulu on this account).
3. Pivoted to MTV (4018), Instagram-only, Authorized, last 7 days.
4. Clicked **Sentiment** → sentiment tiles rendered (Classification, Classification (Daily), Emotion, **Emotion (Daily)**, Topics, Top 7 Topics (Daily), 25 Most Vocal, Posts).
5. Scrolled to the **Emotion / Emotion (Daily)** tiles (Emotion (Daily) = stacked area chart Love/Joy/Surprise/Neutral/Sadness/Fear/Anger; screenshot `emotion-daily-tile.png`).
6. Hovered the **Joy** slice of the Emotion donut → tooltip "Joy Emotion: 31% / Total Comments: 369 / Read" → clicked **Read** → **Read Comments modal** opened (screenshot `read-comments-modal.png`).
7. Modal **Export** (`button.csv-export-comments-btn`) → format **CSV**.
8. **"Sentiment Export Request"** confirmation popup appeared with the email-format message (screenshot `export-email-popup.png`).
9. Clicked **Ok**.
10. Export completed async → **auto-downloaded** to disk + new **notification-bell** entry (11:18 pm).
11. Parsed CSV on disk and compared record count vs modal's 369.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Read on Joy slice | Read Comments modal opens for the selected slice | Modal titled **"Joy Emotion: 31%"**, **369 Sample Comments**, IG rows, cols Date/Author/Type/Comment Text/Classified(Positive)/Emotion(Joy)/Topics; Sort + Close + Export | **PASS** |
| A2 | Export → CSV | Confirmation popup with email-format message | Popup **"Sentiment Export Request"**: "…your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an **email to lfiqa@listenfirstmedia.com**." | **PASS** |
| A3 | Notification / Recent Activity | Export entry with correct title | Bell shows NEW **"Sentiment Export · Jul 11, 2026 11:18 pm · Your Sentiment Export for MTV from Jul. 04, 2026 to Jul. 10, 2026 is now ready. Download file."** (prior run entries were 11:02/11:05 pm) | **PASS** |
| A4 | CSV arrives | CSV downloads or arrives via email | **Auto-downloaded** end-to-end: `MTV-Brand Content-2026-07-04-2026-07-10-comments-sentiment.csv` (56,811 bytes) from `analytics-cdn.lfmdev.in/302177-e1c359374edfa043ba41f1860399de14.csv`; saved under `.playwright-out/QA-111243/` | **PASS** |
| A5 | CSV headers | Date, Author, Comment Text, Classified, Emotion, Topics… | 13 cols: **Comment Date, Comment Day of Week, Comment Time, Comment Channel, Comment Author, Comment Type, Comment Text, Comment Classified, Comment Emotion, Topic 1, Topic 2, Topic 3, Post Link** | **PASS** |
| A6 | Row count vs modal (probe APPS-55875) | Match within ≤4 | Modal **369** vs CSV **367** records → **mismatch = 2** (≤4). All 367 rows Emotion=Joy / Classified=Positive / Channel=Instagram | **PASS** (reproduces APPS-55875 pattern) |

## Evidence
- `.playwright-out/QA-111243/emotion-daily-tile.png` — Emotion + Emotion (Daily) tiles.
- `.playwright-out/QA-111243/emotion-donut-position.png` — Emotion donut before hover.
- `.playwright-out/QA-111243/read-comments-modal.png` — "Joy Emotion: 31% · 369 Sample Comments" modal.
- `.playwright-out/QA-111243/export-email-popup.png` — "Sentiment Export Request" email-format popup.
- CSV on disk: `.playwright-out/QA-111243/MTV-Brand Content-2026-07-04-2026-07-10-comments-sentiment.csv` (367 data records, 13 cols; verified via Python `csv` parser accounting for quoted embedded newlines).
- Modal count: **369**; CSV records: **367**; delta **2**.

## Known bugs checked
- **Bug-history grep (QA-111243):** one open bug — **APPS-55875** (Bug, Minor, **Open**) "Brand content – Sentiment Read Comments exported data mismatched with comments modal (Hulu – 323 in modal vs 319 in export)." This is the explicit subject of probe **A6**, which **tolerates a ≤4 mismatch**, so it does **not** interfere with the assertions → case runs (not open-bug auto-fail).
- **Reproduction verdict:** the modal-vs-export count mismatch **reproduces on MTV** (369 vs 367, delta 2), matching the APPS-55875 pattern (export count slightly below modal count). Within the documented ≤4 tolerance → **Minor, non-blocking, PASS**. The Hulu-specific 323/319 figures were not reproducible here (no Authorized Hulu on this account) and remain deferred.
- No other linked/related bug on this surface interfered.

## Bugs filed
None. (APPS-55875 confirmed still present as a small modal-vs-export count delta; already an open Minor ticket — not re-filed.)
