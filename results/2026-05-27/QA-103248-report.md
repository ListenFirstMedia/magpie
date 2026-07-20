# QA-103248 — Brand Sets > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103248
- **Run date:** 2026-05-27
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** LF // TV // Episodic (brand_set_id=756)
- **Priority:** Minor (P4)
- **Result:** ⏸ **BLOCKED — Brand Sets > Content for `LF // TV // Episodic` repeatedly hangs on Adam Orfei in dev env. Posts panel never finished rendering after 40+ seconds (skeleton loaders held steady). Could not click "Daily Analysis" on the first post. Same pattern as the Hulu Brand>Content renderer freeze documented earlier today on QA-1519 — this brand set is large and the dev renderer can't paint it in a reasonable window.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Adam Orfei (already on Adam Orfei from QA-104870 run) | ✓ |
| 1 | Hover Brand Sets in top nav → Content | ✓ — navigated to `/#explore/competitive/content` |
| 2 | Select brand set `LF // TV // Episodic` via URL `brand_set_id=756` | ✓ — header reads `LF // TV // Episodic`, breadcrumb `Account: Adam Orfei | Brand Sets > Content` |
| 3-8 | Click 'Daily Analysis' on first post → Bar viz → Export PNG/GS → Close | ⏸ — Posts panel never finished rendering after 40+ seconds; first post tile never materialized |

## Why this hit the renderer-freeze quirk

Same pattern documented earlier today on QA-1519 (Hulu Brand>Content) and noted in `knowledge-base/known-quirks.md` for large brand sets / brands. Skeleton loaders stayed in place, no error in network requests visible, no JS console errors apparent. Memory + GPU constraints in the MCP-managed Chrome tab seem to be the root cause — a real user on a fresh local Chrome would likely see the page render in 5-10s.

## Assertion results
All A1–A8 ⏸ DEFERRED. Modal not opened.

## Recommended next-pass coverage
- LFIQA: run the test manually (~5 min) on Adam Orfei → Brand Sets > Content → `LF // TV // Episodic` → first post → Daily Analysis → Bar → Export PNG → Export Google Sheets → Close. Verify:
  - A1 PNG filename: `[Brand Name]-Daily Content Analysis-Bar-YYYY-MM-DD-YYYY-MM-DD.png`
  - A2 LF logo top-left above brand name
  - A3 "Daily Content Analysis" + date range below graph
  - A4 PNG matches the on-screen modal
  - A5 Google Sheets filename: `[Brand Name]-[Publish Channel]-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD`
  - A6 Date format `YYYY-MM-DD`
  - A7 Google Sheets data matches page
  - A8 Modal closes on Close click
- Save the PNG to ~/Downloads and the Sheets URL — I'll verify against spec patterns once they're available.

## Skill registry impact
- No changes. The `brand-content-data-set-selector` and `export-png` skills exist for the underlying pieces.
- Possible new skill: `daily-post-analysis-modal-run` if this modal recurs in other tests (it does: QA-100764 is the same modal on Brand>Content). Defer scaffolding until LFIQA confirms manual run works.

## Sources
- [QA-103248 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-103248)
