# QA-2035 — Brand Sentiment - CSV & GS

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2035 · Priority: Blocker
- **Result:** **OUT OF SCOPE (not run)** — every assertion depends on the emailed CSV file or the Google Sheet; there are no in-app-only assertions to verify.
- **Precondition/brand:** MTV
- **Skills:** (n/a) — would use brand-content sentiment + export flow

## Linked bug scan
41 linked issues, **all Closed** — no open blocker (so the [[open-bug-auto-fail]] rule does not apply here).

## Why out of scope
Brand Sentiment export is delivered **asynchronously by email** (CSV) and via **Google Sheets** — both unreachable on this Playwright track (inbox + Google 2FA), per [[email-export-scope]]. This case's assertions are **entirely** about the emailed artifact:
- CSV filename `Brand-Tab-YYYY-MM-DD-YYYY-MM-DD-comments-sentiment.csv`
- CSV columns: Comment Classified, Comment Emotion, Topics
- Date range shown in export; Date `MM/(D)D/YYYY`; Day of Week `DOW`; Time `HH:MM XM PST`
- GS data matches CSV data

Steps 1–5 (Brand>Content → MTV → Sentiment → Sentiment Export → OK) merely trigger the emailed export; there is no in-app data-set/enablement assertion to verify (unlike QA-1519). The in-app Sentiment mode + "export queued" notification flow is already confirmed working in prior runs (QA-111242 / QA-111243). With no in-app assertion coverage and the file/GS out of scope, the case is recorded as OUT OF SCOPE rather than executed.

## Next step
Re-run once emailed-CSV/Google-Sheets verification is available on the track (e.g. Gmail access for lfqa@listenfirstmedia.com).

## Bugs filed
None.
