# QA-96045 — Settings > Data Identities - Instagram Threads

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS (with one assertion blocked by unavoidable third-party auth boundary)

## Steps executed

1. Settings → Data Identities (`#data-identities`).
2. Verified the **Channels (7)** list includes **Threads** with "2 AUTHORIZED USERS".
3. Clicked the **Threads** row → `#data-identities/threads` → **Authorized Users (2)** table rendered with columns Email, Data Feed, Identity, Created at, Last Updated, Access, Pages — both rows show `Data Feed: Threads Page (Authorized)`.
4. Clicked the **Authorize** button (top right) → a **"Log In"** confirmation modal appeared ("Please log in to verify your identity before authenticating").
5. Clicked **Login** → opened a new tab, redirected to `auth.lfmdev.in` (LFM's own Cognito identity boundary — same pattern as the documented Admin-auth gate, a separate identity check from the main app session). Logged in with the same LFM QA test credentials (`config/.env`) — this is LFM's own internal re-auth step, not a third-party platform credential.
6. Redirected back to `app.lfmdev.in/#data-identities/threads?authenticated=true&connectChannel=threads` → a **"Connect: Threads Account"** modal opened automatically ("Connect your brand's Threads account to access data.").
7. Clicked **Next** → navigated to the real `threads.com/login` OAuth page with `redirect_uri=https://accounts.lfmdev.in/users/auth/threads/callback`, `scope=threads_basic,threads_manage_insights,threads_read_replies`.
8. **Stopped here** — did not enter any Threads/Meta platform credentials (third-party social-media login, out of scope per safety policy, same boundary as the documented `admin.lfmdev.in` Cognito gate). Closed the tab.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 1 | Threads data identity is listed | "Threads" row present in Channels (7) list with 2 authorized users | ✅ PASS |
| 2 | Authorize CTA opens the Threads/Connect auth flow | Authorize → internal re-auth Login modal → LFM Cognito login → "Connect: Threads Account" modal → real `threads.com/login` OAuth URL with correct `client_id`, `redirect_uri` (`accounts.lfmdev.in/users/auth/threads/callback`), and scopes (`threads_basic`, `threads_manage_insights`, `threads_read_replies`) | ✅ PASS |
| 3 | Multi-select of feeds is available | **NOT VERIFIABLE** — the feed multi-select screen (if any) only renders after completing the real Threads/Meta OAuth login, which requires entering third-party platform credentials. Cannot proceed past this boundary per safety policy. The existing Authorized Users table does show a `Data Feed` column (`Threads Page (Authorized)` per row), consistent with a per-user feed model, but the actual multi-select UI during a fresh Connect flow was not reached. | ⚠️ NOT VERIFIED (auth boundary) |

## Finding

The Threads Authorize/Connect flow works correctly end-to-end up to the external OAuth handoff: internal re-auth → Connect modal → real `threads.com` OAuth URL with correct redirect/scopes. This mirrors the documented pattern for `admin.lfmdev.in` (separate Cognito identity boundary, not auto-passed from the main app session) — worth cross-referencing in `known-quirks.md` as the same architectural pattern applied to social-channel Connect flows. No product defect found; assertion 3 is a hard automation boundary (real third-party login), consistent with Rule advice to not enter external platform credentials.

## Bugs filed

None.

## Cleanup

Not applicable — no mutation occurred; the OAuth flow was not completed (no new authorization was created or altered).
