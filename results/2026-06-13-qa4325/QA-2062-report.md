# QA-2062 — Pinterest Content - Post Hovering — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand attempted:** Sephora (brand_id=30515)
- **Result:** 🚫 BLOCKED this attempt — Pinterest channel not available on the loaded Sephora brand variant

## Notes
- The "Sephora" brand selected (brand_id=30515) exposes only FB/X/IG/TikTok/YouTube in its channel bar — **no Pinterest channel** — so the Pinterest post-hover tooltip can't be exercised here. Posts table returns empty for this config.
- The prior PASS (2026-06-04) used a Pinterest-enabled Sephora variant (cf. QA-22296 QA-929 "Sephora Pinterest Only", ~85,832 posts) — a different brand_id. Re-run on that specific Pinterest-enabled Sephora brand to exercise the embedded Pinterest tooltip + the known blank-CDN-iframe quirk (rows 3/4 Pinterest embed stays blank — Pinterest-side restriction, not an LF bug).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Pinterest post hover tooltip | embed tooltip on Pinterest post type | NOT REACHED — Pinterest channel absent on loaded Sephora variant | 🚫 BLOCKED |

## Bugs filed
_None._ (Brand-variant/test-data selection issue, not a product bug.)
