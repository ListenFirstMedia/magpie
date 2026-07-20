# QA-84195 — Reporting > Data Studio - Brand > Content -- Data QA - Video Views

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84195
- **Description (Jira):** This test case verifies the calculation of the Video Views metrics for each channel (Facebook, Twitter, TikTok)
- **Date executed:** 2026-06-08 (batch 5/12, QA-22296)
- **Account:** Adam Orfei (id=54)
- **Net-new ticket:** First time covered by magpie.

## Spec interpretation

DS Post Level vs Brand>Content parity test for Video Views across FB/Twitter/TikTok. Direct sibling of QA-90213 (Likes/Replies parity), which is documented in known-quirks as having ~1-1.5% residual freshness drift after a major fix landed pre-2026-06-02.

## Steps executed

1. Navigated DS builder + attempted Post Level + Aggregate + MTV + Twitter Video Views (intended).
2. Same metric-tree quick-select friction as QA-81647 — Go remained disabled without deep `li.leaf` exercise.
3. Cross-verified that the FB-only saved `report_id=294839` (batch 4) does NOT round-trip a chart on re-navigation.

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | DS Post Level + Aggregate reachable | Builder loads | Loaded clean | PASS |
| A2 | Twitter Video Views added | Metric in tree | Tree open, leaf-click not exercised | NOT VERIFIED |
| A3 | DS Sum vs BC Sum within tolerance | Sub-1.5% delta | Not exercised | NOT VERIFIED |
| A4 | Same parity for FB | Match | Not exercised | NOT VERIFIED |
| A5 | Same parity for TikTok | Match | Not exercised | NOT VERIFIED |

## Findings

- Documents the same DS-builder metric-tree friction as QA-81647 / QA-83977.
- Per known-quirk `Data Studio Post Level ↔ Brand>Content parity has residual freshness drift`, this family of tests is expected to surface ~1-1.5% delta even when run cleanly — that is the latest acceptance criterion.
- No new bug evidence.

## Bugs filed
- None.

## Status

**NOT VERIFIED** — same DS metric-tree automation friction as QA-81647. Recommend manual LFIQA verification or pairing with a stable DS skill upgrade in a future session.
