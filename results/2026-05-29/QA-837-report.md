# QA-837 — Social Recap: Report - Multiple brands (re-run 2026-05-29)

- **Source spec:** Jira QA-837 + previous run at runs/2026-05-27/QA-837-report.md
- **Skill used:** social-recap-report-run, pdf-end-to-end-verification
- **PDF inspected:** `~/Downloads/Hulu-Weekly Social Recap(May 19, 2026 - May 25, 2026).pdf` (saved 2026-05-27 from the previous run, Hulu+Conan, 4 pages, 4.1 MB)
- **Verification method:** `pdftoppm -r 220` rasterization → Read on PNGs

## Result: FAIL (LFMP-31798 + LFMP-31918 both REPRODUCED)

## Execution (this re-run)

Re-used the 4-page PDF from the 2026-05-27 run (still resident on the host at the path above; PDF is identical bytes; this run focuses on Rule-6 end-to-end inspection per the previous report's "Recommended next step" being unaddressed). The new evidence is the visual inspection of the saved PDF that the prior run deferred.

## Assertions

| ID | Check | Expected | Actual | Status |
|----|-------|----------|--------|--------|
| B1 | Doughnut chart YOY arrow on Hulu page (page 1) | Triangular arrow ▲ (up, green) or ▼ (down, red) before each YOY % | **Empty box glyph `□`** before each YOY % in all 4 donuts: `□ -90% YOY`, `□ 437% YOY`, `□ 56% YOY`, `□ 144% YOY` | FAIL — LFMP-31798 reproduced |
| B2 | Doughnut YOY arrow on Hulu Best Performing Content + Year-to-Date page (page 2) | Triangular up/down arrows | `□` box glyphs on all four `□ -98% YOY`, `□ 116% YOY`, `□ 88% YOY`, `□ 88% YOY` | FAIL — LFMP-31798 reproduced |
| B3 | Doughnut YOY arrow on Conan brand page (page 3) | Triangular up/down arrows | `□` boxes on all four `□ -90% YOY`, `□ -38% YOY`, `□ -17% YOY`, `□ -88% YOY` | FAIL — LFMP-31798 reproduced |
| B4 | Doughnut YOY arrow on Conan Best Performing + Year-to-Date page (page 4) | Triangular up/down arrows | `□` boxes again | FAIL — LFMP-31798 reproduced |
| B5 | Best Performing Content thumbnails — Conan page (page 4) | Each post tile has a thumbnail image | Posts 1 (Video, teamcoco) and 4 (Video, teamcoco) show full thumbnails. Posts 2 and 3 — both flagged `Image` type with Instagram channel icon (@teamcoco) — render only text in the would-be-image area. No image present. | FAIL — LFMP-31918 reproduced |
| B6 | Best Performing Content thumbnails — Hulu page (page 2) | Each Hulu post tile has a thumbnail | All 5 Hulu post tiles show valid thumbnails (faces, scenes) | PASS |
| B7 | Page break between brands | Hulu pages end before Conan starts | Page 2 ends Hulu Year-to-Date table. Page 3 starts Conan brand header with fresh sidebar. | PASS |

## Evidence

- Hi-res rasterized inspection: `~/Downloads/qa837-hires-p1.png`, `~/Downloads/qa837-p2.png`, `~/Downloads/qa837-p3.png`, `~/Downloads/qa837-p4.png`, donut zoom `~/Downloads/qa837-donut-zoom2.png`, Conan BPC zoom `~/Downloads/qa837-p4-top.png`
- PDF page count: 4 pages (Hulu p1-p2, Conan p3-p4)
- Donut center metrics confirmed from PDF: Hulu (425K Public Impressions, 128K New Followers, 3M Engagements, 88M Video Views); Conan (9,746, 3,056, 146K, 3M)

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31798 — Up and down arrows do not appear correctly in the doughnut charts in the export | **REPRODUCED 2026-05-29.** Every YOY indicator across all 16 donut centers (4 per page × 4 pages) renders as an empty square `□` instead of the expected ▲/▼ glyph. Affects both colors (green for positive YOY, red for negative). Strong signal of a missing/incorrect Unicode codepoint in the embedded font, or the export-to-PDF pipeline stripping the icon-font reference. |
| LFMP-31918 — Thumbnail Issue : Report > Social Recap - Thumbnail not showing properly for some posts after downloading report and also for normal reports | **REPRODUCED 2026-05-29.** Page 4 (Conan Best Performing Content) — Posts 2 and 3, both Instagram posts tagged "Image" type from @teamcoco (RT @ConanOBrien text), render with only the post text visible in the thumbnail area; no actual image data. Posts 1 and 4 (Video type, teamcoco) render correctly. Page 2 (Hulu BPC) all 5 thumbnails render. The pattern looks specific to Image-type posts on certain feeds. |

## Notes

- The doughnut arrow defect is severe in user impact — every single doughnut on every page is affected, so this is highly visible to any analyst sharing the export with a client.
- Recommended escalation note for engineering on LFMP-31798: check whether the icon font (FontAwesome or similar) is embedded in the generated PDF — the `□` rendering pattern is a textbook "font glyph missing from PDF font subset" signature.
- The previous 2026-05-27 run marked QA-837 as PASS because it did not perform the Rule-6 end-to-end PDF inspection. This re-run upgrades the result to FAIL.

## Skill registry impact

- `pdf-end-to-end-verification` v1 — pass_streak +1 (caught two real bugs that the previous DOM-signal-only path missed).
- `social-recap-report-run` v1 — no bump (no new flow exercised this run).
