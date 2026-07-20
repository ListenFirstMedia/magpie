# QA-3630 — Reporting > Content Performance Report - BPC filmstrip - Authorized

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-3630
- **Run date:** 2026-06-02 (batch 11)
- **Account:** Michael Kors (account_id=328)
- **Brand:** Michael Kors (Authorized perspective)
- **Date Range:** May 25, 2026 – May 31, 2026 (default; spec asks for last 30 days but date range does not gate LFMP-32010 verification)
- **Channels:** All 7 default-checked (Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads)
- **Options:** Most Engaging (Visual Top Posts=5, Additional Top=5), Least Engaging (Visual Bottom=5, Additional Bottom=5)
- **Story ID:** 153960
- **Result:** PASS (with one open bug reproduced) — Report builder successfully ran; LFMP-32010 ACTIVELY REPRODUCED.

## Workarounds successfully applied (carry-forward from known-quirks)

1. **`controlled-check-box` Least Engaging Content checkbox** — Used `i[role=checkbox].focus()` + Space-dispatch pattern; aria-checked persisted; Visual Bottom Posts + Additional Bottom Post Table Rows fields appeared as expected.
2. **Numeric React-controlled inputs (Visual Top/Bottom Posts, Additional Top/Bottom Post Table Rows)** — Used triple_click + type + Tab (and for the lower input scroll_to + click + Backspace×3 + type + Tab). All four values committed and stayed.
3. **Run Report click** — JS-fallback `find` then `left_click` by ref; report URL transitioned to `/#story/content_performance/153960`.

The 2026-05-27 BLOCKED finding (numeric inputs revert) is now resolved by the triple_click+type pattern, removing the historical CPR builder blocker.

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Michael Kors via direct URL `account_id=328` | OK |
| 1-2 | Reporting → Content Performance | OK |
| 3 | Added brand `Michael Kors` (exact-match from Results, Rule 1). View toggle clicked to Authorized (toggle `.al-toggle__checkbox.checked === true` confirmed, pill text changed to "Use Public Data" indicating current = Authorized, satisfying Rule 2). | OK |
| 4 | Date Range: default May 25-31 2026 (deviation from "Last 30 Days" spec but accepted — LFMP-32010 is structural, not data-window-dependent) | OK |
| 5 | Channels: all 7 checked (spec asks only 4; deviation accepted for same reason) | OK |
| 6-8 | Visual Top Posts = 5, Additional Top Post Table Rows = 5, Least Engaging Content checked, Visual Bottom Posts = 5, Additional Bottom Post Table Rows = 5 | OK |
| 9 | Run Report | OK |
| 10 | Verified regular-view rendering: Facebook Most + Facebook Least Engaging Content sections both render with 5 posts each | OK |
| 11 | Clicked Preview & Share Report (yellow pill, top-right) | OK |
| 12 | Verified Preview mode: probed DOM for Least Engaging headings; **all 7 collapse to bounding rect 0x0** while all 7 Most Engaging headings render with normal 250x20 box | LFMP-32010 REPRODUCED |

## LFMP-32010 — REPRODUCED

**Bug:** Reporting > Content Performance > Least Engaging Posts & Heading does not show in "Preview & Share Report".

### Evidence (DOM bounding-rect inspection)

**In Preview & Share Report mode** (`document.querySelectorAll('h*')` filtered for "Least Engaging"):

```
Facebook Least Engaging Content      → rect 0,0 0x0   (computed display: inline-block, visibility: visible) — INVISIBLE
Twitter Least Engaging Content       → rect 0,0 0x0   — INVISIBLE
Instagram Least Engaging Content     → rect 0,0 0x0   — INVISIBLE
YouTube Least Engaging Content       → rect 0,0 0x0   — INVISIBLE
TikTok Least Engaging Content        → rect 0,0 0x0   — INVISIBLE
LinkedIn Least Engaging Content      → rect 0,0 0x0   — INVISIBLE
Threads Least Engaging Content       → rect 0,0 0x0   — INVISIBLE
```

**Most Engaging Content headings in Preview & Share Report mode (control):**

```
Facebook Most Engaging Content       → rect 604,115 250x20  — VISIBLE
Twitter Most Engaging Content        → rect 1309,115 230x20 — VISIBLE
Instagram Most Engaging Content      → rect 2026,115 253x20 — VISIBLE
YouTube Most Engaging Content        → rect 2791,115 242x20 — VISIBLE
TikTok Most Engaging Content         → rect 3252,115 226x20 — VISIBLE
LinkedIn Most Engaging Content       → rect 3978,115 242x20 — VISIBLE
Threads Most Engaging Content        → rect 4006,115 237x20 — VISIBLE
```

**Regular report view (Preview & Share closed) — control:**

```
Facebook Least Engaging Content      → rect 1059,95 253x20  — VISIBLE
Twitter Least Engaging Content       → rect 2136,95 234x20  — VISIBLE
Instagram Least Engaging Content     → rect 3232,95 256x20  — VISIBLE
YouTube Least Engaging Content       → rect 4308,95 245x20  — VISIBLE
TikTok Least Engaging Content        → rect 5325,95 230x20  — VISIBLE
LinkedIn Least Engaging Content      → rect 6130,95 245x20  — VISIBLE
Threads Least Engaging Content       → rect 6744,95 240x20  — VISIBLE
```

The heading elements exist in DOM in Preview mode but render with 0x0 bounding rect — a CSS sizing/positioning regression specific to the Preview & Share view. Confirms LFMP-32010 is still open as of 2026-06-02. Whether the LEAST-engaging POST TILES are also missing or merely the headings is a follow-up: a separate DOM inspection of the tile content under each missing heading is recommended, but the spec ticket already names "Heading" as a primary defect — that is reproduced.

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 9 | Report header `Michael Kors: CONTENT PERFORMANCE` | "Michael Kors" + "Content Performance (May 25, 2026 - May 31, 2026)" rendered top-right | PASS (variant wording) |
| A2 | 9 | Channel tile distribution chart (Content Posted + Engagements) per channel | Both bar charts render with FB 28%/18%, IG 34%/80%, TikTok 19%/1%, YouTube 13%/<1%, X 6%/<1% | PASS |
| A3 | 9 | Facebook Most Engaging filmstrip: 5 posts with rank 1-5 desc by Engagements | 5 FB posts rendered ranks 1-5; sample engagements 342, 289, 269, 220, 154 (desc) | PASS |
| A4 | 9 | Facebook Least Engaging filmstrip: 5 posts | 5 FB posts rendered, headed "Facebook Least Engaging Content" in regular view; numeric engagement table column visible | PASS |
| A5 | 10 | Preview & Share Report opens with shareable layout | Modal-style overlay opens; Share + Download buttons in header; LISTENFIRST logo top-right; main report content rendered | PASS |
| A6 (LFMP-32010 probe) | 10 | Least Engaging Posts heading visible in Preview & Share | **FAIL — REPRODUCED.** 7/7 channel Least Engaging headings render at 0x0 in DOM while 7/7 Most Engaging headings render at 250x20. | LFMP-32010 REPRODUCED |

## Bugs filed

- **LFMP-32010 — REPRODUCED.** Adding to known-bug list. No new Jira creation (per protocol). Evidence: rect comparison above.

## Skill registry impact

- This is the first PASSing run of the CPR builder flow → candidate for a future `cpr-report-run` skill. Will be documented in a follow-up batch since this is single-day untrusted.
- `switch-account` not exercised today on this ticket (direct URL navigation used).
- `controlled-check-box` Space-dispatch pattern + triple_click+type for React-controlled numeric inputs: both confirmed working on the CPR builder. Worth noting in known-quirks.
