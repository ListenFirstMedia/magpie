# QA-567 — Facebook Lifetime Private Data QA

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account (precondition):** Hulu

## Verdict: FAILED (blocked by open bug)

## Reason — open linked bug (Rule 7: open-bug auto-fail)
Compact open-bug screen returned one **OPEN** linked defect:

- **APPS-58817** (Bug, status **Open/To Do**) — "Brand Content - Posts deleted from Native are still visible in LF app." Repro is on **Account Hulu / Brand Hulu / Facebook / Brand Content** — the exact surface this test exercises (Brand > Content, Hulu, Facebook channel, post table).

Per the open-bug auto-fail rule, a case with any open linked bug is marked FAILED (blocked) **without running**, until the bug is closed. APPS-58817 directly affects the post set this case compares (post counts / per-post data on Brand Content), so it would contaminate assertions A11 (post-count match) and A8/A10 (per-post data match).

## Not executed
Steps not run. Note also this case's precondition requires **dev in one browser + stage in another** (cross-environment dev-vs-stage comparison), which the current single-environment (dev `app.lfmdev.in`) harness cannot satisfy — a secondary blocker independent of the bug.

## Bugs filed
None (APPS-58817 already exists and is open).
