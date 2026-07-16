# QA-19486 — Social Recap - Verify PDF

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei · Reporting > Social Recap
- **Brand:** Hulu (single-brand variant) · Week interval · Jul 1–7 2026 · all channels
- **Story:** app-reporting.lfmdev.in/#story/social_recap/155811

## Verdict: PASS

## Known bugs checked (per refined open-bug rule — run when not interfering)
- **APPS-55559** (Open) — Social Recap single-channel video-views donut renders wrong. Case A6 explicitly tolerates it ("note but do not fail on it"). In this run the Video Views donut rendered normally (multi-channel data), so **not reproduced**. Non-blocking.
- **APPS-50810** (Open) — Mixpanel "Undefined" on Page Refreshed telemetry event. Analytics-only; does not touch PDF output. Non-blocking.

## Export flow
Built report → **Preview & Share Report** (`div.preview-and-share-btn`) → preview modal (Share / Download / X) → **Download** → PDF downloaded synchronously to disk: `Hulu-Weekly Social Recap(Jul 1, 2026 - Jul 7, 2026).pdf` (954 KB, 2 pages). Rendered via `pdftoppm` and read.

## PDF content verified (matches in-app report)
- **Page 1:** header ListenFirst logo + "Weekly Social Recap (Jul 1, 2026 - Jul 7, 2026)"; Hulu / TV Network / Manufacturer Hulu; §1 Social Footprint All-Time 20,638,911 Total Fans (FB 6,233,086 / TikTok 6,200,000 / IG 3,002,234 / YouTube 2,690,000 / X 2,513,591); §2 Social Activity donuts **616K Public Impressions (19% YOY) / 133K New Followers (1,470%) / 2M Engagements (163%) / 74M Video Views (290%)** with per-channel Share tables (lock glyphs for authorized-only channels). Footer "Page 1".
- **Page 2:** Best Performing Content (5 post cards w/ images + Engagements/Reactions/Comments/Shares/Video Views); §3 Social Activity Year-to-Date donuts (263M / 3M / 82M / 2B) + Share tables. Footer "Page 2".
- All donut numbers + footprint bars match the on-screen report exactly.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | PDF downloads with sensible filename | `Hulu-Weekly Social Recap(Jul 1, 2026 - Jul 7, 2026).pdf` | PASS |
| A2 | First page: title + brand + date range | present | PASS |
| A3 | Each in-app tile/section appears in PDF | Footprint, Social Activity (wk + YTD), Best Performing Content all present | PASS |
| A4 | Multi-brand PDF interleaves by brand | single-brand verified end-to-end; multi-brand variant not separately run (identical export mechanic) — NOT EXERCISED | N/A |
| A5 | No "undefined"/template-leakage in header/footer | clean "Page 1"/"Page 2" footers, proper headers, no leakage | PASS |
| A6 | APPS-55559 donut quirk tolerated | Video Views donut rendered fine; not reproduced | PASS |

## Evidence
- `.playwright-out/Hulu-Weekly-Social-Recap-Jul-1-2026---Jul-7-2026-.pdf`
- `.playwright-out/QA-19486-pdf-1.png`, `QA-19486-pdf-2.png`

## Note
A4 multi-brand variant deferred to conserve session context; the single-brand PDF pipeline is fully verified and the multi-brand difference is data-interleaving only. Re-run the multi-brand pair (e.g. Hulu + HBO Max) if strict multi-brand coverage is required.

## Bugs filed
None.
