# QA-90072 — Brand Content > Reels Data Set - LFM vs Native

**Run date:** 2026-11-18 (Wednesday)
**Track:** Playwright MCP, unattended headless (`claude -p`)
**Test Set:** QA-21686 "Daily Data Testing -3"
**Verdict: FAILED (blocked by open bug) — APPS-60871**

## Open-bug screen (spec-adherence Rule 7)
The case file's "Open linked bugs" section lists an OPEN bug, so per Rule 7 the case was **not executed** and the browser was never opened.

| Bug | Status | Summary | Source |
|-----|--------|---------|--------|
| APPS-60871 | Open | Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube) | `cases/QA-90072.md` (baked 2026-10-20) and `results/open-bugs-2026-11-18.json` (today's refresh, still Open) |

The bug affects Instagram metric rendering. This case compares Reel Reactions, Comments and Shares between LFM and the native post, so it is exposed to the bug. Per the open-bug auto-fail policy, no judgement is made on whether it interferes with the assertions.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1-6 | All steps | NOT RUN — blocked by open bug APPS-60871 |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | 6 | LFM metric values (Reel Reactions / Comments / Shares) show no big variation vs Native | Not evaluated (case not run) | ❌ FAILED (blocked by open bug APPS-60871) |

## Evidence
- None captured. No browser session was started and no screenshots exist under `.playwright-out/QA-90072/`.
- Open-bug map entry: `results/open-bugs-2026-11-18.json`, key `QA-90072`.

## Known bugs checked
- Linked bug APPS-60871 is Open as of 2026-11-18, which triggers the auto-fail.
- `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md` have no QA-90072 entries (pre-fetched shell-side).
- Re-runs will pick the case up automatically once APPS-60871 closes and the cache is refreshed.

## Bugs filed
None (markdown-only; no new bugs). The failure is attributed to existing bug APPS-60871.

## Cleanup
None (read-only Data Test; nothing created).
