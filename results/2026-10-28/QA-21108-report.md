# QA-21108 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 2

- **Date:** 2026-10-28 (Wednesday)
- **Run mode:** unattended / headless (`claude -p`)
- **Test Set:** QA-26183 "Daily Data Testing -2"
- **Verdict: FAILED (blocked by open bug) — APPS-60871**

## Open-bug screen (Rule 7)

The case file `cases/QA-21108.md` carries an "Open linked bugs" section (baked in from Jira on 2026-10-20) that lists:

- **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

Per the open-bug auto-fail policy (`skills/_shared/spec-adherence-rules.md`, Rule 7; confirmed by the user on 2026-10-22), a case with any open linked defect is not executed. No browser session was opened, no login was performed, and no steps were run.

The bug's scope matches this case. APPS-60871 covers Twitter, Instagram and YouTube datasets rendering "–" for metrics, and this case compares exactly those datasets (Twitter Engagements & Follows, Instagram Insights / Reels / ActionTypes, YouTube Insights / Premium) day over day. A trustworthy PASS is not possible while the defect is open.

## Steps executed

None (skipped by the open-bug screen).

| Step | Description | Status |
|---|---|---|
| 1–5 | Brand Content > Amazon Prime Video > Twitter only: Engagements & Follows; compare with attached screenshot | NOT RUN |
| 6–8 | Instagram Only: Insights; compare | NOT RUN |
| 9–11 | Reels dataset; compare | NOT RUN |
| 12–14 | Instagram Only: ActionTypes; compare | NOT RUN |
| 15–17 | YouTube Only: Insights; compare | NOT RUN |
| 18–20 | YouTube Only: Premium; compare | NOT RUN |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | Metric values show no big variation (about 2–3x) from the previous day to today (Twitter Engagements & Follows) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A2 | 8 | Same, Instagram Insights | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A3 | 11 | Same, Reels dataset | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A4 | 14 | Same, Instagram ActionTypes | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A5 | 17 | Same, YouTube Insights | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A6 | 20 | Same, YouTube Premium | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots were captured (no `.playwright-out/QA-21108/` artifacts) because the browser flow was not started.

## Known bugs checked

- **APPS-60871 (Open)** — from the case file's "Open linked bugs" section (as of 2026-10-20). The unattended run has no Jira access, so the status could not be refreshed. It is treated as still open.
- `knowledge-base/bug-history.md` — no matches for QA-21108 (pre-fetched).
- `knowledge-base/known-quirks.md` — the pre-fetched match is the open-bug auto-fail policy entry, which names QA-21108/21109 explicitly.

## Bugs filed

None. This is a markdown-only report and no new bugs were identified. The failure is attributed to the existing APPS-60871.

## Re-run note

Once APPS-60871 is closed and the case cache is refreshed, a re-run will pick the case up automatically. No skill matched this flow in `skills/REGISTRY.md` (pre-fetched). `brand-content-grid-math` is referenced in the case notes for the Table View scrape. Skill/REGISTRY maintenance is deferred to harvest.sh.
