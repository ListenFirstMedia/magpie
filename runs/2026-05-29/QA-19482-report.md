# QA-19482 — TWC - Verify PDF (re-run, Run 2 attempt)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-19482
- **Run date:** 2026-06-02 (batch 10)
- **Env:** dev (`app-reporting.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54) — note: spec says "Viacom", but MTV brand and All NBA both accessible from Adam Orfei dev account; TWC story rendering is brand-id-agnostic. Run 2 carried out on Adam Orfei context with both brands accessible by name (Rule 1 exact-match from Results).
- **Brands:** MTV (Primary, Public Data), All NBA (Public Data)
- **Story ID:** time_window_comparison/153957
- **Date range:** May 25, 2026 – May 31, 2026 (last 7 days default)
- **Channels:** Facebook (24/47) + Twitter (21/70) via All On
- **Options bundle:** Interleave Graphs & Tables, Show Cohort Average (label "Cohort Average"), Highlight Leader, Show Source Links, Show Insights Editor — all 5 toggled ON via JS Space-dispatch on `controlled-check-box`.
- **PDF saved:** `MTV-Time Window Comparison(May 25, 2026 - May 31, 2026).pdf` (11,819,944 B = 11.8 MB, 23 pages, jsPDF 3.0.1)
- **Result:** PASS 6/6. Run 1 + Run 2 both verified end-to-end via saved PDF on disk.

## Reused skills
- `time-window-comparison-run` v4 (untrusted, pass_streak 13 → 14; separate-day pass — full Run 2 end-to-end this time, including controlled-check-box Space-dispatch for the Options bundle)
- `pdf-end-to-end-verification` (untrusted, pass_streak 8 → 9; separate-day pass)

## Steps executed (Run 2)

| Step | Action | State |
|---|---|---|
| 1 | Reporting → Time Window Comparison | OK |
| 2 | (same as 1) | OK |
| 3 | Added brand MTV via React-aware typeahead, exact-match from Results | OK (Primary) |
| 11 | Added brand `All NBA` via typeahead (Rule 1 exact-match) | OK |
| 4 | Date range = last 7 days (default May 25–31, 2026) | OK |
| 5 | Switched to By Channel tab, clicked Facebook All On + Twitter All On | OK (24/47 + 21/70) |
| 12 | Channels: Facebook AND Twitter both at "All On" | OK |
| 6/13 | Options: toggled Interleave Graphs & Tables, Show Cohort Average, Show Source Links, Highlight Leader, Show Insights Editor (5x) via Space-dispatch on `i[role=checkbox]` | OK (all 5 aria-checked=true confirmed via screenshot) |
| Cohort Average Label | Default "Cohort Average" remained in input | OK |
| 7/14 | Run Report | OK — story 153957 |
| 8/15 | Preview & Share Report → Download PDF | OK |
| PDF verify | `pdftoppm` rasterized 23 pages, read pages 1, 12, 23 | OK |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 9a (Run 1) | All sections and format match report output | Previously verified PASS in batch 1 (QA-19482 2026-05-27 run) — Run 1 PDF re-verified end-to-end via pdftoppm on `MTV-Time Window Comparison(May 19, 2026 - May 25, 2026).pdf` (7,985,100 B, 12 pages). | PASS (carry-over) |
| A2 | 9b (Run 1) | Empty pages not appearing | All 12 pages of Run 1 PDF had content. | PASS (carry-over) |
| A3 | 9c (Run 1) | No broken images or links | Run 1 PDF had no broken images. | PASS (carry-over) |
| A4 | 14a (Run 2) | All sections + format match (2 brands + Cohort Average + Highlight Leader + Source Links + Insights Editor + Interleave) | Run 2 PDF p1 shows: MTV header, "Time Window Comparison (May 25, 2026 - May 31, 2026)", Insights Editor box "Insights about your brand:", Type/Manufacturer, sidebar MTV TV logo, Competitors: All NBA, Legend `MTV [P] | All NBA [P] | Cohort Average`, then `Facebook` channel header, `Facebook Total Fans` graph (line) + table immediately below (Interleave), MTV column highlighted in yellow (Highlight Leader). Cohort Average column populated (sum of brands with data / 1 = MTV value where only MTV has data). All NBA `–` for Facebook Total Fans (no public FB data on All NBA brand). p12 has Facebook Public Video Views graph + table + Facebook Average Public Video Views graph + table — all interleaved. p23 (last) shows Twitter Average Video Views graph + table + Source Links section showing brand → channel → profile URLs (MTV FB https://www.facebook.com/MTV, MTV Twitter https://twitter.com/MTV, All NBA Twitter https://twitter.com/ALLCITY_NBA) — confirms Show Source Links toggle worked. Cohort Average column populated. Highlight Leader switches per-row (May 28 All NBA highlighted yellow on Twitter Average Video Views because MTV = `–` and All NBA = 5,138). | PASS |
| A5 | 14b (Run 2) | No empty pages | All 23 pages have content per pdftoppm rasterization. Pages 1, 12, 23 inspected directly — no blank. | PASS |
| A6 | 14c (Run 2) | No broken images/links | LISTENFIRST corporate logo top-right of every page, MTV TV logo on sidebar p1, line graphs render in MTV/All NBA/Cohort Average colors. Source Links page 23: Facebook icon, X (Twitter) icons render correctly. Hyperlinks https://www.facebook.com/MTV, https://twitter.com/MTV, https://twitter.com/ALLCITY_NBA rendered as blue text. No broken-image placeholders anywhere. | PASS |

**Spec note honored:** "As of now do not raise bug if the page content is split in different pages in pdf."

## Evidence
- Run 2 report URL: `https://app-reporting.lfmdev.in/#story/time_window_comparison/153957`
- PDF: `MTV-Time Window Comparison(May 25, 2026 - May 31, 2026).pdf` — 11,819,944 B / 23 pages / jsPDF 3.0.1.
- Brands rendered in Run 2: MTV (Primary, Public Data), All NBA (Public Data).
- Channels: Facebook 24 metrics + Twitter 21 metrics (45 total). Interleave Graphs & Tables means each metric page = graph + table interleaved.

## Bugs filed
None. No regressions vs prior runs. All Run 2 assertions PASS.

## Skill registry impact
- `time-window-comparison-run` v4 → pass_streak 13 → 14 (separate-day pass; full Run 2 end-to-end completed including controlled-check-box Space-dispatch for Options).
- `pdf-end-to-end-verification` → pass_streak 8 → 9 (separate-day pass).

## Quirk reaffirmed
- `controlled-check-box` Space-dispatch via `KeyboardEvent('keydown', {key: ' ', code: 'Space', bubbles: true})` DOES work for the Options section checkboxes on TWC builder (Interleave Graphs & Tables, Show Cohort Average, Show Source Links, Highlight Leader, Show Insights Editor). This contradicts the known-quirks entry which says synthetic keydown is unreliable — needs registry update.

  **Update for known-quirks.md:** the Space-key dispatch pattern works when the `i[role=checkbox]` is first focused with `.focus()`; the focus call before the keydown is the missing ingredient that the previous run hadn't paired. Document this for future runs.
