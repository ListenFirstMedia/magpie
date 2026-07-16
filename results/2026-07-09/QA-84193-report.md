# QA-84193 — Reporting > Data Studio - Brand > Content - Data QA - Engagements

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54) · Brand **MTV** (brand_id=4018) · window **May 27 – Jun 2, 2026**

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Parity result
| Surface | Engagements | Notes |
|---|---|---|
| **Brand > Content** (Sum, 92 posts, all channels) | **1,099,338** | Reactions 1,080,978 / Comments 6,420 / Shares 11,961 |
| **Data Studio — Post Level** (Aggregate, MTV) | **1,106,369** | per-day 226,444+329,459+65,729+25,761+6,418+279,052+173,506 |

**Delta = |1,106,369 − 1,099,338| / 1,106,369 = 0.64%** → within the ≤1.5% parity tolerance.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | DS Aggregate Engagements loads | 1,106,369 (Post Level) | PASS |
| A2 | Brand > Content Sum Engagements loads | 1,099,338 | PASS |
| A3 | \|DS − BC\| / max ≤ 1.5% | 0.64% | PASS |
| A4 | Match within tolerance OR document delta | within tolerance (0.64%) | PASS |

## Method notes / scope
- **Post Level is required** (not Page Level). Page Level "Engagements" is a *net/daily* metric (shows negative daily values, Sum 2,359,128) that does **not** match Brand Content. Switching to **Post Level** gave 1,106,369, matching the post-based Brand Content sum. (Documented for future DS parity runs.)
- Compared the **all-channel aggregate** on both surfaces (tight 0.64% total parity). Per-channel isolation (FB/TW/IG/TK individually) was **not** broken out — the near-exact aggregate match satisfies the parity intent and per-channel would need 8+ extra channel-toggle passes on both surfaces. The ~0.64% delta is consistent with the documented DS↔BC freshness drift.
- Perspectives: Brand Content read at Authorized (extended); DS Post Level default (public). Engagements is a public metric, so this doesn't affect the comparison — confirmed by the tight delta.

## Evidence
- `.playwright-out/QA-84193-bc-sumrow.png` (Brand Content Sum row), `QA-84193-ds-result.png` (DS Page Level), `QA-84193-postbuilder.png` (Post Level).

## Bugs filed
None.
