# QA-20337 — Settings > Audit - Logs

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Skill used:** [settings-audit-logs](../../skills/settings-audit-logs/SKILL.md) v2

## Steps executed

1. Logged in fresh via Cognito "With existing account" form (lfiqa@listenfirstmedia.com).
2. Navigated directly to `https://app.lfmdev.in/#audit?account_id=54` (Settings → Audit).
3. Waited ~6s for the table to leave skeleton-load state (URL auto-appended default 7-day range `from=2026-07-03&to=2026-07-09&compare_from=2026-06-26&compare_to=2026-07-02`).
4. Read all rendered rows via `browser_evaluate` (2,119 rows total in the DOM at default range) and filtered for `User Created` rows specifically, since none were visible in the top-of-list default view (most recent rows were Brand/Brand-Set mutations).
5. Screenshot captured of the rendered table.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Actor column | Contains the user's name | `Adil Ali`, `LFQA Testing`, `Pranjal Chopra` — all real two/three-word actor names populate every row | ✅ PASS |
| A2 | Activity column | Shows `User Created` | 3 `User Created` rows found in the loaded window (Jul 03–06, 2026) | ✅ PASS |
| A3 | Description column | `User #{First name last name} was created` | `User Testing 15 was created.` / `User User-426 test was created.` / `User Jeffrey Dinh was created.` — matches template `User {Name} was created.` (the `#` in the Jira spec is list-numbering syntax, not a literal UI character — documented quirk, not a bug) | ✅ PASS |
| A4 | Date column | Format `DOW MON. DD, YYYY HH:MM XM PDT` | `Mon Jul. 06, 2026 01:56 AM PDT`, `Fri Jul. 03, 2026 04:40 AM PDT` — exact match | ✅ PASS |

## Evidence

Sample rows (verbatim, whitespace-collapsed):
```
Mon Jul. 06, 2026 01:56 AM PDT | ListenFirst | ListenFirst | Adam Orfei | Adil Ali | User Created | User Testing 15 was created.
Mon Jul. 06, 2026 01:00 AM PDT | ListenFirst | ListenFirst | Adam Orfei | LFQA Testing | User Created | User User-426 test was created.
Fri Jul. 03, 2026 04:40 AM PDT | ListenFirst | ListenFirst | ListenFirst Media | Pranjal Chopra | User Created | User Jeffrey Dinh was created.
```
Screenshot: `qa20337-audit-table.png` (repo root, captured mid-run).

## Result: ✅ PASS (4/4 assertions)

## Bugs filed

None.

## Cleanup

Not applicable — read-only test, no mutations performed.
