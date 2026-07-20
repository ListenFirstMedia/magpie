# QA-104870 — Settings > Custom Data Sets - Basic View — Run Report

- **Run date:** 2026-06-27
- **Branch:** feature/playwright-mcp (Playwright MCP, real Chrome)
- **Source ticket:** https://listenfirstmedia.atlassian.net/browse/QA-104870 (Blocker / P1)
- **Skill reused:** `settings-custom-data-sets` v2 (untrusted; QA-104870 is its origin case)
- **Account under test:** Adam Orfei (account_id=54)
- **Result:** **PASS** — 12/13 assertions PASS, 1 N/A (A5, empty-state not observable on a populated account). No bugs filed.

## Pre-flight

| Check | Result |
|-------|--------|
| App reachable (`app.lfmdev.in`) | OK — redirected to Cognito hosted UI |
| Programmatic login ("With existing account" form, creds from `config/.env`) | OK — `oauth_callback` → `#home`, title "Home - ListenFirst" |
| Dashboard renders without login redirect | OK |

## Account precondition handling (important)

Precondition: *"logged in as Adam Orfei."*

- On the first `#home` render the header read **`Account: Adam Orfei`** (no `account_id` in URL).
- After clicking through to `#custom-data-sets`, the breadcrumb resolved to **`Account: Hulu`** and the URL/state locked to **`account_id=336`** (Hulu). Re-navigating to `#home` then also showed `Account: Hulu` — i.e. the persisted "current account" for this LFQA session was Hulu (336), and the initial "Adam Orfei" label on the cold home render did not reflect the account the app actually resolved on first real navigation.
- Per the account-precondition rule, I switched to Adam Orfei via the LFQA user menu → **Search Account** → typed "Adam Orfei" → clicked the item under the **Results** heading (not Recent Searches). URL then carried `account_id=54` and the header confirmed `Account: Adam Orfei`.
- **All assertions below were evaluated only after the active account was confirmed as Adam Orfei.** See "Observations" for the state-consistency note (not filed as a bug).

## Steps executed

1. **Hover 'Settings' in the top nav** — Settings dropdown opened (14 items, alphabetical).
2. **Click 'Custom Data Sets'** — navigated to `#custom-data-sets`; listing screen rendered under Adam Orfei.
3. **Click the ellipsis in the first row's Actions column** (row "Hii") — action menu opened.
4. **Review the listing table** — 7 Custom Data Sets enumerated.

(Steps 1–2 were performed twice: once under the carried-over Hulu context for initial exploration, then re-performed under the corrected Adam Orfei context for the recorded results.)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | 'Custom Data Sets' appears after 'Brands' in the Settings dropdown | Dropdown order: …Brand Sets, **Brands (idx 4), Custom Data Sets (idx 5)**, Custom Metrics… — immediately after Brands | PASS |
| A2 | 2 | 'Custom Data Sets' is selected in the dropdown | CDS `<li>` carries class `active` with highlight bg `rgb(232,232,232)`; Brands has no active class (transparent bg) | PASS |
| A3 | 2 | Breadcrumb 'Account: Adam Orfei \| Settings > Custom Data Sets' above the header | Rendered: `Account: Adam Orfei` `\|` `Settings` `>`(icon separator) `Custom Data Sets` | PASS |
| A4 | 2 | Data Sets Listing Screen opens and displays available Custom Data Sets | Listing table rendered with 7 CDS rows | PASS |
| A5 | 2 | When no Custom Data Sets exist, a blank table is displayed | Adam Orfei has 7 CDS — empty state not observable without an empty account; not fabricated | N/A |
| A6 | 2 | Text below dropdown: "Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set" | Exact text present below the header | PASS |
| A7 | 2 | "Create a Custom Data Set" button on the right side of the window | Button present; bounding box left=1074, right=1256 of viewport 1280 (right side) | PASS |
| A8 | 2 | Table fields: Data Set, Created Date, Creator, Metrics, Actions | Column headers (in order): Data Set, Created Date, Creator, Metrics, Actions | PASS |
| A9 | 3 | Ellipsis options in order: Edit, Delete, Duplicate | Menu rendered: **Edit, Delete, Duplicate** | PASS |
| A10 | 4 | 'Data Set Name' displayed under 'Data Set' column | Names present (Hii, Main Test 1, …) | PASS |
| A11 | 4 | 'Created Date' format `Mon. DD, YYYY` | All 7 dates match (e.g. Jun. 26, 2026 / Mar. 28, 2025 / May. 09, 2025) | PASS |
| A12 | 4 | Creator's name displayed under 'Creator' column | Names present (Taruna Kumari, Phil Cutler, James Butler, Sasikumar Drylogics) | PASS |
| A13 | 4 | Metrics displayed under 'Metrics' column, comma-separated | Comma-separated metric lists present in every row | PASS |

## Evidence

### Dropdown order (A1)
`API, Audit, Authorization, Brand Sets, Brands, Custom Data Sets, Custom Metrics, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users` — Brands at index 4, Custom Data Sets at index 5.

### Selected-state (A2)
CDS list item class: `navigation-menu-item is-alt active link item-6`, bg `rgb(232,232,232)`.
Brands list item class: `navigation-menu-item is-alt link item-5`, bg `rgba(0,0,0,0)`.

### Descriptive text (A6) — verbatim
`Configure up to 10 Data Sets for your account with up to 7 metrics in each Custom Data Set`

### Action menu (A9)
`Edit`, `Delete`, `Duplicate` (first row "Hii").

### Listing table (A4 / A8 / A10–A13) — Adam Orfei, 7 rows
| Data Set | Created Date | Creator | Metrics |
|----------|--------------|---------|---------|
| Hii | Jun. 26, 2026 | Taruna Kumari | Engagements, Reactions, Response Rate, Video Views, Video Response Rate, Shares, Comments |
| Main Test 1 | Mar. 28, 2025 | Phil Cutler | Engagements, Impressions, Video Views, Saves, Shares, Shares |
| Some new data set name | Apr. 18, 2025 | Phil Cutler | Likes, Shares, Shares, Reactions, Engagements |
| Test | Jul. 16, 2025 | James Butler | Reactions, Comments, Reactions, Comments |
| Test 3 Dupes | May. 09, 2025 | Phil Cutler | Engagements, Reactions, Comments, Shares, Engagements, Reactions, Comments |
| performance test | May. 23, 2025 | Sasikumar Drylogics | Engagements, Impressions, Engagement Rate, Video Views, Video Response Rate, Clicks, Plays |
| performance test 2 | Jun. 05, 2025 | Sasikumar Drylogics | Reactions, Comments, Engaged User Rate, Watch Time (Minutes), Shares, Completed Views, Likes |

### Screenshots (`.playwright-out/`)
- `QA-104870-01-listing.png` — Custom Data Sets listing under Adam Orfei (breadcrumb, description, Create button, table).
- `QA-104870-02-dropdown-selected.png` — Settings dropdown with Custom Data Sets highlighted (A2).
- `QA-104870-03-actions-menu.png` — first-row Actions menu: Edit / Delete / Duplicate (A9).

## Observations (not bugs)

- **Account state-consistency on cold load.** The cold `#home` render labelled the account `Adam Orfei`, but the session's persisted current account was actually **Hulu (account_id=336)**, which surfaced on the first real navigation. This looks like environmental session-state carryover (persisted "current account" from a prior LFQA session) plus a possibly stale/placeholder header label on the cold render — not a confirmed product defect, and the test passes cleanly once the account is explicitly set to Adam Orfei. Flagging for human review only; per Rule 6 I am not asserting a UI defect from this proxy signal alone.
- **Metric lists contain visible duplicates** in several seed data sets (e.g. "Main Test 1": Shares twice; "Test 3 Dupes": Engagements/Reactions/Comments repeated). This is pre-existing seed test data created by LFM users (Phil Cutler etc.), not a rendering fault — the Metrics column faithfully echoes the stored metric list. No assertion covers de-duplication; noted for awareness.

## Bugs filed

None. All in-scope assertions passed (A5 is N/A on a populated account, not a failure).
