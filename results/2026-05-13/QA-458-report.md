# QA-458 — TWC Report Relative Date Rates Data QA

> **Status:** 🟡 Dev side executed; **prod comparison deferred to manual review** (per user instruction)
> **Run date:** 2026-05-13 · **Env:** dev (https://app.lfmdev.in) · **Browser:** Regression Testing (attached)
> **User:** lfiqa@listenfirstmedia.com (display name **LFQA**) · **Account:** Adam Orfei (account_id=54)

---

## Execution summary

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Click Reporting in top nav | ✅ |
| 2 | Select Time Window Comparison | ✅ |
| 3 | Switch to Relative Dates tab | ✅ |
| 4 | Days interval (default) | ✅ |
| 5 | Start = 3 Days **Before**, End = 1 Day **After** Event | ✅ |
| 6 | Add brand `The Walking Dead` with Public Data perspective | ✅ (no `(Public Data)` variant exists — same as QA-5757; used base brand with default toggle) |
| 7 | Click Select Key Date on brand row | ✅ (new UI — captured in new skill `keydate-picker`) |
| 8 | Select Season 9 Episode 16 | ✅ (keydate resolved to **Mar 31, 2019**) |
| 9 | Enable all rate metrics + Avg Responses per Post | ⚠ **partial** (see finding F1 below) |
| 10 | Uncheck Show Metrics Graphs | ✅ |
| 11 | Check Show Share and Show Change | ✅ |
| 12 | Run Report | ✅ — story built at `/#story/time_window_comparison/152990` |
| 13 | Repeat on prod | ⛔ **not executed** (per user, deferred to manual validation) |

## Assertion results

| ID | Description | Status |
|---:|-------------|:------:|
| A1 | Dev data matches prod data cell-by-cell | ⏸ **DEFERRED** — full dev snapshot captured for manual prod compare |
| A2 | Show Share and Show Change columns present in tables | ✅ PASS — `Brand Share`, `Change`, `Change %` columns appear under each metric block |
| A3 | No graphs render when Show Metrics Graphs is unchecked | ✅ PASS — only data tables visible; chart-like DOM nodes = 2 (decorative icons, not data charts) |

## Data captured

- **52 data tables** extracted into [QA-458-dev-snapshot.md](QA-458-dev-snapshot.md) for prod compare.
- 13 unique rate metrics across Cross-Channel, Facebook, Twitter, Instagram, YouTube. TikTok had no rate metrics available for The Walking Dead.
- Each metric block contains four tables: base value, `Change`, `Change %`, `Brand Share` — confirming A2.

## Findings (non-bug, worth knowing)

### ℹ F1 — Metric-selection step is ambiguous; "Avg Responses per Post" doesn't exist as a metric

**Category:** test_case_outdated · **Severity:** info

Step 9 says: "select all rate data points and avg responses per post metrics."

Reality observed:
- **"All rate data points"** is not a discrete tree node. Filtering the metric tree by `Rate` returned **50 metrics** across two top categories (Audience & Growth: 8; Content: 42). For The Walking Dead on dev, **18 of the 50 were toggleable** — the other 32 were greyed out because the brand doesn't have data for those channel/metric combinations (e.g., LinkedIn Follower Growth Rate, Threads Fan Growth Rate). The 18 successfully enabled metrics produced the 52 captured data tables.
- **"Avg Responses per Post"** is not a metric in the tree. Filter searches for `responses per post`, `avg response`, `avg responses` returned no matches. Filtering by `per post` returned 13 unrelated metrics, all named "Average Engagements per Post" or variants. Filtering by `respon` returned 16 metrics — all `Response Rate` variants (which were already enabled via the "all rates" selection).

Two possible intents:
1. The author meant "all rate metrics" — already covered. The "+ avg responses per post" phrase may be a leftover or shorthand for additional Response Rate metrics that we did enable.
2. The author meant a specific metric named "Average Responses per Post" that has since been renamed or doesn't exist for this brand.

**Recommendation:** Rewrite step 9 as: "In the metric tree, filter by `Rate` and click 'On' at the top of both Audience & Growth and Content. Verify the counter shows N rate metrics enabled (the rest are inactive for The Walking Dead's channels)." That makes the step unambiguous and auditable.

### ℹ F2 — Test case wording: step 13 says "stage" but description/assertion say "dev and prod"

**Category:** test_case_wording · **Severity:** info

Confirmed with the user that **prod** is the intended compare target. Step 13's "stage" wording is a typo and should be updated in Jira.

### ℹ F3 — Recent Searches in profile dropdown does NOT trigger account switch

**Category:** known_quirk · **Severity:** info (already captured)

Re-observed during this run: clicking `Adam Orfei` from the Recent Searches section of the profile dropdown did not switch accounts. Only clicking from the `Results` section (after typing the name) works. The `switch-account` skill is already updated.

## Skills authored or updated this run

| Skill | Action | Why |
|-------|--------|-----|
| `keydate-picker` | **NEW** (v1, untrusted) | Captures the Season / Episode autoSelect flow for keydate-based reports |
| `time-window-comparison-run` | Bump to v3 | Add Relative Dates flow: `Start`/`End` days, `Before`/`After` direction, "Bulk Select Key Date" caveat, keydate per-brand requirement |
| `switch-account` | Bump to v2 | Document that Recent Searches click is a no-op for account switch (was a brand-picker-only caveat in v1) |

## Per-case telemetry

| Metric | Value |
|--------|------:|
| Wall time (approx) | ~12 min |
| MCP calls | ~50 |
| Story ID | 152990 |
| Tables captured | 52 |
| Cells captured | 520 |
| Console errors | 0 |
| Network 4xx/5xx | 0 |
| Tokens | not measured this run |

## What you need to do next (manual)

1. Open prod (URL TBD) in a tab.
2. Sign in as the same test user (LFIQA).
3. Switch to **Adam Orfei** account.
4. Repeat steps 1–12 in the report exactly. Use the same Start=3 Before / End=1 After / Season 9 Episode 16 keydate.
5. Compare prod's 52 tables against the dev snapshot in [QA-458-dev-snapshot.md](QA-458-dev-snapshot.md). Any cell mismatch is a parity bug — file it with both the prod and dev story URLs and the offending metric/day cell.

If you ever decide to give me prod access, I can do the whole comparison end-to-end in one run.
