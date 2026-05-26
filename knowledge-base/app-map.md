# App Map

Inventory of pages, URLs, and navigation paths. Built up incrementally as exploration runs touch new areas of the app.

## Domains

- **Main app:** `app.lfmdev.in` (the platform shell with global navigation)
- **Reporting sub-app:** `app-reporting.lfmdev.in` (TWC and other report builders/viewers — runs as a separate SPA)
- **Domain API:** `domain-api.lfmdev.in` (e.g., `notifications_messages`)

## Top-level pages (observed so far)

| Page | URL pattern | Reached by | Key elements | Skills that touch it |
|------|-------------|------------|--------------|----------------------|
| Home | `app.lfmdev.in/#home?account_id=<id>` | direct nav, redirect post-login | account header, welcome card, favorite brands & brand sets | (pre-flight check) |
| Time Window Comparison (builder) | `app-reporting.lfmdev.in/#/time_window_comparison` | Top nav → Reporting → Time Window Comparison | Add Brands, Select Date Range, Select Channel Data, Options, Run Report | `time-window-comparison-run` |
| Built report (Story view) | `app-reporting.lfmdev.in/#story/time_window_comparison/<reportId>` | After clicking Run Report | Brand panel, line chart per metric, data table per metric, Export dropdown | `export-google-sheets`, `export-csv` |
| Google Sheets export | `docs.google.com/spreadsheets/d/<sheetId>/edit?gid=0#gid=0` | Export → Google Sheets | populated sheet | `export-google-sheets` |

## Global UI elements (every authenticated page)

| Element | Location | Selector notes |
|---------|----------|----------------|
| Global navigation header | top of page, full width | `.navigation-menus` container holds `Home`, `Dashboards`, `Brand`, `Brand Sets`, `Reporting` |
| User profile menu trigger | top-right of header | shows display name (e.g., "Yash") — locate by visible text, not coordinates |
| Settings dropdown | top-right, immediately left of profile | Do NOT confuse with profile — Settings contains API/Audit/etc, NOT account switcher |
| Account breadcrumb | top-left of content area | `Account: <name> | <breadcrumb>` |

## Reporting menu items (under "Reporting" top-nav dropdown)

- Data Studio
- **Time Window Comparison** (covered by QA-5757)
- Content Performance
- Social Recap
- Follower Demographics

## Brand picker (Add Brand By Name)

- Lives inside the "Add Brands" section on the TWC builder.
- React-controlled typeahead (`input.al-typeahead__text-input`). See `time-window-comparison-run/SKILL.md` for the input-event quirk.
- After selection: the brand appears in a row with a per-brand `View: Public Data | Authorized Data` toggle.

## Export dropdown options (from a built TWC report)

Order observed:
1. Google Sheets — opens new tab
2. CSV — silent download
3. TSV — silent download (not yet exercised by a test case)
4. XLS — silent download (not yet exercised by a test case)
