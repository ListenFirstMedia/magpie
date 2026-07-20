# QA-43915 — Ads Account IDs Radaac Report — 2026-06-13

- **Env:** Dev (radaac.lfmdev.in) · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (safety) — Radaac requires Cognito SSO login (session not active); credentials not entered per policy. LFMP-30870 carry-forward.

## Execution
- Navigated `radaac.lfmdev.in/` → redirected to Cognito `auth.lfmdev.in/login` (Sign-in: Corporate email / Sign in with Google / email+password). The SSO session is not currently authenticated.
- Per safety policy I do not enter credentials or complete SSO. Report flow not reachable this session.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1–A4 | Modal/description, filter inputs, file download `YYYYMMDDAdsAccountIds_<hash>.<ext>`, well-formed CSV | NOT REACHED — login gate | 🚫 BLOCKED |

## Open-bug verdict
- **LFMP-30870 (Closed→regression) — Ads Account IDs export failed to download:** **Carry-forward.** Reproduced on 2026-06-05 (page title flips to "Failed to process", CSV never lands). Not re-verifiable today without authenticating to Radaac. Prior REPRODUCED verdict stands; recommend LFIQA re-run while logged into Radaac.

## Cleanup
_None._
