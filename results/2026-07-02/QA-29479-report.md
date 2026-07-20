# QA-29479 — Dashboards - Share Dashboard via Email

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-29479 · Priority: Critical
- **Result:** **OUT OF SCOPE / NOT RUN** — cross-user sign-in + Gmail email verification + saved-dashboard precondition.
- **Precondition:** Adam Orfei · **AND QA-14398 completed** (saved dashboard "Mail Testing Dashboard").

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Why not run
All of this case's assertions (9–10) are recipient-side / email:
- **Cross-user sign-in:** steps 6–8 sign out and sign in as **`lfm-qa@drylogics.com`** (a different account, with a given password), then log into Adam Orfei — a full session teardown + different-user login, out of scope on this track (same as QA-24544).
- **Gmail / email verification (out of scope):** step 9 opens **Gmail** to read the shared-dashboard email (subject "[lfm-qa] Shared a ListenFirst Dashboard With You", LF logo, body text, View Dashboard button) — email inbox is out of scope ([[email-export-scope]]).
- **Precondition dependency:** requires QA-14398 to have saved a dashboard named "Mail Testing Dashboard" first.

The in-app share-setup (steps 1–5: open dashboard → Options → Share → add recipient email → Share) is reachable, but every assertion depends on the recipient opening the emailed link as a different user — unreachable here.

## Next step
Re-run with: the "Mail Testing Dashboard" saved (QA-14398), a recipient browser context authenticated as `lfm-qa@drylogics.com`, and Gmail access for that inbox.

## Bugs filed
None.
