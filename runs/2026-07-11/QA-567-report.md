# QA-567 — Facebook Lifetime Private Data QA

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP track — `feature/playwright-mcp`)
- **Account:** Hulu
- **Skill:** brand-content-data-set-selector (stable)
- **Verdict:** **BLOCKED — stage environment not available on this track; dev-vs-stage parity assertions Not Evaluable**

## Summary

QA-567 is a **cross-environment parity** test: its precondition requires the user to have **dev
open in one browser and stage open in another**, and every numbered step / assertion compares
data on **dev** against data on **stage** (impressions, video views, post counts must match
between the two environments).

This Playwright MCP track has **no stage environment**. The only reachable app domain is
`app.lfmdev.in` (the framework's "dev"), and `config/.env` holds a single Cognito login for it.
There is no stage URL, no stage credentials, and no stage MCP configured anywhere. Because the
cross-environment comparison — the entire point of the case — cannot be performed, none of the
assertions (A8, A10, A11) are evaluable. Per Rule 1/3/5 I did **not** substitute a dev-vs-dev
comparison to manufacture a pass. The browser flow was not opened, since with no stage the verdict
is predetermined and running the dev half cannot yield a trustworthy PASS/FAIL (same budget
rationale as the open-bug screen).

This matches the prior run: `knowledge-base/bug-history.md` records the 2026-06-04 QA-4325 batch-2
attempt as **PARTIAL (dev-only; stage not accessible)**, and the sibling cases QA-569/QA-575 note
"Stage comparison NOT VERIFIED — dev only (same limitation as QA-567)."

## Environment evidence (why BLOCKED)

| Signal | Observed | Implication |
|--------|----------|-------------|
| `.mcp.json` | Single `playwright` server, base app `app.lfmdev.in` only; `--isolated --headless` | No stage browser/target |
| `config/.env` | `LFM_EMAIL` / `LFM_PASSWORD` for `app.lfmdev.in` Cognito only | No stage credentials |
| `config/env.md` | Domains: `app.lfmdev.in`, `app-reporting.lfmdev.in`, `domain-api.lfmdev.in` | No stage domain |
| `grep -i stage config/ .mcp.json` | Only hit: `staging/lf-regression` in `env.md` — a **git branch name** (the prior Chrome-MCP track), not a stage URL | No stage environment reference |
| `knowledge-base/bug-history.md` (QA-567) | "2026-06-04 QA-4325 batch-2 — PARTIAL (dev-only; stage not accessible)" | Same structural block, prior run |

## Steps

| # | Step | Executable on this track? | Notes |
|---|------|---------------------------|-------|
| 1 | Click Brand top nav, select Content on stage and dev | Partial (dev only) | Stage half impossible — no stage env |
| 2 | Type & select Hulu in brand dropdown on dev and stage | Partial (dev only) | Stage half impossible |
| 3 | Select Facebook channel only, Apply | Partial (dev only) | Stage half impossible |
| 4 | View Data Set dropdown → Impressions | Partial (dev only) | Stage half impossible |
| 5 | On **Stage** click Impressions | **No** | Requires stage environment |
| 6 | Compare Impressions data (dev vs stage) | **No** | Requires both environments |
| 7 | On dev Content, click Data Set dropdown | Yes (dev) | — |
| 8 | Select Video Views | Yes (dev) | — |
| 9 | On **Stage** Content, Data Set → Video Views | **No** | Requires stage environment |
| 10 | Compare Video Views data (dev vs stage) | **No** | Requires both environments |
| 11 | Compare posts (dev vs stage) | **No** | Requires both environments |

The steps that touch **stage** (5, 6, 9, 10, 11) are structurally impossible on this track, and
every assertion depends on them. The dev-only half (steps 1–4, 7–8) has no independent assertion to
satisfy.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A8 | 8 | Impressions data for posts in the dev date range match the data on stage for those posts | No stage environment reachable — comparison cannot be made | **Not Evaluable (BLOCKED)** |
| A10 | 10 | Video Views data match between dev and stage | No stage environment reachable — comparison cannot be made | **Not Evaluable (BLOCKED)** |
| A11 | 11 | Number of posts for each view matches between dev and stage | No stage environment reachable — comparison cannot be made | **Not Evaluable (BLOCKED)** |

## Known bugs checked

- **`knowledge-base/bug-history.md` (grep QA-567):** No open product defect linked. The only prior
  record is the 2026-06-04 dev-only **PARTIAL** limitation (stage not accessible) — an
  environment-access gap, not a product bug. Sibling cases QA-569/QA-575 carry the identical
  "stage comparison NOT VERIFIED" note.
- **Case file `## Open linked bugs`:** section absent from `testcases/english/QA-567.md` (case was
  cached without it). No open-bug auto-fail (Rule 7) triggered on that basis.
- **No new bug reproduced or observed** (browser flow not opened; block is environmental).

## Bugs filed

None. This is a test-harness/environment limitation (no stage environment on the Playwright MCP
track), not a product defect. Do **not** file a product bug (would repeat the QA-91412 wrong-config
false-positive pattern). Recommendation for the spec/harness owner: either provision a stage target
+ credentials for this track, or retarget QA-567 to a single-environment data-integrity check if the
dev-vs-stage parity is no longer the intent.

**Verdict: BLOCKED** — stage environment unavailable on the Playwright MCP track; dev-vs-stage
parity assertions A8/A10/A11 Not Evaluable. No substitution made (Rule 1/3/5).
