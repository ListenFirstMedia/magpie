# QA-581 — Twitter In Window Private Data QA

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account (precondition):** Hulu

## Verdict: FAILED (blocked by open bug)

## Reason — open linked bug (Rule 7: open-bug auto-fail)
- **LFMP-32095** (Bug, status **Open/To Do**) — "Brand > Content: Twitter Impression data for 27 May 2026 is not displaying." Repro: Brand > Content, Twitter channel, impression data missing on a post (with duplicate-post artifacts). This is exactly the surface QA-581 tests (Twitter, Brand Content, **Impressions** private-data comparison), so it would contaminate assertions A10 (impression data match) and A13 (post-count match).

Per the open-bug auto-fail rule, marked FAILED (blocked) **without running** until LFMP-32095 is closed.

## Secondary blocker
Precondition requires **dev in one browser + stage in another** (cross-environment comparison); the single-environment dev harness cannot satisfy the stage-parity assertions regardless.

## Bugs filed
None (LFMP-32095 already exists and is open).
