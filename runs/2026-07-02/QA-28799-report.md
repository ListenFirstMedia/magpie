# QA-28799 — Settings > User > Create new user for Admin - Dev

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-28799 · Priority: Blocker
- **Result:** **OUT OF SCOPE / NOT RUN** — consequential data mutation (create + deactivate a real user) plus an external-tool (Dev Mixpanel) verification.
- **Precondition:** Adam Orfei

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Why not run
1. **Creates a real user account (data mutation):** steps 3–7 create a new user (Account: Drylogics, name, email, unique phone, job title) in the shared Adam Orfei account, then steps 9–10 **deactivate** it. Creating/deactivating a real user is a consequential write to shared account state — beyond the low-risk, test-intended mutations, and not something to perform without explicit approval. (Contrast QA-1677's tag creation, which was gated by an open bug anyway.)
2. **External tool — Dev Mixpanel (out of scope):** steps 11–13 / assertion 13 require **logging into Dev Mixpanel** (a separate third-party analytics product with its own credentials) to confirm "User Deactivated" appears in the Activity Feed and no duplicate user is created. Mixpanel is not reachable on this Playwright track.
3. Step 8 also uses the **Classic Admin** ("key" icon) Users page.

The in-app user-create/validate/deactivate flow (assertions 2, 3, 4, 7, 8, 10 — role dropdown defaults/options, invalid-email error, success prompts, classic-admin listing) is largely reachable, but gated by the user-creation mutation above; the case's terminal verification (13) is external.

## Next step
Run only with explicit approval to create/deactivate a throwaway user, AND with Dev Mixpanel access provisioned for the recipient-side verification.

## Bugs filed
None.
