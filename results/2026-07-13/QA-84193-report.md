# QA-84193 — Reporting > Data Studio ↔ Brand > Content — Data QA: Engagements

- **Run:** 2026-07-13 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84193
- **Skill reused:** `data-studio-post-level-run` (stable) + `brand-content-table-view` + `view-perspective-toggle` + `switch-account`
- **Verdict:** **PASS** — per-channel Engagements match **exactly** (0.00% delta, well within the 1.5% parity tolerance) across Facebook / Twitter / Instagram / TikTok.

## Configuration

- **Brand:** MTV (Rule 1 exact typeahead match — DS brand option `options-4018`; Brand>Content Public entity `brand_id=10765`, Authorized entity `4018`. The Public↔Authorized brand-entity swap is expected — see [[view-perspective-toggle]] / known-quirks.)
- **Account:** Adam Orfei (`account_id=54`). The run started on Michael Kors (`account_id=328`) where the DS brand typeahead returned **no results for "MTV"**; switched to Adam Orfei (spec precondition "Adam Orfei dev") via the LFQA menu → Search Account → Results row. MTV then surfaced.
- **Date window:** Absolute **May 27 – Jun 02, 2026** (7 days), set via the two-calendar Custom picker on both surfaces.
- **Perspective:** Public (DS brand-row View = Public `P` badge; Brand>Content toggle explicitly clicked to Public per Rule 2 — `perspective=standard`).

### Window-mode alignment (key finding)
Brand > Content **Content tab is Lifetime-only** — the "Mode: Lifetime" label has **no In-Window toggle** (`stat-mode-label` is a static label; clicking it opens nothing; `stats_attribution_window=lifetime` is fixed). Therefore the valid parity is **Lifetime ↔ Lifetime**. The DS side was run **twice**:
1. DS **In-Window** (report 302199) — the historical parity-protocol default; **does NOT align** with BC (BC has no In-Window mode).
2. DS **Lifetime** (report 302202) — the correct like-for-like comparison against BC Lifetime.

## Source 1 — Data Studio › Post Level (MTV, Public, May 27–Jun 02 2026)

Post Level Metrics: Engagements (rollup) + Facebook / Twitter / Instagram / TikTok Engagements. Metric checkboxes selected via trusted click on `.controlled-check-box` (fa-check-square verified).

| Metric | In-Window Sum (report 302199) | **Lifetime Sum (report 302202)** |
|---|---|---|
| Engagements (rollup) | 816,575 | 1,106,399 |
| Facebook Engagements | 39,278 | **49,310** |
| Twitter Engagements | 52,621 | **53,150** |
| Instagram Engagements | 697,412 | **903,270** |
| TikTok Engagements | 22,032 | **93,814** |

Per-row Σ(daily) = Sum verified (e.g. In-Window rollup 81,786+213,612+109,371+53,515+32,532+193,947+131,812 = 816,575). Evidence: `.playwright-out/QA-84193/ds-report.png` (In-Window), `.playwright-out/QA-84193/ds-lifetime-table.png` (Lifetime).

## Source 2 — Brand > Content › Content › Table View (MTV, Public, Lifetime, same window)

Channels FB/TW/IG/TK selected; Data Set = Public; Posts (88). Per-channel Engagements computed by reading all 88 rendered post rows (channel from `td.channel-icon i.fa-<channel>`, Engagements from column index 9) and summing per channel. The sum reconciles **exactly** to the on-screen aggregate **Sum row = 1,099,544** (evidence `.playwright-out/QA-84193/bc-tableview.png`).

| Channel | Posts | BC Lifetime Engagements Sum |
|---|---|---|
| Facebook | 19 | 49,310 |
| Twitter | 24 | 53,150 |
| Instagram | 24 | 903,270 |
| TikTok | 21 | 93,814 |
| **Total (4 channels)** | 88 | **1,099,544** |

## Parity comparison (DS Lifetime ↔ BC Lifetime)

| Channel | DS Lifetime | BC Lifetime | \|Δ\| | %Δ | Status |
|---|---|---|---|---|---|
| Facebook | 49,310 | 49,310 | 0 | 0.00% | MATCH |
| Twitter | 53,150 | 53,150 | 0 | 0.00% | MATCH |
| Instagram | 903,270 | 903,270 | 0 | 0.00% | MATCH |
| TikTok | 93,814 | 93,814 | 0 | 0.00% | MATCH |

Sum of the 4 DS per-channel values (1,099,544) = BC aggregate Sum (1,099,544) exactly. The DS rollup "Engagements" (1,106,399) is 6,855 higher because it also includes YouTube/LinkedIn/Threads/Pinterest engagements not in the 4-channel BC comparison — expected, not a discrepancy.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | DS Aggregate Engagements loads | Value renders | Rollup 1,106,399 + per-channel FB/TW/IG/TK all load (Lifetime) | PASS |
| A2 | BC Sum Engagements loads (per-channel) | Value renders per channel | Per-channel sums load; total 1,099,544 = on-screen Sum row | PASS |
| A3 | \|DS−BC\|/max ≤ 1.5% per channel | ≤1.5% FB/TW/IG/TK | 0.00% all four channels | PASS |
| A4 | Match within tolerance OR document delta | Match | Exact match all channels | PASS |

## Known bugs checked

- **bug-history.md (QA-84193):** 0 open bugs. Prior finding "BC Hulu side BLOCKED — cross-account redirect from Adam Orfei" — **not applicable** here: used MTV (reachable on Adam Orfei), so no cross-account block. The prior PARTIAL was because the BC side had never been reconciled; this run completes it.
- **Perspective-toggle brand fallback (known-quirk 2026-06-08):** REPRODUCED and handled — clicking the Brand>Content perspective toggle to Public swapped MTV `brand_id` 4018 → 10765 and dropped Threads/LinkedIn/YouTube from the channel set. This is the documented expected Public/Authorized entity swap; header still reads "MTV"; does not affect the assertions.
- **DS post-level Impressions require In-Window+Authorized (known-quirk):** N/A — this case is Engagements (public metric), available in both modes.
- **No new bug interfered with any assertion.**

## Bugs filed

None. Product behavior correct — Engagements reconcile exactly between Data Studio Post Level and Brand > Content when window modes are aligned (Lifetime↔Lifetime).

## Notes for framework

- **New reusable finding:** Brand > Content (Content tab) is **Lifetime-only** — no In-Window mode. For DS↔BC Engagements/Impressions parity, run DS in **Lifetime** to match BC (not In-Window). The historical QA-84193 protocol note ("use In-Window") produces a non-comparable DS number; In-Window matched BC only for Twitter (fast-accruing, short tail) and diverged badly for IG/TikTok (long engagement tails). Candidate quirk entry.
- **BC per-channel Engagements** are cleanly derivable from the Table View DOM (88 rows, non-virtualized) by grouping `td.channel-icon i.fa-<channel>` + the Engagements column, reconciled against the aggregate Sum row — avoids the flaky channel-selector isolation and the async CSV path.
