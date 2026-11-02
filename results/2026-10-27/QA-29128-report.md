# QA-29128 — Brand Content - Impressions - Data Test - (Twitter and Instagram)

- **Date:** 2026-10-27 (Tuesday)
- **Run mode:** unattended / headless (`claude -p`)
- **Test Set:** QA-26183 "Daily Data Testing -2"
- **Verdict: FAILED (blocked by open bug) — APPS-60871**

## Open-bug screen (Rule 7)

The case file `cases/QA-29128.md` carries an "Open linked bugs" section (baked in from Jira on 2026-10-20) that lists:

- **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

Per the open-bug auto-fail policy (`skills/_shared/spec-adherence-rules.md`, Rule 7), a case with any open linked defect is not executed. No browser session was opened, no login was performed, and no steps were run.

The bug's scope matches this case. APPS-60871 covers Twitter and Instagram datasets rendering "–" for metrics. This case sums Organic and Paid Impressions and Reach, then divides Engagements by Impressions and by Reach, on the Impressions dataset for Instagram Only and Twitter Only. A trustworthy PASS is not possible while the defect is open.

## Steps executed

None (skipped by the open-bug screen).

| Step | Description | Status |
|---|---|---|
| 1–3 | Brand > Content; add the weekday brand (Tuesday: University of California, Los Angeles / MTV / Gatorade); select the Impressions dataset; enable Instagram Only | NOT RUN |
| 4–7 | Instagram Only grid math: Organic + Paid Impressions; Organic + Promoted Reach; Engagements / Impressions; Engagements / Reach | NOT RUN |
| 8–11 | Twitter Only: repeat the Impressions and Reach sums, note Engagements and Impressions, check the Engaged User Rate endash | NOT RUN |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions (Instagram) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A5 | 5 | Organic Reach + Promoted Reach = Reach (Instagram) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A6 | 6 | Engagements / Impressions = Engagement Rate (Instagram) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A7 | 7 | Engagements / Reach = Engaged User Rate (Instagram) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A9 | 9 | Organic Impressions + Paid Impressions = Impressions (Twitter) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A10 | 10 | Organic Reach + Promoted Reach = Reach (Twitter) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A11a | 11 | Engagements / Impressions = Engagement Rate (Twitter) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A11b | 11 | Engaged User Rate displays endash (Twitter) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots were captured (no `.playwright-out/QA-29128/` artifacts) because the browser flow was not started.

## Known bugs checked

- **APPS-60871 (Open)** — from the case file's "Open linked bugs" section (as of 2026-10-20). The unattended run has no Jira access, so the status could not be refreshed. It is treated as still open.
- `knowledge-base/bug-history.md` — no matches for QA-29128 (pre-fetched).
- `knowledge-base/known-quirks.md` — the pre-fetched match is the unattended-runner entry, which lists QA-29128/35301 (APPS-60871) as FAILED on an open linked bug. User policy of 2026-10-22: any open linked bug means FAILED.

## Bugs filed

None. This is a markdown-only report and no new bugs were identified. The failure is attributed to the existing APPS-60871.

## Re-run note

Once APPS-60871 is closed and the case cache is refreshed, a re-run will pick the case up automatically. No skill matched this flow in `skills/REGISTRY.md` (pre-fetched). `brand-content-grid-math` is referenced in the case notes for the Table View scrape. Skill/REGISTRY maintenance is deferred to harvest.sh.
