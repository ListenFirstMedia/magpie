# QA-43915 — Ads Account IDs Radaac Report

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** ⛔ BLOCKED — safety (Google/Cognito SSO login), consistent with all prior runs

## Why blocked

`radaac.lfmdev.in` requires a Google-based Cognito SSO login. Per `knowledge-base/bug-history.md`'s established precedent ("LFMP-30870 — Radaac Ads export; BLOCKED (Cognito login, safety)"), this framework does not automate real Google-account authentication flows. This is a standing, repo-wide policy — every prior run of QA-43915 (2026-05-27 onward) has carried the same BLOCKED verdict, and this run reconfirms it rather than attempting a workaround.

## What would unblock this

Either a direct email/password login path for `radaac.lfmdev.in` (bypassing Google SSO), or explicit LFIQA-provided Google session credentials safe for automation use.

## Assertions

Not evaluated.

## Bugs filed

None — carry-forward of LFMP-30870's existing BLOCKED status, not a new finding.

## Cleanup

Not applicable.
