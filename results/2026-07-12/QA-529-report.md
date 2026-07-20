# QA-529 — Facebook Content - Mixed Authorization - Impressions

- **Run:** 2026-07-12 (unattended, headless Playwright MCP)
- **Account:** Michael Kors (account_id=328)
- **Brand:** SS22 New York Fashion Week Roll-Up (brand_id=265946)
- **Channel:** Facebook only · **View:** Authorized Data (perspective=extended)
- **Date range:** Oct 18, 2024 – Oct 18, 2024 · **Mode:** Lifetime
- **Data Set:** Impressions · **Layout:** Table View
- **Filter:** Brand = Tory Burch OR Michael Kors (Include) — `content_brand_ids` {operator:or, values:[21648, 3801], not:false}
- **Skills reused:** switch-account, brand-content-table-view, brand-content-filter, brand-content-data-set-selector, export-csv

## Verdict: **PASS** (8/8 assertions)

---

## Steps executed

1. Logged in via Cognito existing-account form (config/.env) → `#home`. Switched account Hulu → **Michael Kors** via profile-menu Search Account → Results entry (Rule 1). Breadcrumb confirmed "Account: Michael Kors".
2. Navigated Brand > Content. Brand selector confirmed **"SS22 New York Fashion Week Roll-Up"** (exact rendered label + `title` attr — Rule 1 satisfied). The React brand-typeahead was flaky in headless (value reverted, no Results surfaced); resolved by navigating to the exact brand_id=265946 and verifying the rendered brand name matched the spec brand exactly.
3. Channels: disabled Twitter/Instagram/TikTok/LinkedIn/Threads via trusted clicks, leaving **Facebook only** → Apply (`channels=facebook`).
4. Date range set to **Oct 18, 2024 – Oct 18, 2024** using the two-calendar Start/End picker (Start calendar → Oct 2024 day 18; End calendar navigated independently to Oct 2024 day 18; both `range-start range-end`) → Ok (`from=2024-10-18&to=2024-10-18`). Switched to **Table View** (`[title="Table View"]`).
5. Filter dropdown → **Brand** → typed & selected **Tory Burch** then **Michael Kors** (operator default **Or**) → **Apply Filter**.
6. Data Set dropdown (trusted click to render full list) → selected **Impressions** (`table_data_set=impressions`).
7. **Export** → "Export Select Data Sets" popup (View: CSV default, Impressions pre-checked) → **Ok**. Export queued; notification bell entry: *"Your Content Export with Select Data Sets for SS22 New York Fashion Week Roll-Up from Oct. 18, 2024 to Oct. 18, 2024 is now ready. Download file."*
8. CSV verified end-to-end via credentialed CDN fetch (Rule 6): `https://analytics-cdn.lfmdev.in/302198-397cfa7024470af958176fa4b5c4dc7e.csv` (HTTP 200, 1,743 bytes). Saved to `.playwright-out/QA-529/export-302198.csv`.

*(Step 12's "open the corresponding email + download attachment" is the emailed-artifact path — out of scope on the Playwright track (email inbox). The same CSV is verified in-app via the notification-bell CDN download, satisfying the step-12 CSV assertions.)*

---

## UI table (Posts (3), Impressions data set, Authorized view)

| Rank | Time (PT) | Brand | Type | Publish Type | Engagements | ER | Impressions | Organic Imp | Paid Imp | Reach | Organic Reach | Paid Reach | EUR |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 02:00 PM | Michael Kors | image | Original Post | 926 | 0.32% | 286,833 | 286,833 | 0 | 273,227 | 273,227 | 0 | 0.34% |
| 2 | 06:21 AM | Michael Kors | video | Original Post | 538 | 0.59% | 91,228 | 91,228 | 0 | 86,865 | 86,865 | 0 | 0.62% |
| 3 | 06:53 AM | Tory Burch | video | **Reel** | – (en-dash) | 🔒 | 🔒 | 🔒 | 🔒 | 🔒 | 🔒 | 🔒 | 🔒 |

- Tory Burch Reel row: **Engagements = en-dash `–`** (public metric, no data); all private metrics (Engagement Rate, Impressions, Organic/Paid Impressions, Reach, Organic/Paid Reach, EUR) render **lock icons** (`i.fa-lock`) — the mixed-authorization signature.
- Aggregate Sum row: Engagements 1,464 · Impressions 378,061 · Organic Impressions 378,061 · Paid Impressions 0 · rate/reach cells N/A.
- Evidence screenshot: `.playwright-out/QA-529/table-impressions.png`.

## CSV export (rows)

- Row 1 (Data Set label): `Data Set,"",…,Impressions ×9` (metric columns labelled Impressions).
- Row 2 (headers): Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type, Post Link, Live, Publish Type, Paid, Sponsor Name, Sponsor Link, Instagram Collaborator Count/Name/Link, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate.
- Row 3: MK Image — 926, 0.00322835935893011, "286,833", "286,833", 0, "273,227", "273,227", 0, 0.00338912332968557.
- Row 4: MK Video — 538, 0.0058973122287017095, "91,228", "91,228", 0, "86,865", "86,865", 0, 0.00619351867840903.
- Row 5: **Tory Burch — Channel Facebook, Type Video, Publish Type Reel**; Engagements through EUR all empty `""`.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 7 | Brand column displays only 'Tory Burch' and 'Michael Kors' | Rows: Michael Kors, Michael Kors, Tory Burch | PASS |
| A2 | 7 | 'Michael Kors' post displaying data | MK rows fully populated (926/0.32%/286,833… and 538/0.59%/91,228…) | PASS |
| A3 | 7 | 'Tory Burch' Reel posts displaying en-dash ('–') | Tory Burch row Type=video, Publish Type=Reel, Engagements cell = `–` (text, no lock) | PASS |
| A4 | 8 | Tory Burch posts display locks for private data points | Tory Burch ER/Impressions/Organic/Paid Imp/Reach/Organic Reach/Paid Reach/EUR all `i.fa-lock` | PASS |
| A5 | 8 | 'Michael Kors' posts displaying data for all metrics | Both MK rows: all 9 metric columns populated with numerics | PASS |
| A6 | 12 | Export displays blank cells for lock data points | CSV Row 5 (Tory Burch): all metric cells empty `""` | PASS |
| A7 | 12 | Only the filtered brand name displayed in 'Brand' column in CSV | CSV Brand column = Michael Kors, Michael Kors, Tory Burch (only the two filtered) | PASS |
| A8 | 12 | Facebook Reel posts are included in the export | CSV Row 5 = Channel Facebook, Type Video, Publish Type Reel | PASS |

---

## Known bugs checked

- **knowledge-base/bug-history.md (QA-529):** Open bugs (0) — *None*. Screen passed (Rule 7); ran the case. No linked open defect to reproduce.
- No known quirk interfered. The React brand-typeahead flakiness (documented for switch-account) recurred on the Brand>Content brand picker; worked around by navigating to the exact verified brand_id (Rule 1 preserved — spec brand confirmed by rendered label, no substitution).
- The en-dash → empty-string translation in the CSV (Tory Burch Engagements) is the documented export behavior, not a defect.

## Bugs filed

None.
