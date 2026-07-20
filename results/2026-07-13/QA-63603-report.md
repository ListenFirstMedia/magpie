# QA-63603 — Settings > Tags > Content Tagged - Upload Tags

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ⚠️ SPEC/FEATURE DRIFT (reconfirms known-quirks finding)

## Steps executed
1. Direct URL navigation to `#settings/tags` and `#tags` both rendered stale content (SPA route quirk — page stayed on the previous view's title). Navigated via the **Settings dropdown menu → Tags link** instead, which worked correctly (`#tags?account_id=54`, title "Settings Tags").
2. Inspected the Tags page: toolbar has `Filter | Export` only — **no "Upload Tags" button/link anywhere on this page.**
3. "Content Tagged" is not a tab — it's a **table column header** (`Tag | Date Created | Creator | Content Tagged | Actions`), showing a numeric count of how many pieces of content each tag is applied to, with per-row `Update | Delete` actions.

## Assertions

Spec title implies: "Content Tagged Tab" + "Upload Tags" functionality should exist on Settings > Tags.

| Expected | Actual | Status |
|----------|--------|--------|
| A "Content Tagged" tab exists | It's a table column, not a tab | ❌ Spec wording mismatch |
| "Upload Tags" functionality is on this page | Not present. Confirmed earlier this run (QA-27292) that **Upload Tags actually lives under Brand > Content's Tag toolbar dropdown**, on brands that have existing tags (e.g. Hulu) | ❌ FAIL (spec/feature drift) |

## Verdict

**Reconfirms the documented spec/feature drift**: "Upload Tags lives on Brand>Content, not Settings>Tags" (`knowledge-base/known-quirks.md`). This is a stable, repeatedly-confirmed finding (2026-06-05, 2026-06-13, now 2026-07-13) — the Jira spec's location for this feature does not match the actual product location. Recommend updating the spec to point to Brand>Content's Tag dropdown, or confirming with product whether Settings>Tags was ever meant to have this capability.

## Bugs filed

None — third reconfirmation of pre-existing documented drift.

## Cleanup

Not applicable — no mutation.
