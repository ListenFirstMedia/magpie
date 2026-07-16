# QA-84194 — Reporting > Data Studio ↔ Brand > Content — Data QA: Twitter Impressions

- **Run:** 2026-07-13 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84194
- **Skill reused:** `data-studio-post-level-run` (stable) + `brand-content-data-set-selector` (stable) + `view-perspective-toggle`
- **Verdict:** **PASS**

## Summary
Twitter-Impressions parity between Data Studio Post-Level and Brand > Content. With both surfaces set to the **same brand (Hulu, brand_id 5670), Authorized perspective, In-Window mode, and window May 27 – Jun 02 2026**, the Twitter Impressions Sum is **identical (700,804)** on both sides — 0% delta, well inside the 1.5% tolerance.

## Preconditions
- Logged in via config/.env (lfiqa@listenfirstmedia.com), pre-flight OK (`#home`).
- Session switched to the **Hulu** account (account_id=336) via the LFQA account switcher (Results row, not Recent Searches) so both DS and the account-scoped Brand > Content resolve on the same brand. Brand > Content stayed on brand_id=5670 (no 5670→11003 redirect this run).

## Steps executed
1. Reporting → Data Studio → **Post Level**.
2. Window Mode → **In-Window** (required — Impressions metrics are greyed under Lifetime, per known-quirks).
3. Date Range → **Custom → May 27 2026 – Jun 02 2026** (two independent calendars; left→May click 27, right→June click 2, Ok).
4. Add a Brand → typed "Hulu" → selected the **exact "Hulu"** Results option (Rule 1).
5. Brand row View toggle → **Authorized** (clicked the switch `label[for="1"]`, not the text — Rule 2; verified checkbox `checked=true`).
6. Select Metrics → tree → **"Twitter Post Impressions"** (the only Twitter-specific Impressions leaf; internal key `twitter-paid-insight-total-impressions`). Checkbox flipped to `fas fa-check-square`.
7. **Go** → report_id=302305. Read the data table.
8. Brand menu → **Content** (brand_id=5670) → set `from=2026-05-27&to=2026-06-02`, `channels=twitter`, `perspective=extended`; verified perspective toggle `checked=true` (Authorized) and header "May. 27, 2026 - Jun. 02, 2026".
9. Data Set selector → **Impressions** (cross-channel). Read aggregate Sum under Lifetime, then switched **Select Mode → In Window** to align with DS and re-read.

## Evidence

### Data Studio Post-Level (In-Window, Authorized)
| Metric | Brand | Sum | Average | May 27 | May 28 | May 29 | May 30 | May 31 | Jun 01 | Jun 02 |
|---|---|---|---|---|---|---|---|---|---|---|
| Twitter Post Impressions | Hulu | **700,804** | 100,115 | 2,314 | 15,612 | 42,334 | 112,432 | 10,287 | 408,372 | 109,453 |

- Σ(daily) = 2,314+15,612+42,334+112,432+10,287+408,372+109,453 = **700,804** = Sum ✓; Average 700,804/7 = 100,114.9 ≈ 100,115 ✓
- Screenshot: `.playwright-out/QA-84194/ds-twitter-impressions.png`

### Brand > Content (Twitter channel, Authorized, Impressions data set)
Aggregate Impressions column (`Impressions` = Organic + Paid), Posts (21):

| Select Mode | Impressions Sum | Organic | Paid | Avg |
|---|---|---|---|---|
| Lifetime | 929,689 | 929,689 | – | 44,271 |
| **In Window** | **700,804** | 700,804 | – | 33,372 |

- All 21 posts are Hulu Twitter (t.co / "X Thread") posts published within the window.
- Screenshot (In-Window): `.playwright-out/QA-84194/bc-twitter-impressions-inwindow.png`

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | DS Post-Level Twitter Impressions | value loads | 700,804 (Σdaily reconciles to Sum) | PASS |
| A2 | Brand > Content Twitter Impressions Sum | value loads | 700,804 (In-Window) | PASS |
| A3 | \|DS − BC\| / max ≤ 1.5% | ≤ 1.5% | \|700,804 − 700,804\| / 700,804 = **0.0%** | PASS |

## Methodology note (parity requires matching window mode)
Impressions are window-dependent. DS Post-Level Impressions are only selectable under **In-Window** (greyed under Lifetime — known-quirks 2026-06-13). Brand > Content defaults to **Lifetime** attribution (929,689). Comparing DS In-Window (700,804) against BC Lifetime (929,689) yields a spurious 24.6% gap. Aligning BC to **In Window** makes them identical. The parity check is only meaningful with the same Select Mode on both sides.

## Observation (non-blocking, not filed)
On Brand > Content, after switching Select Mode to **In Window** (radio `value=in_window` `checked=true`, and the data correctly changed 929,689 → 700,804), the small `.stat-mode-label` still read **"Mode: Lifetime"**. Cosmetic/stale-label only — the underlying data and radio reflect In-Window. Not a functional defect; flagged for eng, not filed.

## Known bugs checked
- Case "Probes / Open linked bugs": **None linked.** (Rule 7 screen passed.)
- `knowledge-base/bug-history.md` grep QA-84194: prior run 2026-06-04 batch-6 was **PARTIAL** ("Twitter Impressions requires Authorized perspective; toggle flip incomplete in run window"). This run completed the Authorized toggle **and** aligned In-Window mode → clean PASS. Not a regression; the earlier PARTIAL was an incomplete-setup artifact, now resolved.
- Applied known-quirk: DS post-level Impressions require In-Window + Authorized (2026-06-13) — held exactly.

## Bugs filed
None.
