# QA-83928 — Brand > Paid - CSV - Select Channels & Data Sets Export + notification view — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Window:** Jun 1–15 2026
- **Skills:** brand-paid-csv-export, export-notification-view, csv-export-verify (anchor+fetch)
- **Result:** ✅ PASS

## Steps
1. Brand > Paid for MTV → **Export** → "Export Select Data Sets" modal (View=**CSV**, Google Sheets toggle off).
2. Modal lists **Channel Data Sets**: Facebook Engagements/Rates/Video Views/Cost/Delivery, Twitter Basic/Engagements/Rates/Video/Video Views/Cost/Delivery, Instagram Engagements/Rates, …
3. Selected **Facebook Engagements** (default) + **Twitter Engagements** (two channels' data sets).
4. Installed download hooks (`createObjectURL` + anchor `click`). **Ok** → export queued/processed; auto-download fired.
5. Fetched the downloaded file in-page (Rule 6) and parsed.
6. Opened **notifications bell** to verify the export notification view.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Select Channels & Data Sets modal | CSV view with selectable channel data sets | Modal rendered; multi-channel data-set checkboxes; CSV/Google Sheets toggle | ✅ |
| Export produces CSV | A CSV file is delivered | fetched OK; 602 chars, 5 lines; header `Channel,…,Facebook,Facebook…` (channel-keyed columns) | ✅ |
| Notification view | Export-ready entry appears in notifications | Bell count 8,362→**8,363**; top entry **"Select Channels & Data Sets Export … Your Paid Export … for MTV from Jun. 01, 2026 to Jun. 15, 2026 is now ready. Download file."** | ✅ |

## Notes / automation learning
- The CSV is **sparse** (header + a couple rows) because this Adam Orfei / MTV context has **no authorized paid ad data** (Ads 0) — but the export pipeline, channel/data-set selection, and notification all function correctly. The header is **channel-keyed** (Channel row → Facebook / Twitter column groups), confirming the selected channels are reflected.
- Paid export is **async** like Content CSV: capture the auto-download via the anchor-`click` hook + in-page `fetch` (the `createObjectURL` hook alone returns no blob).
- The **notification view** is the deliverable here and renders cleanly: dated, unread (green dot), with an inline **"Download file"** link; the prior Content "Select Data Sets Export" (QA-28405) is also listed.

## Bugs filed
_None._
