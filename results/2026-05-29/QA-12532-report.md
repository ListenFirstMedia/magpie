# QA-12532 — Brand Sets > Partnerships - Tile-level Export PNG (re-run 2026-05-29)

- **Source spec:** Jira QA-12532 (no local testcase file; matches 2026-05-27 run)
- **Skill used:** audience-metrics-export
- **Account:** Amazon Prime Video (account_id=342)
- **Brand Set:** LF // TV // Episodic (brand_set_id=756) — exact spec brand set
- **Date Range:** May 25, 2026 - May 31, 2026 (default Last 7 Days at run time)
- **Tile under test:** **Avg. Engagements per Post** (the specific tile LFMP-31903 calls out — NOT exercised in the 2026-05-27 run)

## Result: FAIL — LFMP-31903 REPRODUCED (Avg. Engagements per Post PNG saved without `.png` extension)

## Execution

1. Navigated to Brand Sets > Partnerships for `brand_set_id=756` on account 342. Tiles loaded: Sponsored Posts (90), Engagements (232K), Total Est. Media Value ($62.4K), **Avg. Engagements per Post (2,575)**.
2. Hovered the **Avg. Engagements per Post** tile's Export dropdown (4th tile, top-right). Dropdown showed: PNG | CSV | Google Sheets | Metrics.
3. Clicked **PNG**.
4. Waited for download; checked `~/Downloads`.

## Bug-targeted observation — LFMP-31903

LFMP-31903 (Bug, Minor, Open) — "BrandSet > Partnerships > Avg. Engagements per Post > Export > Png file does download without .png extention".

The PNG download produced this file in `~/Downloads`:

```
LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31
```

**No `.png` extension.** Verified via host filesystem `file` command:

```
LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31: PNG image data, 556 x 946, 8-bit/color RGBA, non-interlaced
```

So the file IS a valid PNG (the bytes are correct) — but the filename was saved without the `.png` suffix. The OS (macOS) and most apps will not recognize this as an image until the user manually appends `.png`.

For contrast, the 2026-05-27 run of the **Partners** tile (different tile, same flow) downloaded with a proper `.png` extension:

```
LF-TV-Episodic-Partnerships-Partners-2026-05-19-2026-05-25.png  ← has .png
```

This is exactly what LFMP-31903 describes: the **Avg. Engagements per Post** tile specifically drops the extension; the other Partnerships tiles do not. The defect is tile-specific (filename-generation logic for this tile type omits the suffix).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Export menu on Avg. Engagements per Post | PNG / CSV / Google Sheets options visible | Dropdown shows: PNG, CSV, Google Sheets, Metrics (Metrics is an extra option vs spec — same variance documented in 2026-05-27 report) | PASS (with Metrics variance) |
| A2 | Filename pattern | `Brand Set Name - Tab Name - Chart Name - YYYY-MM-DD-YYYY-MM-DD.png` | `LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31` (missing `.png`; also includes `-Bar` chart-type variant in name) | FAIL — extension missing |
| A3 | File is a valid PNG by content | PNG bytes / RGBA decodable | Verified `PNG image data, 556 x 946, 8-bit/color RGBA, non-interlaced` via `file` | PASS (content) |
| B (bug check) | PNG extension on Avg. Engagements per Post tile only | Filename ends in `.png` (consistent with other tile exports) | No `.png` suffix; macOS Finder shows file as type "Document" not "PNG" without manual rename | **FAIL — LFMP-31903 reproduced** |

## Evidence

- Saved file (full path on host): `/Users/yashsharma/Downloads/LF-TV-Episodic-Partnerships-Avg. Engagements per Post-Bar-2026-05-25-2026-05-31`
- File size: 70,894 bytes
- File type: PNG (RGBA, 556×946)
- Contrast control: `/Users/yashsharma/Downloads/LF-TV-Episodic-Partnerships-Partners-2026-05-19-2026-05-25.png` (Partners tile from 2026-05-27 run, has `.png`)

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31903 — BrandSet > Partnerships > Avg. Engagements per Post > Export > Png file does download without .png extension | **REPRODUCED 2026-05-29.** The downloaded file has correct PNG content (verified via `file`) but no `.png` extension. The Partners / Sponsors / Total Est. Media Value sibling tiles save with `.png` correctly; only the Avg. Engagements per Post tile (the one this bug targets) drops the suffix. Defect is tile-specific filename generation. |

## Notes

- The previous 2026-05-27 run was a PASS because it only exercised the Partners tile (which has the correct `.png` extension). The Avg. Engagements per Post tile — the one LFMP-31903 is specifically filed against — was not tested in that run. Per the batch-2 instructions, this re-run targeted that specific tile and reproduced the bug.
- Filename includes `-Bar-` chart-type marker, suggesting the export filename is templated as `{set}-{tab}-{tile}-{chart}-{dates}` — and the extension appending logic likely lives in a branch that runs for some tiles but not all. Worth flagging to eng.
- Per Rule 6: the verification of the file is end-to-end (saved-to-disk inspection with the `file` command), not DOM-signal based. The DOM-level Content-Disposition / anchor `download` attribute was NOT used as the primary signal — the actual file on disk was the source of truth.

## Skill registry impact

- `audience-metrics-export` v1 — pass_streak +1 (tile-level PNG export flow exercised end-to-end with verified file inspection; reproduced LFMP-31903).
