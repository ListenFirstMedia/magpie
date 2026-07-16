# QA-52778 — Brand definition update - Include URL Manager

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP) — **MUTATING (idempotent round-trip)**
- **Surface:** `radaac.lfmdev.in` (Cognito login) · Brand Definitions Fetch → Patch → Apply · Brand ID **236**

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow + mutation note
Full 3-stage chain run with **Include URL Managers** checked at each stage:
1. **Fetch** (Brand IDs = 236): downloaded `20260709BrandDefinitionReport_d371ea.xlsx`.
2. **Patch** (uploaded the Fetch file): downloaded `20260709PatchBrandDefinitionReport_cdf180.xlsx`.
3. **Apply** (uploaded the Patch file): downloaded `20260709ApplyBrandDefinitionReport_3cc736.xlsx`.

**Mutation:** the CSV/XLSX was **never edited** between stages, so Apply re-committed Brand 236's existing definition with identical values (idempotent — no net data change).

## Column assertions (parsed from each report's header)
| Report | `url_managers` column present | `youtube_channel_company` immediately after `youtube_channel_username` |
|---|---|---|
| Fetch (41 cols) | yes | yes (idx 25 → 26) |
| Patch (42 cols) | yes | yes |
| Apply (42 cols) | yes | yes |

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Include URL Manager unchecked by default | Fetch popup checkbox unchecked on open | PASS |
| A2 | `url managers` column in Fetch file | `url_managers` present | PASS |
| A3 | `youtube_channel_company` after `youtube_channel_username` (Fetch) | adjacent, in order | PASS |
| A4 | `url managers` column in Patch file | present | PASS |
| A5 | youtube ordering (Patch) | in order | PASS |
| A6 | `url managers` column in Apply file | present | PASS |
| A7 | youtube ordering (Apply) | in order | PASS |

## Variance note
Report format is **XLSX**, not CSV (case wording says "CSV file"). Columns/assertions verified from the XLSX. Minor naming variance, not a defect.

## Evidence
- `.playwright-out/20260709BrandDefinitionReport-d371ea.xlsx` (Fetch)
- `.playwright-out/20260709PatchBrandDefinitionReport-cdf180.xlsx` (Patch)
- `.playwright-out/20260709ApplyBrandDefinitionReport-3cc736.xlsx` (Apply)

## Finding (harness)
Radaac popup inputs have **hidden duplicate `.brand_ids` inputs** (Fetch/Patch/Apply popups all pre-rendered in DOM) — set the **visible** one (`offsetParent!=null`) with real keystrokes; a programmatic value on the hidden input submits empty (`brand_ids=` → RuntimeError). File uploads work via `browser_file_upload` after clicking the visible `input[type=file]`.

## Bugs filed
None.
