# Shared Selectors

Selectors that recur across multiple flows. Update when the app changes.

## Selector priority (always)

1. `data-testid` — most stable, owned by the engineering team for testing
2. `aria-label` / `role` — semantic, survives visual redesigns
3. `name` attribute on form fields
4. text content (use sparingly; brittle to copy changes)
5. CSS path (last resort; very brittle)

## Cross-flow elements (observed during QA-5757)

| Concept | Primary selector | Fallbacks | Notes |
|---------|------------------|-----------|-------|
| Global nav header | `.navigation-menus` | `header[role="banner"]` | Contains Home/Dashboards/Brand/Brand Sets/Reporting |
| User profile menu trigger | text-based: visible username (e.g., "Yash") in top-right header | none reliable | Located via `find` — no `data-testid`. **Coordinates around (1483, 19) are unreliable**; the Settings dropdown sits immediately to the left. |
| Settings dropdown trigger | text "Settings" in top-right header | — | Do NOT confuse with profile menu. Settings contains API, Audit, Authorization, Brand Sets, Brands, Custom Data Sets, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users. |
| Account breadcrumb | text starts with `Account: ` in top-left of content | — | Reliable for verifying current account context |
| Profile dropdown — Search Account | `input[placeholder="Search Account"]` | — | Lives inside the profile menu (must open first) |
| Profile dropdown — Results section | text "Results" heading | — | Excludes "Recent Searches" — different list |
| TWC: Add Brand By Name textbox | `input.al-typeahead__text-input` with placeholder `Search for a Brand` | — | React-controlled; see `time-window-comparison-run/SKILL.md` for InputEvent quirk |
| TWC: Per-brand View toggle | `input[id$="-perspective-toggle"]` (e.g., `#0-perspective-toggle`) | — | `checked === false` ⇒ Public Data; `checked === true` ⇒ Authorized Data |
| TWC: Absolute/Relative date tabs | text-based: `Absolute Dates` / `Relative Dates` | — | Selected tab has dark background |
| TWC: Run Report button | text `Run Report`, yellow CTA | — | At bottom of builder; preceded by `Brands ✓ · Dates ✓ · Data ✓` indicators |
| Built-report Export dropdown | text `Export` near top-right of report header | — | Between `Change Settings` and `Preview & Share Report` |
| Export option items | `.lfm-dropdown-option` with text `Google Sheets|CSV|TSV|XLS` | — | Order is fixed; selected option gets `.lfm-dropdown-option.selected` |
| Error/alert banner | `[role="alert"]` | `.toast-error`, `.alert-danger` | _Not yet observed in this codebase but kept as standard pattern_ |
