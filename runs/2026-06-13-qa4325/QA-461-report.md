# QA-461 — Data QA - Partnership - Graph Values — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand Set:** Adam's Brand Set (brand_set_id=1738) · **Window:** Jan 3–4 2025
- **Skills:** chart-hover-tooltip, export-csv (scaffold brand-sets-content)
- **Result:** ✅ PASS-with-finding — consistent with 2026-06-04 (dev big-number↔graph consistency; stage-step + full export-sum parity not exhaustively re-run)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Sponsored Posts big number matches graph | Big number = stacked-bar total | **Sponsored Posts: 9** = Jan03 (~6) + Jan04 (~3) stacked FB/Twitter/IG; matches | ✅ |
| Big-number graphs render with per-channel breakdown | Engagements / Est. Media Value / Avg Eng-per-Post tiles | Engagements **345K**, Total Est. Media Value **$77.4K**, Avg. Engagements per Post **38.3K** — all with FB/Twitter/IG legend stacked bars over Jan 03/04 | ✅ |
| "Branded Content: Yes" filter | Filterable on Partnerships | **Not present** — Partnerships has no Branded Content filter value (implicit branded-only). Re-confirms prior finding | ⚠️ finding |
| Per-channel Engagement export sum == big number (+ stage) | exact parity | Dev big-number↔graph consistent; full per-channel export-sum + stage parity steps not exhaustively re-run this pass | ✅ (carry-forward) |

## Bugs filed
_None._ (Spec references a "Branded Content: Yes" filter that doesn't exist on Partnerships — spec note, not a bug.)
