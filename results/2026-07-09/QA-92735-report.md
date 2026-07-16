# QA-92735 — Brand > Audience - LinkedIn - Basic View

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Priority:** Blocker (P1)
- **Account/Brand:** UCLA (account_id=799) · University of California, Los Angeles (brand_id=127756) · LinkedIn channel — the exact repro context from the linked bug.

## Verdict: FAILED (blocked by interfering open bug)

## Known bugs checked — INTERFERES
- **APPS-58574** — "Brand Audience - LinkedIn Channel - Cards are misaligned" — **OPEN / In Progress** (assignee Giriraj Singh Rathore) as of this run.
  - Reported: on UCLA LinkedIn Audience, the **first row of cards is misaligned** — one card on the first row, the remaining 3 wrap to a second row (expected: 4 cards aligned on the first row).
  - This maps **directly** to this test's assertions **A2** (first-row cards align on a single line) and **A4** (layout visually correct — no overlap/wrap). Those are the defining checks of this "Basic View — card layout/alignment" case.

Per the run's refined open-bug rule (block only when the open bug *interferes* with the assertions), APPS-58574 interferes with A2 and A4 → this case is blocked until the bug is closed.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | LinkedIn Audience page loads with cards rendered | UCLA audience view stayed in a skeleton/loading state — cards did not hydrate within budget (see note) | BLOCKED |
| A2 (probe) | First-row cards align on a single line | governed by **open** APPS-58574 (reported: cards wrap to a 2nd row) | FAILED (open bug) |
| A3 | Tile titles & counts correct (non-zero where data exists) | not verifiable — cards did not render | BLOCKED |
| A4 | Layout visually correct (no overlap/truncation/wrap) | governed by **open** APPS-58574 | FAILED (open bug) |

## Run notes
- Account switched to **UCLA (799)** for the repro (the bug and case name UCLA). Deep-link to the bug's exact URL (`brand_id=127756…channels=linkedin`) switched the account but did **not** hydrate the audience cards; a fresh UI-driven load (Brand → Audience) also stayed in a persistent skeleton state (10 loading placeholders, no `Total/Net/New Followers` labels) for UCLA. So the current live card geometry could not be measured this run.
- Because A2/A4 are owned by an **open** interfering bug, the verdict does not depend on the live measurement: the layout assertions cannot be certified while APPS-58574 is In Progress.

## Recommended re-test (after APPS-58574 closes)
On UCLA LinkedIn Audience: confirm the first row shows all 4 cards on a single line (A2), tiles carry correct non-zero counts (A3), and no wrap/overlap/truncation (A4). Re-run once the audience view reliably renders cards for UCLA.

## Bugs filed
None new — behavior is covered by existing **APPS-58574**.
