# QA-575 — Instagram In Window Private Data QA

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Hulu

## Verdict: SKIPPED

## Reason
Part of the dev-vs-stage **Private Data QA cluster** (QA-567/569/575/581) whose precondition requires "dev open in one browser and stage in another" — a cross-environment comparison the single-environment (dev `app.lfmdev.in`) harness cannot perform. Skipped as a group by user direction.

Additional confirmation: on Brand > Content for **Hulu** (current window), Instagram renders `channel-ghost instagram disabled warning` (all non-Pinterest channels disabled), so the Instagram channel cannot be selected to exercise the dev-side behavior either.

## No open bugs
Compact open-bug screen for QA-575 → empty.

## Bugs filed
None.
