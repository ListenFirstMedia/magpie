# QA-27854 — Bulk Import Tags Notification

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-27854 · Priority: Minor
- **Result:** **NOT RUN** — blocked on an unmet precondition; final step is out of scope.
- **Precondition:** Adam Orfei · **AND "Successfully completed QA-27290"** (a bulk tag CSV upload).

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Why not run
1. **Precondition dependency:** The case explicitly requires QA-27290 (Import Tags — a bulk tag CSV upload) to have been completed first. That upload is what generates the "Import Tags" notification this case inspects (bell → Notifications). QA-27290 was **not performed this session**, so there is no guaranteed fresh Import-Tags notification to verify (per test-case-first discipline, I won't assume/fabricate one). The bulk-upload is also a data-mutating action tied to a separate case.
2. **Email out of scope:** Steps 3–4 require opening the **Bulk Tagging email** in a new tab and reviewing its message body (Success/Failure templates). Email inbox is out of scope on this track ([[email-export-scope]]).

The in-app portion (assertions 1–2: the Import Tags notification's header/subheader/message + "download detail log" hyperlink, and its row in the Notifications table with blank New Status) is reachable **only if** a completed bulk upload has produced such a notification. Without the QA-27290 prerequisite this run, it can't be reliably verified.

## Next step
Run **QA-27290** (bulk tag upload) first, then re-run QA-27854 to inspect the resulting notification in-app (skip the email-review step per scope).

## Bugs filed
None.
