# QA-4325 Re-run — Batch 2/12 — 2026-06-13

- **Env:** Dev · **Members:** QA-575, QA-581, QA-2062, QA-10387, QA-13903 (order 6–10) · Accounts: Hulu, Adam Orfei (UCLA, Sephora)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-575 | IG In Window Private Data QA | ⚠️ PARTIAL | Hulu dev IG Impressions render (Posts 40, all cols); stage parity N/A |
| QA-581 | Twitter In Window Private Data QA | ⚠️ PARTIAL | Hulu dev Twitter renders (Posts 51) after reload; Twitter skeleton-hang re-observed; stage N/A |
| QA-2062 | Pinterest Content - Post Hovering | 🚫 BLOCKED (attempt) | Loaded Sephora (30515) has no Pinterest channel; needs the Pinterest-enabled Sephora variant |
| QA-10387 | Insights Impression/VV Chart - PNG | 🚫 BLOCKED | Tile-PNG absent on consolidated Insights tile (carry-forward) + Insights renderer-hang risk |
| QA-13903 | Embedded Post Tooltip - LinkedIn | ✅ PASS | UCLA LinkedIn; embed tooltip renders video thumbnail + 476 reactions + 15 comments |

## Headline
- 1 PASS (QA-13903), 2 PARTIAL (dev-verified, stage N/A), 2 BLOCKED (Sephora-Pinterest variant + Insights tile-PNG/hang). No new product bugs.
- Twitter Brand>Content skeleton-hang re-observed (recovers on reload).

## Cleanup
- No mutations. Accounts traversed Hulu → Adam Orfei.
