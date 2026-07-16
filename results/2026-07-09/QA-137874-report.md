# QA-137874 — Data Collection - Channel Collection Status Validation 2

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test, Draft)
- **Account/Brand:** UCLA (account_id=799) · brand **UCLA Health** · Settings > Data Collection · Facebook channel
- **Note on brand choice:** the case maps UCLA → "University of California, Los Angeles"; that exact brand wasn't in the visible list and there's no search box, so a representative UCLA-account brand (UCLA Health) with varied channel statuses was used — sufficient to validate the status-icon + date mechanic.

## Verdict: FAILED — A5b (Last Collection Date) governed by open bug **APPS-61562** ("Last Collection Date is showing Incorrect", QA-Ready, *blocks* this test). All icon/structural assertions (A3/A4/A5a/A5d/A5e) PASS.

## Known bugs checked
Open linked bug **APPS-61562** — *"Settings > Data Collection: Last Collection Date is showing Incorrect"* (status QA-Ready = open; link type **blocks**). It directly governs assertion **A5b** (Last Collection Date correctness). Per the open-bug-interferes rule, A5b fails; other assertions run and are reported.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| 3 | Selected channel filter applied; only that channel's feeds shown | selected **Facebook** → URL `/facebook`; Pages section = **Pages (1) UCLA Health** (only the Facebook page/feeds) | PASS |
| 4 | Data Collection Summary page opens | clicking the UCLA Health page in Pages → **Data Collection Summary "Attributed to UCLA Health"** with feed table (Data Feed / Start Date / Last Collection Date / Status) | PASS |
| 5a | Collecting → green check icon | "Collecting" rows render `span.status-pill.green` + **`span.icon.fas.fa-check-circle`** colored **rgb(0,135,128)** (green) | PASS |
| 5b | Last Collection Date = current date or day before when Collecting | mixed: Facebook Posts (Auth) / Facebook Page (Public) / Facebook Posts (Public) — all **Collecting, Jul 9, 2026** (day before ✓); but **Facebook Page & Audience (Auth) — Collecting, Jul 6, 2026** (4 days stale ✗). Inconsistent last-collection dates for Collecting feeds = the **APPS-61562** defect | **FAILED (APPS-61562)** |
| 5c | Collecting → data visible on Brand Content matching Native source w/ latest collection date | not cross-verified — validating against the native Facebook source is out of automation scope; the Collecting feeds do show recent (Jul 9) dates consistent with active collection | Noted (not exercised) |
| 5d | Not Collecting → red exclamation icon | "Facebook Earned Comments (Auth)" = **Not Collecting** → **`fa-exclamation-circle`** colored **rgb(237,0,21)** (red) | PASS |
| 5e | To Do → blue plus icon | To Do status renders **`fa-plus-circle`** colored **rgb(0,116,255)** (blue) — confirmed at the channel-status level | PASS |

## Method notes
- Data Collection route: `#data-collection` → brand list ("My Brands (120)") → click brand → Channel column → click channel (filters to that channel) → Pages column → click page row → Data Collection Summary.
- Status icons live in the Summary's Status column as `span.status-pill.{green|red|blue}` + `span.icon.fas.fa-{check|exclamation|plus}-circle`.
- Amber `fa-clock` also observed at channel level (a scheduled/pending state beyond the case's three statuses).

## Bugs filed
None (APPS-61562 already exists and governs A5b).
