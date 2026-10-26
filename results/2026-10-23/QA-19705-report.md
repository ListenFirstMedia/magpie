# QA-19705 — Brand Content - Twitter Only: Engagements & Follows DataSet - Current Date Range Data Test

**Run date:** 2026-10-23 (Friday) — unattended headless
**Verdict:** **FAILED (blocked by open bug)** — LFMP-32088

## Summary
Per spec-adherence Rule 7 (open-bug auto-fail), the case was not executed. No browser session was opened and no steps were run. The assertion is directly about the surface the open bug describes.

## Open-bug screen
| Source | Result |
|---|---|
| `cases/QA-19705.md` "Open linked bugs (as of 2026-10-19)" | LFMP-32088 (Bug, Open) |
| `results/open-bugs-2026-10-23.json` (refreshed snapshot) | `LFMP-32088 [Open] Brand > Content > Twitter Only: Engagements & Follows , User follows` — still open on 2026-10-23 |

## Steps executed
None (blocked before execution).

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic User Follows + Paid User Follows = User Follows in each grid post | Not evaluated: case blocked by open bug LFMP-32088 (title: "Twitter Only: Engagements & Follows, User follows") | FAILED (blocked by open bug) |

## Evidence
No screenshots (browser not opened). Bug status is taken from `results/open-bugs-2026-10-23.json`.

## Known bugs checked
- LFMP-32088 (Open): its title targets the exact dataset and metric this case asserts (Twitter Only: Engagements & Follows, User Follows). Auto-fail applies.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-19705 matches (pre-fetched).
- No skill pre-resolved for this flow. The case notes point to `brand-content-grid-math` for the eventual re-run.

## Bugs filed
None. No new defects found, and no Jira tickets are created from this run.

## Re-run guidance
Re-run once LFMP-32088 is closed and the cached "Open linked bugs" section is refreshed. Use the Friday row (Hulu account, Hulu brand), Table View, and scrape per-post Organic/Paid/User Follows via DOM.
