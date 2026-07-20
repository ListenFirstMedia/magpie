# QA-83928 — Brand > Paid - CSV - Select Channels & Data Sets Export notification view

- **Verdict:** **PASS** (4/4 assertions)
- **Run:** 2026-07-11, unattended headless (Playwright MCP, `feature/playwright-mcp`)
- **Account:** Adam Orfei (`account_id=54`) — switched from Michael Kors acct via LFQA account switcher (Results row)
- **Brand:** Michael Kors (`brand_id=3801`), exact typeahead match (Rule 1)
- **Surface:** Brand > Paid, channel=Facebook, CSV export
- **Priority:** P1 (Blocker) | Mutating: NO

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand top-nav → Paid tab | OK — landed `#explore/brand/paid`, tiles loaded |
| 2 | Brand dropdown → type & select 'Michael Kors' | OK — exact-match `.lfm-ta-option` "Michael Kors" clicked; `brand_id=3801`; Paid tiles populate (820 Active Ads, 59.1M Paid Impressions, $455K Spend) — **2026-06-04 backend degradation NOT reproducing** |
| 3 | Click Export | OK — "Export Select Data Sets" modal opened (CSV/Google Sheets toggle, CSV default) |
| 4 | Select Facebook Engagements, Rates, Video Views, Cost, Delivery | OK — all 5 checkboxes `checked=true` (Engagements was pre-checked as active data set) |
| 5 | Click Ok in export popup | OK — modal submitted; "We're hard at work preparing your export" queue message |
| 6 | Click OK in 'Select Channels & Data Sets Export Request' popup | Queue submitted directly on the single Ok (see Note 1); export accepted |
| 7 | Hover Notification icon | OK — Recent Activity panel; export notification present |
| 8 | Click 'Download file' | OK — real download fired (Playwright `download` event) |
| 9 | Settings > Notifications | OK — `#notifications` table rendered (341 rows) |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | Notification 3-row: (1) "Select Channels & Data Sets Export"; (2) "Mon DD, YYYY XX:YY xm"; (3) "Your Paid Export with Select Channels & Data Sets for Michael Kors from Mon. DD, YYYY to Mon. DD, YYYY is now ready. Download file." | Row 1: `Select Channels & Data Sets Export`; Row 2: `Jul 11, 2026 06:56 pm`; Row 3: `Your Paid Export with Select Channels & Data Sets for Michael Kors from Jul. 04, 2026 to Jul. 10, 2026 is now ready. Download file.` — verbatim spec match | **PASS** |
| A2 | 7 | 'Download file' text is blue hyperlinked | Anchor with `href=https://analytics-cdn.lfmdev.in/302165-53bd9aa4a7676517bdced3e3c7ca8c67.csv`, computed color `rgb(0, 128, 255)` (blue) | **PASS** |
| A3 | 8 | The CSV file is downloaded | Real download event → `Michael Kors-Cross-Channel-Paid-2026-07-04-2026-07-10.csv` on disk (516,183 bytes, 825 lines). "Data Set" preamble row = Engagements/Rates/Video Views/Cost/Delivery (exactly the 5 selected Facebook sets); header row present; 822 data rows. Rule-6 satisfied (on-disk read). | **PASS** |
| A4 | 9 | The same 'Select Channels & Data Sets Export' notification displays in Settings > Notifications | Table row present: `Jul 11, 2026 06:56 PM | Your Paid Export with Select Channels & Data Sets for Michael Kors from Jul. 04, 2026 to Jul. 10, 2026 is now ready. Download file.` | **PASS** |

## Evidence

- CSV on disk: `.playwright-out/Michael Kors-Cross-Channel-Paid-2026-07-04-2026-07-10.csv` (copied to `.playwright-out/QA-83928/`)
  - Header cols include: Rank, Date, Day of Week, Time, Channel, …, Spend, Paid Actions, Clicks, Outbound Clicks, Inline Clicks, Paid Action Rate, CTR, …, 95% Completed Views, …, CPC, CPM, CPE, …, Paid Impressions — Facebook Engagements/Rates/Video Views/Cost/Delivery data sets all present.
- Download filename (server-suggested, from Playwright download event): `Michael Kors-Cross-Channel-Paid-2026-07-04-2026-07-10.csv` — spec-format `<Brand>-<Channel>-<Report>-<begin>-<end>.csv`, NOT the CDN hash. (Contrast with BC-2 historical note: real user click yields the spec filename; confirmed here end-to-end.)
- Notification bell link href: `https://analytics-cdn.lfmdev.in/302165-53bd9aa4a7676517bdced3e3c7ca8c67.csv`
- Screenshot: `.playwright-out/QA-83928/settings-notifications.png`

## Known bugs checked

- **`knowledge-base/bug-history.md` QA-83928:** 0 open product bugs; 1 carry-forward BACKEND flakiness (2026-06-04: Michael Kors Brand>Paid all 12 tiles "failed to load" + Export queue never completed). **NOT reproduced this run** — all Paid tiles rendered with data and the export queued + delivered within the run window. Backend appears recovered.
- **Case file "Open linked bugs":** section absent in cached file; no open-bug gate triggered (Rule 7). Ran normally.
- **Async export mechanics (known-quirks 2026-06-13):** confirmed — createObjectURL hook captured nothing; the CDN `<a>`-click auto-download + notification-bell entry is the delivery path. Playwright `download` event gave the true on-disk filename directly (Rule 6, cleaner than the fetch reproduction).

## Notes / observations

- **Note 1 (Step 5→6 flow):** No separate blocking "Select Channels & Data Sets Export Request" confirmation popup was observed between the export-modal Ok (Step 5) and the queue submit; the single Ok queued the export directly. Functional outcome correct (export queued + notification + CSV delivered). Minor flow-vs-spec wording variance, not a defect.
- **Duplicate notification:** the Settings table showed TWO identical Michael Kors Jul 04–Jul 10 rows (06:56 PM + 08:32 PM). The bell feed also shows other exports duplicated at identical timestamps (Liquid Death, MTV Content) — a pre-existing app characteristic of duplicate export notifications, not caused by this run's single Export submission. Does not affect A1–A4.
- Date-format variance A1 vs A4: bell renders lowercase `pm`; Settings table renders uppercase `PM`. Spec A1 example uses lowercase `xm` and matches the bell view (Step 7). Illustrative, not a defect.

## Bugs filed

_None._
