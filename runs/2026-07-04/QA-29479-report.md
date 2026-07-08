# QA-29479 — Dashboards - Share Dashboard via Email

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (headless, unattended)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-29479
- **Verdict:** **SKIPPED — external-user precondition (deferred)**
- **Open-bug screen (Rule 7):** "None open. Screen only — run normally." → screen passed; skip is on scope grounds, not an open bug.

## Why skipped (scope decision, made before opening the browser)

This case cannot be evaluated by the unattended Playwright track because **every assertion sits behind two out-of-scope gates simultaneously** — a second user identity *and* Gmail:

1. **Second-identity requirement (steps 6–8).** Step 6 signs out the current user; step 7 signs back in as **`lfm-qa@drylogics.com`** with its own password (`5gJ6;7Dry&My*kt1"Idc`) — a *different user identity* from the `config/.env` login. In-app account/brand switching changes account context for the *same* user; it cannot become a different login. Per the SCOPE RULES (EXTERNAL-USER / SECOND-IDENTITY), the flow must not be attempted and the timeout must not be spent exploring.

2. **Gmail requirement (step 9).** Step 9 opens Gmail in a new tab to read the shared-dashboard email, and step 10 clicks **View Dashboard** from inside that email. Gmail is a Google-auth surface and is explicitly out of scope (Google 2FA — never open gmail.com/docs.google.com).

There is **no in-scope, in-app assertion** to fall back on. Steps 1–5 (open the dashboard → Options → Share → add `lfm-qa@drylogics.com` → Share) are creator-side *setup only*; the spec attaches no assertion to them. All five assertions (A9 subject, A9 LF logo, A9 body text, A9 View Dashboard button, A10 dashboard opens) require reading the email as the recipient identity. With both the recipient identity and Gmail unavailable, none are evaluable.

Per SCOPE RULES: "do NOT attempt the flow. Immediately write the report with verdict 'SKIPPED - external-user precondition (deferred)' and stop." The browser was therefore not launched.

## Steps executed

None. Case skipped at scope-screening (before pre-flight/browser launch) per the external-user precondition rule.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A9 (subject) | 9 | Email subject: `[lfm-qa] (sender name) Shared a ListenFirst Dashboard With You` | Not evaluated — requires sign-in as `lfm-qa@drylogics.com` (2nd identity) + Gmail (out of scope) | SKIPPED |
| A9 (logo) | 9 | ListenFirst logo displays in email content | Not evaluated — same gates | SKIPPED |
| A9 (body) | 9 | Body: `Hi Automation Account, (Sender name) shared the Mail Testing Dashboard dashboard with you. Please click here to view it` | Not evaluated — same gates | SKIPPED |
| A9 (button) | 9 | View Dashboard button displays in email | Not evaluated — same gates | SKIPPED |
| A10 (open) | 10 | Clicking View Dashboard opens the saved dashboard | Not evaluated — requires 2nd-identity session + click from Gmail email | SKIPPED |

## Evidence

No screenshots — the browser was intentionally not launched (external-user precondition; do not spend the timeout exploring). Scope determination is based solely on the cached spec at `testcases/english/QA-29479.md`:
- Step 7 names a distinct login `lfm-qa@drylogics.com` (≠ `config/.env` identity).
- Step 9 requires opening Gmail.

## Bugs filed

None. A skip on precondition/scope grounds is not a product defect (cf. Rule 5 — do not file bugs from unmet preconditions; QA-91412 false-positive pattern).

## How to evaluate this case in future

Requires a two-identity harness: run the creator side as one identity (e.g. `config/.env` / Adam Orfei), then verify the email + View-Dashboard link as `lfm-qa@drylogics.com`. Options:
- Wire a Gmail MCP scoped to the **`lfm-qa@drylogics.com`** mailbox to verify A9 subject/logo/body/button on the actual delivered message (cf. the 2026-06-30 QA-27854 Gmail-MCP template-verification pattern — note the operator-mailbox caveat: the available Gmail MCP is authenticated to `yash.sharma@listenfirstmedia.com`, not the recipient mailbox, so it cannot read this email today).
- For A10 (dashboard opens on link click), a genuine second-identity browser session is needed to prove cross-user access.
