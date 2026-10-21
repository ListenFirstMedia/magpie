# QA-19710 — Brand Content - Pinterest Only: Basic - Current Date Range Data Test

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Sephora (655) · **Brand:** Sephora (7159) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Data set:** Pinterest Only: Basic (auto-selects Pinterest)
**Verdict: BLOCKED (test-data gap) — Sephora has 0 Pinterest pins in the current week, so there is nothing to add; the Ralph Lauren alternative could not be reached (the Ralph Lauren account opens on brand "Andrew Domink" with no Pinterest channel, and the brand typeahead returned no results for "Ralph Lauren" via keystrokes)**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Pin Saves + Comments = Engagements for each pin | **Posts (0)** on Sephora / Pinterest Only: Basic for Oct 11–17 2026 — no table rendered | 🚫 not evaluable |

## Notes
- The same identity was verified on the past-range sibling QA-20334 (62,031 pins, Jun 2024 – Jun 2025): it holds, with Pin Saves "–" on every pin (flagged there).
- For an unattended run this case needs either a brand that pins weekly or a "Last 30 Days" fallback in the spec.

Evidence: `.playwright-out/QA-19710/01-pinterest-basic.png`, `02-ralph-lauren-brand.png` · Known bugs: none open · Bugs filed: none · Cleanup: none.

## Retry — 2026-10-20 (second session; default week rolled to Oct. 12 – Oct. 18, 2026)
Sephora → Brand>Content (Posts 41 across channels) → Data Set **Pinterest Only: Basic** → channel auto-switched to Pinterest → **Posts (0)** again. Evidence: `.playwright-out/QA-19710/03-sephora-pinterest-retry.png`. Verdict unchanged: **BLOCKED** (no pins in the current week; the past-range sibling QA-20334 covers the identity on 62,031 pins).
