# QA-111242 — Brand > Content · Sentiment · Read Comments CSV Export & notification pop-up

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `app.lfmdev.in`)
- **Verdict:** **PASS** (LFMP-31947 NOT reproduced — 3rd consecutive non-repro)
- **Brand / account:** MTV (`brand_id=4018`, `account_id=181` / Viacom), Public/Authorized perspective (`perspective=extended`)
- **Date range:** Jul 4 – Jul 10, 2026 (last-7-days, auto-populated — matches spec step 2 "recent week / last 7 days")
- **Skills reused:** `brand-content-data-set-selector` (sentiment mode), `export-csv` (sentiment Read-Comments CSV variant)

## Preconditions
- Logged in programmatically as `lfiqa@listenfirstmedia.com`; dashboard rendered at `#home`.
- MTV has sentiment-tagged posts on multiple channels in the window — IG **Posts (20)**, Twitter **Posts (22)** — so the "sentiment-tagged posts on multiple channels" precondition is met on the last-7-days window (no need to fall back to a historical window).

## Steps executed
1. Navigated Brand → Content for MTV (`#explore/brand/content?brand_id=4018&account_id=181`). Header confirmed **MTV**.
2. Date range = last 7 days (Jul 4–10, 2026), auto-set by the app on brand load.
3. Filtered channels to **Instagram** only — disabled FB/Twitter/TikTok/LinkedIn/Threads via `.channel-ghost` trusted clicks, clicked Apply → URL `channels=instagram`.
4. Clicked the **Sentiment** button (`.sentiment-button`) → `sentiment_mode=true`. Classification donut + "Most Vocal" table + post grid rendered.
5. Clicked **Read Comments** (`.read-samples-button`, top IG post) → modal opened: **"sashka.park's Comments — 15 Sample Comments"** with full table (Date, Author+IG icon, Type, Comment Text, Classified, Emotion, Topics).
6. Observed the sample-comments messaging ("15 Sample Comments"); no 2,000-cap banner (post has <2,000 comments — see A2 note).
7. Modal **Export** (`.csv-export-comments-btn`) → **CSV**.
8. **Sentiment Export Request** popup shown; clicked **Ok** (`.modal-accept-button`).
9. Switched channel to **Twitter** (non-IG control), still in Sentiment mode → repeated steps 5–8: Read Comments on top Twitter post → **"xJamesMiIIer's Comments — 5 Sample Comments"** modal → Export → CSV → Ok.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 (IG) | Read Comments modal displays comments — probe LFMP-31947 (MTV IG known-bad) | Modal "sashka.park's Comments — 15 Sample Comments" rendered a full comment table (15 rows: Date, IG author, Type Gallery/Image/Video, emoji comment text, Classified=Positive, Emotion N/A/Love, Topics N/A). **Comments DISPLAY for IG.** | **PASS** |
| A2 | 6 | Notification popup shows "2,000 Sample Comments…" message or sentiment-limit messaging | Modal subtitle shows **"N Sample Comments"** messaging (15 for IG, 5 for Twitter). The literal "2,000" is the sample **cap** and only surfaces when a post exceeds 2,000 comments — none in this window do, so the actual count is shown. Sample-comments messaging present & correct. | **PASS** (note: 2,000 cap not hit — documented spec-limit behavior, not a defect) |
| A3 | 8 | CSV export request submitted, notification confirms | **Sentiment Export Request** popup: *"We're hard at work preparing your export… your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to lfiqa@listenfirstmedia.com."* Bell shows two **Sentiment Export** entries: *"Your Sentiment Export for MTV from Jul. 04, 2026 to Jul. 10, 2026 is now ready. Download file."* (11:02 pm IG, 11:05 pm Twitter). | **PASS** |
| A4 | — | Resulting CSV in Downloads contains rows + matches modal | IG CSV `MTV-Brand Content-2026-07-04-2026-07-10-comments-sentiment.csv` = header + **15 rows**, all `Instagram`/`sashka.park`, Classified `Positive` — matches the modal. Twitter CSV (same filename, overwrote) = header + **5 rows**, `Twitter`/`xJamesMiIIer`, readable text, Classified Neutral/Negative, incl. `Topic 1` col + twitter.com Post Link — matches its modal. Both verified on disk. | **PASS** |
| A5 | 9 (non-IG) | Read Comments displays correctly on a non-IG channel | Twitter modal "xJamesMiIIer's Comments — 5 Sample Comments" rendered a full table with readable comment text (`@MTV He ain't Oa1utis of Borg…`), Classified (Neutral/Negative), Emotion (Neutral/Surprise), Topics (ngas/licence). Displays correctly. | **PASS** |

## Evidence
- `.playwright-out/QA-111242/01-ig-sentiment-view.png` — MTV IG Sentiment mode (Classification donut, Most Vocal, post grid).
- `.playwright-out/QA-111242/02-ig-read-comments-modal.png` — IG "sashka.park's Comments — 15 Sample Comments" modal.
- `.playwright-out/QA-111242/03-ig-sentiment-export-request-popup.png` — Sentiment Export Request confirmation popup.
- `.playwright-out/QA-111242/04-twitter-read-comments-modal.png` — Twitter "xJamesMiIIer's Comments — 5 Sample Comments" modal.
- On-disk CSVs: `.playwright-out/MTV-Brand-Content-2026-07-04-2026-07-10-comments-sentiment.csv` (IG capture verified 15 rows before Twitter re-export overwrote to 5 rows).

### CSV header (IG export)
`Comment Date, Comment Day of Week, Comment Time, Comment Channel, Comment Author, Comment Type, Comment Text, Comment Classified, Comment Emotion, Post Link`
First data row: `07/10/2026, Fri, 03:15 PM, Instagram, sashka.park, Comment, <emoji text>…love…, Positive, "", https://www.instagram.com/p/Dan5t9xker5/`

### CSV header (Twitter export)
`…, Comment Classified, Comment Emotion, Topic 1, Post Link` — Twitter comments carry topics, so an extra `Topic 1` column appears (IG rows had Topics=N/A → no topic column).

## Known bugs checked
- **LFMP-31947 (Bug, Major, Open)** — "Brand content Sentiment Read Comments not displaying data for IG channel (MTV)." Grepped `bug-history.md` (QA-111242 §) + case Probes section pre-run. **NOT REPRODUCED** this run: the IG Read Comments modal displayed a full 15-row comment table for MTV. This is the **3rd consecutive non-repro** (2026-06-02, 2026-06-04 batch-8, now 2026-07-11) — recommend Jira closure after eng confirmation. Because the target bug does not interfere with the assertions, the case is judged PASS on its in-scope assertions.
- No other linked/open bugs touch this flow.

## Notes / observations (not defects)
- **Sentiment channel support:** in Sentiment mode only Facebook / Twitter / Instagram channels are supported; TikTok / LinkedIn / Pinterest render with a `warning fa-stack` "Channel not supported when sentiment is active" state. Expected.
- **CSV filename does not encode channel:** the sentiment comments export filename is `<Brand>-Brand Content-<from>-<to>-comments-sentiment.csv` (brand + date range only). Consecutive same-window exports on different channels overwrite the same on-disk file. Each export is still a distinct queued job with its own bell entry + email link, so this is a filename-scheme observation, not a data-loss defect.
- **Export delivery is synchronous this run:** selecting CSV both auto-downloaded to disk AND queued the bell/email job (popup wording covers both). Google Sheets export not exercised (out of scope on this track).
- Modal Export dropdown "CSV" option sits under the Help/link fab which intercepts Playwright pointer events; selected via in-page `.click()` on `.lfm-dropdown-option` (menu selection only — the export submission itself is the trusted OK click).

## Bugs filed
None. (Reports are markdown-only; no Jira tickets created.)
