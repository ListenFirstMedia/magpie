# QA-43914 — Facebook User Accounts Radaac Report — 2026-06-13

- **Env:** Dev (radaac.lfmdev.in) · **Result:** 🚫 BLOCKED (safety) — Radaac requires Cognito SSO login; credentials not entered

## Rationale
- Like QA-43915 (Ads Account IDs Radaac), the Facebook User Accounts Radaac report lives on `radaac.lfmdev.in` behind Cognito SSO (`auth.lfmdev.in`). Per safety policy I do not authenticate / enter credentials, and the Chrome MCP cannot act on the Radaac/Cognito domain. Report flow not reachable.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Radaac FB User Accounts report download | file downloads | NOT REACHED — Cognito login gate | 🚫 BLOCKED |

## Bugs filed
_None._ (LFIQA to run while authenticated to Radaac; cf. LFMP-30870 Radaac export family.)
