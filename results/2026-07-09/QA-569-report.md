# QA-569 — Facebook In Window Private Data QA

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Hulu

## Verdict: SKIPPED

## Reason
Part of the dev-vs-stage **Private Data QA cluster** (QA-567/569/575/581) whose precondition requires "dev open in one browser and stage in another" — a cross-environment comparison the single-environment (dev `app.lfmdev.in`) harness cannot perform. Skipped as a group by user direction.

Additional confirmation of non-runnability: on Brand > Content for **Hulu** (current window), **every channel except Pinterest renders `channel-ghost … disabled warning`** (Facebook included) — the Facebook channel cannot be selected (page shows "Data Collection Status: 🔴 11"). So even the dev-side behavior isn't exercisable without a data window where Hulu Facebook is collecting.

## No open bugs
Compact open-bug screen for QA-569 → empty.

## Bugs filed
None.
