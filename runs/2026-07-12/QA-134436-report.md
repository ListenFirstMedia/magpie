# QA-134436 — Brandsets > Content: Verify layered tag filtering (Include + Exclude)

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Account:** Adam Orfei (id=54)
- **Surface:** Brand Sets > Content (`#explore/competitive/content`)
- **Brand set:** 1923 Talent (brand_set_id=11190) — resolved as the default Adam Orfei brand set
- **Window:** Jul 04 2026 – Jul 10 2026, Mode Lifetime, channels FB/Twitter/IG/YT/TikTok, perspective standard
- **Skill reused:** `brand-content-filter` v3 (Brand Sets > Content surface; "Content Tag" label variant)
- **Verdict:** **PASS** (A4 numeric parity data-limited — see note)

## Steps executed

1. Logged in programmatically (Cognito "With existing account", `config/.env`) → `#home` rendered.
2. Navigated to Brand Sets > Content with `account_id=54`; app resolved brand set 1923 Talent, week Jul 4–10. Pre-filter **Posts (1)**, Sum Engagements **5,174** (single IG post — Julia Schlaepfer, Jul 09).
3. Opened Filter dropdown → filter-type list rendered (14 types). Tag filter is labeled **"Content Tag"** on this surface (Brand Sets variant).
4. Opened Content Tag sub-panel → Include (checked) / Exclude radios, Or/And operator, Select All, tag checkbox list (None, jbkaxlx, +tag, …).
5. Selected **jbkaxlx** under Include (Or default) → `option-row selected`.
6. Switched radio to **Exclude** → jbkaxlx became `option-row disabled`.
7. Selected **+tag** under Exclude.
8. Apply Filter → two pills render ("Content Tag: jbkaxlx" Include + "Content Tag: +tag" Exclude); URL `filters` JSON populated.
9. Read results table + empty-state.
10. Or-vs-And test: reopened panel, confirmed operator disabled with 1 Include tag; added second Include tag (000) → operator enabled; flipped to **And**; Apply → URL operator serialized to `and`.
11. Clear All → `filters` param + pills removed; Posts back to (1).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2–3 | Tag popup contains Include radio + Exclude radio + Or/And operator + checkbox list | Content Tag sub-panel rendered: Include (checked) + Exclude radios, Or/And operator buttons, Select All, tag checkbox list (None/jbkaxlx/+tag/…) | **PASS** |
| A2 | 5 | Include-selected tags become disabled (`option-row disabled`) when Exclude radio selected | With Exclude active (include=false/exclude=true), jbkaxlx class = `option-row disabled` | **PASS** |
| A3 | 7 | URL `filters` encodes `content_tags` array: `{or,[…],not:"false"}` + `{or,[…],not:"true"}` | `{"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` | **PASS** |
| A4 | 7–8 | Posts table populates with Include∧¬Exclude semantics; Sum/Avg row matches | Include jbkaxlx ∧ ¬Exclude +tag → 0 matching posts (the single in-window post carries neither tag). Clean empty state: Sum `–` / Average `–`, "There is no data available." — **not** the OR+None backend-failure pane. Semantics correct; numeric parity not assertable (data-limited) | **PASS** (data-limited) |
| A5 | 9 | Or with 1 tag is disabled OR single-value Or works identically to And | Single Include tag → both operators `edit-operator-button … disabled` + `pointer-events:none` (Or = filled dot). Two Include tags → operators enabled (`pointer-events:auto`); flipping to And serialized URL operator to `and` (`values:[" jbkaxlx","000"]`) | **PASS** |
| A6 | 10 | Clear All resets all tag filters; URL `filters` empties | Clear All → no `filters` param, 0 pills, Posts back to (1) pre-filter | **PASS** |

## Evidence

- Pre-filter: `Posts (1)`, Sum/Avg Engagements = 5,174 (Julia Schlaepfer IG post, `instagram.com/p/DalNrqmmjX1/`).
- A3 URL (decoded): `{"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` (leading space on " jbkaxlx" matches prior-run serialization).
- A4 empty-state text: "There is no data available. Please select a different brand, brand set, or date range." Sum `–` / Average `–`.
- A5 operator DOM: single-tag → `.edit-operator-button.or.disabled` (`fa-dot-circle`) + `.edit-operator-button.and.disabled` (`fa-circle`), both `pointer-events:none`. Two-tag → same buttons without `disabled`, `pointer-events:auto`. AND-applied URL: `{"operator":"and","values":[" jbkaxlx","000"],"not":"false"}`.
- A6: hash query has no `filters` key; `.filter-pill` count = 0; `Posts (1)`.
- Screenshots: `.playwright-out/QA-134436/after-apply-layered-filter.png`, `.playwright-out/QA-134436/after-clear-all.png`.

## Known bugs checked

- `bug-history.md` (grep QA-134436): prior PASS 2026-06-04 (QA-4325 batch 12) on the same brand set; layered Include jbkaxlx + Exclude +tag encoded correctly; Clear All clean. No open linked bugs — Rule 7 screen passes.
- Case Notes / skill v2 **"OR + None backend rejection"** quirk: **did NOT reproduce** here — the layered filter returned a clean "no data available" empty state (Sum/Avg en-dash), not the "This table failed to load" backend error. (No `None`+OR combination was applied in this run.)
- Brand-Sets **View-toggle-disabled** quirk: consistent — View shows Public Data / Authorized Data derived from the Rank-by metric; not interacted with (not relevant to tag filtering).

## Bugs filed

None.
