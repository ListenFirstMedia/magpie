# Harvest log — 2026-06-27 skill-maintenance pass

Run index: `runs/2026-06-27/summary.json` — 10 cases (6 PASS, 0 FAIL, 3 BLOCKED, 1 UNKNOWN).
File-only maintenance; no browser opened.

## Summary of changes

| Skill / file | Action | Old → New |
|---|---|---|
| settings-custom-data-sets | streak bump + version bump + **promotion** | streak 6→10, v2→v3, untrusted→**stable**, last_verified 2026-06-08→2026-06-27 |
| brand-content-dpa-modal | streak bump + **registry row created** (was missing) | streak 5→7, last_verified 2026-06-08→2026-06-27 |
| known-quirks.md | 2 new entries | — |

---

## settings-custom-data-sets — bumped, version v3, PROMOTED to stable

- **Streak 6 → 10 (+4).** Four same-day PASS cases reused this skill:
  - QA-104870 (Basic View, 12/13 + 1 N/A)
  - QA-104876 (Delete, 3/3)
  - QA-106218 (Create, 14/14)
  - QA-106221 (Edit, 5/5 — **edit flow exercised end-to-end for the first time**)
- **Version v2 → v3.** Added an Edit-flow section to the SKILL: keyboard-accessible DnD reorder (`Space`/`Arrow`/`Space` + `role=log` live-region verify, preferred over synthetic mouse drag per the Jira "Not Recommended" note), in-Edit metric delete, search-and-add of a channel-scoped metric (label-collision-across-channels caveat — e.g. "Views" under Twitter/Instagram/Threads are distinct DCR keys), save-persistence with no success toast, and the QA-106218→QA-106221 precondition-recreate dependency pattern. Added v3 failure signatures + carry-forward notes (no success toast on Create/Save under Playwright; checkboxes accept trusted clicks; Settings account-context-not-inherited).
- **Promotion untrusted → stable.** Verified separate-day evidence before promoting: 2026-06-02 (batch-7 re-runs), 2026-06-08 (v2 Delete / QA-104876), 2026-06-27 (this run). ≥3 separate days — meets the promotion rule.
- `last_verified` / `last_passed_run` → 2026-06-27. Registry row + SKILL frontmatter + "Used by" list all updated.

## brand-content-dpa-modal — bumped, REGISTRY ROW CREATED

- The skill file existed on disk since 2026-06-08 (streak 5, untrusted) but had **no row in REGISTRY.md** — a registry-sync gap. Created the row this pass.
- **Streak 5 → 7 (+2).** Two same-day PASS cases reused it (PNG export path):
  - QA-103246 (Brand>Content, MTV TikTok, DATA-12209 reproduced as expected)
  - QA-103248 (Brand Sets>Content, Love Island USA TikTok, 8/8)
  - Google Sheets steps are OUT OF SCOPE on the Playwright MCP track (Google 2FA, per `config/env.md`) → A5/A6/A7 not-tested, not failed.
- Left **untrusted** — separate-day promotion evidence is not reconstructable from registry notes (no prior row existed). Flagged below for human review.
- `last_verified` / `last_passed_run` → 2026-06-27; v1-reconfirm changelog line added.

## knowledge-base/known-quirks.md — 2 new entries (newest-first, Playwright MCP section)

1. **Settings surfaces do not inherit the active Home account context** (QA-106218): Custom Data Sets loaded under a Recent-Searches account (Hulu) instead of the active Home account (Adam Orfei). Candidate Minor/UX bug; treat as a precondition step (re-switch via user-menu → Search Account → Results entry).
2. **Max brand (Adam Orfei dev) has no Threads channel on Brand>Content** (QA-100764): channel selector offers only FB/X/IG/TikTok/YouTube; `channels=threads` URL param is stripped. Test-data/data-collection gap — blocks Threads cases on Max.

No app-map.md / glossary.md changes (no new page or term appeared).

---

## Not skill drift — no action (per the non-over-reaction rule)

- **QA-100764 (BLOCKED)** — Threads channel unavailable for Max = test-data gap, not skill drift. brand-content-dpa-modal and brand-channels-threads steps still match the app. Captured as a KB quirk; no quarantine.

---

## Needs human review

1. **QA-107134 status discrepancy (summary UNKNOWN vs report PASS).** The report verdict is PASS (A1/A2 pass; A3 is an expected reproduction of the existing Minor bug APPS-54603 — broader scope: same-tab URL replace fails to re-apply both filter AND date range). It reused `settings-audit-logs` v2. Because the run index classifies it **UNKNOWN**, I did **not** auto-bump (respecting the index + the conservative rule). If a human confirms PASS, `settings-audit-logs` (currently untrusted, streak 3, last_verified 2026-06-08) earns +1 → 4 **and** would be promotion-eligible (separate days 2026-06-04 / 2026-06-08 / 2026-06-27).

2. **Missing report files: QA-10387 and QA-1053.** Both are listed BLOCKED in `summary.json` but `runs/2026-06-27/QA-10387-report.md` and `QA-1053-report.md` do not exist on disk. Could not assess — no skill action taken. Recommend confirming whether these runs produced reports.

3. **Orphan report QA-84193 not in the run index.** `runs/2026-06-27/QA-84193-report.md` exists and is a clean PASS (DS↔Brand>Content Engagements parity, 0.00% delta) reusing `switch-account`, `data-studio-post-level-run` (stable), `brand-content-data-set-selector`, `view-perspective-toggle` — but QA-84193 is **not** one of the 10 cases in `summary.json`. Not credited (conservative — outside the official run index). If a human confirms it belongs to this run, those four skills each earn +1.

4. **Broader registry-sync gap.** Several skills exist on disk with no REGISTRY.md row (besides brand-content-dpa-modal, now added): `brand-channels-threads`, `brand-content-tag-modal-drag`, `brand-content-tag-upload`, `brand-conversation`, `brand-navigation-timestamp`, `brand-video-favourites`, `cpr-builder`, `data-collection-channel-status`, `radaac-report-runner`. Only the one touched by this run (dpa-modal) was added. Recommend a dedicated registry-reconciliation pass to backfill rows + reconstruct separate-day evidence (which also gates the dpa-modal promotion question in item 1's spirit).
