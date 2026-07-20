# QA-121217 — Brand > Content - Instagram - Instagram Collaborator count - Export

- **Date:** 2026-06-08 (batch 8/12 QA-22296)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (spec brand_id=5670; URL auto-resolved to brand_id=11003)
- **Channel:** Instagram only
- **Perspective:** Public Data
- **Result:** BLOCKED (no IG collaborated post available on Hulu/Hulu LA brand to exercise icon+tooltip+export flow)

## Steps attempted

1. Switched account Adam Orfei → Hulu via Yash menu → Search Account "Hulu" Results click.
2. Navigated to Brand>Content with Hulu brand_id=5670, channels=instagram, Public, sentiment_mode=false.
3. URL settled at brand_id=11003 (Hulu LA sub-brand). Posts panel showed Brand Sentiment overview tiles instead of the post table (sentiment-mode auto-lock — likely from earlier Conversation visit affecting this brand_id).
4. Cross-checked: in all-channel mode for Hulu brand on 2024 year, 3,285 posts loaded; in IG-only channel filter, sentiment mode dominates the page regardless of explicit `sentiment_mode=false` URL param.
5. Filter Collaborated Total {1, 2, 3, 4, 5} sweep across Jun 2026 / 2025 / 2024 windows: all returned `Posts (0)` — Hulu/Hulu LA brand on this Hulu account does not surface posts tagged with IG collaborator counts.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | IG collaborator icon shown e.g. icon(1) on post | Could not verify — no IG post with collaborator on this brand/data window | BLOCKED |
| A2 | 6 | Tooltip count matches post collaborator count in Detail view | BLOCKED |
| A3 | 6 | Collaborated name displays in Detail view | BLOCKED |
| A4 | 7 | Table View "Collaborated" column shows icon + count | BLOCKED |
| A5 | 10 | Noted count matches CSV's IG collaborator count column | BLOCKED |
| A6 | 10 | CSV headers include: Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type, Post Link, Live, Publish Type, Paid, Sponsor Name, Sponsor Link, **Instagram Collaborator Count**, **Instagram Collaborator Name**, **Instagram Collaborator Link**, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views | BLOCKED |

## Notes
- Hulu on Hulu account (account_id=336) auto-redirects spec brand_id=5670 → 11003 (a sub-brand) which has zero IG posts tagged with Instagram Collaborator data in our verified date windows.
- Spec assertions A1-A6 fundamentally require at least one IG post with Collaborator metadata; without it the icon, tooltip, Detail/Table column behavior, and CSV column-population checks cannot be empirically verified.
- For LFIQA: re-run on a Hulu sub-brand with confirmed IG collaborator data (likely a US-Hulu authorized brand variant not currently on this dev account) is required to complete this case.
- CSV export pipeline mechanics themselves are independently confirmed working via the export-csv skill on Brand>Content CDS exports across batches 4, 8, 9 — but the specific Collaborator headers (cols 15-17) require IG-collaborator-present data to materially verify.

## Bugs filed
None (test BLOCKED — no implication of product defect).
