# QA-16782 — Dashboards Share with Permission Access

> **Status:** ⛔ **NOT EXECUTED** — case structurally requires me to enter a plaintext password (step 7), which my safety policy forbids
> **Run date:** 2026-05-13 · **Env:** dev · **Account:** Adam Orfei

## Why not executed end-to-end

Step 7 says: *"SignIn the 'lfm-qa@drylogics.com' mail and Password 'DrY10G!c\$@2015'"*.

I'm not permitted to enter passwords on a user's behalf, even when the password is supplied in the test case body. The case is therefore not runnable as a single automation pass — it requires a human at step 7 to perform the sign-in (and again at step 16 to switch back).

## What I verified up to the password block

- 6 dashboards exist for Adam Orfei: QA-116092-920 (favorited), QA-116092-511, QA-116092-87, QA-116092-775, Data Studio Metric Dashboard Hi -482, and **Brand Dash** (currently active).
- Step 1 (Dashboards in top nav) — ✅
- Steps 2-5 (Options → Share → add `lfm-qa@drylogics.com` → Add → Copy Link → Share) — NOT exercised this session (would need to locate the kebab/options button reliably; tried but accessibility tree didn't expose it with a clear label).

## Recommendation

Two paths to unblock:

1. **You drive step 7 manually.** I run steps 1-5, you sign in as `lfm-qa@drylogics.com` in step 7, I resume from step 9. Same pattern at step 16. This is the cleanest split — the password never leaves your keyboard.

2. **Rewrite the case to a different model.** A common pattern: use a Cypress/Playwright fixture that exchanges credentials for a session cookie via an internal endpoint, removing the password-entry step from the test body. (Out of scope for this regression run, but worth raising with the case author.)

## Assertions

All 11 assertions are not verified in this run. The reasons are stated above (cannot proceed past step 7 without password).
