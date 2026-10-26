# QA-144817 — Settings > Data Collection - Status Parity Between UI and CSV Export (APPS-61645)

**Run date:** 2026-10-23 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Account:** Michael Kors (account_id=328, switched from Hulu via the LFQA profile menu) · **Env:** app.lfmdev.in
**Verdict: PASS** — status parity holds row for row on both channels tested (Instagram: 5 feeds, all Collecting; Twitter: 5 feeds + 1 ad-account child, a mix of Collecting / Not Collecting / no-status), feed counts match, and the Dormant flag in the export lands only on feeds the UI shows as Collecting. Structural notes below; none change the verdict.

## Steps executed
1. Login via Cognito "With existing account" (lfiqa), landed on Hulu (336). Precondition "logged in as Michael Kors": profile menu (LFQA) → Search Account → "Michael Kors" from **Results** → breadcrumb `ACCOUNT: MICHAEL KORS`, account_id=328.
2. Settings (top right) → Data collection. My Brands (70) rendered.
3. Typed "Michael Kors" in the brand search; exact-match typeahead result "Michael Kors" (first, focused) selected (pointer click was intercepted per the known quirk, so Enter on the focused exact option was used). Channels (9) panel rendered.
4. Channel = **Instagram** → Pages (1) `michaelkors` → Data Collection Summary. Recorded all feed rows (table below).
5. Export → CSV. The menu offers two options: "Data Collection - All" and "Data Collection - Status Only"; the spec does not name one, so **both** were exported and checked. Files verified on disk under `.playwright-out/QA-144817/` (Rule 6).
6. Compared UI vs CSV (below).
7. Repeated steps 2–6 on a second channel with a mix of statuses: **Twitter** (page `MichaelKors`). Brand re-searched and re-selected from the typeahead, channel selected in the Channels panel, ad-account child expanded via the row chevron.

## Instagram (page `michaelkors`) — UI 5 feeds vs "All" CSV 5 rows
| Data Feed | UI Start | UI Last Coll. | UI Status | CSV Status | CSV Last Coll. | CSV Active Last 30 Days |
|---|---|---|---|---|---|---|
| Instagram Earned Comments (Authorized) | Aug 12, 2018 | Oct 22, 2026 | Collecting | Collecting | 10/22/2026 | Active |
| Instagram Page & Audience (Authorized) | Feb 15, 2016 | Oct 21, 2026 | Collecting | Collecting | 10/21/2026 | (blank) |
| Instagram Posts (Authorized) | Nov 29, 2017 | Oct 22, 2026 | Collecting | Collecting | 10/22/2026 | Active |
| Instagram Page (Public) | Jul 29, 2014 | Oct 22, 2026 | Collecting | Collecting | 10/22/2026 | (blank) |
| Instagram Posts (Public) | Jul 28, 2014 | Oct 22, 2026 | Collecting | Collecting | 10/22/2026 | Active |

All 5 status icons = `fa-check-circle`, rgb(0,135,128). No Dormant row on Instagram.

## Twitter (page `MichaelKors`) — UI 5 feeds (+1 ad-account child) vs "All" CSV 6 rows
| Data Feed | UI Start | UI Last Coll. | UI Status | CSV Status | CSV Last Coll. | CSV Active Last 30 Days |
|---|---|---|---|---|---|---|
| Twitter Ads (Authorized) — parent | Feb 7, 2012 | Oct 22, 2026 | (none shown; expandable) | "–" | 10/22/2026 | Active |
| ↳ Ad Account `2jdhb9` (expanded) | Feb 7, 2012 | Oct 22, 2026 | **Not Collecting** (fa-exclamation-circle, rgb(214,79,66)) | Not Collecting | 10/22/2026 | Active |
| Twitter Posts (Authorized) | Sep 26, 2021 | Sep 21, 2026 | Collecting | Collecting | 09/21/2026 | **Dormant** |
| Twitter Earned Comments (Public) | Jan 2, 2017 | Oct 22, 2026 | Collecting | Collecting | 10/22/2026 | Active |
| Twitter Page (Public) | Jan 25, 2013 | Oct 21, 2026 | Collecting | Collecting | 10/21/2026 | (blank) |
| Twitter Posts (Public) | Sep 2, 2012 | Sep 21, 2026 | Collecting | Collecting | 09/21/2026 | **Dormant** |

## "Status Only" CSV (wide format, one row per brand; 70 brands / 71 lines)
Michael Kors row (Brand ID 3801): Instagram Earned Comments / Page & Audience / Posts (Authorized) = Collecting ×3; Twitter Ads (Authorized) = "–", Twitter Posts (Authorized) = Collecting. Every value present agrees with the UI and the "All" CSV. It carries only Authorized feeds (no Public feeds, no per-ad-account rows), so it is a subset by design — not used for the feed-count assertion. The two exports are account-wide and byte-identical whether exported from the Instagram page or the Twitter page (md5 `511ddfab…` All, `8a8d3c94…` Status Only).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Status of every feed matches UI ↔ CSV, row for row | Instagram 5/5 match. Twitter 5/5 feed rows + ad-account child match (Posts Auth/Public, Earned Comments, Page = Collecting; ad account 2jdhb9 = Not Collecting). Start / Last Collection dates also match on every row | PASS |
| A2 | 6 | CSV feed count = number of feeds on the UI | Instagram 5 = 5. Twitter 6 CSV rows = 5 UI feed rows + 1 ad-account child shown when the Ads row is expanded | PASS (see note 1) |
| A3 | 6 | Dormant indicator in the export corresponds to a feed the UI still shows as Collecting | Dormant (`Active Last 30 Days`) appears on exactly two rows in the whole Michael Kors export: Twitter Posts (Authorized) and Twitter Posts (Public). The UI shows both as **Collecting** (last collection Sep 21, 2026). No Dormant on any Not Collecting feed. Instagram: no Dormant rows | PASS |
| A4 | 7 | Match holds across channels, not limited to a single channel or feed type | Verified on Instagram (all Collecting; Authorized + Public) and Twitter (Collecting + Not Collecting + parent with no status; Authorized + Public; Posts / Earned Comments / Page / Ads) | PASS |

## Notes / observations (no verdict impact)
1. Ad-account granularity: the UI shows one parent "Ads" row per feed, expandable to ad accounts; the CSV lists the parent ("–") plus one row per ad account. Count parity holds once the expansion is counted (consistent with known-quirks and the 2026-10-19 run, where the same effect was 38 rows on Facebook).
2. `Active Last 30 Days = Dormant` is not surfaced anywhere in the UI; it is export-only. The two Dormant Twitter feeds are "Collecting" in both with a Last Collection Date 31 days old (Sep 21) — consistent between UI and CSV, so not a parity defect (related to the staleness class of APPS-61562, out of scope here).
3. Typeahead: pointer click on the option is intercepted (`<div> intercepts pointer events`); Enter on the focused exact match works. Already in known-quirks.
4. Account-switch: after clicking the Michael Kors result the app sat on a bare `https://app.lfmdev.in/` "Loading…" for ~40 s before rendering Home; no reload was needed.

## Evidence
- `.playwright-out/QA-144817/ig-summary-ui.png`, `tw-summary-ui.png`, `tw-summary-ui-ads-expanded.png`, `pages-panel.yml`
- CSVs: `ig-Michael Kors-2026-10-23-Data-Collection-Summary-All.csv` (665 rows), `…-Status-Only.csv`, and the `tw-` copies from the Twitter page.
- Download filenames confirmed from the browser download event: `Michael Kors-2026-10-23-Data-Collection-Summary-All.csv` / `…-Status-Only.csv`.

## Known bugs checked
Case file: "Open linked bugs: None open" (Rule 7 screen passed). bug-history / known-quirks greps for QA-144817: none. APPS-61645 (the defect this case regresses — status parity) did **not** reproduce. No other bug on the Data Collection surface interfered.

## Bugs filed
None (markdown-only policy). Cleanup: none needed (read-only export).
