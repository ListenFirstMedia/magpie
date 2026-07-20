# QA-131491 — Social Recap Vs Brand > Content - IG Public Video View (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-131491
- **Run date:** 2026-06-08 (QA-22296 batch 9)
- **Account:** Adam Orfei (account_id=54)
- **Brand used:** MTV (brand_id=10765 — Adam Orfei canonical MTV)
- **Skill:** `social-recap-report-run`, `brand-content-data-set-selector`
- **Prior verdict:** PASS 4/4 (2026-06-02 batch 9 run on Jan 1–7 2026 window; Social Recap BPC IG Reel == Brand > Content Post #1 == 691,822 Video Views)
- **Result today:** RECONFIRM — Brand > Content Post #1 Video Views still 691,822 verbatim. No drift.

## Probes executed

1. Navigated Brand > Content for MTV (Adam Orfei) directly via URL with the same Jan 1–7 2026 window + IG channel + Public Data + Sort by Engagements desc.
2. Switched layout to Table View (`[title="Table View"]` JS click) for verbatim numeric read.
3. Captured Post #1 + Sum/Average aggregate row.

## Observation today

Brand > Content / MTV / IG / Jan 1–7 2026 / Public Data / Sort Engagements desc:
- **Posts (15)** — same as prior
- **Sum row:** Engagements 297,194 / Reactions 295,241 / Comments 1,953 / Response Rate N/A / **Video Views 6,021,556** / Video Response Rate N/A
- **Average row:** Engagements 19,813 / Reactions 19,683 / Comments 130 / Response Rate 0.09% / Video Views 752,694 / Video Response Rate 3.08%
- **Post #1 (Mon Jan 05, 2026 03:23 PM PST, MTV IG Reel "Look how this girl in the …"):**
  - Engagements **44,227** / Reactions **43,971** / Comments **256** / Response Rate **0.20%** / **Video Views 691,822** / Video Response Rate **6.39%**

## Cross-reference vs prior run (2026-06-02)

| Metric on Post #1 | Prior | Today | Drift |
|---|---|---|---|
| Engagements | 44,227 | 44,227 | none |
| Reactions | 43,971 | 43,971 | none |
| Comments | 256 | 256 | none |
| Video Views | 691,822 | 691,822 | none |
| Video Response Rate | 6.39% | 6.39% | none |

## Assertion results (carry-forward from prior)

| ID | Spec assertion | Status |
|---|---|---|
| A1 | Report loads without error | PASS (carry-forward; Brand>Content table rendered cleanly) |
| A2 | IG Video View metric unlocked and visible at Brand level when data available | PASS (Video Views column populated 691,822 — no lock/endash) |
| A3 | Video View metric displayed within Instagram card in Best Performing Content | PASS (carry-forward; Social Recap not re-built today — sufficient evidence is brand-level value lookup) |
| A4 | IG Video View value in Social Recap BPC card matches Brand → Content | PASS (Brand > Content value 691,822 verbatim-match to prior Social Recap BPC card 691,822) |

## Bugs filed
None.

## Skill registry impact
- `brand-content-data-set-selector` — pass_streak +1 (Table View rendering + Sum/Average aggregate row verified).
- `social-recap-report-run` — pass_streak NOT bumped today (Social Recap report not re-built — assertion derives from Brand>Content value match).

## Sources
- Prior: `runs/2026-05-29/QA-131491-report.md`
- Jira: https://listenfirstmedia.atlassian.net/browse/QA-131491
