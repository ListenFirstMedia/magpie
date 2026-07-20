# QA-27292 — Brand > Content - Download CSV Template in Update Tag Modal — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018)
- **Result:** ✅ PASS (link + filename verified; content carry-forward) — consistent with 2026-06-05

## Steps
1. Brand>Content MTV → Tag dropdown → options: Bulk Tag / Upload Tags / Manage Tags.
2. Upload Tags → modal "Please use our CSV template to upload up to 5,000 rows" + Drag & Drop / Browse + **Download CSV Template** link + Cancel + Upload CSV.
3. Inspected the Download CSV Template anchor.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Modal renders with template download | Update Tag / Upload Tags modal + Download CSV Template link | All present (5,000-row note, Drag&Drop/Browse, Download CSV Template, Cancel, Upload CSV) | ✅ |
| Template filename | `LF Upload Tags Sample - Sheet1.csv` | Anchor href = `…/LF%20Upload%20Tags%20Sample%20-%20Sheet1.csv` (.csv, LFM host) | ✅ |
| Template content: 2-col (Post URL, Post Tag) + 8 sample rows | — | Content read CORS-blocked in-page (static asset); **carry-forward from 2026-06-05** (696 bytes, Post URL/Post Tag, 8 rows across 6 channels). No link/filename regression | ✅ (carry-forward) |

## Bugs filed
_None._
Note: in-page `fetch` of the static template asset is CORS-blocked and ~/Downloads isn't mounted, so byte-level content wasn't re-read this run; the link target and filename match prior verified content exactly.
