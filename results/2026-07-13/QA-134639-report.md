# QA-134639 — Brand > Insights: Export across Intervals, BRI Aggregation, and TWC Parity

- **Run date:** 2026-07-13
- **Harness:** Playwright MCP (branch `feature/playwright-mcp`), unattended headless (`claude -p`)
- **Account:** Adam Orfei (id=54)
- **Brand:** MTV (brand_id=4018)
- **Page:** Brand > Insights
- **Verdict:** **BLOCKED — Brand>Insights renderer hang / hard MCP-crash on the Playwright MCP harness**

## Decision summary

The case was **not executed against the live app** by deliberate choice. Navigating to
MTV Brand > Insights on the Playwright MCP harness is a **documented hard-crash trigger**. Per
`knowledge-base/known-quirks.md` (2026-07-10 update, authored during the prior QA-134639 rerun on
this exact branch):

> On the Playwright MCP harness, navigating to MTV Brand>Insights (`brand_id=4018`, default range)
> escalates beyond a timeout — it **fully disconnected/crashed the Playwright MCP server**: the
> `wait_for` timed out at 30s, then the next call returned "Connection closed" and **all
> `mcp__playwright__browser_*` tools dropped**. Recovery required the user to `/mcp` reconnect AND a
> fresh Cognito re-login (session lost). **Guidance for the Playwright-MCP harness: do NOT navigate
> to MTV Brand>Insights to fetch tiles — treat it as a hard MCP-crash trigger.** … This crashed the
> run twice in one session.

In an **unattended headless run there is no human to `/mcp` reconnect or re-authenticate**, so
triggering this crash would take down the automation server with no recovery path and would prevent
completion of this and any subsequent case. Honoring the explicit KB guidance, I did not open the
browser to the Brand>Insights surface. This is consistent with the 5-minute step budget's
"make-the-call" mandate and with the case's own Note that PARTIAL/blocked is acceptable when the
MTV-Brand>Insights hang reproduces and no non-MTV brand is viable.

## Known bugs checked

- **`bug-history.md` grep `QA-134639`** (line 2034+): prior run 2026-06-04 QA-4325 batch-12 was
  **BLOCKED** — renderer hang reproduced across 3 brands (MTV, Michael Kors, Tory Burch) on
  `channels=instagram` + Last 30 Days; CDP `Runtime.evaluate` 45s timeout each. Cross-cutting
  dev-stability finding: Brand>Insights renderer hang repeatedly froze the pipeline on MTV
  (cf. perf ticket APPS-55565).
- **`known-quirks.md` "Brand Insights … freezes … renderer"** (lines 509–523): the hang is
  long-standing and has broadened over time — from long ranges → Last 5/7 Days → single-channel →
  Threads-only → multi-channel Threads mixes → and now (2026-07-10) a **hard MCP-server crash on the
  Playwright track specifically for MTV Brand>Insights**. Prior guidance (2026-06-04) already said to
  *"Defer Brand>Insights heavy-export tests (QA-134639, QA-134188, QA-114845) to LFIQA real-browser
  verification when 3+ brands fail in a row."*
- **Case file "## Notes"**: explicitly warns long-range Brand>Insights freezes the renderer and that
  MTV-Brand>Insights specifically hangs across many configs per the QA-134188 batch-11 finding.
- **Rule 7 open-bug screen:** the cached case file has no `## Open linked bugs` section; treated as
  not-listed and would otherwise run normally. The block here is a harness-stability block, not an
  open-defect block.

## Why no substitute brand (Rule 1)

The spec names **MTV** (brand_id=4018) specifically. Substituting is barred by Rule 1, and in any
case the KB records that **Tory Burch (21648)** and **Michael Kors (12597)** Brand>Insights also hang
(2026-06-04 update), so there is no viable non-MTV brand on which the same assertions could be
verified. No substitution attempted.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Step 2 | Daily CSV exports successfully and per-day rows match UI | Not executed — MTV Brand>Insights navigation is a hard MCP-crash trigger on Playwright harness (known-quirks 2026-07-10); no headless recovery path | BLOCKED |
| A2 | Step 3 | Weekly/Monthly/Quarterly CSV exports successfully; aggregation = sum/avg per spec | Not executed — same crash trigger. Partial prior on-disk evidence exists (see below) but cannot be freshly reproduced this run | BLOCKED |
| A3 | Step 4 | BRI tile aggregation behavior verified (or BRI tile absent — document) | Not executed — BRI tile lives on Brand>Insights, the crash surface | BLOCKED |
| A4 | Step 5 | TWC equivalent values match Brand Insights export within freshness tolerance | Not executed — parity requires the Brand>Insights export side, which cannot be fetched; TWC-only numbers would have nothing valid to compare against | BLOCKED |

## Partial prior on-disk evidence (for context, not a PASS)

These were captured in earlier runs and are retained as cross-references; they do **not** satisfy the
assertions for this run because A1–A4 require fresh, same-session Brand>Insights + TWC-parity data:

- `.playwright-out/MTV-Insights-Total-Followers-2026-07-04-2026-07-10.csv` — a prior Insights
  Total-Followers export (Monthly-family), from QA-134188 runs.
- Interval-picker behavior (Daily/Weekly/Monthly/Quarterly selection, arrow-nav granularity,
  historical floors) is separately verified under `brand-insights-interval-picker` skill v2 via
  QA-134176 / QA-134182 / QA-134184 — but those exercise the *picker*, not the *export+aggregation*
  assertions of this case.
- Prior QA-134639 reports: `runs/2026-06-13-qa4325/QA-134639-report.md`,
  `runs/2026-06-02/QA-134639-report.md` — both BLOCKED for the same renderer-hang reason.

## Recommendation

Defer QA-134639 (and the sibling heavy Brand>Insights export cases QA-134188, QA-114845) to
**LFIQA real-browser manual verification**. The Brand>Insights renderer instability is an
environment/automation-harness limitation (heavy SVG/chart paint stalling the renderer, and on the
Playwright track crashing the MCP server) — it is **not a product defect for end users on real
browsers**. A perf ticket is warranted regardless (cf. APPS-55565).

## Bugs filed

None. This is a harness-stability block, not a newly discovered product defect. No new Jira tickets
created (markdown-only per framework). The existing Brand>Insights renderer-instability finding is
already captured in `knowledge-base/known-quirks.md` and cross-referenced to APPS-55565.
