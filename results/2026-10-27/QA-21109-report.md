# QA-21109 — Brand Content > previous date range data test > Channel-Specific Metrics Data Sets - part 3

- **Date:** 2026-10-27 (Tuesday)
- **Run mode:** unattended / headless (`claude -p`)
- **Test Set:** QA-26183 "Daily Data Testing -2"
- **Verdict: FAILED (blocked by open bug) — APPS-60871**

## Open-bug screen (Rule 7)

The case file `cases/QA-21109.md` carries an "Open linked bugs" section (baked in from Jira on 2026-10-20) that lists:

- **APPS-60871 (Open)** — Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)

Per the open-bug auto-fail policy (`skills/_shared/spec-adherence-rules.md`, Rule 7), a case with any open linked defect is not executed. No browser session was opened, no login was performed, and no steps were run.

The bug's scope matches this case. APPS-60871 covers YouTube datasets rendering "–" for metrics, and this case compares YouTube "Subscribers and Playlists" and "Cards" dataset metrics day over day. A trustworthy PASS is not possible while the defect is open.

## Steps executed

None (skipped by the open-bug screen).

| Step | Description | Status |
|---|---|---|
| 1–8 | Brand Content > Amazon Prime Video > YouTube Only: Subscribers and Playlists / Cards datasets, compare against the attached screenshot | NOT RUN |

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 5 | Metric values show no big variation (about 2–3x) from the previous day to today (Subscribers and Playlists dataset) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |
| A2 | 8 | Metric values show no big variation (about 2–3x) from the previous day to today (Cards dataset) | Not evaluated — open linked bug APPS-60871 | FAILED (blocked by open bug) |

## Evidence

No screenshots were captured (no `.playwright-out/QA-21109/` artifacts) because the browser flow was not started.

## Known bugs checked

- **APPS-60871 (Open)** — from the case file's "Open linked bugs" section (as of 2026-10-20). The unattended run has no Jira access, so the status could not be refreshed. It is treated as still open.
- `knowledge-base/bug-history.md` — no matches for QA-21109 (pre-fetched).
- `knowledge-base/known-quirks.md` — no matches for QA-21109 (pre-fetched).

## Bugs filed

None. This is a markdown-only report and no new bugs were identified. The failure is attributed to the existing APPS-60871.

## Re-run note

Once APPS-60871 is closed and the case cache is refreshed, a re-run will pick the case up automatically. No skill matched this flow in `skills/REGISTRY.md` (pre-fetched). `brand-content-grid-math` is referenced in the case notes for the Table View scrape. Skill/REGISTRY maintenance is deferred to harvest.sh.
