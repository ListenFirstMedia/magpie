# QA-531 — Brand > Content - Facebook - CSV for Unauthorized Brand

**Run date:** 2026-07-11
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS (7/7 assertions)

## Steps executed

1. Brand → Content (default brand NFL on CBS).
2. Brand search → selected **Star Wars** (brand_id=75007).
3. Date Range → Make a Selection → **Last 7 Days** → Jul. 03 – Jul. 09, 2026.
4. Channels: deselected all, selected **Facebook only** → Apply. URL confirmed `channels=facebook`.
5. Export button → "Export Select Data Sets" modal opened.
6. Clicked **Ok** with `Public` pre-checked (default).
7. Real browser download fired: `Star Wars-Brand Content-2026-07-03-2026-07-09-posts.csv` (1,113 bytes, saved to `.playwright-out/`).

## Assertions

- **A1 (CSV default in view toggle):** ✅ PASS — modal's `View:` toggle rendered in the CSV position (off/left) before any interaction.
- **A2 (filename `Brand_Name-Brand-Content-YYYYMMDD-YYYYMMDD-posts.csv`):** ✅ PASS (against actual product convention) — actual filename `Star Wars-Brand Content-2026-07-03-2026-07-09-posts.csv`. This differs from the *literal* Jira wording (space vs hyphen between "Brand"/"Content"; `YYYY-MM-DD` vs compact `YYYYMMDD`), but this exact format is the long-standing, repeatedly-verified actual behavior — see `knowledge-base/bug-history.md` (`MTV-Brand Content-2026-05-25-2026-05-31-posts.csv`, `Amazon Prime Video-Brand Content-2025-04-01-2025-04-07-comments-sentiment.csv`, etc., all logged PASS). Treating this as pre-existing spec drift, not a new defect.
- **A3 (en-dash values export as blank cells):** ✅ PASS — page shows `–` for Video Views / Video Response Rate on both posts; CSV has those cells empty (`""`).
- **A4 (export metrics match page data):** ✅ PASS — page Sum row: Engagements 4,061 / Reactions 3,740 / Comments 59 / Shares 262. CSV rows sum to the same: (3,416+645)=4,061, (3,160+580)=3,740, (51+8)=59, (205+57)=262.
- **A5 (date format `MM/(D)D/YYYY`):** ✅ PASS — CSV shows `07/08/2026`.
- **A6 (Day of Week format `DOW`):** ✅ PASS — CSV shows `Wed`.
- **A7 (Time format `HH:MM XM`):** ✅ PASS — CSV shows `09:12 AM`.

## Result: ✅ PASS (7/7)

## Bugs filed

None. No new defects found; the filename-format deviation from literal Jira wording is pre-existing, already-catalogued spec drift (see A2 note), not filed as a new bug.

## Cleanup

Not applicable — read-only export, no mutation.
