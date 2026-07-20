# Regression Run — 2026-05-13

> **Status:** ✅ All assertions passed (3/3) — with 3 informational findings
> **App:** ListenFirst Platform · **Env:** dev · **Browser:** attached Work Browser (macOS)
> **Run kind:** Exploration (first run for this case) · **Cases:** 1 / 1

---

## At a glance

| Metric | This run | Notes |
|--------|---------:|-------|
| Cases run | **1** | QA-5757 |
| Passed | **1** ✅ | All three assertions PASS |
| Bugs | **0** 🐛 | — |
| Informational findings | **3** ℹ | See "Findings" below |
| Untrusted skills created | **4** | New skill files written — flagged for review |
| Stale-skill auto-updates | **0** | First run — no prior skills |

## Pre-flight

| Check | Status | Detail |
|-------|:------:|--------|
| App reachable | ✅ | `https://app.lfmdev.in` returned a logged-in Home page |
| Logged in | ✅ | Existing browser session was active |
| Switched to Hulu | ✅ | account_id=336, switched via My Profile → Search Account "Hulu" |
| Dashboard renders | ✅ | Welcome screen for account Hulu loaded |

---

## QA-5757 — Reporting > Google Sheets export - TWC

🟢 **PASS WITH FINDINGS**

Source: [QA-5757 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-5757)

### Test parameters used

| Parameter | Value | How chosen |
|-----------|-------|------------|
| Account | Hulu | per test case precondition |
| Brand | Hulu | test case said "Hulu (Public Data)"; no such brand exists in autocomplete. Per user, used plain "Hulu" — see Finding F1 |
| Perspective | Public Data | Default toggle position after selecting Hulu — confirmed by Perspective column = "Public" in exports |
| Date range type | Absolute Dates | Default tab |
| Date range | **2026-05-05 to 2026-05-11** | Default 7-day window (per user "by default 7 days are selected") |
| Data points | Facebook New Fans | Single metric, per test case example |

### Assertion results

#### A1 — Filename pattern ✅ PASS

Expected pattern: `Brand - Time Window Comparison - begin_date - end_date`

| Export | Actual filename | Result |
|--------|-----------------|:------:|
| Google Sheets | `Hulu - Time Window Comparison - May 5, 2026 - May 11, 2026` | ✅ |
| CSV | `Hulu - Time Window Comparison - May 5, 2026 - May 11, 2026.csv` | ✅ |

Both filenames substitute `Brand → Hulu`, `begin_date → May 5, 2026`, `end_date → May 11, 2026`, exactly as the pattern prescribes. The CSV adds the standard `.csv` extension; the Google Sheets tab title appends `- Google Sheets` (a Google Drive convention, not part of the file name).

#### A2 — Perspective column = "Public" ✅ PASS

Captured from both exports for all 7 rows:

| Row | Perspective (Google Sheets) | Perspective (CSV) | Match | Expected |
|----:|:----------------------------|:------------------|:-----:|:--------:|
| 1 | Public | Public | ✅ | Public |
| 2 | Public | Public | ✅ | Public |
| 3 | Public | Public | ✅ | Public |
| 4 | Public | Public | ✅ | Public |
| 5 | Public | Public | ✅ | Public |
| 6 | Public | Public | ✅ | Public |
| 7 | Public | Public | ✅ | Public |

All 7 rows in the Perspective column display `Public` exactly (text_equals after trim, case-sensitive). No whitespace, casing, or stray-character mismatches detected.

#### A3 — Google Sheets export matches CSV export ✅ PASS

Both exports captured and compared cell-by-cell:

**Headers (both files):**

```
Perspective, Brand, Date, Facebook New Fans
```

**Data rows (identical in both files):**

| # | Perspective | Brand | Date | Facebook New Fans |
|--:|:-----------:|:-----:|:----:|------------------:|
| 1 | Public | Hulu | 05/05/2026 | 6329 |
| 2 | Public | Hulu | 05/06/2026 | 4906 |
| 3 | Public | Hulu | 05/07/2026 | 2648 |
| 4 | Public | Hulu | 05/08/2026 | 1787 |
| 5 | Public | Hulu | 05/09/2026 | 1785 |
| 6 | Public | Hulu | 05/10/2026 | 2061 |
| 7 | Public | Hulu | 05/11/2026 | 3883 |

Comparison: **7 rows × 4 columns = 28 cells**, **0 mismatches**.

#### Bonus cross-source check (in-app table vs exports)

| Date | In-app table | CSV / Google Sheets | Match |
|------|------------:|--------------------:|:-----:|
| May 05, 2026 | 6,329 | 6329 | ✅ |
| May 06, 2026 | 4,906 | 4906 | ✅ |
| May 07, 2026 | 2,648 | 2648 | ✅ |
| May 08, 2026 | 1,787 | 1787 | ✅ |
| May 09, 2026 | 1,785 | 1785 | ✅ |
| May 10, 2026 | 2,061 | 2061 | ✅ |
| May 11, 2026 | 3,883 | 3883 | ✅ |

The in-app values display with thousands separators (`6,329`); the exports use raw integers (`6329`). After numeric normalization (strip commas, parse as integer), all 7 values match exactly. No backend/frontend drift detected.

---

## Findings (not bugs)

### ℹ F1 — Brand "Hulu (Public Data)" does not exist in autocomplete

**Category:** test_case_outdated · **Severity:** info

**Detail:** Step 4 of QA-5757 says to enter `Hulu (Public Data)` in the Add Brand by Name field. The autocomplete returns four Hulu variants — `Hulu`, `Hulu (Brazil)`, `Hulu (Japan)`, `Hulu (LATAM)` — none of which contain the word "Public". The brand was instead selected as `Hulu`, and the per-brand View toggle (which appeared after selection) defaulted to **Public Data**. The Perspective column in both exports correctly displays "Public", confirming that selecting `Hulu` with the default toggle position is functionally equivalent to what the test case author meant by "Hulu (Public Data)".

**Recommendation:** Reword the step to remove the misleading parenthetical:

> 4. In the Add Brand by Name field, enter `Hulu` and select the result. Verify the per-brand View toggle defaults to **Public Data**.

If the original intent was a different brand entity (e.g., a separate "Public Data" feed) that has since been merged into the primary `Hulu` brand, this should be confirmed with whoever authored the case.

### ℹ F2 — Logged-in user display is "Yash", expected `lfiqa@listenfirstmedia.com`

**Category:** user_identity · **Severity:** info

**Detail:** The top-right user name on the attached Work Browser session shows `Yash`. `credentials.md` indicates the expected test user is `lfiqa@listenfirstmedia.com`. This may be the display name for that account (some apps use first-name displays), or a different user is logged in on this browser profile. All test functionality worked, so this isn't blocking, but worth confirming so the report header has the right user identity going forward.

**Recommendation:** Either (a) the user confirms `Yash` is the display name for `lfiqa@listenfirstmedia.com` and we add a note to `credentials.md`, or (b) the user logs in as the intended test account on the Work Browser before subsequent runs.

### ℹ F3 — Brand autocomplete needs a programmatic input event

**Category:** automation_quirk · **Severity:** info

**Detail:** Typing into the "Search for a Brand" field via the Chrome MCP `type` action set the input's `value` but did not trigger the React typeahead's `onChange` handler. The dropdown only appeared after dispatching a native `InputEvent` on the field via JavaScript. A real user typing keys would not encounter this — it is automation-only friction. The skill `time-window-comparison-run` documents this quirk and uses programmatic dispatch as the canonical interaction for this field.

**Recommendation:** No product change needed. Document the pattern in `skills/_shared/network-patterns.md` or a new `automation-quirks.md` so future skills covering React-controlled inputs don't rediscover this.

---

## Skills created (all `trust: untrusted`)

These are first-run skills. Per the architecture, they're flagged as untrusted until 3 successful runs on separate days.

| Skill | Version | Purpose | Cases that use it |
|-------|---------|---------|-------------------|
| [`switch-account`](../../skills/switch-account/SKILL.md) | 1 | Open My Profile dropdown, search account by name, switch | Any case that requires a specific account |
| [`time-window-comparison-run`](../../skills/time-window-comparison-run/SKILL.md) | 1 | Navigate to Time Window Comparison report, add a brand, pick metrics, run | QA-5757 and future TWC tests |
| [`export-google-sheets`](../../skills/export-google-sheets/SKILL.md) | 1 | From a built report, trigger Google Sheets export and capture the filename + content | QA-5757 |
| [`export-csv`](../../skills/export-csv/SKILL.md) | 1 | From a built report, trigger CSV download and intercept the blob | QA-5757 |

The knowledge-base files `app-map.md`, `known-quirks.md`, and `skills/_shared/selectors.md` were also seeded from this run.

---

## Per-case telemetry

| Case | Status | Wall time | Tokens | MCP calls (approx) | Screenshots saved | Console errors | Network 4xx/5xx |
|------|:------:|----------:|-------:|-------------------:|------------------:|---------------:|----------------:|
| QA-5757 | ✅ | ~8 min | not measured this run | ~40 | 0 to disk* | 0 | 0 |

\* Screenshots were captured during the run for in-conversation verification but the Chrome MCP did not surface a disk path for the `save_to_disk` option in this session; subsequent runs will reattempt and the report's evidence folder will be populated. Since all assertions passed and we have full row-level data in both directions, the bug-evidence pattern (screenshot at point of failure) wasn't exercised.

Token & precise-time logging will be wired up properly in run 2 once the skills are in place and the exploration overhead is gone.

---

## Trend

This is run 1. Trends/comparisons begin from run 2.

## Bugs

None this run. See [bugs.md](bugs.md) for the (empty) bugs file and the format that future bug entries will follow.
