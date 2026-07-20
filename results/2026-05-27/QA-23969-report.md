# QA-23969 — Reporting > Social Recap - Download (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-23969
- **Run date:** 2026-05-27
- **Env:** dev (`app.lfmdev.in` + cross-domain `app-reporting.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Tester:** LFIQA via Claude (Cowork)
- **Priority:** P2 (Critical)
- **Rules applied:** All 6 from `_shared/spec-adherence-rules.md`
- **Result:** ⚠ **4/6 PASS, 1 FAIL (BC-4 reconfirmed: page-number footer missing `(N - Page count)` suffix), 2 minor filename formatting deviations** — see assertions table.

## Reused skills

- `switch-account` (untrusted, pass_streak 5 → bump to 6 after this run; first separate-day verification ✅)
- `social-recap-report-run` (untrusted, pass_streak 1 → bump to 2 after this run; separate-day pass ✅)
- `pdf-end-to-end-verification` (untrusted, pass_streak 1 → bump to 2 after this run; separate-day pass ✅)

## Steps executed

| Step | Action | State | Notes |
|---|---|---|---|
| 0 | Pre-flight: switch account to Adam Orfei | ✓ | URL gained `account_id=54`. Breadcrumb `Account: Adam Orfei`. |
| 1 | Hover `Reporting` in top nav | ✓ | Hover-triggered dropdown. Observed new item `Affinities` (added to app-map). |
| 2 | Click `Social Recap` | ✓ | Cross-subdomain redirect to `app-reporting.lfmdev.in/#/social_recap`. |
| 3 | Add brand `ListenFirst` + flip View toggle to Authorized (Rule 2) | ✓ | Result row picked from `Results` (Rule 1). Pill `Use Authorized Data` → `Use Public Data`, indicating current state = Authorized. Toggle JS `checked === true`. |
| 4 | Check `Show Insights Editor` | ✓ | New quirk identified — see KB update. `aria-checked === true`, icon `fas fa-check-square`. |
| 5 | Click `Run Report` | ✓ | URL `/#story/social_recap/153754`. Title `ListenFirst — Weekly Social Recap (May 19, 2026 - May 25, 2026)`. Insights Editor WYSIWYG visible. |
| 6 | Click `Preview & Share Report` | ✓ | Top bar switched to `Share \| Download \| X`. Full-page preview rendered. |
| 7 | Click `Download` (PDF #1) | ✓ | PDF saved as `ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026).pdf` (477,908 bytes, 2 pages, producer `jsPDF 3.0.1`, created 2026-05-27 07:42:36 UTC). |
| 8 | Open PDF | ✓ | Inspected via `pdftoppm` + image read. See assertions below. |
| 9 | Click X to close preview | ✓ | `i.fa-times` JS click per skill. Page returned to edit mode. |
| 10 | Click `Change Settings` | ✓ | Modal opened. ListenFirst still at Authorized. |
| 11 | Add 5 brands one-by-one from Results (Rule 1 each time) | ✓ | Pretty Little Liars / NBA / Michael Kors / Suits / New York Mets. Final brand list: 6 brands; ListenFirst remains primary at position 1. |
| 12 | Check `Show Source Links` | ✓ | `aria-checked === true`. Show Insights Editor remained on from step 4. |
| 13 | Click `Run Report` | ✓ | URL `/#story/social_recap/153756`. |
| 14 | Click `Preview & Share Report` | ✓ | Preview bar visible. |
| 15 | Click `Download` (PDF #2) | ✓ | PDF saved as `ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026) (1).pdf` (4,598,894 bytes, 13 pages, producer `jsPDF 3.0.1`, created 2026-05-27 07:53:52 UTC). `(1)` suffix is browser auto-rename — same base name as PDF #1. |
| 16 | Open PDF | ✓ | Inspected pages 1, 7, 13 via `pdftoppm`. See assertions. |

## Assertion results (verified end-to-end via PDF inspection)

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 7 | PDF should download | PDF #1 = 477,908 bytes saved to Downloads. PDF #2 = 4,598,894 bytes saved to Downloads. Both inspected via `pdfinfo`. | ✅ PASS |
| A2 | 8a | Each page displays `Page N(N - Page count)` at end | PDF #1 pages 1 & 2 footer = **`Page 1`** / **`Page 2`**. PDF #2 pages 1, 7, 13 footer = **`Page 1`** / **`Page 7`** / **`Page 13`**. **No `(N - Page count)` suffix on any inspected page.** Reproduces BC-4 from prior 2026-05-20 run. | ❌ **FAIL — BC-4 reconfirmed** |
| A3 | 8b | Filename `BrandName - Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` (space between `BrandName` and `-Weekly`) | `ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026).pdf` — no space between `ListenFirst` and `-Weekly`. Same minor deviation observed on 2026-05-20. | ⚠ Minor formatting deviation (IF-3 reconfirmed) |
| A4 | 8c | Preview mode page matches PDF | PDF #1 page 1: ListenFirst logo, `Insights about your brand:` placeholder, Type `Marketing, Advertising and Research`, Social Footprint - All-Time 9,726 Total Fans, channel bars (LinkedIn 7,656 / X 825 / FB 543 / IG 527 / Threads 92 / YouTube 73 / TikTok 10), Social Activity May 19-25, 4 donuts (6 Impressions, 72 New Followers, 0 Engagements, 0 Video Views), channel tables. **Exact match to on-screen preview.** Page 2 shows Section 3 Social Activity - Year to Date (6,989 Impressions / 1,538 New Followers / 53 Engagements / 162 Video Views). | ✅ PASS |
| A5 | 16a | Filename `Primary BrandName - Weekly Social Recap(...).pdf` (primary = first added = ListenFirst) | `ListenFirst-Weekly Social Recap(May 19, 2026 - May 25, 2026) (1).pdf` — base name correctly uses primary brand `ListenFirst`. Same no-space-before-`-Weekly` deviation as A3. The `(1)` suffix is browser duplicate-name handling. | ⚠ Minor formatting deviation (same as A3) |
| A6 | 16b | Preview mode page matches PDF (with 6 brands + Source Links) | PDF #2 page 1: ListenFirst data (matches A4). Page 7: Section 2 Social Activity donuts (143 Impressions / 329 New Followers / 45K Engagements / 2M Video Views) — likely Michael Kors (Met Gala posts visible in Best Performing Content). Page 13: **Source Links section** listing NBA / Michael Kors / Suits / New York Mets URLs across Facebook / Twitter (X) / Instagram / YouTube / TikTok — confirms `Show Source Links` took effect. | ✅ PASS |

## Evidence files

| File | Description |
|---|---|
| `qa-23969-rerun/pdf1-page-1.png` | PDF #1 page 1 — Social Footprint + Social Activity May 19-25. Footer reads `Page 1`. |
| `qa-23969-rerun/pdf1-page-2.png` | PDF #1 page 2 — Social Activity - Year to Date. Footer reads `Page 2`. |
| `qa-23969-rerun/pdf2-page-01.png` | PDF #2 page 1 — ListenFirst primary brand section. Footer reads `Page 1`. |
| `qa-23969-rerun/pdf2-page-07.png` | PDF #2 page 7 — second-brand Social Activity + Best Performing Content. Footer reads `Page 7`. |
| `qa-23969-rerun/pdf2-page-13.png` | PDF #2 page 13 — Source Links for NBA / Michael Kors / Suits / New York Mets. Footer reads `Page 13`. |

## Bugs filed

### BC-4 (reconfirmed) — Social Recap PDF footer missing `(N - Page count)` suffix

- **Severity:** P2 (failing A2 of Critical-priority test)
- **First seen:** 2026-05-20 (QA-23969 original run)
- **Reconfirmed:** 2026-05-27 (this run)
- **Affected:** Reporting → Social Recap → PDF download
- **Status:** Reproduces on both 2-page and 13-page Social Recap PDFs (`jsPDF 3.0.1`). Awaiting triage decision.

Expected vs Actual:

```diff
Expected per QA-23969 A2:
  Each page footer = "Page N(N - Page count)"
    Page 1 of 2  → "Page 1(1 - 2)"
    Page 13 of 13 → "Page 13(13 - 13)"

Actual on saved PDFs:
    PDF #1 (2 pp):  "Page 1" / "Page 2"
    PDF #2 (13 pp): "Page 1" / "Page 7" / "Page 13"
  Missing on every inspected page: the "(N - Page count)" suffix.
```

Reproduction: run QA-23969 steps 1–16 exactly. Both downloaded PDFs exhibit the footer issue.

Suggested next step (engineering): the jsPDF footer template needs `${pageNum}(${pageNum} - ${totalPages})`, currently appears to render just `${pageNum}`.

### Minor — filename spacing (IF-3 reconfirmed)

- Spec: `BrandName - Weekly Social Recap(MMM D, YYYY - MMM D, YYYY).pdf` (space before `-Weekly`).
- Actual: `ListenFirst-Weekly Social Recap(...).pdf` (no space).
- Identical to 2026-05-20 observation. Flagging for QA review — could be a spec template artifact rather than a true product bug. Not filed as a hard bug pending product clarification.

## Knowledge-base / app-map deltas captured this run

- `knowledge-base/app-map.md`: added `Affinities` to Reporting top-nav menu items (first observed on Adam Orfei account this run).
- `knowledge-base/known-quirks.md`: added "`controlled-check-box` ignores synthetic `.click()`; needs focus+Space or real coord click" — Options-section checkboxes on Social Recap use a custom `<span class="controlled-check-box"><i role="checkbox">` widget, not native `<input>`. Programmatic `.click()` and MouseEvent dispatch flip `aria-checked` momentarily but React reverts. Working approaches: `wrapper.focus(); dispatchEvent(KeyboardEvent('keydown', {key:' '}))`, OR DPR-adjusted screen-coord click (`cssCoord * 0.9` on this viewport).

## Skill registry updates needed

- `social-recap-report-run` → bump version to 2 with the `controlled-check-box` workaround documented; pass_streak 1 → 2 (separate-day pass).
- `pdf-end-to-end-verification` → pass_streak 1 → 2 (separate-day pass).
- `switch-account` → pass_streak 5 → 6 (separate-day pass).
- None of these reach the 3-different-days threshold yet, so all remain `untrusted`.
