# QA-24544 — Reporting > TWC - Share Functionality

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-24544 · Priority: Blocker
- **Result:** **OUT OF SCOPE (not run)** — the case's payoff assertion requires signing in as a **different user** to verify the shared link; that cross-user login is out of scope on this track.
- **Precondition:** Adam Orfei

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] does not apply.

## Why out of scope
Steps 11–15 require:
- **Sign out** the current user (step 11),
- **Sign in** as `lfiqa@listenfirstmedia.com` / password `Testing@123` (step 12),
- Log into Adam Orfei, **paste the copied share URL**, and verify the **Shared Report displays** (step 14 — the key assertion),
- Sign out (step 15).

This is a **cross-user recipient verification**: it needs separate credentials and a full sign-out/sign-in, which would tear down the current authenticated session (storageState) on this Playwright track. Same class as the external-user / second-account cases deferred elsewhere (cf. QA-457 stage-env skip; account-switch ≠ user-switch). Not attempted to avoid destroying the session.

The **in-app share setup** (steps 1–10: build TWC for Michael Kors/Authorized/Instagram, Preview & Share, add recipient email row, Copy Link, Share → "You've successfully shared a report") is reachable in-app and could be spot-checked, but the case's verdict hinges on the recipient-side view (assertion 14), which is unreachable — so the case is recorded OUT OF SCOPE rather than partially executed.

## Next step
Re-run when a second-user login (`lfiqa@listenfirstmedia.com`) can be automated on the track (e.g., a separate browser context / storageState for the recipient), so the shared-link recipient view can be verified end-to-end.

## Bugs filed
None.
