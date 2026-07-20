# QA-19486 — Social Recap - Verify PDF

- **Run date:** 2026-07-11
- **Mode:** unattended / headless (Playwright MCP, `claude -p`)
- **Account:** Adam Orfei (default login context — matches spec)
- **Brands:** Hulu (single-brand), Hulu + HBO Max (multi-brand) — both exact-match from typeahead Results (Rule 1)
- **Perspective:** Public Data (default on add; spec does not specify Authorized)
- **Date range:** Week interval, default current week = **Jul 3, 2026 – Jul 9, 2026**
- **Skills used:** `social-recap-report-run` (v3), `pdf-end-to-end-verification` (v2)
- **Reports built:** `#story/social_recap/155894` (Hulu), `#story/social_recap/155895` (Hulu + HBO Max)

## Verdict: **PASS**

Both the single-brand and multi-brand PDFs downloaded to disk, rendered as valid jsPDF 3.0.1 A4 documents, and reproduced every in-app tile with correct per-brand headers, date range, and clean footers. The one known open defect that reproduced (LFMP-31798 donut-arrow glyph) and a likely one-tile LFMP-31918 thumbnail miss are pre-existing Major open bugs that do not interfere with any of this case's assertions.

---

## Steps executed

| # | Step | Result |
|---|------|--------|
| 0 | Pre-flight login (`app.lfmdev.in` → Cognito existing-account form, `config/.env` creds) | OK — landed on app, "Brand Explorer" |
| 1 | Navigate to Social Recap builder (`app-reporting.lfmdev.in/#/social_recap`) | OK — Account: Adam Orfei |
| 2 | Add **Hulu** via Add Brand By Name — typed "Hulu", clicked literal exact-match `Hulu` result (Rule 1) | OK — Hulu row, View=Public Data |
| 3 | Date range — default Week / Jul 3–9 2026 (spec: "default is fine") | OK |
| 4 | Run Report | OK — `#story/social_recap/155894`, title "Social Recap > Hulu" |
| 5 | Preview & Share Report (`div.preview-and-share-btn`) → Download (`div.download-btn`) | OK — PDF downloaded silently |
| 6 | Wait for download | OK — download event fired |
| 7 | Render PDF → PNG (`pdftoppm -r 100`) + Read each page | OK — 2 pages verified |
| 8a | Multi-brand: fresh builder, add **Hulu** then **HBO Max** (both exact-match Results, Rule 1) | OK — 2 rows, both Public Data |
| 8b | Run Report → Preview & Share → Download | OK — `#story/social_recap/155895`, 4-page PDF |
| 8c | Render + Read all 4 pages | OK — Hulu pp.1–2, HBO Max pp.3–4 |

Poppler (`pdfinfo`/`pdftoppm`) present on host — used the pixel-level rasterize path (not the Read-multimodal fallback).

---

## Evidence

### Single-brand (Hulu) — `#story/social_recap/155894`
- **On-disk file:** `.playwright-out/Hulu-Weekly-Social-Recap-Jul-3-2026---Jul-9-2026-.pdf` → copied to `.playwright-out/QA-19486/single-hulu.pdf`
- **Server download name:** `Hulu-Weekly Social Recap(Jul 3, 2026 - Jul 9, 2026).pdf`
- **Metadata:** jsPDF 3.0.1, **2 pages**, A4 (595.28×841.89), 994,343 bytes
- **Page 1** (`.playwright-out/QA-19486/single-hulu-page-1.png`): header `Hulu` / Type: TV Network / Manufacturer: Hulu; top-right `Weekly Social Recap (Jul 3, 2026 - Jul 9, 2026)` + LISTENFIRST logo. §1 **Social Footprint - All-Time** 20,676,052 Total Fans (FB 6,241,469 / TikTok 6,200,000 / IG 3,005,758 / YT 2,690,000 / Twitter 2,538,825). §2 **Social Activity - July 03, 2026 - July 09, 2026** — 4 donuts: Public Impressions **979K** (+57% YOY), New Followers **129K** (+1,614% YOY), Engagements **2M** (+111% YOY), Video Views **54M** (+225% YOY) + per-channel Impressions/New-Followers/Engagements/Video-Views breakdown tables. Footer `Page 1`.
- **Page 2** (`.playwright-out/QA-19486/single-hulu-page-2.png`): **Best Performing Content** filmstrip — all **5/5** post thumbnails render (real images) with Engagements/Reactions/Comments/Shares/Video Views. §3 **Social Activity - Year to Date** — donuts 264M / 3M / 83M / 2B + channel tables. Footer `Page 2` (verified at 200 dpi crop `single … p2-footer.png`).

### Multi-brand (Hulu + HBO Max) — `#story/social_recap/155895`
- **On-disk file:** copied to `.playwright-out/QA-19486/multi-hulu-hbomax.pdf`
- **Server download name:** `Hulu-Weekly Social Recap(Jul 3, 2026 - Jul 9, 2026).pdf` (named after primary/first brand Hulu — same schema)
- **Metadata:** jsPDF 3.0.1, **4 pages**, A4, 1,972,966 bytes
- **Pages 1–2:** identical to single-brand Hulu content (byte-identical PNG sizes 113,176 / 294,635).
- **Page 3** (`multi-page-3.png`): **HBO Max** section — own header `HBO Max` / Type: TV Network / Manufacturer: HBO Max + "max" logo + `Weekly Social Recap (Jul 3, 2026 - Jul 9, 2026)`. §1 Social Footprint All-Time 34,000,432 Total Fans (FB 17,350,860 / TikTok 6,100,000 / IG 4,918,547 / YT 3,100,000 / Twitter 2,531,025). §2 Social Activity Jul 03–09 — donuts 5M (+258% YOY) / 270K (+2,977% YOY) / 6M (+136% YOY) / 216M (+185% YOY) + channel tables. Footer `Page 3`.
- **Page 4** (`multi-page-4.png`): HBO Max **Best Performing Content** (5 posts) + §3 Social Activity YTD 807M / 5M / 180M / 8B. Footer `Page 4` (verified at 200 dpi crop `m4-footer.png`). **1 of 5 BPC tiles (post #4, a Video post — Engagements 566 / Video Views 9,668) rendered a grey "..." placeholder instead of the post image** (see LFMP-31918 below); the other 4 thumbnails rendered.
- **Brand order / interleave:** brands render in **add-order**, each as its own 2-page block with its own name/logo/date-range/sections (Hulu pp.1–2, HBO Max pp.3–4) — matches the per-brand-page-break template (consistent with QA-837).
- **In-app baselines:** `.playwright-out/QA-19486/single-hulu-report.png`, `.playwright-out/QA-19486/multi-report.png`.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | PDF downloads to disk with a sensible filename | Both saved via Playwright `download` event; server name `Hulu-Weekly Social Recap(Jul 3, 2026 - Jul 9, 2026).pdf` (brand + report type + date range). Multi-brand uses primary brand (Hulu). | **PASS** |
| A2 | 7 | First page has report title with brand name(s) + date range | p1 `Hulu` + `Weekly Social Recap (Jul 3, 2026 - Jul 9, 2026)`; multi-brand p3 `HBO Max` + same date range | **PASS** |
| A3 | 7 | Each in-app tile/section appears in the PDF | Social Footprint All-Time, Social Activity (window) donuts + channel tables, Best Performing Content, Social Activity YTD — all present per brand, matching in-app screenshots | **PASS** |
| A4 | 8 | Multi-brand PDF correctly interleaves/aggregates by brand per template | 4-page PDF: Hulu pp.1–2, HBO Max pp.3–4, each a full per-brand block in add-order with own header/logo | **PASS** |
| A5 | 7 | Footer/header rendered without "undefined"/template-leakage (LFMP-31798 / BC-4 guard) | Footers read `Page 1`…`Page 4` (increment correctly, verified at 200 dpi); headers show brand + date range; **no** "undefined"/null/NaN/template strings anywhere | **PASS** |
| A6 | 7 | APPS-55559 single-channel donut may render incorrectly — note, do not fail | Not triggered — both brands are multi-channel; all donuts rendered with correct multi-segment rings. Noted per spec. | **PASS (n/a, noted)** |

---

## Known bugs checked

Screened `knowledge-base/bug-history.md` (grep QA-19486) + case notes. Open bugs linked to QA-19486:

- **APPS-50810** (Trivial, Open) — "Mixpanel Page Refreshed undefined". Analytics-only; does not touch the PDF flow or any assertion. **Not applicable / not evaluated** (console-level Mixpanel event).
- **APPS-55559** (Minor, Open) — Social Recap donut single-channel render. **Not triggered** — both brands multi-channel (A6). Noted, no interference.
- **LFMP-31798** (Major, Open — donut up/down arrows render incorrectly in the export). **REPRODUCED** — every Social-Activity donut center YOY label renders the trend indicator as a `□` box glyph instead of a ▲/▼ arrow (e.g. `□ 57% YOY`, `□ 258% YOY`), across both Hulu and HBO Max, all pages. In-app preview shows the label fine; the defect is jsPDF render-side. Known Major open bug — noted, **does not fail** the case (A5 guards specifically against undefined/template-leakage, which is absent; the arrow-glyph is the tracked LFMP-31798). Contrast: on 2026-07-02 (QA-837) it did NOT reproduce — this run it does, so LFMP-31798 remains intermittent/live.
- **LFMP-31918** (Major, Open — BPC thumbnails not showing properly for some posts in the download). **LIKELY REPRODUCED (1 tile).** HBO Max page-4 BPC post #4 (a Video post) rendered a grey `...` placeholder instead of its image; the other 4 HBO Max tiles and all 5 Hulu tiles rendered correctly. Single-tile miss on a Video post — consistent with the tracked LFMP-31918 pattern. Known Major open bug — noted, **does not fail** (A3/A4 satisfied; BPC section present, majority of thumbnails render).

None of the linked open bugs interfere with A1–A6, so per the open-bug-interference rule the case runs and passes. (The case file carried no baked-in "## Open linked bugs" section; screening done from bug-history + case notes.)

## Bugs filed

None. All observed anomalies map to pre-existing tracked Major open bugs (LFMP-31798 reproduced; LFMP-31918 likely reproduced on one tile). No new defect. Bugs are recorded here only — no Jira tickets created.
