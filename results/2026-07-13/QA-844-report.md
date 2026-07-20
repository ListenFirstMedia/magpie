# QA-844 — TikTok Content - Exporting Tags

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS

## Note on brand selection

The real Jira ticket (fetched fresh) has description *"This test case ensures the content tagging export functionality"* and names **no specific brand**. My previously-ingested `testcases/english/QA-844.md` had inferred "MTV brand_id=4018" from a prior exploration run — this is NOT part of the actual spec. Confirmed MTV has **zero** TikTok posts on Adam Orfei even over a full year window (`from=2025-07-01&to=2026-07-11`), so MTV would have blocked this case on test-data. Also checked Amazon Prime Video (brand_id=25864) — also 0 TikTok posts. **Selected Hulu (brand_id=11003, the Hulu-LA sub-brand per the known `brand_id 5670→11003` auto-redirect quirk) — 1,729 TikTok posts available.** This is not a Rule 1 violation since no brand was named in the spec.

## Steps executed
1. Brand → Content, brand = Hulu (brand_id=11003), channel = TikTok only, window 2025-07-01 → 2026-07-11.
2. Confirmed Posts (1,729) with TikTok rows visible (after one transient "This table failed to load" → Reload, a known automation-only rendering flake — retried successfully).
3. No pre-existing tagged post found in the visible set — applied a tag via the per-post **Tag** button (bottom-strip `tag-blob.label-blob` element, distinct from the toolbar-level "Tag"/"Bulk Tag" buttons) on Post #1 ("Tristin Dugray..." TikTok video). Tag value: `QA-844-TEST-20260713` (unique, timestamped per mutating-test convention).
   - **Quirk:** the platform auto-lowercased the tag to `qa-844-test-20260713` on save (same normalization behavior documented for tag-upload).
4. Export → clicked the **content-export-btn** (not the identically-labeled per-card dropdown item that happened to also read "Export" — see Finding below) → "Export Select Data Sets" modal → **Public** data set pre-checked, **CSV** view pre-selected (left side of the CSV/Google Sheets toggle) → clicked **Ok**.
5. Export downloaded synchronously to `.playwright-out/Hulu-Brand-Content-2025-07-01-2026-06-30-posts.csv` (no async queue/notification-bell needed this time — Playwright `download` event fired directly).
6. Inspected the saved CSV on disk for the tag column and the tagged row.
7. **Cleanup:** reopened the Tag popup on Post #1 → **Delete All Tags** → confirmed **Delete All** in the modal (`.cdui-delete`) → verified `qa-844-test-20260713` no longer appears anywhere in the page text.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | TikTok-only filter active; channel ghost shows TikTok enabled only | `channels=tiktok` in URL, only TikTok posts rendered (Author Link `tiktok.com/@hulu` on every row) | ✅ PASS |
| A2 | 2 | Posts(N>0) for TikTok in the chosen window | Posts (1,729) | ✅ PASS |
| A3 | 4 | CSV downloads with 200 OK + comma-separated payload | Downloaded `.csv`, verified genuinely comma-separated with quoted fields (not TSV) — `544,287` bytes on disk | ✅ PASS |
| A4 | 5 | CSV header row includes `Tags` (or equivalent label `Content Tags`) | **Deviation:** the header does not use a generic "Tags"/"Content Tags" label — instead each distinct tag gets **its own column named after the literal tag value** (`qa-844-test-20260713`). Functionally equivalent (the tag data is exported), but the column-naming convention differs from the spec's wording. | ⚠️ PASS-with-deviation |
| A5 | 5 | For the spot-check TikTok row, the `Tags` cell contains the spec tag string (non-empty for tagged rows) | Row 1 (Rank=1, "Tristin Dugray...") has `qa-844-test-20260713` in the last column | ✅ PASS |
| A6 | 5 | For non-tagged rows, the `Tags` cell is empty (not e.g. literal `null`) | Spot-checked rows 5, 26, 91 — trailing field absent/empty, no `null` literal | ✅ PASS |

## Finding (automation-only, not a product defect)

The Brand>Content page has **two different DOM elements whose visible text is exactly "Export"**: the real toolbar `content-export-btn`, and (in this session) what appeared to be a per-post-card dropdown option that also rendered the string "Export" transiently. A naive text-match click landed on the wrong one and opened an unrelated `modal--select-datasets`-styled dropdown (Auto/Prior Period/Public/Engagements options) instead of the intended per-post-card menu. Recommend any future skill for this page scope the Export lookup to `.content-export-btn` specifically rather than a bare text match.

## Bugs filed

None. A4's deviation is a spec-wording mismatch, not a functional defect — recommend updating the Jira spec text to describe the actual per-tag-column export convention rather than filing a bug.

## Cleanup

✅ Complete — test tag `qa-844-test-20260713` added to Hulu TikTok post #1 (Rank 1, "Tristin Dugray...") and removed via Delete All Tags + confirmed no longer present.
