# QA-27856 — Notification Modal - Import Tags Notification Download Detail Log

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-27856 · Priority: Minor
- **Result:** **NOT RUN** — unmet precondition + email/download-log steps out of scope.
- **Precondition:** Adam Orfei · **AND "Successfully completed QA-27290"** (bulk tag CSV upload).

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A.

## Why not run
- **Precondition dependency:** requires QA-27290 (bulk tag upload) completed first to produce the Import-Tags notification + its "results.csv" detail log. Not performed this session (data-mutating, separate case) — no guaranteed notification to inspect.
- **Email / detail-log out of scope:** steps 3–4 open the **Bulk Tagging email** and click its "Download Detail Log" button; the notification-modal "download detail log" also delivers a CSV. Email inbox is out of scope ([[email-export-scope]]); the notification-side CSV download depends on the same missing prerequisite.

Same class as QA-27854 (its sibling). The in-app notification-modal check (header "Import Tags", subheader date/time, "LF Upload Tags.csv…" message, hyperlinked "download detail log", results.csv columns Post URL/Social Channel/Tags/Error) is only reachable after a completed bulk upload.

## Next step
Run **QA-27290** (bulk tag upload) first, then re-run QA-27856 to verify the notification modal + detail-log CSV in-app (skip the email step per scope).

## Bugs filed
None.
