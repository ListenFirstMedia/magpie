# QA-103248 — Brand Sets > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103248
- **Run date:** 2026-06-02 (batch 7)
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** LF // TV // Episodic (brand_set_id=756) — spec brand set, picked from Results section of typeahead (Rule 1).
- **Date Range (page):** May. 25, 2026 – May. 31, 2026 (7-day default)
- **Date Range (modal):** May. 28, 2026 – May. 31, 2026 (auto, post publish + 4 days)
- **Post:** Off Campus (APV) TikTok video posted Thu May 28 2026 08:01 AM PDT — "One couple made a deal. The next one is keeping score. ❤️‍🔥🏒 From Garrett…"
- **Priority:** Minor (P4)
- **Result:** PASS 8/8 (BLOCKED in 2026-05-27 batch — unblocked here by using 7-day default window instead of long window)

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account HBO Max → Adam Orfei via account picker | OK |
| 1 | Top nav: Brand Sets → Content | OK |
| 2 | Brand Set typeahead: typed `LF // TV // Episodic` → clicked the exact-match Results entry | OK — brand_set_id=756 in URL |
| 3 | Clicked `Daily Analysis` link below post 1 (Off Campus (APV)) | OK — Daily Post Analysis modal opened |
| 4 | Clicked Data Viz dropdown (label "Line") → selected `Bar` | OK — chart re-rendered as bar |
| 5 | Clicked `Export` dropdown (top-right of modal) | OK — PNG / CSV / Google Sheets menu shown |
| 6 | Clicked `PNG` | OK — file saved to Downloads |
| 7 | Re-opened Export → clicked `Google Sheets` | OK — new tab opened to docs.google.com (captured via window.open hook) |
| 8 | Clicked `Close` button | OK — modal dismissed, returned to Brand Sets > Content grid |

## Saved file (Step 6 — PNG)

- **Filename:** `Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png`
- **Saved to:** `~/Downloads/Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png`
- **Size:** 80,647 bytes; PNG image data, 1507×860, 8-bit/color RGBA
- **Read end-to-end via host filesystem:** confirmed contents:
  - Top-left: ListenFirst logo + wordmark
  - Brand title line: `Off Campus (APV)`
  - Legend: blue square + `Engagements`
  - Bar chart: May 28 bar ≈ 2.6M, May 29 bar ≈ 1.1M, May 30 & May 31 empty
  - X-axis labels: May 28 / May 29 / May 30 / May 31 (rotated)
  - Y-axis: 0 to 2.8M in 200K increments
  - Bottom: `Daily Content Analysis` / `Date: May. 28, 2026-May. 31, 2026`

## Captured tab (Step 7 — Google Sheets)

- **Tab title (stripped `- Google Sheets`):** `Off Campus (APV)-May 28 2026-08-01 AM PDT-TikTok-Daily Content Analysis-2026-05-28-2026-05-31`
- **URL:** `https://docs.google.com/spreadsheets/d/16nDWFbDmYD5PLE0mDgVN4rm0Wey2_qBdySyfaeI2p1U/edit?gid=0#gid=0`
- **Note on timezone:** spec calls for `[Publish Time PST]`; UI/file rendered `08-01 AM PDT` (May 28 is during DST in PT). Conceptual match — both reference Pacific Time.
- **Sheet contents (rows 1-8):**
  - A1: post URL (`https://www.tiktok.com/@offcampusonprime/video/7644957998334348558`)
  - Row 2 headers: `Date | Text | Engagements`
  - Row 3: `SUM | – | 3770000` (matches modal Sum cell 3,770,000)
  - Row 4: `AVG | – | 942500` (matches modal Average cell 942,500)
  - Row 5: `2026-05-28 | One couple mad… | 2671100` (matches modal May 28 cell 2,671,100)
  - Row 6: `2026-05-29 | One couple mad… | 1098900` (matches modal May 29 cell 1,098,900)
  - Row 7: `2026-05-30 | One couple made a deal…` (no number — modal showed `–`)
  - Row 8: `2026-05-31 | One couple made a deal…` (no number — modal showed `–`)

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | PNG filename `[Brand Name]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png` — exact match (Daily Content Analysis is present per current build despite the spec strikethrough) | PASS |
| A2 | ListenFirst logo+name in top-left corner above brand name | Verified end-to-end on saved PNG — logo + `LISTENFIRST` wordmark over `Off Campus (APV)` title line | PASS |
| A3 | `Daily Content Analysis` text + date range below graph | Verified end-to-end — bottom text reads `Daily Content Analysis` then `Date: May. 28, 2026-May. 31, 2026` | PASS |
| A4 | PNG matches the page | Verified — same bar heights (2.6M, 1.1M), same dates, same legend | PASS |
| A5 | GS filename `[Brand]-[Publish Date]-[Publish Time PST]-[Channel]-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD` | `Off Campus (APV)-May 28 2026-08-01 AM PDT-TikTok-Daily Content Analysis-2026-05-28-2026-05-31` — exact pattern; PST↔PDT minor drift (May = DST) | PASS |
| A6 | Date format YYYY-MM-DD (e.g., 2026-01-26) | Sheet rows 5-8 use `2026-05-28`, `2026-05-29`, `2026-05-30`, `2026-05-31` | PASS |
| A7 | Google Sheets data matches the page data | SUM=3,770,000, AVG=942,500, May 28=2,671,100, May 29=1,098,900 — all match the in-modal table | PASS |
| A8 | The window closes (Close button) | Clicked Close → modal dismissed, underlying Brand Sets > Content grid restored | PASS |

## Bugs filed
None.

## Diagnostic / unblock notes

- **Previous BLOCKED state (2026-05-27):** LF // TV // Episodic posts panel hung 40+ seconds. Today's re-run on the 7-day default window (May 25 – May 31, 2026) loaded posts in ~10 seconds (Posts (28,438)). No hang. Adam's Brand Set was also tested first as a diagnostic and rendered fine — confirms the original hang was driven by either the long date window (12-month) or a transient platform load, not LF // TV // Episodic per se.

## Skill registry impact

- New skill candidate: `daily-post-analysis-modal-run` — captures the modal lifecycle for both Brand>Content (QA-100764) and Brand Sets > Content (this ticket). Defer scaffolding to a future session.
- `export-csv` skill v2 patterns reused for PNG/GS export pipeline verification.

## Sources
- [QA-103248 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-103248)
- Prior run: `/runs/2026-05-27/QA-103248-report.md` (BLOCKED on data load)
