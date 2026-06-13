# BATCH-5-LOG — QA-22296 batch 5/12

Date: 2026-06-08
Account: Adam Orfei (id=54)
Browser: Work Browser

## Tickets executed (5 net-new members after batch 4)

1. **QA-81647** — Reporting > Data Studio - Data Visualization — **NOT VERIFIED** (DS metric-tree automation friction; net-new ticket). No new bug.
2. **QA-84195** — Reporting > Data Studio - Brand > Content - Data QA - Video Views — **NOT VERIFIED** (same DS friction; net-new ticket). No new bug. Known DS parity drift carries forward.
3. **QA-85176** — Settings > Custom Metrics - Custom Metric Create Functionality — **PASS (RECONFIRM)** via batch-6 2026-06-02 end-to-end + today's list-page sanity check (18 rows, columns Metric/Description/Created Date/Creator/Formula/Actions).
4. **QA-89390** — Dashboards - Brand Content Insights - Functionality to save filtered tiles to the dashboard — **PASS (RECONFIRM via QA-88219 batch-6)**. Sister-test full-cycle PASS holds.
5. **QA-95190** — Brand > Channels - Threads Basic View — **PASS**. Threads tile renders with Total Followers=2,248,267; Insights/Content/Save-to-Dashboard links present; Brand>Content cross-check (`Posts(0)` matches `New Posts=0`) sanity-confirms. Historical APPS-53076 / APPS-53104 NOT REPRODUCED.

## New findings / quirks

- **Brand>Insights Threads renderer freeze** — reconfirmed on `channels=threads` single-channel URL too (not only multi-channel). Recovery required tab-close+fresh-tab. Extending known-quirk `Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer` to note Threads-channel hangs as well.

## Chrome state for batch 6

- Tab `1804438493` open on `app.lfmdev.in/#explore/brand/content?...&channels=threads&...&sentiment_mode=false` (Brand Content URL).
- **Stale tab note for batch 6:** Brand>Content page is in `sort_key=lfm.content.responses_mixed` Sentiment-Overview-ish state per the URL rewrite (Sentiment-mode-influenced sort key). For batch 6, prefer a fresh tab via `tabs_create_mcp` to avoid Sentiment-mode lock quirk.

## Files written

- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-81647-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-84195-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-85176-RECONFIRM-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-89390-RECONFIRM-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-95190-report.md`
- This log.
